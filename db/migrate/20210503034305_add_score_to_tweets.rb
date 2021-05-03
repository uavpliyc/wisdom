class AddScoreToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :score, :decimal, precision: 5, scale: 3
  end
end
