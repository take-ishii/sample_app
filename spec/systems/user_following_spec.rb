require 'rails_helper'

RSpec.describe 'UsersFollowing', type: :system do
  let(:user) { create(:user) }
  let(:users) { create_list(:other_user, 30) }

  subject { page }

  describe "following/followers メソッド" do
    before do
      users
      users.each do |u|
        user.follow(u)
        u.follow(user)
      end
      user.follow(other_user)
      other_user.follow(user)
    end

    it { expect(user.following.count).to eq 31 }
    it { expect(other_user.following.count).to eq 1 }
    it { expect(user.followers.count).to eq 31 }

    describe "フォロー" do
      before do
        valid_login(user)
        click_link "following"
      end
      it { expect(page).to have_css('img.gravatar') }
      it { expect(page).to have_css('h1', text: user.name) }
      it { expect(page).to have_text("Microposts") }
      it { expect(page).to have_link("view my profile", href: user_path(user)) }
    end
    describe "フォロワー" do
      before do
        valid_login(user)
        click_link "following"
      end
      it { expect(page).to have_css('img.gravatar') }
      it { expect(page).to have_css('h1', text: user.name) }
      it { expect(page).to have_text("Microposts") }
      it { expect(page).to have_link("view my profile", href: user_path(user)) }
    end

    describe "ページネーション" do
      before { valid_login(user) }
      scenario "フォロー一覧" do
        click_link "following"
        user.following.paginate(page: 1).each do |u|
          expect(page).to have_css("li", text: u.name)
          expect(page).to have_link(u.name, href: user_path(u))
        end
      end
      scenario "フォロワー一覧" do
        click_link "followers"
        user.followers.paginate(page: 1).each do |u|
          expect(page).to have_css("li", text: u.name)
          expect(page).to have_link(u.name, href: user_path(u))
        end
      end
    end
  end
end
