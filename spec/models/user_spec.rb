# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

describe 'モデルのテスト' do
  it "有効な投稿内容の場合は保存されるか" do
    expect(FactoryBot.build(:user_test)).to be_valid
  end
end

end