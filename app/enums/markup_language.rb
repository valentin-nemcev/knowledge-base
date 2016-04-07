class MarkupLanguage < ClassyEnum::Base
  def render(string)
    template {string || ''}.render.html_safe
  end
end

class MarkupLanguage::Slim < MarkupLanguage
  Slim = ::Slim

  def template(&block)
    Slim::Template.new(&block)
  end

  def render(*args)
    super
  rescue Slim::Parser::SyntaxError => e
    "<pre>#{e}</pre>".html_safe
  end
end

class MarkupLanguage::Kramdown < MarkupLanguage
  def template(&block)
    Tilt::KramdownTemplate.new(parse_block_html: true, &block)
  end
end
