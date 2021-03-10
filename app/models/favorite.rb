class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :tweet

  validates :user_id, presence: true, uniqueness: {scope: :tweet_id}
  validates :tweet_id, presence: true

end
