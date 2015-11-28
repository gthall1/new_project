class Game < ActiveRecord::Base
  has_many :user_game_sessions
  #device types 0:none 1:mobile-only 2:desktop-only 3:mobile-and-desktop

  def is_mobile?
  	self.device_type == 1 || self.device_type == 3
  end

  def is_desktop?
  	self.device_type == 2 || self.device_type == 3
  end  
end
