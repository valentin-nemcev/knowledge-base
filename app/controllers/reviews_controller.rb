class ReviewsController < ApplicationController
  before_action :set_card

  def create
    @review = @card.reviews.create!(review_params)
    if params[:queue]
      redirect_to next_card_path(@card)
    else
      redirect_to card_path(@card), notice: :review_create_success
    end
  end

  def destroy
    @card.reviews.find(params[:id]).destroy
    redirect_to card_path(@card), notice: :review_destroy_success
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:card_id])
    end

    def review_params
      params.require(:review).permit(:grade)
    end
end
