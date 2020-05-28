require 'rails_helper'

RSpec.describe "SessionValidations", type: :request do
  describe `index` do
    let!(:user) { create(:user) }
    let(:remember_token) { "hogehoge" }
    context `available user_id and remember_token` do
      before do
        user.update_attribute(:remember_digest, User.digest(remember_token))
      end
      it `returns 200` do
        get "/api/v1/users/#{user.id}/session_validations", headers: { Authorization: "Token token=#{remember_token}" }
        expect(response.status).to eq(200)
      end
    end
  end
end
