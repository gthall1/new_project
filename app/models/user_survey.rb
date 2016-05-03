class UserSurvey < ActiveRecord::Base
	belongs_to :user 
	belongs_to :survey

  has_many :user_survey_answers
  has_many :answers, :through => :user_survey_answers

end
