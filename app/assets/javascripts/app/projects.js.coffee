$(document).on 'ready page:load', ->
  clip = new ZeroClipboard($(".js-copy-button"))

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
