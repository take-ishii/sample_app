require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path  # ログイン用のパスを開く
    assert_template 'sessions/new'  # 新しいセッションのフォームが正しく表示されたことを確認
    post login_path, params: {session: {email:"", password: ""}}  # わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
    assert_template 'sessions/new'
    assert_not flash.empty? # 新しいセッションのフォームが再度表示され、フラッシュメッセージが追加されることを確認
    get root_path
    assert flash.empty? # 移動先のページでフラッシュメッセージが表示されていないことを確認
  end
end
