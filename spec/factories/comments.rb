FactoryBot.define do
  factory :comment do
    text { "MyString" }
    user
    todo
  end
end
