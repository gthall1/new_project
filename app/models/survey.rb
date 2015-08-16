class Survey < ActiveRecord::Base
	has_many :user_surveys
end
