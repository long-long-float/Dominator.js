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

    update = ->
      context.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

      context.strokeStyle = '#FFF'
      context.lineWidth = 1.5
      context.beginPath()
      context.arc(CIRCLE_RADIUS + 1, CIRCLE_RADIUS + 1, CIRCLE_RADIUS, 0, Math.PI * 2, false)
      context.stroke()

      context.fillStyle = '#FFF'

      context.font = 'italic 10px Arial Hebrew'
      context.fillText('CRIME COEFFICIENT:', CIRCLE_RADIUS, CIRCLE_RADIUS - 25)

      context.font = 'italic 40px Arial Hebrew'
      context.fillText('299.0 -', CIRCLE_RADIUS, CIRCLE_RADIUS)
      w = context.measureText('299.0 -').width

      context.font = 'italic 25px Arial Hebrew'
      context.fillText('300', CIRCLE_RADIUS + w + 10, CIRCLE_RADIUS)

      context.font = 'italic 10px Arial Hebrew'
      context.fillText('TARGET:', CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6 - 20)

      context.font = 'italic 20px Arial Hebrew'
      context.fillText('Not Target', CIRCLE_RADIUS, CIRCLE_RADIUS * 1.6)

    setInterval update, 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
