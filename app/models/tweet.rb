class Tweet < ApplicationRecord

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      tweet_id: id,
      visited_id: user_id,
      action: "favorite"
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回された場合、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      tweet_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  attachment :image

  enum status: { published: 0, draft: 1 }

  validates :tweet, presence: true, length: { maximum: 140 }
  validates :category_id, presence: true

end
