require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
    get login_path  # ログイン用のパスを開く
    assert_template 'sessions/new'  # 新しいセッションのフォームが正しく表示されたことを確認
    post login_path, params: {session: {email:"", password: ""}}  # わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
    assert_template 'sessions/new'
    assert_not flash.empty? # 新しいセッションのフォームが再度表示され、フラッシュメッセージが追加されることを確認
    get root_path
    assert flash.empty? # 移動先のページでフラッシュメッセージが表示されていないことを確認
  end
  
  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user  # リダイレクト先が正しいかどうかを確認
    follow_redirect!            # リダイレクト先に実際に移動する
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # count:0をオプションに追加することで、渡したパターンに一致するリンクが0かどうかを確認
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
