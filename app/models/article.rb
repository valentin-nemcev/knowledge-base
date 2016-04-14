class Article < ActiveRecord::Base

  include SoftDestruction

  has_many :revisions, -> { order(:updated_at) }, dependent: :destroy
  belongs_to :current_revision, class_name: 'Revision', autosave: true
  before_destroy :unset_current_revision, prepend: true

  def unset_current_revision
    update_column(:current_revision_id, nil)
  end

  def autosaving(autosave)
    if current_revision.nil?
      self.current_revision = revisions.build(article: self, autosave: autosave)
    elsif current_revision.persisted?
      unless current_revision.autosave?
        self.current_revision = revisions.build(article: self)
      end
      current_revision.autosave = autosave
    end
    self
  end

  delegate :title, :markup_language, :body, :body_html,
    to: :current_revision, allow_nil: true

  delegate :title=, :markup_language=, :body=, to: :current_revision


  has_many :reviews, -> { order(:reviewed_at) }, dependent: :destroy

  # Should be called by review that needs reference to previous reviews in
  # sequence
  def update_prev_reviews(requesting_review)
    reviews.each_with_index do |review, i|
      review.update_prev_reviews(reviews[0...i])
      # there maybe multiple review objects for same record, make sure to
      # actually update the one that requested it
      if !requesting_review.equal?(review) &&
          requesting_review.id == review.id
        requesting_review.update_prev_reviews(reviews[0...i])
      end
    end
  end

  def last_reviewed_at
    reviews.last.try!(:reviewed_at)
  end

  def next_review_at
    reviews.last.try!(:next_at)
  end

  def next_review_at_for_sort
    next_review_at || Time.zone.at(0)
  end


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
        Card.find_or_initialize_by(path: path).tap do |card|
          card.update_attributes!(article: self, body_html: card_html)
        end
      end
    updated_cards.select(&:soft_destroyed?).each(&:restore)

    (existing_cards - updated_cards).each(&:soft_destroy)
  end
end
