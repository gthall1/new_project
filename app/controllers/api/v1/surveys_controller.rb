module API
    module V1
        class SurveysController < ApiController

            def get_surveys
                start_id = params[:start]
                end_id = params[:end]
                
                surveys = Survey.unscoped.where("id >= ? AND id <= ?",start_id, end_id).to_json
                
                render json: surveys, root: false 
            end
            
        end
    end
end