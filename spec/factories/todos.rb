FactoryBot.define do
  factory :todo do
    title { "MyString" }
    text { "MyText" }
    limit_date { Time.current }
    status { "todo" }
    user
    # association :user
    # user_id {FactoryBot.create(:user)}

    # after(:build) do |post|
    #   post.image.attach(io: File.open('spec/fixtures/files/image/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    # end

    trait :todo_change_status do
      limit_date { Time.current.yesterday }
    end

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
