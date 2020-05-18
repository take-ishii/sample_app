require "rails_helper"

RSpec.describe "microposts api", type: :request do

  
  describe "特定ユーザーのマイクロポストを取得する" do
    subject(:json) { JSON.parse(response.body) }  

    context "ユーザーがIDが存在している場合" do
      let!(:user) { create(:user) }
      
      context "投稿があるユーザーの場合" do
        let!(:microposts) { create_list(:user_post,32, user: user) }
        
        context "1ページ目のmicropostsを取得しようとした場合" do
          before { get "/api/v1/users/#{user.id}/microposts?page=1" }
    
          it "リクエストが成功していること" do
            expect(response.status).to eq(200)
          end
          
          it "ユーザー名を取得していること" do
            expect(json["user_name"]).to eq(user.name)
          end    
          
          it "アイコンURLを取得していること" do
            expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
          end    
          
          it "1ページ目のマイクロポストを取得していること" do
            expect(json["microposts"].length).to eq([microposts.length,30].min)
          end
        end
        context "最終ページのmicropostsを取得しようとした場合" do
          before { get "/api/v1/users/#{user.id}/microposts?page=#{microposts.length/30+1}" }
    
          it "リクエストが成功していること" do
            expect(response.status).to eq(200)
          end
          
          it "ユーザー名を取得していること" do
            expect(json["user_name"]).to eq(user.name)
          end    
          
          it "アイコンURLを取得していること" do
            expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
          end    
          
          it "最終ページのマイクロポストを取得していること" do
            expect(json["microposts"].length).to eq([microposts.length%30,30].min)
          end
        end
      end
      
      context "投稿がないユーザーの場合" do
        before { get "/api/v1/users/#{user.id}/microposts?page=1" }
  
        it "リクエストが成功していること" do
          expect(response.status).to eq(200)
        end
        
        it "ユーザー名を取得していること" do
          expect(json["user_name"]).to eq(user.name)
        end    
        
        it "アイコンURLを取得していること" do
          expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
        end    
        
        it "マイクロポストを一つも取得しないこと" do
          expect(json["microposts"].length).to eq(0)
        end
      end
      
      context "膨大な投稿があるユーザーの場合" do
        let!(:microposts) { create_list(:user_post,1000, user: user) }

        context "1ページ目のmicropostsを取得しようとした場合" do
          before { get "/api/v1/users/#{user.id}/microposts?page=1" }
  
          it "リクエストが成功していること" do
            expect(response.status).to eq(200)
          end
          
          it "ユーザー名を取得していること" do
            expect(json["user_name"]).to eq(user.name)
          end    
          
          it "アイコンURLを取得していること" do
            expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
          end    
          
          it "1ページ目のマイクロポストを取得していること" do
            expect(json["microposts"].length).to eq([microposts.length,30].min)
          end
        end
        context "最終ページのmicropostsを取得しようとした場合" do
          before { get "/api/v1/users/#{user.id}/microposts?page=#{microposts.length/30+1}" }
    
          it "リクエストが成功していること" do
            expect(response.status).to eq(200)
          end
          
          it "ユーザー名を取得していること" do
            expect(json["user_name"]).to eq(user.name)
          end    
          
          it "アイコンURLを取得していること" do
            expect(json["icon_url"]).to eq("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?s=80")
          end    
          
          it "最終ページのマイクロポストを取得していること" do
            expect(json["microposts"].length).to eq([microposts.length%30,30].min)
          end
        end
      end
    end

    context "ユーザーIDが存在していない場合" do
      before { get "/api/v1/users/500/microposts?page=1" }
      
      it "リクエストが失敗していること" do
        expect(response.status).to eq(404)
      end
      
      it "エラーメッセージが返ってきていること" do
        expect(json["message"]).to eq("Validation Failed")   
      end
    end
  end
end
