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

    drawText = (text, fontSize, x, y) ->
      context.font = "italic #{fontSize}px Arial Hebrew"
      context.fillText(text, x, y)
      context.strokeText(text, x, y)

    update = ->
      context.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

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

      drawText('CRIME COEFFICIENT:', 10, CIRCLE_RADIUS, CIRCLE_RADIUS - 25)
      drawText('299.0 -', 40, CIRCLE_RADIUS, CIRCLE_RADIUS)
      w = context.measureText('299.0 -').width
      drawText('300', 25, CIRCLE_RADIUS + w + 10, CIRCLE_RADIUS)

      drawText('TARGET:', 10, CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6 - 20)
      drawText('Not Target', 20, CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6)

    setInterval update, 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
