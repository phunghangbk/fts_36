$(document).ready ->
  timeleft = $('#timeleft').data('time')

  countdown_timer = ->
    if timeleft < 0
      clearInterval counter
      if $('#exam_submit').length == 1
        $('#exam_submit').click()
        alert 'Time expired!\nYour answers were auto submitted.'
      timeleft = 0
    minute = parseInt(timeleft / 60)
    second = timeleft % 60
    $('#timeleft').html 'Time left: ' + minute + ' m : ' + second + ' s.'
    timeleft = timeleft - 1
    return

  if timeleft != null
    minute = undefined
    second = undefined
    counter = setInterval(countdown_timer, 1000)
  return
