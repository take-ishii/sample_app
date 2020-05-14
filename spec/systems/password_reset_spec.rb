require 'rails_helper'

RSpec.describe "PasswordReset", type: :system do
  let!(:user) { create(:user) }
  before { visit new_password_reset_path }
  subject { page }
  
  it { is_expected.to have_current_path(new_password_reset_path) }

  context "正しいメールアドレスを入力した場合" do
    it `フラッシュメッセージが表示されること` do
      fill_in 'Email', with: user.email
      click_button 'Submit'
      is_expected.to have_selector('.alert')
      is_expected.to have_current_path(root_path)
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end
  context "間違ったメールアドレスを入力した場合" do
    it `エラーフラッシュメッセージが表示されること` do
      fill_in 'Email', with: ""
      click_button 'Submit'
      is_expected.to have_selector('.alert-danger')
    end
  end
end
