class CreateGameCategoryRels < ActiveRecord::Migration
  def change
    create_table :game_category_rels do |t|
      t.integer :feed_game_id
      t.integer :category_id

      t.timestamps
    end
  end
end
