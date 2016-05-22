module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }[flash_type.to_sym] || flash_type
  end

  def close_button
    content_tag(:button,
                type: 'button', class: "close", aria_label: 'Close',
                data: { dismiss: 'alert' }) do
      content_tag(:span, raw('&times;'), aria_hidden: true)
    end
  end

  def flash_messages(messages = {})
    Array(flash.notice).map do |message_key|
      type, text = *messages.fetch(message_key.to_sym, [:info, message_key])
      content_tag(:div, class: "alert alert-#{type} fade in") do
        close_button + text
      end
    end.join.html_safe
  end

  def time_in_words_html(from_time, options = {})
    if from_time.present?
      content = distance_of_time_in_words_to_now(from_time, options)
      if from_time > DateTime.now
        content = 'in ' + content
      else
        content = content + ' ago'
      end
      datetime = from_time.iso8601
      title = I18n.l(from_time, :format => :long)
      content_tag(:time, content, {datetime: datetime, title: title})
    else
      content_tag(:span, '(Never)', class: 'no-data')
    end
  end

  def nav_link(body, url, options = {})
    link_options = {class: ['nav-item', 'nav-link'] | [*options.fetch(:class, [])]}
    link_options[:class] << 'active' if current_page?(url)
    if url.nil?
      link_options[:class] << 'disabled'
      url = 'javascript:;'
    end
    link_to(body, url, options.merge(link_options))
  end
end
