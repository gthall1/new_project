class AddCountryToWaitlistUsers < ActiveRecord::Migration
  def change
    add_column :waitlist_users, :country, :string
  end
end
