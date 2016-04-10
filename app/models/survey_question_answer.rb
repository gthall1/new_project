class SurveyQuestionAnswer < ActiveRecord::Base
  belongs_to :survey_question
  belongs_to :answer

  accepts_nested_attributes_for :answer

end
