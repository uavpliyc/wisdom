FactoryBot.define do
  factory :user do
  end

  factory :user_test, class: 'User' do
    id { 1 }
    email { 'a@a' }
    password { 'password' }
    name { '田中' }
    username { '@tanaka' }
  end

  factory :tweet, class: 'Tweet' do
    id { 1 }
    tweet { '早起きする' }
    user_id { 1 }
    category_id { 1 }
    status { 0 }
  end
  
  factory :category, class: 'Category' do
    id { 1 }
    name { '経営' }
  end

end