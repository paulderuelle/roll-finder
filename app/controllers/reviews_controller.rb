class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_event, only: %i[new create edit update]
  before_action :set_review, only: %i[edit update]

  def index
    @reviews = current_user.event_reviews
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.event = @event
    @review.user = current_user
    # @review = current_user.reviews.build(review_params)
    if @review.save!
      redirect_to user_path(@event.user), notice: 'Review was successfully created.'
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
