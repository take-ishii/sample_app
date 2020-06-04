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
          if !logged_in_authorization?(params[:user_id])
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
      end
    end
  end
end
