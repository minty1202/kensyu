FactoryBot.define do
  factory :user do
    name                  {"test"}
    sequence(:email) { |n| "test#{n}@example#{n}.com" }
    password              { "123456" }
    password_confirmation { "123456" }
  end
end
