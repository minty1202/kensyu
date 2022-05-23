FactoryBot.define do
  factory :todo do
    title { "MyString" }
    text { "MyText" }
    user
    # association :user
    # user_id {FactoryBot.create(:user)}

    # after(:build) do |post|
    #   post.image.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    # end

    trait :with_attachment do
      attachment { Rack::Test::UploadedFile.new(
      "#{Rails.root}/spec/fixtures/files/image/test_image.png", 'image/png') }
    end

  end

end
