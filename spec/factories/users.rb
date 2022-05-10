FactoryBot.define do
  factory :user do
    name                  {"test"}
    email                 { "test@example.com" }
    password              { "123456" }
    password_confirmation { password }
  end
end
