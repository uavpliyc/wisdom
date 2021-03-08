class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    # @tweet = Tweet.find(params[:id])
  end
  

end
