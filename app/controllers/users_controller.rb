class UsersController < ApplicationController
  def show; end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile successfully updated.'
    else
      render :update, status: :unprocessable_entity
    end
  end
end

private

def user_params
  params.require(:user).permit(:nickname, :first_name, :email, :password, :description, :photo)
end
