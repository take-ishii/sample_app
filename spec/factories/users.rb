FactoryBot.define do
  factory :user, class: User do
    name { 'Example user' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
    activated { true }
    
    factory :other_user do
      name { "other_user" }
      email { Faker::Internet.email }
    end
    
    factory :admin_user do
      name { "admin_user" }
      email { "admin@example.com" }
      admin { true }
    end
  end
end