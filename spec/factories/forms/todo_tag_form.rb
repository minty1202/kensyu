FactoryBot.define do
  factory :todo_tag_form do
    title { 'title' }
    text { 'text' }
    limit_date { Time.current }
    status { '未完了' }
    name { 'name' }
  end
end
