$(document).on 'ready page:load', ->
  clip = new ZeroClipboard($("#copy_button"))

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
