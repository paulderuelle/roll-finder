class UsersController < ApplicationController
  # before_action :set_user, only: %i[show edit update]

  def show
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile was successfully updated.'
    else
      render :update, status: :unprocessable_entity
    end
  end
end

private

# def set_user
#   @user = User.find(params[:id])
# end

def user_params
  params.require(:user).permit(:nickname, :first_name, :email, :password, :description, :photo)
end
