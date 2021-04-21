FactoryBot.define do

  factory :tweet do
    tweet { Faker::Lorem.characters(number: 20) }
    status { 0 }
    association :user
    association :category
  end

end