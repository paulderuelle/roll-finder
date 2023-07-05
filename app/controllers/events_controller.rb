class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :owner, only: %i[edit update destroy]
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.all
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        info_window_html: render_to_string(partial: "popup", locals: {event: event}),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def show
    @user = @event.user
  end

  def new
    @event = Event.new
    @games = []
    @games << Game.find(params[:game_id])
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @games = []
    @games << Game.find(event_params[:game_id])
    # @games.each do |game|
    #   EventGame.create!(event: @event, game: game)
    # end
    if @event.save
      @games.each do |game|
        EventGame.create!(event: @event, game: game)
      end
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
    params.require(:event).permit(:title, :description, :start_hours, :playtime, :address, :slot_number, :online, :user_id, :game_id)
  end

  def owner
    @event = Event.find(params[:id])
    return if @event.user == current_user

    flash[:warning] = "You are not authorized to perform this action."
    redirect_to events_path
  end
end
