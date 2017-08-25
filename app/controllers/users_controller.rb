class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path(current_user)
  end

  def user_params
      params.require(:user).permit(
        :first_name, :last_name, :phone_number
      )
  end
end
