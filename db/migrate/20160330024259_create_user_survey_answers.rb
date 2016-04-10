class CreateUserSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :user_survey_answers do |t|
      t.integer :user_survey_id
      t.integer :user_id
      t.integer :question_id
      t.integer :answer_id

      t.timestamps null: false
    end
  end
end
