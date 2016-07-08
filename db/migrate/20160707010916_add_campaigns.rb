class AddCampaigns < ActiveRecord::Migration
  def change
    c = Campaign.create(advertiser_id:Advertiser.find_by_slug('dunkin-donuts').id, description:"Dunkin Donut Fastest way to dunkin!", start_date:Time.now,active:true)
    BrandedGameAsset.create(name:'Dunkin Fall Down bg with logo', description: 'Dunkin Fall Down bg with logo donuts and coffee',width:722, height: 1282, campaign_id: c.id, asset_url:'dd_fall_down_bg_1.png')
    BrandedGameAsset.create(name:'Dunkin Fall Down bg with latte', description: 'Dunkin Fall Down bg with latte',width:722, height: 1282, campaign_id: c.id, asset_url:'dd_fall_down_bg_2.png')
    BrandedGameAsset.create(name:'Dunkin Fall Down bg with machhiato', description: 'Dunkin Fall Down with an iced macchiato',width:722, height: 1282, campaign_id: c.id, asset_url:'dd_fall_down_bg_3.png')
    BrandedGameAsset.create(name:'Dunkin Fall Down Donut', description: 'Dunkin Fall Down Ball that is a donut',width: 80, height: 80, campaign_id: c.id, asset_url:'better_donut.png')  
  end
end