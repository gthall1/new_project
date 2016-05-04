class UserSurveyAnswer < ActiveRecord::Base
  belongs_to :survey_question_answer
  belongs_to :user_surveys
  belongs_to :question
  belongs_to :survey_question
end
