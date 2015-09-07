class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_many :user_entries
  has_many :jackpots, through: :user_entries
  has_many :user_game_sessions
  belongs_to :jackpot

  before_create :create_remember_token, :create_referral_code

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
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

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def create_referral_code
    self.referral = SecureRandom.hex(4)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
