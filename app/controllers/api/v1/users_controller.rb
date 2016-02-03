module API
    module V1
        class UsersController < ApiController

            def get_users
                start_id = params[:start]
                end_id = params[:end]
                
                users = User.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: users, root: false 
            end
            
            def get_game_sessions
                start_id = params[:start]
                end_id = params[:end]
                
                game_sessions = UserGameSession.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: game_sessions, root: false 
            end

             def get_cash_outs
                start_id = params[:start]
                end_id = params[:end]
                
                cash_outs = CashOut.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: cash_outs, root: false 
            end           
        end
    end
end