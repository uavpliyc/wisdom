class TweetsController < ApplicationController
  # before_action :set_tweet, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @tweets     = Tweet.published.order("created_at DESC")
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def confirm
    @tweets = current_user.tweets.draft.order("created_at DESC")
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
    # 下書きはログインしていないと見れない
    if  @tweet.nil?
      redirect_to root_path
    elsif @tweet.draft?
      login_required
    end
  end

  def new
    @tweet = current_user.tweets.build
  end

  def edit
    @tweet      = Tweet.find(params[:id])
    @categories = Category.all
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    @categories = Category.all
    if @tweet.save
      flash[:notice] = "ツイートをしました"
      redirect_to tweets_path
    elsif @tweet.draft?
      flash[:notice] = "下書き保存しました"
      redirect_to tweets_path
    else
      flash[:alert] = "ツイートに失敗しました"
      @tweets     = Tweet.published.order("created_at DESC")
      render :index
    end
    # logger.debug @tweet.errors.inspect
    # if tweet_params[:tweet][:category_id] == ""
    #   flash[:alert] = "選択して下さい"
    #   redirect_to tweets_path
    # end


  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update(tweet_params)
      flash[:notice] = "ツイートを更新しました"
      redirect_to @tweet
    else
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

  private

    def tweet_params
      params.require(:tweet).permit(:tweet, :image, :category_id, :status)
    end

    def login_required
      redirect_to login_url unless current_user
    end

end
