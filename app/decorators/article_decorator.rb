class ArticleDecorator < Draper::Decorator
  delegate_all

  def body_html
    h.markdown(body || '')
  end

  def title_html
    if title.present?
      title
    else
      h.content_tag(:span, '(Untitled)', class: 'no-data')
    end
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
