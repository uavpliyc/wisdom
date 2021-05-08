class CommentFavoritesController < ApplicationController

  def create
    @tweet            = Tweet.find_by(params[:tweet_id])
    @comment          = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.new(comment_id: @comment.id)
    @comment_favorite.save
    @comment.create_notification_by(current_user)
    
  end

  def destroy
    @tweet            = Tweet.find_by(params[:tweet_id])
    @comment          = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.find_by(comment_id: @comment.id)
    @comment_favorite.destroy
  end

  def index_destroy
    @tweet            = Tweet.find_by(params[:tweet_id])
    @comment          = Comment.find(params[:comment_id])
    @comment_favorite = current_user.comment_favorites.find_by(comment_id: @comment.id)
    @comment_favorite.destroy
    redirect_to myfavorite_tweets_path
  end

end
