# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#

$ ->

  $(':submit[name=autosave]').click( (ev) ->
    ev.preventDefault()
    $form = $(this).closest('form')
    console.log($form.attr('action') + '/autosave')
    $.ajax(
      method: "PATCH",
      url: $form.attr('action') + '/autosave',
      data: $form.serialize(),
      dataType: "script",
      beforeSend: -> console.log("start"),
      complete: -> console.log("complete"),
    )
  )
