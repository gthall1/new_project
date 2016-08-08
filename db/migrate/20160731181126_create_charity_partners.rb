class CreateCharityPartners < ActiveRecord::Migration
  def change
    create_table :charity_partners do |t|
      t.string :name
      t.string :description
      t.string :logo_m
      t.string :logo_d
      t.string :slug

      t.timestamps null: false
    end

    add_column :cash_outs, :charity_partner_id, :integer

  end
end

