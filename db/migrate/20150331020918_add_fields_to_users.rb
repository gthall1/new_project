class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dob, :date
    add_column :users, :zipcode, :string
    add_column :users, :gender, :integer
  end
end
