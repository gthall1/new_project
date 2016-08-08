class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    attr_accessor :reset_token

    has_many :user_entries
    has_many :jackpots, through: :user_entries
    has_many :user_game_sessions
    has_many :game_purchases, -> { where purchase_type: 1 }, class_name: "Purchase"
    has_many :cash_outs
    has_many :user_surveys
    has_many :surveys, :through => :user_surveys
    has_many :challenges_as_challenged, :foreign_key => 'challenged_user_id', :class_name => 'Challenge'
    has_many :challenges_as_challenger, :foreign_key => 'user_id', :class_name => 'Challenge'


    #before_validation :generate_password
    before_create :create_remember_token, :create_referral_code
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
    validates_uniqueness_of :name
    validates_uniqueness_of :email, :on => :create
    # validates_date :dob, on_or_after: lambda { 125.years.ago }, :after_message => "must not be this old. You don't have much time left, please spend it elsewhere.", :on => :update
    # validates_date :dob, on_or_before: lambda { 13.years.ago }, :before_message => "must be at least 13 years old", :on => :update

    has_secure_password
    validates :password, length: { minimum: 6 } ,:if => '!password.nil?'
    
    USER_TYPES = { nil => 'user', 1 => "rep" , 2 => "admin" } 


    def challenges
        challenges_as_challenged + challenges_as_challenger
    end

    def origin_arrival
        Arrival.where(id:self.arrival_id).first
    end

    def completed_profile
        !gender.blank? && !firstname.blank? && !lastname.blank? && !dob.blank? 
    end

    #TODO: Make more accurate so doesnt round
    def age
        return Time.now.year-self.dob.year unless self.dob.blank?
        nil
    end

    def get_gender
        self.gender == 1 ? "male" : self.gender == 2 ? "female" : "unknown"
    end

    def get_highscore(args={})
        version = args[:version]
        case args[:timeframe]
            when 'weekly'
                prefix = 'w'
            when 'alltime'
                prefix = 'at'
            else 
                prefix = 'at'
        end

        if $redis.get("#{prefix}_#{args[:slug]}_v#{version}_user_#{self.id}")
            return JSON.parse($redis.get("#{prefix}_#{args[:slug]}_v#{version}_user_#{self.id}"))["score"]
        else
            game = Game.where(slug:args[:slug]).first
            return UserGameSession.where(user_id:self.id,game_id:game.id,version:version).where.not(score: nil).order("score desc").first.score if UserGameSession.where(user_id:self.id,game_id:game.id).where.not(score: nil).order("score desc").present?
        end

        return 0
    end

    def has_purchased_game(game_id)
        self.game_purchases.where(purchase_record_id:game_id).present?
    end

    def user_type_name
     USER_TYPES[self.user_type]
    end

    def self.omniauth(auth,arrival_id)
        where(provider:auth.provider,uid:auth.uid).first_or_initialize do |user|
            user.provider = auth.provider
            if user.name.blank?
             name = auth.info.name.gsub(" ","").downcase
             name = "#{name}"
             if User.where(name:name).present?
                 name = "#{name}#{rand(999)}"
             end
             user.name = name
            end
            user.uid = auth.uid
            user.oath_name = auth.info.namea

            pass = SecureRandom.urlsafe_base64
            user.password = pass
            user.password_confirmation = pass
            if auth.info.email
                user.email = auth.info.email
            # else
            #   user.email = "a#{rand(1000000)}@change.me"
            end
            arrival = Arrival.where(id:arrival_id).last

            if arrival && !arrival.referred_by.blank? 
                referral_user = User.unscoped.where(id:arrival.referred_by).first
                if referral_user
                        if referral_user.user_type_name == 'rep'
                            referral_user.add_credits({credits: 0})
                        else
                            referral_user.add_credits({credits: 50})
                        end
                end
            end

            user.gender = auth.extra.raw_info.gender == "male" ? 1 : auth.extra.raw_info.gender == "female" ? 2 : nil
            res = Net::HTTP.get_response(URI(auth.info.image+'?width=200&height=200'))
            user.oath_image = res["location"]
            user.oath_token = auth.credentials.token
            user.arrival_id = arrival_id if user.arrival_id.blank?
            user.oath_expires_at = Time.at(auth.credentials.expires_at)
            user.save!
            UserNotifier.send_confirmation_email({user_id: user.id,verify_token:user.verify_token}).deliver
        end
    end

    def omniauth_connect(auth)
        self.provider = auth.provider
        self.uid = auth.uid
        res = Net::HTTP.get_response(URI(auth.info.image+'?width=200&height=200'))
        self.oath_image = res["location"]
        self.oath_token = auth.credentials.token
        self.oath_expires_at = Time.at(auth.credentials.expires_at)
        self.save!
    end

    def self.to_csv(options = {})
        attributes = %w{id email name lifetime_credits}

        CSV.generate(options) do |csv|
                csv << attributes

                all.each do |user|
                        csv << user.attributes.values_at(*attributes)
                end
        end
    end

    def email_activate
        self.email_verified = true
        #self.verify_token = nil
        save!(:validate => false)
        send_welcome_email
    end
    
    def self.total_user_credits
        User.sum(:lifetime_credits)
    end

    def profile_complete?
       !dob.blank? && !gender.blank? && !firstname.blank? && !lastname.blank?
    end

    def add_credits(args={})
        credits = args[:credits].to_i
        if !self.credits.nil? && self.credits >= 0
                self.credits += credits
        else
                self.credits = credits
        end

        if !self.lifetime_credits.nil? && self.lifetime_credits >= 0
                self.lifetime_credits += credits
        else
                self.lifetime_credits = credits
        end
        if self.enabled != false
            self.save
        end
    end

    def User.new_remember_token
            SecureRandom.urlsafe_base64
    end

    def send_welcome_email
            UserNotifier.send_welcome_email({user_id:self.id}).deliver
    end

    def send_password_reset_email
            UserNotifier.password_reset(self).deliver
    end

    def User.digest(token)
            Digest::SHA1.hexdigest(token.to_s)
    end

    def create_referral_code
            self.referral = SecureRandom.hex(4)
    end

    # Returns true if a password reset has expired.
    def password_reset_expired?
            reset_sent_at < 2.hours.ago
    end

    # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_remember_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

        
    private


    #generates password before verified
    def generate_password
        if self.password.blank?
            pass = SecureRandom.urlsafe_base64
            self.password = pass
            self.password_confirmation = pass
        end
    end

    def create_verify_token
        self.verify_token = SecureRandom.urlsafe_base64.to_s
    end

    def create_remember_token
        self.remember_token = User.digest(User.new_remember_token)
    end

end
