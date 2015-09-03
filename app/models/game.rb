class Game < ActiveRecord::Base
  has_many :user_game_sessions
end
