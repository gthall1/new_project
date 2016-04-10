class Question < ActiveRecord::Base
  has_one :survey_question
end
