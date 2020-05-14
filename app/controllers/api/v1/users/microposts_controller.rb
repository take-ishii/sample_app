module Api
  module V1
    module Users
      class MicropostsController < ApplicationController
        def index
          user = User.find_by(id: params[:user_id])
          
          if user
            gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
            gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=80"
            render json: {user_name: user.name, icon_url: gravatar_url, microposts: user.microposts}
          else
            render json: {message: "Validation Failed"}            
          end
        end
      end
    end
  end
end
