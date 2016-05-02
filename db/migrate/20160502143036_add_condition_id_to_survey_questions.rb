class AddConditionIdToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :condition_id, :integer
  end
end
