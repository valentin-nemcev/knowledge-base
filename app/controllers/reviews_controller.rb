class ReviewsController < ApplicationController
  before_action :set_card

  def create
    @review = @card.reviews.create!(review_params)
    respond_to do |format|
      format.html {
        redirect_to card_path(@card), notice: :review_create_success
      }
      format.json { head :no_content }
    end
  end

  def destroy
    @card.reviews.find(params[:id]).destroy
    respond_to do |format|
      format.html {
        redirect_to card_path(@card), notice: :review_destroy_success
      }
      format.json { head :no_content }
    end
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
