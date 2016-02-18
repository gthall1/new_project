class AddEmailVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_verified, :boolean, :default => false
    add_column :users, :verify_token, :string
  end
end
