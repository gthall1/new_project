class Game < ActiveRecord::Base
  has_many :user_game_sessions
  has_many :branded_game_properties
  #device types 0:none 1:mobile-only 2:desktop-only 3:mobile-and-desktop 5:purchasable

  scope :mobile,       -> { where( :device_type=>[1,3,5] )                                 } 
  scope :desktop,       -> { where( :device_type=>[2,3,5] )                                } 

  def is_mobile?
  	self.device_type == 1 || self.device_type == 3
  end

  def is_desktop?
  	self.device_type == 2 || self.device_type == 3
  end  

  def game_title(args={})
    if !args[:advertiser_id].blank?
      self.branded_game_properties.find_by_advertiser_id(args[:advertiser_id]).branded_game_name
    else
      self.name
    end
  end

  def game_image(args={})
    advertiser_id = args[:advertiser_id]
    if args[:desktop] == true
      self.get_desktop_game_image({advertiser_id: advertiser_id})
    else
      self.get_mobile_game_image({advertiser_id: advertiser_id})
    end
  end

  def get_desktop_game_image(args={})
    if !args[:advertiser_id].blank?
      self.branded_game_properties.find_by_advertiser_id(args[:advertiser_id]).branded_game_image_d
    else
      self.desktop_image
    end
  end

  def get_mobile_game_image(args={})
    if !args[:advertiser_id].blank?
      self.branded_game_properties.find_by_advertiser_id(args[:advertiser_id]).branded_game_image_m
    else
      self.desktop_image
    end
  end

end
