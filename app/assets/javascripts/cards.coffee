$ ->




  $('.kb-card.review').each ->
    $card = $(this)

    $showAnswer = $card.find('[name=show-answer]')
    $reviewGrades = $card.find('[name=review-grades]')

    $reviewGrades.hide()
    $showAnswer.on 'click', (ev) ->
      ev.preventDefault()

      $card.trigger('revealBlanks')
      $reviewGrades.show()
      $showAnswer.hide()


    getAction = (state) -> if state then 'reveal' else 'conceal'

    $card.on 'toggleBlanks', ->
      $card.trigger(getAction($card.data('concealBlanks')) + 'Blanks')


    $card.on 'concealBlanks', ->
      $card.data('concealBlanks', true)
      $card.find('.blank').contents()
        .wrapAll('<span class="concealed"/>')
        .parent()
        .before('<span class="blank-placeholder">…</span>')

    $card.on 'revealBlanks', ->
      $card.data('concealBlanks', false)
      $card.find('.blank')
        .find('.blank-placeholder').remove().end()
        .find('.concealed').contents().unwrap()


    $card.trigger(
      getAction(not $card.data('concealBlanks')) + 'Blanks'
    )
