json.array!(@feed_games) do |feed_game|
  json.extract! feed_game, :name, :description, :thumb_60, :thumb_120, :thumb_180, :external_link, :orientation, :game_added, :aspect_ratio
  json.url feed_game_url(feed_game, format: :json)
end