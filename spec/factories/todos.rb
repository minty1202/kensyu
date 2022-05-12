FactoryBot.define do
  factory :todo do
    title { "MyString" }
    text { "MyText" }
    user
    # association :user
    # user_id {FactoryBot.create(:user)}
  end
end
