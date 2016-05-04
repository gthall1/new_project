class Survey < ActiveRecord::Base
	has_many :user_surveys
  has_many :survey_questions 
  has_many :questions, :through => :survey_questions
  has_many :survey_question_answers
  accepts_nested_attributes_for :survey_questions, reject_if: proc { |attributes| attributes['question_id'].blank? }
end
