class Format < ClassyEnum::Base
  def render(string)
    template {string || ''}.render.html_safe
  end
end

class Format::Slim < Format
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

class Format::Kramdown < Format
  def template(&block)
    Tilt::KramdownTemplate.new(parse_block_html: true, &block)
  end
end
