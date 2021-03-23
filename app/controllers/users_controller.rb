class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user   = User.find(params[:id])
    @tweets = @user.tweets
    # @tweet = Tweet.find(params[:id])
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.follower
    render 'following'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followed
    render 'followers'
  end

end
