class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  attr_accessor :reset_token

  has_many :user_entries
  has_many :jackpots, through: :user_entries
  has_many :user_game_sessions
  has_many :cash_outs
  belongs_to :jackpot

  before_create :create_remember_token, :create_referral_code
  after_create :send_welcome_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :name, :on => :create
  has_secure_password
  validates :password, length: { minimum: 6 } ,:if => '!password.nil?'

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.name = auth.info.name
      user.uid = auth.uid
      user.oath_name = auth.info.namea
      pass = SecureRandom.urlsafe_base64
      user.password = pass
      user.password_confirmation = pass
      user.email = auth.info.email
      user.gender = auth.extra.raw_info.gender == "male" ? 1 : auth.extra.raw_info.gender == "female" ? 2 : nil
      res = Net::HTTP.get_response(URI(auth.info.image+'?width=200&height=200'))
      user.oath_image = res["location"]
      user.oath_token = auth.credentials.token
      user.oath_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
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
    self.save
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

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
