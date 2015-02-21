class Jackpot < ActiveRecord::Base
	has_many :users
	has_many :user_entries
end
