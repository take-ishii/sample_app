require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system do
  include_context "setup"

  subject { page }

  describe "index" do
    before { users }
    it { expect(User.count).to eq users.count }

    scenario "ページネーションでユーザーが表示されること" do
      valid_login(user)
      click_link "Users"
      expect(page).to have_current_path("/users")
      expect(page).to have_css("h1", text: "All users")
      User.paginate(page: 1).each do |user|
        expect(page).to have_css("li", text: user.name)
      end
    end
  end
end