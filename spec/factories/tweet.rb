FactoryBot.define do

  factory :tweet do
    id { 1 }
    tweet { Faker::Lorem.characters(number: 20) }
    user_id { 1 }
    category_id { 1 }
    status { 0 }
  end

end