class Revision < ActiveRecord::Base
  belongs_to :article, inverse_of: :revisions

  include ClassyEnum::ActiveRecord
  classy_enum_attr :markup_language, default: :slim

  before_save :render_body_html

  def update_body_html
    render_body_html
    save
  end

  def body_html
    super.html_safe
  end

  def render_body_html
    self.body_html = markup_language.render(body || '')
  end
end
