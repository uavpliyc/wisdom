class AddCategoryToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :category, :integer
  end
end
