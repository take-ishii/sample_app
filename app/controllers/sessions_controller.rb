class SessionsController < ApplicationController
  def new
    session[:outside_url] = params[:url]
    if logged_in? && session[:outside_url].present? && cookies.permanent.signed[:user_id].present? && cookies.permanent[:remember_token].present?
      uri = URI(session[:outside_url])
      ar = (uri.query ? URI.decode_www_form(uri.query) : []) << ["user_id", cookies.permanent.signed[:user_id]] << ["token", cookies.permanent[:remember_token]]
      uri.query = URI.encode_www_form(ar)          
      redirect_to uri.request_uri
    end
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password]) # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        if session[:outside_url].present?
          @user.remember if params[:session][:remember_me] != '1'
          uri = URI(session[:outside_url])
          ar = (uri.query ? URI.decode_www_form(uri.query) : []) << ["user_id", @user.id] << ["token", @user.remember_token]
          uri.query = URI.encode_www_form(ar)          
          redirect_to uri.request_uri
        else
          redirect_back_or @user
        end
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination' # flash.nowはレンダリングが終わっているページでフラッシュメッセージを表示、その後リクエストが発生したときに消滅
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
