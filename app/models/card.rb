class Card < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  delegate :body_html, to: :current_revision, allow_nil: true

  belongs_to :article, inverse_of: :cards


  has_many :reviews, -> { order(:reviewed_at) }, dependent: :destroy

  def last_reviewed_at
    reviews.last.try!(:reviewed_at)
  end

  def next_review_at
    reviews.last.try!(:next_at)
  end

  def next_review_at_for_sort
    next_review_at || Time.zone.at(0)
  end
end
