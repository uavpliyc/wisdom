class ChangeColumnsAddNotnullOnTweets < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tweets, :tweet, false
    change_column_null :tweets, :user_id, false
  end
end
