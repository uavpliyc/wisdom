require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメントモデルのテスト' do
      
    it 'コメントが入力されていること' do
      expect(FactoryBot.build(:content)).to be_valid
    end
    
  end
end