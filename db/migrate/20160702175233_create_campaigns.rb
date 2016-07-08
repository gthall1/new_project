class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :advertiser_id
      t.string :description
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
