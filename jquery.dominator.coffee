do (jQuery) ->
  $ = jQuery

  $.fn.dominator = (options) ->
    $.extend options

    $(@).css(cursor: 'crosshair')

    ###
    $svg = $(document.createElement('svg'))
        .attr(width: 500, height: 500)
        .append(
          $(document.createElement('circle'))
            .attr(
              cx: 0, cy: 0, r: 30,
              stroke: 'white', 'stroke-width': 4))
    $(@).append $svg
    ###

    $('body').svg
      onLoad: (svg) ->
        svg.circle 100, 100, 60,
          fill: 'none', stroke: 'white', strokeWidth: 2
    svg = $('body').svg('get').root()

    document.onmousemove = (event) ->
      console.log event
      svg.style.left = event.x
      svg.style.top  = event.y

    return @
