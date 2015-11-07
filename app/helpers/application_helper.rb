module ApplicationHelper
  def countdown(time)
    if time.present?
      content_tag(:div, {
        class: 'js-countdown',
        data: { "epoch-seconds" => time.to_i }
      }) { time.to_formatted_s(:long) }
    else
      content_tag :div, "No time specified"
    end
  end
end
