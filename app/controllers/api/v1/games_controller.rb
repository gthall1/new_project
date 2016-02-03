module API
    module V1
        class GamesController < ApiController

            def get_games
                start_id = params[:start]
                end_id = params[:end]
                
                games = Game.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: games, root: false 
            end
            
        end
    end
end