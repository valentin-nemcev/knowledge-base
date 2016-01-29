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
end
