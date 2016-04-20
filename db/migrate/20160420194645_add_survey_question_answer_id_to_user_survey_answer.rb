class AddSurveyQuestionAnswerIdToUserSurveyAnswer < ActiveRecord::Migration
  def change
    add_column :user_survey_answers, :survey_question_answer_id, :integer
  end
end
