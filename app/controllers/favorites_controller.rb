class FavoritesController < ApplicationController

  def create
    @tweet    = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.new(tweet_id: @tweet.id)
    @favorite.save
    @tweet.create_notification_by(current_user)
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
  end

  def destroy
    @tweet    = Tweet.find(params[:tweet_id])
    @favorite = current_user.favorites.find_by(tweet_id: @tweet.id)
    @favorite.destroy
  end

end
