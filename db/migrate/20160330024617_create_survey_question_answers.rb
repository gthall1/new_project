class CreateSurveyQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :survey_question_answers do |t|
      t.integer :survey_question_id
      t.integer :answer_id

      t.timestamps null: false
    end
  end
end
