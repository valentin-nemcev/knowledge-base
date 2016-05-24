class Card < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  default_scope { includes(:current_revision, :reviews) }
  delegate :body_html, to: :current_revision, allow_nil: true

  belongs_to :article, inverse_of: :cards

  def path_for_sort
    path.split(%r{[/.]}).map(&:to_i)
  end


  has_many :reviews, -> { order(:reviewed_at) }, dependent: :destroy

  def last_reviewed_at
    reviews.last.try!(:reviewed_at)
  end

  def next_review_at
    reviews.last.try! do |review|
      review.next_at.to_date
    end
  end

  def self.sort_by_review_order
    now = Time.zone.now
    all.sort_by do |card|
      [
        card.soft_destroyed? ? 1 : 0,
        card.next_review_at || now,
        [card.next_review_at, card.path].hash,
      ]
    end
  end


  def body_doc
    @body_doc ||= Nokogiri::HTML.fragment(body_html)
  end

  def blank_element
    body_doc.css('.blank')
  end
end
