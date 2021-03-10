class FavoritesController < ApplicationController

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.new(tweet_id: @tweet.id)
    @favorite.save
    redirect_back(fallback_location: root_path)
    # redirect_to tweet_path(@tweet)
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.find_by(tweet_id: @tweet.id)
    @favorite.destroy
    redirect_back(fallback_location: root_path)
  end

end
