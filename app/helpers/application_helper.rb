module ApplicationHelper
  def countdown(time)
    if time.present?
      content_tag(:div, {
        class: 'js-countdown',
        title: "Due on #{time.to_formatted_s(:long)}",
        data: { "epoch-seconds" => time.to_i }
      }) do
        time.to_formatted_s(:long)
      end
    else
      content_tag :div, "No time specified"
    end
  end
end
