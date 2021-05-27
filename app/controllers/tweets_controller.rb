class TweetsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  def index
    @tweets     = Tweet.published.paginate(params)
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def category
    @categories = Category.all
    @category   = Category.find(params[:id])
    @tweets     = @category.tweets.published.paginate(params)
    @tweet      = Tweet.new
  end

  def show
    @comments = @tweet.comments.paginate(params)
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
    @categories = Category.all
    redirect_to tweets_path if @tweet.user != current_user
  end

  def create
    @tweet       = current_user.tweets.new(tweet_params)
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
      @tweets     = Tweet.published.paginate(params)
      @categories = Category.all
      render :index
    end
  end

  def update
    @tweet.score = Language.get_data(tweet_params[:tweet])
    @categories  = Category.all
    if @tweet.update(tweet_params)
      flash[:notice] = "ツイートを更新しました"
      redirect_to @tweet
    else
      flash[:alert] = "ツイートの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @tweet.destroy
    flash[:notice] = "ツイートを削除しました"
    redirect_to tweets_url
  end

  def search
    @tweets     = Tweet.published.paginate(params)
    @tweets     = @tweets.search(params)
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def confirm
    @tweets = current_user.tweets.draft.paginate(params)
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

  # callback(before_action)を利用して共通化
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

end
