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
      redirect_to event_path(@event)
    else
      render "events/show", status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to event_path, status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

end
