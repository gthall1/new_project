json.array!(@jackpots) do |jackpot|
  json.extract! jackpot, 
  json.url jackpot_url(jackpot, format: :json)
end