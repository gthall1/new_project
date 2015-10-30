class FixArrivalOnSurvey < ActiveRecord::Migration
  def change
  	    remove_column :surveys, :arrival_id
  	    add_column :user_surveys, :arrival_id, :integer   
  end
end
