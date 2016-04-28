class Article < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  delegate :title, :markup_language, :body, :body_html,
    to: :current_revision, allow_nil: true


  def body_doc
    @body_doc ||= Nokogiri::HTML.fragment(body_html)
  end

  def labels
    todo_count = body_doc.css('.todo').size
    todo_count > 0 ? ["TODO: #{todo_count}"] : []
  end

  has_many :cards, -> { order(:id) }, dependent: :destroy

  before_save :update_cards

  def update_cards
    existing_cards = self.cards.to_set
    updated_cards = CardExtractor.extract_cards(body_doc, self)
      .map do |path, card_html|
        Card.find_or_initialize_by(article: self, path: path).tap do |card|
          card.save_revision(
            autosave: current_revision.autosave,
            attributes: {body_html: card_html,
                         article_revision: current_revision}
          )
        end
      end
    updated_cards.select(&:soft_destroyed?).each(&:restore)

    (existing_cards - updated_cards).each(&:soft_destroy)
  end
end
