require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }
  it { is_expected.to be_valid }
  
  describe  "モデルの属性"  do
    describe "属性" do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :email }
    end
    
    describe  "長さとか"  do
      it {  is_expected.to  validate_length_of(:name).is_at_most(50)  }
      it {  is_expected.to  validate_length_of(:email).is_at_most(255)  }  
      it {  is_expected.to  validate_length_of(:password).is_at_least(6)  }      
    end
  end

  describe "メールアドレスの一意性" do  
    it "重複したメールアドレスなら無効な状態であること" do
      create(:user, email: "aaron@example.com")
      user = build(:user, email: "Aaron@example.com")
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end
  end
  
  describe  "メールアドレスの有効性" do
    context "無効なメールアドレスの場合"  do
      it "ユーザーが無効であること" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                              foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each  do  |invalid_addresses|
          user.email  = invalid_addresses
          expect(user).to_not be_valid
        end
      end
    end
    
    context "有効なメールアドレスの場合"  do
      it "ユーザーが有効であること" do
        valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@bar.cn]
        valid_addresses.each  do  |valid_addresses|
          user.email  = valid_addresses
          expect(user).to be_valid
        end
      end
    end
  end
  
  describe  "パスワード確認"  do
    context "一致する場合"  do
      it "ユーザーが有効であること" do
        user  = build(:user,  password: "password", password_confirmation: "password")
        expect(user).to be_valid
      end
    end
    
    context "一致しない場合"  do
      it "ユーザーが無効であること" do
        user  = build(:user,  password: "password", password_confirmation: "different")
        expect(user).to_not be_valid
        expect(user.errors[:password_confirmation]).to  include("doesn't match Password")
      end
    end
  end
  
  describe  "マイクロポスト"  do
    before { user.save }
    
    let(:new_post) { create(:user_post, :today, user: user) }
    let(:old_post) { create(:user_post, :yesterday, user: user) }    
    
    it "降順に表示されること" do
      new_post
      old_post
      expect(user.microposts.to_a).to eq [new_post, old_post]
    end
    
    it "ユーザーが削除されるとマイクロポストも削除されること" do
      new_post
      old_post    
      
      my_post = user.microposts.to_a
      user.destroy
      
      expect(my_post).not_to be_empty
      user.microposts.each do |post|
        expect(Micropost.where(id: post.id)).to be_empty
      end
    end
    
    describe "マイクロポストフィード" do
      let(:following) { create_list(:other_user, 30) }
      let(:not_following) { create(:other_user) }

      before do
        create_list(:user_post, 10, user: user)
        create_list(:other_user_post, 10, user: not_following)
        following.each do |u|
          user.follow(u)
          u.follow(user)
          create_list(:other_user_post, 3, user: u)
        end
      end
      
      it { expect(user.microposts.count).to eq 10 }
      it { expect(not_following.microposts.count).to eq 10 }
      
      describe  "正しいマイクロポスト"  do
        it "フォローユーザーのマイクロポストが含まれていること" do
          following.each  do  |u|
            u.microposts.each do |post|
              expect(user.feed).to  include(post)
            end
          end
        end
        it "ユーザー自身のマイクロポストが含まれていること" do
          user.microposts.each  do  |post|
            expect(user.feed).to include(post)
          end
        end
        it "フォローしていないユーザーのマイクロポストは含まれていないこと" do
          not_following.microposts.each do |post|
            expect(user.feed).not_to include(post)
          end
        end
      end
    end
  end
  
  describe  "フォロー/フォロー解除" do
    let(:following) { create_list(:other_user, 30) }
    
    before  do
      user.save
      following.each  do  |u|
        user.follow(u)
        u.follow(user)
      end
    end
    
    describe  "フォロー"  do
      it "following?メソッドが動いていること" do
        following.each do |u|
          expect(user.following?(u)).to be_truthy
        end
      end
      
      it "other_userをフォローしていること" do
        following.each do |u|
          expect(user.following).to include(u)
        end
      end
      
      it "フォロワーがユーザーをフォローしていること" do
        following.each do |u|
          expect(u.followers).to include(user)
        end
      end
    end
    
    describe  "フォロー解除" do
      before  do
        following.each do |u|
          user.unfollow(u)
        end
      end
      
      it "following?メソッドが動いていること" do
        following.each do |u|
          expect(user.following?(u)).to be_falsey
        end
      end
      
      it "other_userをフォローしていないこと" do
        following.each do |u|
          expect(user.reload.following).not_to include(u)
        end
      end

      it "フォロワーがユーザーをフォローしていないこと" do
        following.each do |u|
          expect(u.followers).not_to include(user)
        end
      end
    end
  end
end
