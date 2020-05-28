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

    context `unavailable user_id` do
      it `returns 401` do
        get "/api/v1/users/999/session_validations", headers: { Authorization: "Token token=#{remember_token}" }
        expect(response.status).to eq(401)
      end
    end

    context `unavailable remember_token` do
      it `returns 401` do
        get "/api/v1/users/#{user.id}/session_validations", headers: { Authorization: "Token token=WrongToken" }
        expect(response.status).to eq(401)
      end
    end

    context `nil remember_token` do
      it `returns 401` do
        get "/api/v1/users/#{user.id}/session_validations"
        expect(response.status).to eq(401)
      end
    end

    context `unavailable user_id and remember_token` do
      it `returns 401` do
        get "/api/v1/users/999/session_validations", headers: { Authorization: "Token token=WrongToken" }
        expect(response.status).to eq(401)
      end
    end
  end
end
