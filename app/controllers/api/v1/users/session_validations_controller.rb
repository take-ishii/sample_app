module Api
  module V1
    module Users
      class SessionValidationsController < ApplicationController
        def index
          if logged_in?(params[:user_id])
            head 200
          else
            head 401
          end
        end
      end
    end
  end
end
