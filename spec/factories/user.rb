FactoryBot.define do

  factory :user do
    id { 1 }
    email { 'a@a' }
    name { '田中' }
    username { '@tanaka' }
    password { 'password' }
    password_confirmation { 'password' }
  end
  
end