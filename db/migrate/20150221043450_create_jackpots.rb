class CreateJackpots < ActiveRecord::Migration
  def change
    create_table :jackpots do |t|
      t.string :name
      t.integer :max_entries
      t.datetime :draw_date
      t.string :prize
      t.boolean :open
      t.integer :winner_id
      t.timestamps
    end
  end
end
