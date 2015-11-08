$(document).on 'ready page:load', ->
  $('#password-form-tab').on 'click', ->
    $('#general-form').hide()
    $('#general-form-tab').removeClass('active')
    $('#password-form').show()
    $(this).addClass('active')

  $('#general-form-tab').on 'click', ->
    $('#password-form').hide()
    $('#password-form-tab').removeClass('active')
    $('#general-form').show()
    $(this).addClass('active')
