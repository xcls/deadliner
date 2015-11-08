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

$(document).on 'ready page:load', ->
  $wrapper = $('.js-dark-knight')
  dueInSeconds = $wrapper.data('dueInSeconds')
  $night = $wrapper.find('.milestone-featured')
  secondsInDay = 24 * 3600

  setOpacity = (opacity) ->
    console.log("setting the night!", opacity)
    $night.css('background-color', "rgba(90, 83, 98, #{opacity})")

  updateNight = ->
    console.log(dueInSeconds)
    secondsLeft = dueInSeconds - (new Date().getTime() / 1000)
    console.log("seconds left", secondsLeft)

    if secondsLeft <= 0 # project not yet overdue
      setOpacity(1)
      return

    hoursLeft = secondsLeft / 3600
    if hoursLeft <= 24 # project within a day of due date
      # opacity = (1.0 / 24) * (24 - hoursLeft)
      opacity = (1.0 / secondsInDay) * (secondsInDay - secondsLeft)
      setOpacity(opacity)

    setTimeout(updateNight, 30 * 1000)

  updateNight()


