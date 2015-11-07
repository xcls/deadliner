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

  def ago_or_from_now(time)
    in_words = distance_of_time_in_words_to_now(time)
    suffix = if Time.now <= time then "from now" else "ago" end
    "#{in_words} #{suffix}"
  end
end
