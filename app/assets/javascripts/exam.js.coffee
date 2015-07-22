@add_fields = (link, assoc, content) ->
  new_id = (new Date).getTime()
  regexp = new RegExp('new_' + assoc, 'g')
  $(link).before content.replace(regexp, new_id)
  return

@remove_fields = (link) ->
  $(link).prev('input[type=hidden]').val '1'
  $(link).closest('.form-group').hide()
  return

setTimeout (->
  $('.flash').fadeOut()
  return
), '5000'
