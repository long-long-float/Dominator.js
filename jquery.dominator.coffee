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

    contextState = (func) ->
      context.save()
      ret = func()
      context.restore()
      ret

    getTextWidth = (text, fontSize) ->
      contextState ->
        context.font = "italic #{fontSize}px Arial Hebrew"
        context.measureText(text).width

    drawText = (text, fontSize, stroke = true) ->
      context.font = "italic #{fontSize}px Arial Hebrew"
      context.fillText(text, 0, 0)
      context.strokeText(text, 0, 0) if stroke

    drawTextWithBanner = (text, fontSize) ->
      contextState ->
        w = getTextWidth(text, fontSize)
        grad = context.createLinearGradient(0, 0, w * 1.5, 0)
        grad.addColorStop(0, 'rgba(0, 0, 0, 0.5)')
        grad.addColorStop(1, 'rgba(0, 0, 0, 0)')
        context.fillStyle = grad
        context.fillRect(-5, -10, w * 1.5, 13)
      drawText text, fontSize, false

    crimeCoefficient =
      goal   : 0
      current: 0
      update : ->
        @current = Math.min(@current + 2, @goal)
      toString: ->
        str = (Math.floor(@current.toString() * 10) / 10).toString()
        str += '.0' if @current == parseInt(@current)
        ('   ' + str).slice(-5)

    crimeCoefficient.goal = 299.0

    update = ->
      crimeCoefficient.update()

    draw = ->
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
        contextState ->
          cc = crimeCoefficient.toString()
          w = getTextWidth(cc, 40)
          context.translate(110 - w, 0)
          drawText(cc, 40)

          context.translate(w, 0)
          drawText('-', 40)
          context.translate(context.measureText('-').width, 0)
          drawText('300', 25)

        context.translate(0, 20)
        drawTextWithBanner('TARGET:', 10)

        context.translate(0, 20)
        drawText('Not Target', 20)

    setInterval (->
      update()
      draw()
    ), 100

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

    return @
