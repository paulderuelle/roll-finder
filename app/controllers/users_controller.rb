class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_user, only: %i[show]

  def show
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_without_password(user_params)
      redirect_to user_path(@user), notice: 'Profile was successfully updated.'
    else
      render :update, status: :unprocessable_entity
    end
  end
end

private

def set_user
  @user = User.find(params[:id])
end

def user_params
  params.require(:user).permit(:nickname, :first_name, :email, :password, :description, :photo)
end
