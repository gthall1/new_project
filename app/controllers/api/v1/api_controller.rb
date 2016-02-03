module API
    module V1
        class ApiController < ApplicationController
            protect_from_forgery with: :null_session
            skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

            before_filter :token_valid

            def token_valid
                head :unauthorized unless ApiUser.where(token:params[:token]).present?
            end
        end
    end
end

