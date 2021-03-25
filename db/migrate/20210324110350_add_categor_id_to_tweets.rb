class AddCategorIdToTweets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweets, :category_id, :integer
    add_column :tweets, :category_id, :integer
  end
end
