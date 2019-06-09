class CardsController < ApplicationController

  def start_review
    card = Card
      .includes(:article => [:current_revision])
      .review_queue
      .first

    if card.present?
      redirect_to card_path(card, review: true, queue: true)
    else
      render 'no_review'
    end
  end

  def next
    queue = Card
      .includes(:article => [:current_revision])
      .review_queue

    card = Card.find(params[:id])

    next_card = queue.index(card).try do |i|
      queue[i + 1]
    end

    if next_card.present?
      redirect_to card_path(next_card, review: true, queue: true)
    else
      redirect_to :start_review_cards
    end
  end

  def index
    @cards = if article.present?
               article.cards.sort_by_article_position
             else
               Card
                .includes(:article => [:current_revision])
                .review_order
                # .sort_by_review_order
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
