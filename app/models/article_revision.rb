class ArticleRevision < ActiveRecord::Base
  belongs_to :article, inverse_of: :revisions

  include ClassyEnum::ActiveRecord
  classy_enum_attr :markup_language, default: :slim

  before_save :ensure_body_html_attr

  include Revisions::Revision
  def revision_attributes
    %w{title body body_html markup_language}
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
