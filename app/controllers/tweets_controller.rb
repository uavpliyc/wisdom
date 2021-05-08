class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets     = Tweet.published.order("created_at DESC")
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def category
    @categories = Category.all
    @category   = Category.find(params[:id])
    @tweets     = @category.tweets.published.order("created_at DESC")
    @tweet      = Tweet.new
  end

  def show
    @tweet    = Tweet.find(params[:id])
    @comments = @tweet.comments
    @comment  = Comment.new
    @comment_favorite = current_user.comment_favorites.find_by(params[:id])
    # 下書きはログインしていないと見れない
    if  @tweet.nil?
      redirect_to root_path
    elsif @tweet.draft?
      login_required
    end
  end

  def edit
    @tweet      = Tweet.find(params[:id])
    @categories = Category.all
    if @tweet.user != current_user
      redirect_to tweets_path
    end
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    @tweet.score = Language.get_data(tweet_params[:tweet])
    if @tweet.save
      if @tweet.published?
        flash[:notice] = "ツイートをしました"
      else
        flash[:notice] = "下書き保存しました"
      end
      redirect_to tweets_path
    else
      flash[:alert] = "ツイートに失敗しました"
      if tweet_params[:category_id] == ""
        flash[:alert] = "カテゴリーを選択して下さい"
      end
      @tweets     = Tweet.published.order("created_at DESC")
      @categories = Category.all
      render :index
    end
  end

  def update
    @tweet = Tweet.find(params[:id])
    @categories = Category.all
    if @tweet.update(tweet_params)
      flash[:notice] = "ツイートを更新しました"
      redirect_to @tweet
    else
      flash[:alert] = "ツイートの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    flash[:notice] = "ツイートを削除しました"
    redirect_to tweets_url
  end

  def search
    @tweets     = Tweet.published.order("created_at DESC")
    @tweets     = @tweets.where('tweet LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def confirm
    @tweets = current_user.tweets.draft.order("created_at DESC")
  end

  def myfavorite
    @comment_favorites = current_user.comment_favorites.order("created_at DESC")
    @tweet   = Tweet.find_by(params[:tweet_id])
    @comment = Comment.find_by(params[:comment_id])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:tweet, :image, :category_id, :status)
  end

  def login_required
    redirect_to login_url unless current_user
  end

end
