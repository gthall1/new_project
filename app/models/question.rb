class Question < ActiveRecord::Base
  has_many :survey_questions
  has_many :user_survey_answers
end
