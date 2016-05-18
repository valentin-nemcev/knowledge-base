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
    h.time_in_words_html(next_review_at)
  end

  def updated_at_html
    h.time_in_words_html(updated_at)
  end

end
