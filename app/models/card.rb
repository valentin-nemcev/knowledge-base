class Card < ActiveRecord::Base

  include SoftDestruction
  include Revisions

  delegate :body_html, to: :current_revision, allow_nil: true

  belongs_to :article, inverse_of: :cards
end
