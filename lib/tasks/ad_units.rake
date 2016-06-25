require 'rake'

task :add_initial_ad_units => :environment do | t, args |
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'bellhop-fall-1', name: 'Bellhops Falldown 1', partner: 'Bellhops', ad_number: 2, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'kia-soul-fall-1', name: 'Kia Soul Falldown', partner: 'Kia', ad_number: 3, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'bmw-fall-1', name: 'BMW Falldown 1', partner: 'BMW', ad_number: 4, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'regions-bank-fall-1', name: 'Regions Falldown 1', partner: 'Regions', ad_number: 5, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'capital-one-fall-1', name: 'Capital One Falldown 1', partner: 'Capital One', ad_number: 6, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'pnc-fall-1', name: 'PNC Falldown 1', partner: 'PNC', ad_number: 7, value: 0})
  a = AdUnit.create({ game_id: Game.where(slug:'fall-down').first.id, slug: 'chase-fall-1', name: 'Chase Falldown 1', partner: 'CHase', ad_number: 8, value: 0})
end


task :add_dd_ad_units => :environment do | t, args |
  a = AdUnit.create({ game_id: Game.where(slug:'flappy-pilot').first.id, slug: 'dd-flygirl', name: 'Flygirl DD', partner: 'Dunkin Donuts', ad_number: 9, value: 0})
end
