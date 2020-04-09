class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      flash.now[:danger] = 'Invalid email/password combination' # flash.nowはレンダリングが終わっているページでフラッシュメッセージを表示、その後リクエストが発生したときに消滅
      render 'new'
    end
  end

  def destroy
  end
end
