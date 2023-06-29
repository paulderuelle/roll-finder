class BookingsController < ApplicationController
  before_action :set_event, only: %i[new create]
  before_action :set_booking, only: %i[edit update destroy]

  def index
    @bookings = Booking.where(user: current_user)
    @bookmarks = Bookmark.where(user: current_user)
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.event = @event
    @booking.user = current_user
    @booking.status = "Pending"
    if @booking.save
      redirect_to @event, notice: "Booking created succesfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @booking.status = params[:status]
    if @booking.save
      redirect_to @booking.event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:status)
  end
end
