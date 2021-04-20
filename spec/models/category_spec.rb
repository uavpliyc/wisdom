require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'カテゴリーモデルのテスト' do
      
    it 'カテゴリーが選択されていること' do
      expect(FactoryBot.build(:category)).to be_valid
    end
    
  end
end