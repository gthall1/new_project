class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey
  belongs_to :question
  has_many :survey_question_answers
  has_many :answers, :through => :survey_question_answers
  has_many :user_survey_answers
  accepts_nested_attributes_for :question
  accepts_nested_attributes_for :survey_question_answers

end
