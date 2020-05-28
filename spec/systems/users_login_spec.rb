require 'rails_helper'

RSpec.describe 'UsersLogin', type: :system do
  include_context "setup"

  subject { page }
  let(:not_active_user) { create(:other_user, activated: false) }

  describe "内部からのログイン" do
    before { visit "/login" }

    context "ログインの値が有効の場合" do
      scenario "ログインできること" do
        visit "/login"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"
        expect(page).to have_title(user.name)
        expect(page).to have_css('h1', text: user.name)
        expect(page).to have_current_path(user_path(user))
      end
    end

    context "ログインの値が無効の場合" do
      scenario "ログインできないこと" do
        visit "/login"
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        click_button "Log in"
        expect(page).to have_title("Log in")
        expect(page).to have_css("h1", text: "Log in")
        expect(page).to have_current_path("/login")
      end
    end
    
    context "有効化されていない場合" do
      scenario "ログインできないこと" do
        visit "/login"
        fill_in "Email", with: not_active_user.email
        fill_in "Password", with: not_active_user.password
        click_button "Log in"
        expect(page).to_not have_title(not_active_user.name)          
        expect(page).to have_current_path(root_path)
      end
    end
  end
  
  describe "外部からのログイン" do
    let(:user) { create(:user) }
    context "ログインしている場合" do
      context "cookieにidとtokenが保存されている場合" do
        before do
          valid_remember_login(user)
          visit "/login?url=#{help_url}"
        end
        after do
          # FIXME: visitしないとCookieが消えずログイン状態が引き継がれる
          visit root_url
        end
        
        scenario "リダイレクトURLが指定したURLであること" do
          expect(page).to have_current_path(help_url, ignore_query: true)
        end
        scenario "user_idとtokenがURLに含まれていること" do
          expect(current_url).to include("user_id=")
          expect(current_url).to_not include("user_id=&")
          expect(current_url).to include("token=")
          expect(current_url).to_not end_with("token=")
        end
      end
      
      context "cookieにidとtokenが保存されていない場合" do
        before do
          valid_login(user)
          visit "/login?url=#{help_url}"
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end
        after do
          # FIXME: visitしないとCookieが消えずログイン状態が引き継がれる
          visit root_url
        end
        
        scenario "リダイレクトURLが指定したURLであること" do
          expect(page).to have_current_path(help_url, ignore_query: true)
        end
        scenario "user_idとtokenがURLに含まれていること" do
          expect(current_url).to include("user_id=")
          expect(current_url).to_not include("user_id=&")
          expect(current_url).to include("token=")
          expect(current_url).to_not end_with("token=")
        end
      end
    end
    
    context "ログインしていない場合" do
      before do
        visit "/login?url=#{help_url}"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"
      end
      after do
        # FIXME: visitしないとCookieが消えずログイン状態が引き継がれる
        visit root_url
      end
      
      scenario "リダイレクトURLが指定したURLであること" do
        expect(page).to have_current_path(help_url, ignore_query: true)
      end
      scenario "user_idとtokenがURLに含まれていること" do
        expect(current_url).to include("user_id=")
        expect(current_url).to_not include("user_id=&")
        expect(current_url).to include("token=")
        expect(current_url).to_not end_with("token=")
      end
    end
  end
  
  describe "logout" do
    scenario "正常にログアウトできること" do
      valid_login(user)
      click_link "Account"
      click_link "Log out"
      expect(page).to have_current_path root_path
      expect(page).to have_link 'Log in', href: login_path
    end
  end
end
