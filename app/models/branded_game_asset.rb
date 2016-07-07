class BrandedGameAsset < ActiveRecord::Base
  belongs_to :game
  belongs_to :campaign
end
