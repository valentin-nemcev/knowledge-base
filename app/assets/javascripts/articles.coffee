$ ->
  $autosaveButton = $(':submit[name=autosave]')
  $form = $autosaveButton.closest('form')
  autosaveIntervalMsec = 3000

  $form.on('change input', ':input', _.debounce(
    (ev) -> $autosaveButton.click()
    autosaveIntervalMsec
  ))

  $autosaveButton.click( (ev) ->
    ev.preventDefault()
    $.ajax(
      method: "PATCH",
      url: $form.attr('action') + '/autosave',
      data: $form.serialize(),
      dataType: "script",
      beforeSend: -> $autosaveButton.prop('disabled', true)
      complete: -> $autosaveButton.prop('disabled', false)
    )
  )
