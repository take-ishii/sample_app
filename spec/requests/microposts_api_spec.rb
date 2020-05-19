require "rails_helper"

shared_examples "マイクロポストの検証" do
  before { get "/api/v1/users/#{user.id}/microposts?page=#{page}&per=#{per_page}" }

  it "リクエストが成功していること" do
    expect(response.status).to eq(200)
  end
  it "ユーザー名を取得していること" do
    expect(json["user_name"]).to eq(user.name)
  end    
  it "アイコンURLを取得していること" do
    expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
  end    
  it "指定したページのマイクロポストを取得していること" do
    expect(json["microposts"].length).to eq([microposts.length - (page - 1) * per_page, per_page].min)
  end
end

RSpec.describe "microposts api", type: :request do

  describe "特定ユーザーのマイクロポストを取得する" do
    subject(:json) { JSON.parse(response.body) }  

    context "ユーザーがIDが存在している場合" do
      let!(:user) { create(:user) }
      
      context "投稿があるユーザーの場合" do
        let!(:microposts) { create_list(:user_post, 21, user: user) }
        let!(:per_page) { 20 }
        
        context "1ページ目のマイクロポストを取得しようとした場合" do
          let!(:page) { 1 }
          it_behaves_like "マイクロポストの検証"
        end
        
        context "最終ページのマイクロポストを取得しようとした場合" do
          let!(:page) { microposts.length / per_page + 1 }
          it_behaves_like "マイクロポストの検証"
        end
      end
      
      context "投稿がないユーザーの場合" do
        let!(:microposts) { create_list(:user_post, 0, user: user)}
        let!(:page) { 1 }
        let!(:per_page) { 20 }
        it_behaves_like "マイクロポストの検証"
      end
    end

    context "ユーザーIDが存在していない場合" do
      before { get "/api/v1/users/500/microposts" }
      
      it "リクエストが失敗していること" do
        expect(response.status).to eq(404)
      end
      
      it "エラーメッセージが返ってきていること" do
        expect(json["message"]).to eq("Validation Failed")   
      end
    end
  end
end
