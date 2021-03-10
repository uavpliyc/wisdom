class AddImageIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :image_id, :string
  end
end
