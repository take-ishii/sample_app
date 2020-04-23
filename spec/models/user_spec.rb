require 'rails_helper'

RSpec.describe User, type: :model do

  #facrory botが存在するかのテストです
  it 'has a valid factory bot' do
    expect(build(:user)).to be_valid
  end

  #ここからバリデーションのテストです
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it do
      is_expected.to allow_values('first.last@foo.jp',
                                  'user@example.com',
                                  'USER@foo.COM',
                                  'A_US-ER@foo.bar.org',
                                  'alice+bob@baz.cn').for(:email)
    end
    it do
      is_expected.to_not allow_values('user@example,com',
                                      'user_at_foo.org',
                                      'user.name@example.',
                                      'foo@bar_baz.com',
                                      'foo@bar+baz.com').for(:email)
    end

    # emailの一意性検証
    describe 'validate unqueness of email' do
      let!(:user) { create(:user, email: 'original@example.com') }
      # メール重複
      it 'is invalid with a duplicate email' do
        user = build(:user, email: 'original@example.com')
        expect(user).to_not be_valid
      end
      # 大文字小文字区別
      it 'is case insensitive in email' do
        user = build(:user, email: 'ORIGINAL@EXAMPLE.COM')
        expect(user).to_not be_valid
      end
    end
    
    describe 'validate presence of password' do
      it 'is invalid with a blank password' do
        user = build(:user, password: ' ' * 6)
        expect(user).to_not be_valid
      end
    end
    it { is_expected.to validate_length_of(:password).is_at_least(6) }  
    
  end
  
  describe 'before_save' do
    describe '#email_downcase' do
      let!(:user) { create(:user, email: 'ORIGINAL@EXAMPLE.COM') }
      it 'makes email to low case' do
        expect(user.reload.email).to eq 'original@example.com'
      end
    end
  end
  

  
end