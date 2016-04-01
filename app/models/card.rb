class Nokogiri::XML::Node
  def add_class(*classes)
    existing = self['class'].to_s.split(/\s+/)
    self['class'] = (existing + classes).join(" ")
  end

  def remove_class(*classes)
    existing = self['class'].to_s.split(/\s+/)
    self['class'] = (existing - classes).join(" ")
  end
end

class CardGroup
  include Enumerable

  attr_reader :element, :article_context
  def initialize(element, article)
    @element = element
  end

  def article_context
    @article_context ||= element.ancestors.last.css('#context, #context + *')
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
    card_element.delete('id')
    if card_element.name != 'div'
      new_element = card_element.document.create_element('div')
      new_element.add_child(card_element)
      card_element = new_element
    end
    card_element
  end

  def ungroup_blanks(card_element)
    card_element
      .css('.blank-group')
      .tap{ |els| els.remove_class('blank-group') }
      .each{ |el| el.children.add_class('blank') }
    card_element
  end

  def card_element
    @card_element ||= ungroup_blanks(wrap_card(element.dup))
  end

  def separate_blanks(card_element)
    card_element
      .css('.blank')
      .tap{ |els| els.remove_class('blank') }
      .map do |blank_el|
        blank_el.add_class('blank')
        new_element = card_element.dup
        blank_el.remove_class('blank')
        new_element
      end
  end

  def cards
    @cards ||= separate_blanks(card_element)
      .map.with_index do |el, i|
        Card.new(
          id: [id, i].join('-'),
          body_element: el,
          context: context,
          article_context: article_context
        )
      end
  end

  def id
    element['id']
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

  attr_accessor :id, :body_element, :context, :article_context

  def self.build_card_group(element, article)
    CardGroup.new(element, article)
  end

  def body_html
    body_element.to_html.html_safe
  end
end
