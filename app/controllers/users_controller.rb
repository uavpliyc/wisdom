class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    # @tweet = Tweet.find(params[:id])
    @tweets = @user.tweets
  end

  def following
    @user = User.find(params[:id])
    @users = @user.follower
    render 'following'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followed
    render 'followers'
  end

end