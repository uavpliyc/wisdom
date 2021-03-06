class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :profile, :profile_image, :profile_image_id, :password, :password_comfimation)
  end

  def account_update_params
    params.require(:user).permit(:name, :username, :email, :profile, :profile_image, :profile_image_id, :password, :password_comfirmation, :current_password)
  end

  def after_update_path_for(resource)
    user_path(current_user)
  end

end