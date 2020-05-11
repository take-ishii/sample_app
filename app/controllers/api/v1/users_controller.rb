module Api
  module V1
    class UsersController < ApplicationController
      def get_microposts
        @user = User.find params[:id]
        microposts = @user.microposts
        render json: { data: microposts.paginate(page: params[:page]) }
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end