class Nokogiri::XML::Node
  def add_class(*classes)
    existing = self['class'].to_s.split(/\s+/)
    self['class'] = (existing + classes).join(" ")
  end

  def remove_class(*classes)
    existing = self['class'].to_s.split(/\s+/)
    self['class'] = (existing - classes).join(" ")
    self.delete('class') if self['class'].empty?
  end
end

class CardContext
  include Enumerable

  attr_reader :element, :article
  def initialize(element, article)
    @element = element
    @article = article
  end

  def article_context
    @article_context ||=
      element.ancestors.last.css('#context, #context + *').to_a
  end

  def context
    [element, *element.ancestors].map do |el|
      prev = el
      result = nil
      while prev = prev.previous
        if prev.name.in? ['h1', 'h2', 'h3']
          result = prev
          break
        end
      end
      result
    end.compact
  end

  def wrap_card(card_element)
    if card_element.name != 'div'
      new_element = card_element.document.create_element('div')
      new_element.add_child(card_element)
      card_element = new_element
    end
    card_element
  end

  def ungroup_blanks(card_element)
    card_element
      .css('[data-blank-group]')
      .each do |el|
        group_id = el.remove_attribute('data-blank-group')
        el.elements.to_enum.with_index(1) do |e, id|
          e.set_attribute('data-blank', [group_id, id].join('/'))
        end
      end
    card_element
  end

  def card_element
    @card_element ||= ungroup_blanks(wrap_card(element.dup))
  end

  def separate_blanks(card_element)
    card_element
      .css('[data-blank]').to_a
      .map do |blank_el|
        blank_el.add_class('blank')
        new_element = card_element.dup
        blank_el.remove_class('blank')
        [new_element, blank_el.get_attribute('data-blank')]
      end
  end

  def cards
    @cards ||= separate_blanks(card_element)
      .map do |el, blank_id|
        Card.new(
          id: [article.id, context_id, blank_id].join('/'),
          body_html: [*article_context, *context, el].map(&:to_html).join("\n")
        )
      end
  end

  def context_id
    element['data-context']
  end

  def each(&block)
    cards.each(&block)
  end

  def to_ary
    cards
  end
end

class Card
  include ActiveModel::Model

  attr_accessor :id, :body_html

  def self.build_cards(element, article)
    element.css('[data-context]').flat_map{ |d| CardContext.new(d, article) }
  end

  def body_html
    @body_html.html_safe
  end

  # def body_html
  #   body_doc.to_html.html_safe
  # end
end
