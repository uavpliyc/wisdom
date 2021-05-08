class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :tweet
  has_many :comment_favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :content, presence: true, length: { maximum: 140 }

  def favorited_by?(user)
    comment_favorites.where(user_id: user.id).exists?
  end

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      comment_id: id,
      tweet_id: tweet_id,
      visited_id: user_id,
      action: "comment_favorite"
    )
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
