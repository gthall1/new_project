class AddDefaultCredits < ActiveRecord::Migration
  def change
    change_column_default :users, :credits, 0
    User.where(credits:nil).find_each do | u | 
      u.credits = 0
      u.save
    end
  end
end
