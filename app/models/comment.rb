class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :tweet
  has_many :comment_favorites, dependent: :destroy

  validates :content, presence: true, length: { maximum: 140 }

  def favorited_by?(user)
    comment_favorites.where(user_id: user.id).exists?
  end

end
