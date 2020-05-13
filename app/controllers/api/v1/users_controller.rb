module Api
  module V1
    class UsersController < ApplicationController
      def get_microposts
        user = User.find params[:id]
        microposts = user.microposts
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=80"
        render json: {user_name: user.name, icon_url: gravatar_url, microposts: microposts}
      end
    end
  end
end