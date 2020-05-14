require "rails_helper"

RSpec.describe "access to users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:admin_user) { create(:admin_user) }
  
  describe  "GET #index" do
    context "ログイン済みの場合" do
      it "レスポンスが正常であること" do
        sign_in_as user
        get users_path
        expect(response).to be_success
        expect(response).to have_http_status 200
      end
    end
    
    context "ログイン済みでない場合" do
      it "ログイン画面にリダイレクトすること" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe  "GET #show" do
    context "ログイン済みの場合"  do
      it "レスポンスが正常であること" do
        sign_in_as user
        get users_path(user)
        expect(response).to be_success
        expect(response).to have_http_status 200
      end
    end
    
    context "ログイン済みでない場合" do
      it "ログイン画面にリダイレクトすること" do
        get users_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe  "GET #new"  do 
    it "レスポンスが正常であること" do
      get signup_path
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end
  
  describe  "POST #create"  do
    context "リクエストが正常の場合" do
      it "ユーザーが追加されること" do
        expect do
          post signup_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)      
      end
      
      context "ユーザーが追加された場合" do
        before { post signup_path, params: { user: attributes_for(:user) } }
        subject { response }
        it "ホーム画面にリダイレクトされること" do 
          is_expected.to redirect_to root_path
          is_expected.to have_http_status 302
        end
      end
    end
    
    context "リクエストが異常の場合" do
      let(:user_params) do
        attributes_for(:user, name: "",
                              email: "user@..invalid",
                              password: "",
                              password_confirmation: "")
      end
      
      it "ユーザーが追加されないこと" do
        expect do
          post signup_path, params: { user: user_params }
        end.to change(User, :count).by(0)
      end
    end
  end
  
  describe  "GET #edit" do
    context "ログイン済みの場合"  do
      it "レスポンスが正常であること" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_success
        expect(response).to have_http_status 200
      end
    end
    
    context "ログイン済みでない場合"  do
      it "ログイン画面にリダイレクトすること" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
    end
    
    context "異なるユーザーの場合"  do
      it "ホーム画面にリダイレクトすること" do
        sign_in_as(user)
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path        
      end
    end
  end
  
  describe  "#update" do
    context "ユーザー本人の場合"  do
      it "ユーザー情報を更新できること" do
        user_params = attributes_for(:user, name: "UpdateName")
        sign_in_as user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq "UpdateName"
      end
    end
    
    context "ログイン済みでない場合"  do
      it "ログイン画面にリダイレクトすること" do
        user_params = attributes_for(:user, name: "UpdateName")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to login_path
      end
    end
    
    context "異なるユーザーの場合"  do
      it "ユーザー情報を更新できないこと" do
        user_params = attributes_for(:user, name: "UpdateName")
        sign_in_as user
        patch user_path(other_user), params: { id: user.id, user: user_params }
        expect(other_user.reload.name).to eq other_user.name
      end
      it "ホーム画面にリダイレクトこと" do
        user_params = attributes_for(:user, name: "UpdateName")
        sign_in_as user
        patch user_path(other_user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe  "#destroy"  do
    context "Adminユーザーの場合" do
      it "ユーザーを削除できること" do
        sign_in_as admin_user
        expect {
          delete user_path(admin_user), params: { id: admin_user.id }
        }.to change(User, :count).by(-1)
      end
    end
    
    context "Adminユーザーでない場合" do
      it "ユーザーを削除できないこと" do
        sign_in_as user
        expect {
          delete user_path(user), params: { id: user.id }
        }.to change(User, :count).by(0)
      end
      it "ホーム画面にリダイレクトすること" do
        sign_in_as user
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end
