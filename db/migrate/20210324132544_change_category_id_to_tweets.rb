class ChangeCategoryIdToTweets < ActiveRecord::Migration[5.2]
  def change
    change_column :tweets, :category_id, :integer, null: false
  end
end
