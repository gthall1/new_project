class AddDisplayOrderToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :display_order, :integer
  end
end
