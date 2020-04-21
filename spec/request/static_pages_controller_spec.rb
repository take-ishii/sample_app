require 'rails_helper'

RSpec.describe 'Access to static_pages', type: :request do
  it "get home" do
    get root_path
    expect(response).to have_http_status(200)
    expect(response.body).to include 'Ruby on Rails Tutorial Sample App'
    expect(response.body).to_not include '| Ruby on Rails Tutorial Sample App'
    
  end
  it "get help" do
    get help_path
    expect(response).to have_http_status(200)
    expect(response.body).to include 'Help | Ruby on Rails Tutorial Sample App'
  end  
  it "get about" do
    get about_path
    expect(response).to have_http_status(200)
    expect(response.body).to include 'About | Ruby on Rails Tutorial Sample App'
  end  
  it "get contact" do
    get contact_path
    expect(response).to have_http_status(200)
    expect(response.body).to include 'Contact | Ruby on Rails Tutorial Sample App'
  end  
end