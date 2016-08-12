class AddJulieCampaign < ActiveRecord::Migration
  def change
    if !Advertiser.where(slug:'julie').present?
      a = Advertiser.create({name: 'Julie', slug:'julie'})
    end
    if !Campaign.where(description:'Julies Challenge').present?
      c = Campaign.create({advertiser_id:a.id, start_date:Time.now,active:true,description:"Julies Challenge"})
    end
    game_id = Game.find_by_slug('fall-down').id

    BrandedGameAsset.create({
                              name:'Julies Fall Down Background',
                              description:'Julie of boston breakers fall down background.',
                              width:722,
                              height:1282,
                              slug:'fall-down-bg',
                              game_id:game_id,
                              campaign_id:c.id,
                              asset_url:'/assets/fall_down/promos/julie_game.png'
      })

    BrandedGameAsset.create({
                              name:'Julie title for fall down background',
                              description:'Background of boston breakers julie with title.',
                              width:722,
                              height:1282,
                              slug:'fall-down-title-bg',
                              game_id:game_id,
                              campaign_id:c.id,
                              asset_url:'/assets/fall_down/promos/julie_game.png'
      })

    BrandedGameAsset.create({
                              name:'Play button for julies game',
                              description:'Updated play button for julies game.',
                              width:120,
                              height:120,
                              slug:'fall-down-play',
                              game_id:game_id,
                              campaign_id:c.id,
                              asset_url:'/assets/fall_down/promos/soccer_ball.png'
      })

    BrandedGameAsset.create({
                              name:'Soccer Ball Icon',
                              description:'Soccer ball icon for fall down as part of julies game.',
                              width: 80,
                              height: 80,
                              slug:'fall-down-ball',
                              game_id:game_id,
                              campaign_id:c.id,
                              asset_url:'/assets/fall_down/promos/soccer_ball.png'
      })
  end
end