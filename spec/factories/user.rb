FactoryBot.define do

  factory :user do
    email { Faker::Internet.email }
    name { Faker::Lorem.characters(number: 10) }
    username { Faker::Lorem.characters(number: 10) }
    password { 'password' }
    password_confirmation { 'password' }
    profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/twitter_profile_image.png')) }
    profile { Faker::Lorem.characters(number: 10) }
  end

end