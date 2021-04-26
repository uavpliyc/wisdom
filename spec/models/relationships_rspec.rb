require 'rails_helper'

RSpec.describe 'フォロー中間テーブルのテスト', type: :model do
  describe "バリデーション" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    it "中間テーブルの使用" do
      expect(relationship).to be_valid
    end

    context "フォロー状態" do
      it "フォローしていない" do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end
      it "フォローしている" do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end