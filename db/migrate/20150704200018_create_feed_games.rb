class CreateFeedGames < ActiveRecord::Migration
  def change
    create_table :feed_games do |t|
      t.string :name
      t.string :description
      t.string :thumb_60
      t.string :thumb_120
      t.string :thumb_180
      t.string :external_link
      t.string :orientation
      t.datetime :game_added
      t.decimal :aspect_ratio

      t.timestamps
    end
  end
end
