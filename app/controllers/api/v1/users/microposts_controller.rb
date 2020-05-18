module Api
  module V1
    module Users
      class MicropostsController < ApplicationController

        def index
          user = User.find(params[:user_id])  

          gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
          gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=80"
          render json: {user_name: user.name, icon_url: gravatar_url, microposts: user.microposts.paginate(page: params[:page])}
          
        rescue ActiveRecord::RecordNotFound
          response.status = 404
          render json: {message: "Validation Failed"}
        end
      end
    end
  end
end
