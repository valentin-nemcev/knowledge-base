class Revision < ActiveRecord::Base
  belongs_to :article, inverse_of: :revisions

  include ClassyEnum::ActiveRecord
  classy_enum_attr :markup_language, default: :slim


  def body_html
    @body_html ||= markup_language.render(body || '')
  end

end
