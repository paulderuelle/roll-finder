class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :owner, only: %i[edit update destroy]
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to event_path(@event), notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :address, :slot_number, :online, :user_id)
  end

  def owner
    @event = Event.find(params[:id])
    return if @event.user == current_user

    flash[:warning] = "You are not authorized to perform this action."
    redirect_to events_path
  end
end
