require 'rails_helper'

RSpec.describe "Remember me", type: :request do
  let(:user) { create(:user) }

  it "ログイン中にのみログアウトすること" do
    sign_in_as(user)
    expect(response).to redirect_to user_path(user)

    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil

    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil
  end

  describe "authenticated? should return false for a user with nil digest" do
  # ダイジェストが存在しない場合のauthenticated?のテスト
    it "is invalid without remember_digest" do
      expect(user.authenticated?(:remember, '')).to eq false
    end
  end
  
  describe  "チェックボックスのテスト" do
    context "チェックボックスオフの場合" do
      it "記憶トークンが空になっていること" do
        post login_path, params: { session: { email: user.email,
                                    password: user.password,
                                    remember_me: '0'} }
        delete logout_path
        expect(response.cookies['remember_token']).to eq nil
      end
    end
    context "チェックボックスオンの場合" do
      it "記憶トークンが空になっていないこと" do
        post login_path, params: { session: { email: user.email,
                    password: user.password,
                    remember_me: '1'} }
        expect(response.cookies['remember_token']).to_not eq nil

      end
    end
  end
end