do (jQuery) ->
  $ = jQuery

  $.fn.dominator = (options) ->
    $.extend options

    $(@).css(cursor: 'crosshair')

    $canvas = $('<canvas>')
      .attr(width: 500, height: 500)
      .css(position: 'absolute')
    $('body').append $canvas
    context = $canvas.get(0).getContext('2d')
    context.fillStyle = '#FFF'
    context.fillRect(0, 0, 100, 100)

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
