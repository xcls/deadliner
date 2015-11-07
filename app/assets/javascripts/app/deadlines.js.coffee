$(document).on 'ready page:load', ->
  $clock = $('.js-countdown')
  epochSeconds = Number($clock.data('epoch-seconds'))

  updateCountdown = (e) ->
    suffix = if e.elapsed then "ago" else "from now"
    daysFormat = "%D days %-H hours %M minutes #{suffix}"
    $(this).text(e.strftime(daysFormat));

  $clock.countdown(epochSeconds * 1000, { elapse: true })
    .on('update.countdown', updateCountdown)


$(document).on 'ready page:load', ->
  $bigClock = $('.js-countdown-big')
  epochSeconds = Number($bigClock.data('epoch-seconds'))

  updateCountdown = (e) ->
    $this = $(this)
    $this.find('.js-countdown-days').text(e.strftime("%D"));
    $this.find('.js-countdown-hours').text(e.strftime("%H"));
    $this.find('.js-countdown-minutes').text(e.strftime("%M"));

  $bigClock.countdown(epochSeconds * 1000, { elapse: true })
    .on('update.countdown', updateCountdown)
