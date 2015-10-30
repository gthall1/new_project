class CreateArrivals < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.string :landing_url
      t.string :referer
      t.string :user_agent
      t.string :ip
      t.string :mobile
      t.integer :user_id

      t.timestamps
    end
  end
end
