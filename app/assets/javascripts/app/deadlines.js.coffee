$(document).on 'ready page:load', ->
  updateCountdown = (e) ->
    suffix = if e.elapsed then "ago" else "from now"
    daysFormat = "%D days %-H hours %M minutes #{suffix}"
    $(this).text(e.strftime(daysFormat));

  $('.js-countdown').each ->
    $clock = $(this)
    epochSeconds = Number($clock.data('epoch-seconds'))
    $clock.countdown(epochSeconds * 1000, { elapse: true })
      .on('update.countdown', updateCountdown)

$(document).on 'ready page:load', ->
  updateCountdown = (e) ->
    prefix = if e.elapsed then "-" else ""
    $this = $(this)
    $this.find('.js-countdown-days').text(e.strftime("#{prefix}%D"));
    $this.find('.js-countdown-hours').text(e.strftime("%H"));
    $this.find('.js-countdown-minutes').text(e.strftime("%M"));

  $('.js-countdown-big').each ->
    $bigClock = $(this)
    epochSeconds = Number($bigClock.data('epoch-seconds'))
    $bigClock.countdown(epochSeconds * 1000, { elapse: true })
      .on('update.countdown', updateCountdown)
