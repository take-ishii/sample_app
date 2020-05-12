require "rails_helper"

RSpec.describe "get microposts api", type: :request do

  
  describe "特定ユーザーのマイクロポストを取得する" do
    let!(:user) { create(:user) }
    let!(:micropost) { create_list(:user_post,200, user: user) }
    subject(:json) { JSON.parse(response.body) }  
    
    before { get "/api/v1/users/#{user.id}/get_microposts" }
    
    it "リクエストが成功していること" do
      expect(response.status).to eq(200)
    end
    
    it "ユーザー名を取得していること" do
      expect(json["user_name"]).to eq(user.name)
    end    
    
    it "アイコンURLを取得していること" do
      expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
    end    
    
    it "生成した全てのマイクロポストを取得していること" do
      expect(json["microposts"].length).to eq(200)
    end
  end

end