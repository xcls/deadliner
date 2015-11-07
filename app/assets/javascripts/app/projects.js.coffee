$(document).on 'ready page:load', ->
  clip = new ZeroClipboard($("#d_clip_button"))

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
