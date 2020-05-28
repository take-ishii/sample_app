module Api
  module V1
    module Users
      class SessionValidationsController < ApplicationController
        def index
          if logged_in?(params[:user_id])
            render json: { is_logged_in: 'true' }
          else
            render json: { is_logged_in: 'false' }, status: 401
          end
        end

        private

          def logged_in?(user_id)
            user = User.find_by(id: user_id)
            authenticate_with_http_token do |token, _options|
              return user && user.authenticated?(:remember, token)
            end
          end
      end
    end
  end
end
