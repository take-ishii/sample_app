RSpec.shared_context "setup" do
  #ユーザー
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user)}
  let(:admin) { create(:admin_user) }
  let(:admin_params) { attributes_for(:user, admin: true)}
  let(:users) { create_list(:other_user, 30) }
  #マイクロポスト
  let(:my_post) { create(:user_post) }
  let(:my_posts) { create_list(:user_post, 30, user: user) }
  let(:post_params) { attributes_for(:user_post) }
  let(:other_posts) { create_list(:other_user_post, 30, user: other_user) }
end