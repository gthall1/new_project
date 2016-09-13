class Campaign < ActiveRecord::Base
  has_many :branded_game_assets
  belongs_to :advertiser
  
  def self.get_active
    Campaign.where(active:true).where('start_date <= ? AND end_date > ?',Time.now,Time.now)
  end
end
