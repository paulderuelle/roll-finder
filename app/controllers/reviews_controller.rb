class ReviewsController < ApplicationController
  before_action :set_event, only: %i[new create edit update]
  before_action :set_review, only: %i[edit update]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to event_path(@event), notice: 'Review was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to event_path(@event), notice: 'Review was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :user_id, :event_id)
  end
end
