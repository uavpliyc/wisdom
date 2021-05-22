class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users  = User.all.page(params[:page]).per(10)
  end

  def show
    @user   = User.find(params[:id])
    @tweets = @user.tweets.published.page(params[:page]).per(10).order("created_at DESC")
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.follower.page(params[:page]).per(10)
    render 'following'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followed.page(params[:page]).per(10)
    render 'followers'
  end

  def search
    if params[:name][:username].present?
      @users = User.where('name LIKE ?', "%#{params[:name]}%")
      @users = User.where('username LIKE ?', "%#{params[:username]}%")
    else
      @users = User.none
    end
  end

end
