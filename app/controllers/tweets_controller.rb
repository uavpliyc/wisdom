class TweetsController < ApplicationController
  # before_action :set_tweet, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /tweets or /tweets.json
  def index
    @tweets     = Tweet.published.order("created_at DESC")
    @tweet      = Tweet.new
    @categories = Category.all
  end

  def confirm
    @tweets = Tweet.draft.order("created_at DESC")
  end

  def category
    @categories = Category.all
    @category   = Category.find(params[:id])
    @tweets     = @category.tweets.all.order("created_at DESC")
    @tweet      = Tweet.new
  end

  # GET /tweets/1 or /tweets/1.json
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

  # GET /tweets/new
  def new
    @tweet = current_user.tweets.build
  end

  # GET /tweets/1/edit
  def edit
    @tweet      = Tweet.find(params[:id])
    @categories = Category.all
    # logger.debug @tweet.errors.inspect
  end

  # POST /tweets or /tweets.json
  def create
    @tweet = current_user.tweets.build(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweets_path, notice: "Tweet was successfully created." }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
    # if tweet_params[:tweet][:category_id] ==  ""
    #   flash[:notice] = "選択して下さい"
    #   redirect_to tweets_path
    # end

  end

  # PATCH/PUT /tweets/1 or /tweets/1.json
  def update
    @tweet = Tweet.find(params[:id])
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: "Tweet was successfully updated." }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1 or /tweets/1.json
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: "Tweet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_tweet
    #   @tweet = Tweet.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:tweet, :image, :category_id, :status)
    end

    def login_required
      redirect_to login_url unless current_user
    end
end
