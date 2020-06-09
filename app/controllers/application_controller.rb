class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def valid_authorization_session?(user_id)
      user = User.find_by(id: user_id)
      authenticate_with_http_token do |token, _options|
        return user && user.authenticated?(:remember, token)
      end
    end
end
