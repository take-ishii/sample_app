require 'net/http'
require 'uri'
require 'json'

module Api
  module V1
    module Users
      class RelationshipsController < ApplicationController
        # createに対してのCSRF対策がオフになってない可能性があるので、デプロイ後の検証で引っかかったらここをチェック
        protect_from_forgery except: :create

        def create
          if request_session_validations(params[:user_id]) == '401'
            return render json: { "status": '401', "is_logged_in": 'false', "followed": 'false' }, status: 401
          end

          user = User.find_by(id: params[:user_id])
          if followed_user = User.find_by(id: params[:followed_id])
            if user.following?(followed_user)
              render json: { "status": '200', "is_logged_in": 'true', "followed": 'false' }, status: 200
            else
              user.follow(followed_user)
              render json: { "status": '200', "is_logged_in": 'true', "followed": 'true' }, status: 200
            end
          else
            render json: { "status": '404', "is_logged_in": 'true', "followed": 'false' }, status: 404
          end
        end

        private

          def request_session_validations(_user_id)
            uri = URI.parse("http://localhost:3000/api/v1/users/#{_user_id}/session_validations")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == 'https'
            headers = { "Content-Type": 'application/json' }
            authenticate_with_http_token do |token, _options|
              headers['Authorization'] = "Token #{token}"
            end
            response = http.get(uri.path, headers)
            response.code
          end
      end
    end
  end
end
