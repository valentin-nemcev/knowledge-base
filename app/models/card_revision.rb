class CardRevision < ActiveRecord::Base
  belongs_to :card, inverse_of: :revisions
  belongs_to :article_revision


  include Revisions::Revision
  def revision_attributes
    %w{body_html}
  end


  def body_html
    super.html_safe
  end
end
