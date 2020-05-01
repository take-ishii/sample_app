FactoryBot.define do
  factory :user_post, class: Micropost do
    content { "Content" }
    association :user, factory: :user

    trait :today do
      created_at { 1.hour.ago }
    end

    trait :yesterday do
      created_at { 1.day.ago }
    end

    factory :other_user_post do
      content { Faker::Lorem.sentence(5) }
      association :user, factory: :other_user
    end
  end
end