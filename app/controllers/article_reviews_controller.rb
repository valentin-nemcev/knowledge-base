class ArticleReviewsController < ApplicationController
  before_action :set_article,

  def create
    @review = @article.reviews.create!(review_params)
    respond_to do |format|
      format.html { redirect_to @article, notice: :review_success }
      format.json { head :no_content }
    end
  end

  def destroy
    # @article.destroy
    # respond_to do |format|
    #   format.html { redirect_to articles_url, notice: :destroy_success }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:article_id])
    end

    def review_params
      params.require(:article_review).permit(:response_quality)
    end
end
