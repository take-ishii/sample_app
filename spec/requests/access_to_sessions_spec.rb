require 'rails_helper'

RSpec.describe 'access to sessions', type: :request do
  let!(:user) { create(:user) }
  
  describe  "GET #new"  do
    it "ログイン画面の表示が正常であること" do
      get login_path
      expect(response).to have_http_status 200
    end
  end
  
  describe 'POST #create' do
    before { post login_path, params: { session: { email: user.email,
                                            password: user.password } } }
    it 'ログインに成功すること' do
      expect(is_logged_in?).to be_truthy
    end
    it 'ユーザーページにリダイレクトすること' do
      expect(response).to redirect_to user_path(user)
    end
  end
end