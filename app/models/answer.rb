class Answer < ActiveRecord::Base
  has_many :survey_question_answers
  belongs_to :user_survey_answer
end
