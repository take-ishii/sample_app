require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe `create` do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }
    let!(:not_member) { User.new(id: 999, name: 'not_member', email: 'not_member@example.com', remember_digest: User.digest(remember_token)) }
    let(:remember_token) { 'hogehoge' }
    before do
      user.update_attribute(:remember_digest, User.digest(remember_token))
    end
    subject(:json) { JSON.parse(response.body) }

    context `post available requests to followAPI` do
      it `is successful to SessionValidation API` do
        get "/api/v1/users/#{user.id}/session_validations", headers: { Authorization: "Token token=#{remember_token}" }
        expect(response.status).to eq(200)
      end
      context 'successful to follow' do
        before do
          post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                        headers: { Authorization: "Token #{remember_token}" }
        end
        it `returns 200` do
          expect(response.status).to eq 200
        end
        it `is logged in` do
          expect(json['is_logged_in']).to be true
        end
        it `is successful to follow` do
          expect(json['followed']).to be true
        end
      end

      context `already followed` do
        before do
          Relationship.create(follower_id: user.id, followed_id: other_user.id)
          post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                        headers: { Authorization: "Token #{remember_token}" }
        end
        it `returns 200` do
          expect(response.status).to eq 200
        end
        it `is logged in` do
          expect(json['is_logged_in']).to be true
        end
        it `is already followed` do
          expect(json['followed']).to be false
        end
      end
    end

    context `unavailable user_id` do
      it `is unsuccessful to SessionValidation API` do
        get "/api/v1/users/#{not_member.id}/session_validations", headers: { Authorization: "Token token=#{remember_token}" }
        expect(response.status).to eq(401)
      end
      context `unsuccessful to follow` do
        before do
          post '/api/v1/relationships', params: { user_id: not_member.id, followed_id: other_user.id },
                                        headers: { Authorization: "Token #{remember_token}" }
        end
        it `returns 401` do
          expect(response.status).to eq 401
        end
        it `is not logged in` do
          expect(json['is_logged_in']).to be false
        end
        it `is not followed` do
          expect(json['followed']).to be false
        end
      end
    end

    context `available user_id and available followed_id and unavailable token` do
      before do
        post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                      headers: { Authorization: 'Token MistakeToken' }
      end
      it `returns 401` do
        expect(response.status).to eq 401
      end
      it `is not logged in` do
        expect(json['is_logged_in']).to be false
      end
      it `is not followed` do
        expect(json['followed']).to be false
      end
    end

    context `available user_id and unavailable followed_id` do
      before do
        post '/api/v1/relationships', params: { user_id: user.id, followed_id: other_user.id },
                                      headers: { Authorization: "Token #{remember_token}" }
      end
      it `returns 404` do
        expect(response.status).to eq 404
      end
      it `is logged in` do
        expect(json['is_logged_in']).to be true
      end
      it `is not followed` do
        expect(json['followed']).to be false
      end
    end
  end
end
