require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do

  context "GET #home" do
    before { get root_path }
    
    it "レスポンスが正常であること" do
      expect(response).to have_http_status 200
    end
    
    it "タイトルが表示されていること" do
      expect(response.body).to include full_title("")
      expect(response.body).to_not include "| Ruby on Rails Tutorial Sample App"
    end
  end
  
  context "GET #help" do
    before { get help_path }
    
    it "レスポンスが正常であること" do
      expect(response).to have_http_status 200
    end
    
    it "タイトルが表示されていること" do
      expect(response.body).to include full_title("Help")
    end
  end

  context "GET #about" do
    before { get about_path }
    
    it "レスポンスが正常であること" do
      expect(response).to have_http_status 200
    end
    
    it "タイトルが表示されていること" do
      expect(response.body).to include full_title("About")
    end
  end
  context "GET #contact" do
    before { get contact_path }
    
    it "レスポンスが正常であること" do
      expect(response).to have_http_status 200
    end
    
    it "タイトルが表示されていること" do
      expect(response.body).to include full_title("Contact")
    end
  end
end