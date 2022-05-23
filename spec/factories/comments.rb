FactoryBot.define do
  factory :comment do
    comment_text { "MyString" }
    user
    todo
  end
end
