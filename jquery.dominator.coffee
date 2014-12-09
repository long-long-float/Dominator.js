do (jQuery) ->
  $ = jQuery

  $.fn.dominator = (options) ->
    $.extend options

    $(@).css(cursor: 'crosshair')

    CANVAS_WIDTH  = 150
    CANVAS_HEIGHT = 150
    CIRCLE_RADIUS = 70
    $canvas = $('<canvas>')
      .attr(width: CANVAS_WIDTH, height: CANVAS_HEIGHT)
      .css(position: 'absolute')
    $('body').append $canvas
    context = $canvas.get(0).getContext('2d')

    update = ->
      context.strokeStyle = '#FFF'
      context.arc(CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2, CIRCLE_RADIUS, 0, Math.PI * 2, false)
      context.stroke()

      context.fillStyle = '#FFF'
      context.fillText('300', CIRCLE_RADIUS, CIRCLE_RADIUS)

    setInterval update, 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
