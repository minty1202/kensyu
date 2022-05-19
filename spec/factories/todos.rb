FactoryBot.define do
  factory :todo do
    title { "MyString" }
    text { "MyText" }
    user
    # association :user
    # user_id {FactoryBot.create(:user)}

    trait :with_attachment do
      attachment { Rack::Test::UploadedFile.new(
      "#{Rails.root}/spec/fixtures/test_image.png", 'image/png') } end
    end
end
