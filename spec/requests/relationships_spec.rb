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

    context `available requests and successful to follow` do
      before do
        post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                      headers: { Authorization: "Token #{remember_token}" }
      end
      it `returns 200` do
        expect(response.status).to eq 200
      end
      it `is logged in` do
        expect(json["is_logged_in"]).to be true
      end
      it `is successful to follow` do
        expect(json["followed"]).to be true
      end
    end

    context `available requests and already followed` do
      before do
        Micropost.create(follower_id: user.id, followed_id: other_user.id)
        post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                      headers: { Authorization: "Token #{remember_token}" }
      end
      it `returns 200` do
        expect(response.status).to eq 200
      end
      it `is logged in` do
        expect(json["is_logged_in"]).to be true
      end
      it `is already followed` do
        expect(json["followed"]).to be false
      end
    end
  end
end
