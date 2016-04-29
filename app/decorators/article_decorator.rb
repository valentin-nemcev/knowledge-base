class ArticleDecorator < Draper::Decorator
  delegate_all

  decorates_association :reviews

  def title_html
    if title.present?
      title
    else
      h.content_tag(:span, '(Untitled)', class: 'no-data')
    end
  end

  def updated_at_html
    h.time_in_words_html(updated_at)
  end

  def labels_html
    article.labels.map do |label|
      h.content_tag(:span, label, class: 'label label-default')
    end.join(' ').html_safe
  end
end
