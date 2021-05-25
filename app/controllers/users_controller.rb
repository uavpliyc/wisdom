class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:show, :following, :followers]

  def index
    @users  = User.all.paginate(params)
  end

  def show
    @tweets = @user.tweets.published.paginate(params)
  end

  def following
    @users = @user.follower.paginate(params)
    render 'following'
  end

  def followers
    @users = @user.followed.paginate(params)
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

  private

  # callback(before_action)を利用して共通化
  def set_user
    @user = User.find(params[:id])
  end

end
