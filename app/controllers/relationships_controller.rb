class RelationshipsController < ApplicationController


  def create
    current_user.follow(params[:user_id])
    @user.create_notification_follow!(current_user)
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer

  end

  def follow
    current_user.follow(params[:id])
    redirect_back(fallback_location: root_path)
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_back(fallback_location: root_path)
  end

end
