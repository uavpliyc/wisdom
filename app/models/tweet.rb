class Tweet < ApplicationRecord

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end


  def self.search(search)
    if search
      Tweet.where(['tweet LIKE ?', "%#{search}%"])
    else
      Tweet.all
    end
  end

  # def login_required
  #   redirect_to login_url unless current_user
  # end

  attachment :image

  enum status: { published: 0, draft: 1 }

  validates :tweet, presence: true
  validates :category_id, presence: true

end
