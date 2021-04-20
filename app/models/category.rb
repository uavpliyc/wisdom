class Category < ApplicationRecord

  has_many :tweets, dependent: :destroy

end
