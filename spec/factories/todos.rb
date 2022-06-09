FactoryBot.define do
  factory :todo do
    title { "MyString" }
    text { "MyText" }
    limit_date {Time.current}
    # "Sun, 05 Jun 2022"
    status {"todo"}
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
