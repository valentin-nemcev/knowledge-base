class CardsController < ApplicationController
  before_action :set_article

  def index
    @cards = @article.cards
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:article_id]).decorate
    end
end
