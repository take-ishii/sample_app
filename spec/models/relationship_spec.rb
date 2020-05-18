require "rails_helper"

RSpec.describe  Relationship, type: :model  do
  
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:active) { user.active_relationships.build(followed_id: other_user.id) }
  subject { active }
  it { is_expected.to be_valid }
  
  describe  "フォローフォロワーメソッド" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }    
    
    it "followerメソッドは、フォローしているユーザーを返すこと" do
      expect(active.follower).to eq user
    end
    
    it "follwerdメソッドは、フォローされているユーザーを返すこと" do
      expect(active.followed).to eq other_user
    end
  end
  
  describe  "検証"  do
    describe  "属性"  do
      it { is_expected.to validate_presence_of :followed_id }
      it { is_expected.to validate_presence_of :follower_id }      
    end
  end
end
