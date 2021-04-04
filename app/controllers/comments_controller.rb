class CommentsController < ApplicationController

  def create
    @tweet            = Tweet.find(params[:tweet_id])
    @comment          = current_user.comments.new(comment_params)
    @comment.tweet_id = @tweet.id
    if @comment.save
      flash[:notice] = "コメントしました！"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントを記入してください"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @tweet   = Tweet.find(params[:tweet_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :tweet_id, :user_id)
  end

end
