class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_user, only: %i[show]

  def show
    @events = @user.events
    @reviews = @user.event_reviews

    @can_review = false
    if current_user != @user
      current_user.bookings.each do |booking|
        if booking.event.user == @user && booking.status == "Accepted" && !@reviews.where(user: current_user).present?
          @can_review = true
          @event_to_review = booking.event
        end
      end
    end
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
