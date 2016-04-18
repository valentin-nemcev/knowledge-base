class ArticleRevision < ActiveRecord::Base
  belongs_to :article, inverse_of: :revisions

  include ClassyEnum::ActiveRecord
  classy_enum_attr :markup_language, default: :slim

  before_save :ensure_body_html_attr

  REVISION_ATTRIBUTES = %w{title body body_html markup_language}
  def different_from?(other)
    other.nil? ||
      other.slice(*REVISION_ATTRIBUTES) != self.slice(*REVISION_ATTRIBUTES)
  end

  def update_body_html
    render_body_html
    save
  end

  def body_html
    ensure_body_html_attr
    super.html_safe
  end

  def ensure_body_html_attr
    render_body_html if read_attribute(:body_html).nil?
  end

  def render_body_html
    self.body_html = markup_language.render(body || '')
  end
end
