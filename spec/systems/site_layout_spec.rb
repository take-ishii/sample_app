require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  
  context 'root_pathにアクセスした場合' do
    before { visit root_path }
    subject { page }
    it 'root_path,help_path,about_pathが存在すること' do
      is_expected.to have_link nil, href: root_path, count: 2
      is_expected.to have_link 'Help', href: help_path
      is_expected.to have_link 'About', href: about_path
    end
  end
  
  context 'signup_pathにアクセスした場合' do
    before  { visit signup_path }
    subject { page }
    it "SignUpと表示されていること" do
      is_expected.to  have_content  'Sign up'
    end
    it "タイトルにsign upと表示されていること" do
      is_expected.to  have_title  full_title('Sign up')
    end
  end
end
