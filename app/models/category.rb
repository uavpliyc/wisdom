class Category < ApplicationRecord

  has_many :tweets, dependent: :destroy
  # validates :name, presence: true

end
