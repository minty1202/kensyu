FactoryBot.define do
  factory :admin do
    email                 { "admin@example.com" }
    password              { "123456" }
    password_confirmation { "123456" }
  end
end
