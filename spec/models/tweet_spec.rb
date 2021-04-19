# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'ツイートのバリデーション' do
    
    let!(:user_test) { FactoryBot.build(:user_test) }
    let!(:category) { FactoryBot.build(:category) }
    let!(:tweet) { FactoryBot.build(:tweet) }

    # it 'バリデーションが有効であること' do
    #   expect(tweet).to be_valid
    # end
    
    it 'ツイートが空欄でないこと' do
      tweet.tweet = ''
      expect(tweet).to be_invalid
    end
    
    it 'カテゴリーが空欄でないこと' do
      tweet.category_id = ''
      expect(tweet).to be_invalid
    end
    
  end
end