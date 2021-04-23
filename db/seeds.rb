# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create([
    { name: '経営' },
    { name: 'お金' },
    { name: '健康'},
    { name: '暮らし'},
    { name: 'コミュニケーション'},
    { name: 'マーケティング'},
    { name: '就職・転職'},
    { name: 'デザイン'},
    { name: '習慣'},
    { name: '思考法'},
    { name: '読書'},
    { name: '朝活'},
    { name: '生産性'},
    { name: '政治'},
    { name: '経済'},
    { name: '歴史'},
    { name: 'テクノロジー'},
    ])

5.times do |n|
User.create([
    { email: 'a#{ n + 1 }@a' },
    { password: 'aaaa#{ n + 1 }' },
    { name: 'nozaki#{ n + 1 }' },
    { username: '@nozaki#{ n + 1 }' },
    { profile: '日本制覇#{ n + 1 }' }
    ])
  end

User.all.each do |user|
  user.tweets.create([
    { tweet: '早起きすること#{ n + 1}' },
    { category_id: '1 + #{ n + 1}' },
    { status: '0' }
    ])
  end

