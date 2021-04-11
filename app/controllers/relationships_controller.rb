class RelationshipsController < ApplicationController


  # def create
  #   current_user.follow(params[:user_id])
  #   @user.create_notification_follow!(current_user)
  # end

  # def destroy
  #   current_user.unfollow(params[:user_id])
  # end

  def follow
    @user = User.find(params[:id])
    current_user.follow(params[:id])
    @user.create_notification_follow!(current_user)
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(params[:id])
  end

end
