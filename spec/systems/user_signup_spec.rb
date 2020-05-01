require "rails_helper"

RSpec.describe "Users SignUp", type: :system do
  
  describe "SignUp" do
    before  { visit "/signup" }
    before { ActionMailer::Base.deliveries.clear }
    
    describe  "signupフォーム確認" do
      it { expect(page).to have_css("label", text: "Name") }
      it { expect(page).to have_css("label", text: "Email") }
      it { expect(page).to have_css("label", text: "Password") }
      it { expect(page).to have_css("label", text: "Confirmation") }
      it { expect(page).to have_css("input#user_name") }
      it { expect(page).to have_css("input#user_email") }
      it { expect(page).to have_css("input#user_password") }
      it { expect(page).to have_css("input#user_password_confirmation") }
      it { expect(page).to have_button("Create my account") }
    end
    
    context "有効な値の場合" do
      scenario "ユーザーが作成されること" do
        expect {
          visit signup_path
          fill_in "Name",         with: "Test"
          fill_in "Email",        with: "testuser@example.com"
          fill_in "Password",     with: "password"
          fill_in "Confirmation", with: "password"
          click_button "Create my account"
        }.to change(User, :count).by(1)
        
        expect(page).to have_css("div.alert.alert-info", text: "Please check your email to activate your account")
        expect(page).to have_current_path(root_path)
      end
    end
    context "無効な値の場合" do
      scenario "ユーザーが作成されないこと" do
        expect {
          visit signup_path
          fill_in "Name",         with: ""
          fill_in "Email",        with: ""
          fill_in "Password",     with: ""
          fill_in "Confirmation", with: ""
          click_button "Create my account"
        }.to change(User, :count).by(0)
        expect(page).to have_css("div.alert.alert-danger", text: "errors")
        expect(page).to have_title("Sign up")
        expect(page).to have_css("h1", text: "Sign up")
      end
    end    
  end
end