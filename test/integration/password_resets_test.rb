require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path # パスワードリマインダー画面へ
    assert_template 'password_resets/new' # 指定されたテンプレートが選択されたか
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty? # フラッシュメッセージが空でないことを確認（エラーメッセージが表示されるか）
    assert_template 'password_resets/new'
    # メールアドレスが有効
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest # パスワードが更新されたか
    assert_equal 1, ActionMailer::Base.deliveries.size # メイラーに保存された件数が1件であること
    assert_not flash.empty? # 成功メッセージが表示されたか
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    user = assigns(:user) # アクション内で設定されたインスタンス変数を検証(直前に作られたインスタンス変数を取得)
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # 無効なユーザー
    user.toggle!(:activated) # toggleでboolを逆転（有効化を無効化へ）
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email # 画面のHTMLにinput属性、name:email、type:hidden、value:user.emailに表示されていることを確認
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation' # エラーがHTMLにあるか確認
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in? # ログイン状態であることを確認
    assert_not flash.empty?
    assert_redirected_to user
  end
end