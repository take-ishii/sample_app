require "rails_helper"

RSpec.describe "UserProfile", type: :feature do
  include_context "setup"

  subject { page }
  
  describe "profile" do
    before { valid_login(user) }
    
    it "タイトルが表示されていること" do
      expect(page).to have_title(user.name)
      expect(page).to have_css("h1", text: user.name)
    end
    
    it "パスが正しいこと" do
      expect(page).to have_current_path(user_path(user))
      expect(current_path).to eq user_path(user)
    end
    
    describe  "ユーザー情報" do
      before { my_posts }
      it { expect(user.microposts.count).to eq my_posts.count }
      it { expect(page).to  have_css("img.gravatar") }
      it { expect(page).to  have_css("h1", text: user.name) }
    end
    
    describe "マイクロポスト統計" do
      before do
        my_posts
        other_user
        other_posts
        user.follow(other_user)
        other_user.follow(user)
      end
      it { expect(user.microposts.count).to eq my_posts.count }
      it { expect(other_user.microposts.count).to eq other_posts.count }
      it { expect(page).to  have_link("following", href: following_user_path(user)) }
      it { expect(page).to  have_link("followers", href: followers_user_path(user)) }      
    end
    
    describe  "マイクロポスト"  do
      before { my_posts }
      it { expect(user.microposts.count).to eq my_posts.count }
      
      it "マイクロポストが表示されること" do
        expect {
          user.microposts.each do |micropost|
            expect(page).to have_link("img.gravatar", href: micropost.user)
            expect(page).to have_link("#{micropost.user.name}", href: micropost.user)
          end
        }
      end
    end
    
    describe "フォロー/フォロー解除ボタン" do
      before { visit user_path(other_user) }
      it { expect(1+1).to eq 2 }


      context "フォロー" do
        subject { click_button "Follow" }
        it "フォロー数が増加すること" do
          expect { subject }.to change(user.following, :count).by(1)
        end

        it "フォロワー数が増加すること" do
          expect { subject }.to change(other_user.followers, :count).by(1)
        end

        it "ボタンがunfollowになること" do
          expect {
            subject
            expect(page).to have_css "div#follow_form", text: "Unfollow"
          }
        end
      end
      context "フォロー解除" do
        before { click_button "Follow" }
        subject { click_button "Unfollow" }
        it "フォロー数が減少すること" do
          expect { subject }.to change(user.following, :count).by(-1)
        end
        it "フォロワー数が減少すること" do
          expect { subject }.to change(other_user.followers, :count).by(-1)
        end
        it "ボタンがFollowになること" do
          expect {
            subject
            expect(page).to have_css("div#follow_form", text: "Follow")
          }
        end
      end
    end
  end
end
