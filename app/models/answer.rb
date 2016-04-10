class Answer < ActiveRecord::Base
  has_many :survey_question_answers
end
