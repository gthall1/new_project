class UserLead < ActiveRecord::Base
  before_create :create_verify_token
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :name
  validates_uniqueness_of :email, :on => :create

  def create_verify_token
      self.verify_token = SecureRandom.urlsafe_base64.to_s
  end
end
