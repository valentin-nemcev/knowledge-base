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

  def flash_messages(opts = {})
    flash.map do |msg_type, message|
      content_tag(:div,
                  class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        close_button + message
      end
    end.join.html_safe
  end
end
