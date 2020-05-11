require 'rails_helper'

RSpec.describe "MicropostsPages", type: :feature do
  include_context "setup"

  subject { page }

  describe "create" do
    before { valid_login(user) }

    context "有効な値の場合" do
      it "Micropostの作成に成功する" do
        expect {
          visit root_path
          fill_in "micropost_content", with: "test"
          click_button "Post"
        }.to change(Micropost, :count).by(1)
        expect(page).to have_css("div.alert.alert-success", text: "Micropost created")
      end
    end

    context "無効な値の場合" do
      it "Micropostの作成に失敗する" do
        expect {
          visit root_path
          fill_in "micropost_content", with: ""
          click_button "Post"
        }.to change(Micropost, :count).by(0)
        expect(page).to have_css("div.alert.alert-danger")
      end
    end
  end

  describe "destroy", type: :request do
    before { valid_login(user) }

    context "他人のマイクロポストの場合" do
      before { other_posts }
      it "失敗する" do
        expect {
          delete micropost_path(other_posts.first.id)
        }.to change(Micropost, :count).by(0)
      end
    end
  end

end