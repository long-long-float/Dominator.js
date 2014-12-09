do (jQuery) ->
  $ = jQuery

  $.fn.dominator = (options) ->
    $.extend options

    $(@).css(cursor: 'crosshair')

    CANVAS_WIDTH  = 300
    CANVAS_HEIGHT = 150
    CIRCLE_RADIUS = 70.5
    $canvas = $('<canvas>')
      .attr(width: CANVAS_WIDTH, height: CANVAS_HEIGHT)
      .css(position: 'absolute')
    $('body').append $canvas
    context = $canvas.get(0).getContext('2d')

    drawText = (text, fontSize, stroke = true) ->
      context.font = "italic #{fontSize}px Arial Hebrew"
      context.fillText(text, 0, 0)
      context.strokeText(text, 0, 0) if stroke

    drawTextWithBanner = (text, fontSize) ->
      contextState ->
        context.font = "italic #{fontSize}px Arial Hebrew"
        w = context.measureText(text).width
        grad = context.createLinearGradient(0, 0, w * 1.5, 0)
        grad.addColorStop(0, 'rgba(0, 0, 0, 0.5)')
        grad.addColorStop(1, 'rgba(0, 0, 0, 0)')
        context.fillStyle = grad
        context.fillRect(-5, -10, w * 1.5, 13)
      drawText text, fontSize, false

    contextState = (func) ->
      context.save()
      func()
      context.restore()

    update = ->
      context.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

      contextState -> #background circle
        context.translate(CIRCLE_RADIUS - 5, CIRCLE_RADIUS + 5)

        grad = context.createRadialGradient(0, 0, 0, 0, 0, CIRCLE_RADIUS - 10)
        grad.addColorStop(0, 'rgba(0, 0, 0, 0)')
        grad.addColorStop(1, 'rgba(0, 0, 0, 0.2)')
        context.fillStyle = grad

        context.beginPath()
        context.arc(0, 0, CIRCLE_RADIUS - 10, 0, Math.PI * 2)
        context.fill()

      contextState -> #foreground circle
        context.translate(CIRCLE_RADIUS + 1, CIRCLE_RADIUS + 1)

        context.strokeStyle = '#000'
        context.lineWidth   = 2

        context.beginPath()
        context.arc(0, 0, CIRCLE_RADIUS, 0, Math.PI * 2, false)
        context.stroke()

        context.strokeStyle = '#FFF'
        context.lineWidth   = 1

        context.beginPath()
        context.arc(0, 0, CIRCLE_RADIUS, 0, Math.PI * 2, false)
        context.stroke()

      contextState -> #indicator
        context.translate(-CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 4)

        context.fillStyle = '#F00'

        context.rotate((1 / 4 - 2 / 20) * Math.PI)
        for i in [1..3]
          context.rotate(1 / 25 * Math.PI)
          context.fillRect(0, -CIRCLE_RADIUS * 4, 20, 30)

      contextState -> #text
        context.translate(CIRCLE_RADIUS, CIRCLE_RADIUS - 25)

        context.fillStyle   = '#FFF'
        context.strokeStyle = '#000'
        context.lineWidth   = 0.5

        drawTextWithBanner('CRIME COEFFICIENT:', 10)

        context.translate(0, 30)
        drawText('299.0 -', 40)
        contextState ->
          w = context.measureText('299.0 -').width
          context.translate(w + 10, 0)
          drawText('300', 25)

        context.translate(0, 20)
        drawTextWithBanner('TARGET:', 10)

        context.translate(0, 20)
        drawText('Not Target', 20)

    setInterval update, 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
