FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test+hacker#{n}@gmail.com" }
  end
end
