$ ->

  $(document).on 'click', (ev) ->
    $target = $(ev.target)
    if $target.data('clickTriggers')
      $target.trigger($target.data('clickTriggers'))
      ev.preventDefault()



  $('.kb-card.review').each ->
    $card = $(this)

    getAction = (state) -> if state then 'reveal' else 'conceal'

    $card.on 'toggleBlanks', ->
      $card.trigger(getAction($card.data('concealBlanks')) + 'Blanks')


    $card.on 'concealBlanks', ->
      $card.data('concealBlanks', true)
      console.log( $card.find('.blank').contents()
        .wrapAll('<span class="concealed"/>')
        .parent()
        .before('<span class="blank-placeholder">…</span>')
      )

    $card.on 'revealBlanks', ->
      $card.data('concealBlanks', false)
      $card.find('.blank')
        .find('.blank-placeholder').remove().end()
        .find('.concealed').contents().unwrap()



    action = if $card.data('concealBlanks') then 'reveal' else 'conceal'
