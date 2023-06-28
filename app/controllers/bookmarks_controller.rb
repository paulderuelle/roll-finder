class BookmarksController < ApplicationController
  before_action :set_event, only: %i[new create]

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = Bookmark.new
    @bookmark.event = @event
    @bookmark.user = current_user
    if @bookmark.save
      redirect_to bookings_path
    else
      render "events/show", status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

end
