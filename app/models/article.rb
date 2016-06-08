class Article < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  delegate :card_ordering, :title, :markup_language, :body, :body_html,
    to: :current_revision, allow_nil: true


  def body_doc
    @body_doc ||= Nokogiri::HTML.fragment(body_html)
  end

  def labels
    todo_count = body_doc.css('.todo').size
    todo_count > 0 ? ["TODO: #{todo_count}"] : []
  end


  has_many :cards, -> { includes(:article, :current_revision, :reviews) },
    autosave: true,
    dependent: :destroy do
    def article
      proxy_association.owner
    end

    def sort_by_article_position
      index = article.card_ordering_index
      sort_by do |card|
        [
          index.key?(card.path) ? 0 : 1,
          index.fetch(card.path, 0),
          card.path_for_sort
        ]
      end
    end
  end

  def card_ordering_index
    @card_ordering_index ||=
      card_ordering.map.with_index.to_h
  end

  def card_count
    card_ordering.count
  end


  def card_index(card)
    card_ordering_index[card.path]
  end

  {'next' => +1, 'prev' => -1}.each do |name, delta|
    define_method "card_#{name}_to" do |card|
      index = card_index(card)
      index.present? or return nil
      index += delta
      index.in?(0...card_ordering.length) or return nil
      path = card_ordering[index]
      cards.find{ |c| c.path == path }
    end
  end


  def update_cards
    paths_to_cards = Hash[cards.map{ |c| [c.path, c] }]
    paths_to_cards.default_proc = proc do |h, path|
      h[path] = cards.build(path: path)
    end
    updated_cards = CardExtractor.extract_cards(body_doc, self)
      .map do |path, card_html|
        paths_to_cards[path].tap do |card|
          card.update_revision(
            autosave: current_revision.autosave,
            attributes: {body_html: card_html,
                         article_revision: current_revision}
          )
        end
      end
    updated_cards.select(&:soft_destroyed?).each(&:restore)

    existing_cards = cards.to_set
    (existing_cards - updated_cards).each(&:soft_destroy)

    self.current_revision
      .update_attribute(:card_ordering, updated_cards.map(&:path).to_a)

    self
  end
end
