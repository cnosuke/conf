$ ->
  $('body').bind('contextmenu' ->
    unless $('body').hasClass('cookpad_staff')
      false
  )
