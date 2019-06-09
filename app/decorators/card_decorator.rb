class CardDecorator < Draper::Decorator
  delegate_all

  decorates_association :article
  decorates_association :reviews

  def blank
    h.truncate(object.blank_element.text, length: 50)
  end

  def last_reviewed_at_html
    h.time_in_words_html(last_reviewed_at)
  end

  def next_review_at_html
    if next_review_at.present?
      if next_review_at.today?
        h.time_tag next_review_at, 'Today'
      else
        h.time_tag next_review_at, format: :short
      end
    else
      h.content_tag(:span, '(New)', class: 'no-data')
    end
  end

  def updated_at_html
    h.time_in_words_html(updated_at)
  end

  def e_factor_html
    h.number_with_precision(e_factor, precision: 2)
  end

end
