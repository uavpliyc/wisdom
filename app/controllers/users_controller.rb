class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users  = User.all
  end

  def show
    @user   = User.find(params[:id])
    @tweets = @user.tweets
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

  def search
    if params[:name][:username].present?
      @users = User.where('name LIKE ?', "%#{params[:name]}%")
      @users = User.where('username LIKE ?', "%#{params[:username]}%")
    else
      @users = User.none
    end
  end

end
