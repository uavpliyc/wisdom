# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'ツイートモデルのテスト' do

    let!(:user) { build(:user) }
    let!(:category) { build(:category) }
    let!(:tweet) { build(:tweet, user_id: user.id) }

    context 'tweetカラム' do
      it 'ツイートが空欄でないこと' do
        tweet.tweet = ''
        expect(tweet).to be_invalid
      end
      it '140文字以下であること: 140文字は〇' do
        tweet.tweet = Faker::Lorem.characters(number: 140)
        is_expected.to eq true
      end
      it '140文字以下であること: 141文字は×' do
        tweet.tweet = Faker::Lorem.characters(number: 141)
        is_expected.to eq false
      end
      it 'カテゴリーが空欄でないこと' do
        tweet.category_id = ''
        expect(tweet).to be_invalid
      end
    end

  end
end