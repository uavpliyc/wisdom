class CommentsController < ApplicationController

  def create
    @tweet            = Tweet.find(params[:tweet_id])
    @comment          = current_user.comments.new(comment_params)
    @comment.score    = Language.get_data(comment_params[:content])
    @comment.tweet_id = @tweet.id
    if @comment.save
      flash[:notice] = "コメントしました！"
      @comment.tweet.create_notification_comment!(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
    elsif @comment.content == ""
      flash[:alert] = "コメントを記入してください"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントは140字までです"
      render 'tweets/show'
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
