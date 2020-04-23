require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe "GET #new" do
    before { get signup_path }
    it "レスポンス" do
      expect(response).to have_http_status(200)
    end
  end
end