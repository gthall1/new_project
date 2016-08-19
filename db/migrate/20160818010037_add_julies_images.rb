class AddJuliesImages < ActiveRecord::Migration
  def change
    play_button = Campaign.where(description:'Julies Challenge').first.branded_game_assets.where(slug:'fall-down-play').first
    if play_button
      play_button.asset_url = "/assets/fall_down/promos/kings_challenge_play_button.png"
      play_button.save
    end

    title_bg = Campaign.where(description:'Julies Challenge').first.branded_game_assets.where(slug:'fall-down-title-bg').first
    if title_bg
      title_bg.asset_url = "/assets/fall_down/promos/kings_challenge_title.png"
      title_bg.save
    end


  end
end
