require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe `create` do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }
    let(:remember_token) { 'hogehoge' }
    before do
      user.update_attribute(:remember_digest, User.digest(remember_token))
    end
    subject(:json) { JSON.parse(response.body) }
  end
end
