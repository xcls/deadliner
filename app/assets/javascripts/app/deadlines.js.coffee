$(document).on 'ready page:load', ->
  $clock = $('.js-countdown')
  epochSeconds = Number($clock.data('epoch-seconds'))

  updateCountdown = (e) ->
    suffix = if e.elapsed then "ago" else "from now"
    daysFormat = "%D days %-H hours %M minutes #{suffix}"
    $(this).text(e.strftime(daysFormat));

  $clock.countdown(epochSeconds * 1000, { elapse: true })
    .on('update.countdown', updateCountdown)
