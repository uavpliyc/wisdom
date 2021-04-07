class FavoritesController < ApplicationController

  def create
    @tweet    = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.new(tweet_id: @tweet.id)
    @favorite.save
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.find_by(tweet_id: @tweet.id)
    @favorite.destroy
  end

end
