FactoryBot.define do
  factory :todo_tag_form do
    title { 'title' }
    text { 'text' }
    limit_date { Time.current }
    status { '未完了' }
    name { 'name' }

    trait :with_attachment do
      attachment do
        Rack::Test::UploadedFile.new(
          "#{Rails.root}/spec/fixtures/files/image/test_image.png", 'image/png'
        )
      end
    end
  end
end
