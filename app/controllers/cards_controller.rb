class CardsController < ApplicationController

  def index
    @cards = Card.all
    @cards = @cards.where(article: article) if article.present?
    @cards = @cards.decorate
  end

  def show
    @card = Card.find(params[:id]).decorate

    if params[:review]
      render 'review'
    else
      render 'show'
    end
  end

  private

    def article
      @article ||= Article.find_by_id(params[:article_id]).try!(:decorate)
    end
end
