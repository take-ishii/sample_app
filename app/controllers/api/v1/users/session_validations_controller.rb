module Api
  module V1
    module Users
      class SessionValidationsController < ApplicationController
        def index
          render_is_logged_in || render_not_logged_in
        end

        private

          def render_is_logged_in
            user = User.find_by(id: params[:user_id])
            authenticate_with_http_token do |token, _options|
              render json: { is_logged_in: 'true' } if user&.authenticated?(:remember, token)
            end
          end

          def render_not_logged_in
            render json: { is_logged_in: 'false' }, status: 401
          end
      end
    end
  end
end
