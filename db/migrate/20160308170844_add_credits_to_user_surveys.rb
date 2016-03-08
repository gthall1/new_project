class AddCreditsToUserSurveys < ActiveRecord::Migration
  def change
    add_column :user_surveys, :credits, :int
  end
end
