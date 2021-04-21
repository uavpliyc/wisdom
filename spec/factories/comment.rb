FactoryBot.define do

  factory :comment, class: 'Comment' do
    content { Faker::Lorem.characters(number: 10) }
    association :user
    association :tweet
  end

end