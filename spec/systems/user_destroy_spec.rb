RSpec.describe 'UsersDestory', type: :system do
  include_context "setup"

  describe "ユーザー削除権限" do
    before { users }
    it { expect(User.count).to eq users.count }

    context "adminユーザーの場合" do
      scenario "ユーザーを削除できる" do
        valid_login(admin)
        click_link "Users"
        expect(page).to have_current_path("/users")
        expect(page).to have_link('delete', href: user_path(User.first))
        expect(page).to have_link('delete', href: user_path(User.second))
        expect(page).not_to have_link('delete', href: user_path(admin))
        expect {
          click_link('delete', match: :first)
          expect(page.driver.browser.switch_to.alert.text).to eq "You sure?"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_css("div.alert.alert-success", text: "User deleted")
        }.to change(User, :count).by(-1)
      end
    end

    context "adminユーザーでない場合" do
      scenario "ユーザーを削除できない" do
        valid_login(user)
        click_link "Users"
        expect(page).to have_current_path("/users")
        expect(page).not_to have_link('delete', href: user_path(User.first))
        expect(page).not_to have_link('delete', href: user_path(User.second))
        #expect {
          #delete user_path(User.second)
        #}.to change(User, :count).by(0)
      end
    end
  end
end
