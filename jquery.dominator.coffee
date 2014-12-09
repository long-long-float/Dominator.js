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

    drawText = (text, fontSize, x, y, stroke = true) ->
      context.font = "italic #{fontSize}px Arial Hebrew"
      context.fillText(text, x, y)
      context.strokeText(text, x, y) if stroke

    drawTextWithBanner = (text, fontSize, x, y) ->
      context.font = "italic #{fontSize}px Arial Hebrew"
      w = context.measureText(text).width
      console.log text, w
      grad = context.createLinearGradient(x, 0, x + w * 1.5, 0)
      grad.addColorStop(0, 'rgba(0, 0, 0, 0.5)')
      grad.addColorStop(1, 'rgba(0, 0, 0, 0)')
      oldStyle = context.fillStyle
      context.fillStyle = grad
      context.fillRect(x - 5, y - 10, w * 1.5, 13)

      context.fillStyle = oldStyle
      drawText(text, fontSize, x, y, false)

    update = ->
      context.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

      grad = context.createRadialGradient(CIRCLE_RADIUS - 5, CIRCLE_RADIUS + 5, 0, CIRCLE_RADIUS - 5, CIRCLE_RADIUS + 5, CIRCLE_RADIUS - 10)
      grad.addColorStop(0, 'rgba(0, 0, 0, 0)')
      grad.addColorStop(1, 'rgba(0, 0, 0, 0.2)')
      context.fillStyle = grad
      context.beginPath()
      context.arc(CIRCLE_RADIUS - 5, CIRCLE_RADIUS + 5, CIRCLE_RADIUS - 10, 0, Math.PI * 2)
      context.fill()

      context.beginPath()
      context.strokeStyle = '#000'
      context.lineWidth   = 2
      context.arc(CIRCLE_RADIUS + 1, CIRCLE_RADIUS + 1, CIRCLE_RADIUS, 0, Math.PI * 2, false)
      context.stroke()

      context.beginPath()
      context.strokeStyle = '#FFF'
      context.lineWidth   = 1
      context.arc(CIRCLE_RADIUS + 1, CIRCLE_RADIUS + 1, CIRCLE_RADIUS, 0, Math.PI * 2, false)
      context.stroke()

      context.fillStyle   = '#FFF'
      context.strokeStyle = '#000'
      context.lineWidth   = 0.5

      drawTextWithBanner('CRIME COEFFICIENT:', 10, CIRCLE_RADIUS, CIRCLE_RADIUS - 25)
      drawText('299.0 -', 40, CIRCLE_RADIUS, CIRCLE_RADIUS)
      w = context.measureText('299.0 -').width
      drawText('300', 25, CIRCLE_RADIUS + w + 10, CIRCLE_RADIUS)

      drawTextWithBanner('TARGET:', 10, CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6 - 20)
      drawText('Not Target', 20, CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6)

    setInterval update, 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
