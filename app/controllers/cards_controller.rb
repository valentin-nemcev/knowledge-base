class CardsController < ApplicationController

  def index
    @cards = if article.present?
               article.cards.sort_by_article_position
             else
               Card
                .includes(:article => [:current_revision])
                .sort_by_review_order
             end
    @cards = CardDecorator.decorate_collection(@cards)
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
