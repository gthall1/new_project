module API
    module V1
        class ArrivalsController < ApiController

            def get_arrivals
                start_id = params[:start]
                end_id = params[:end]
                
                arrivals = Arrival.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: arrivals, root: false 
            end
            
        end
    end
end