class Article < ActiveRecord::Base

  include SoftDestruction

  has_many :revisions, -> { order(:created_at) },
    class_name: 'ArticleRevision',
    dependent: :destroy,
    inverse_of: :article do
      def add_without_saving(record)
        # http://stackoverflow.com/questions/13197359/add-association-without-commiting-to-database
        proxy_association.add_to_target(record)
        inverse_of = proxy_association.reflection.inverse_of
        record.association(inverse_of.name).replace proxy_association.owner
      end

      def duplicated_chunks
        chunk_while(&:different_from?).select(&:many?)
      end
    end
  belongs_to :current_revision, class_name: 'ArticleRevision', autosave: true
  before_destroy :unset_current_revision, prepend: true

  def unset_current_revision
    update_column(:current_revision_id, nil)
  end

  def save_revision(autosave:, attributes:)
    new_revision = ArticleRevision.new(attributes)

    if new_revision.different_from?(current_revision)
      self.current_revision = new_revision
      self.revisions.add_without_saving(new_revision)
    end

    if current_revision.new_record? || autosave == false
      current_revision.autosave = autosave
    end

    save
  end

  def destroy_duplicated_revisions
    revisions.duplicated_chunks.each do |first, *rest|
      update!(current_revision: first) if current_revision.in? rest
      rest.each(&:destroy!)
    end
  end

  delegate :title, :markup_language, :body, :body_html,
    to: :current_revision, allow_nil: true


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
        Card.find_or_initialize_by(article: self, path: path).tap do |card|
          card.update_attributes!(body_html: card_html)
        end
      end
    updated_cards.select(&:soft_destroyed?).each(&:restore)

    (existing_cards - updated_cards).each(&:soft_destroy)
  end
end
