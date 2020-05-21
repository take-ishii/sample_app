module Api
  module V1
    module Users
      class MicropostsController < API::BaseController

        def index
          user = User.find(params[:user_id])  
          per_page = params[:per].nil? ? 30 : [params[:per].to_i, 100].min
          microposts = user.microposts.paginate(page: params[:page], per_page: per_page)

          gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
          gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=80"
          render json: {user_name: user.name, icon_url: gravatar_url, microposts: microposts}
        end
      end
    end
  end
end
