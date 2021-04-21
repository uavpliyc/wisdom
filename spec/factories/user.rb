FactoryBot.define do

  factory :user do
    # id { 1 }
    email { Faker::Internet.email }
    name { Faker::Lorem.characters(number: 10) }
    username { Faker::Lorem.characters(number: 10) }
    password { 'password' }
    password_confirmation { 'password' }
  end

end