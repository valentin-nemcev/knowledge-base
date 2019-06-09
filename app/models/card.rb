class Card < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  default_scope { includes(:current_revision, :latest_review) }
  delegate :body_html, to: :current_revision, allow_nil: true

  belongs_to :article, inverse_of: :cards

  def path_for_sort
    path.split(%r{[/.]}).map(&:to_i)
  end


  has_many :reviews, -> { order(:reviewed_at) }, dependent: :destroy
  belongs_to :latest_review, class_name: 'Review'
  before_destroy -> {
    update_column(:latest_review_id, nil)
  }, prepend: true

  def update_latest_review!
    update!(latest_review: reviews.last)
  end

  def last_reviewed_at
    latest_review.try!(:reviewed_at)
  end

  def next_review_at
    latest_review.try!(:next_review_at)
  end

  def e_factor
    latest_review.try!(:e_factor)
  end

  def review_order
    [
      soft_destroyed? ? 1 : 0,
      next_review_at.try!(:to_date) || Date.today,
      [next_review_at, path].hash,
    ]
  end

  def ready_for_review?
    next_review_at.nil? || next_review_at.to_date <= Date.today
  end

  def self.review_order
    order_soft_destroyed_last
      .joins('LEFT JOIN reviews ON reviews.id = cards.latest_review_id')
      .order('reviews.next_review_at')
  end

  def self.sort_by_review_order
    all.sort_by(&:review_order)
  end

  def self.review_queue
    without_soft_destroyed
      .select(&:ready_for_review?)
      .sort_by(&:review_order)
  end


  def body_doc
    @body_doc ||= Nokogiri::HTML.fragment(body_html)
  end

  def blank_element
    body_doc.css('.blank')
  end
end
