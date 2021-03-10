class CommentsController < ApplicationController

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = current_user.comments.new(comment_params)
    @comment.tweet_id = @tweet.id
    @comment.save
    redirect_back(fallback_location: root_path)
    # @comment.user_id = current_user.id
  end

  def destroy
    # @tweet.find_by(id: params[:id], tweet_id: params[:tweet_id]).destroy
    # redirect_to tweet_path(params[:tweet_id])
    @tweet = Tweet.find(params[:tweet_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :tweet_id, :user_id)
  end

end
