class CardRevision < ActiveRecord::Base
  belongs_to :card, inverse_of: :revisions
  belongs_to :article_revision


  REVISION_ATTRIBUTES = %w{article_revision body_html}
  def different_from?(other)
    other.nil? ||
      other.slice(*REVISION_ATTRIBUTES) != self.slice(*REVISION_ATTRIBUTES)
  end

  def body_html
    super.html_safe
  end
end
