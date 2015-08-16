class CreateUserSurveys < ActiveRecord::Migration
  def change
    create_table :user_surveys do |t|
      t.integer :user_id
      t.integer :survey_id
      t.boolean :complete

      t.timestamps
    end
  end
end
