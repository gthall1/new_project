class AddSlugsToAssets < ActiveRecord::Migration
  def change
    a = BrandedGameAsset.where(asset_url:'dd_fall_down_bg_1.png').first
    a.slug = "fall-down-bg"
    a.save

    a = BrandedGameAsset.where(asset_url:'dd_fall_down_bg_2.png').first
    a.slug = "fall-down-bg"
    a.save

    a = BrandedGameAsset.where(asset_url:'dd_fall_down_bg_3.png').first
    a.slug = "fall-down-bg"
    a.save

    a = BrandedGameAsset.where(asset_url:'better_donut.png').first
    a.slug = "fall-down-ball"
    a.save
  end
end
