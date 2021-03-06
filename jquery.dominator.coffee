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
      contextState ->
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

    class ValueWithPrev
      constructor: (@current) -> @prev = @current
      set: (value) ->
        @prev = @current
        @current = value
        return @
      isChanged: -> @current != @prev

    dominator =
      CCBORDERS: [
        {
          value  : 0
          message: 'Not Target'
          color  : '#00F2D5'
        },
        {
          value  : 160
          message: 'Execution'
          color  : '#FF9900'
        },
        {
          value  : 300
          message: 'Execution'
          color  : '#FF0000'
        }]
      crimeCoefficient:
        $.extend new ValueWithPrev(0),
          toString: (opts) ->
            opts = $.extend {
                padding: true
              }, opts

            str = (Math.floor(@current.toString() * 10) / 10).toString()
            str += '.0' if @current == parseInt(@current)

            if opts?.padding
              ('   ' + str).slice(-5)
            else
              str
      targetState: new ValueWithPrev('')
      getTargetState: ->
        @targetState.set @getMaxCCBorder().message
      indicatorColor: new ValueWithPrev('#000000')
      getIndicatorColor: ->
        @indicatorColor.set @getMaxCCBorder().color
      getMaxCCBorder: ->
        ccc = @crimeCoefficient.current
        for border in @CCBORDERS by -1
          return border if ccc >= border.value
      ccBorder: new ValueWithPrev(0)
      getCCBorder: ->
        ccc = @crimeCoefficient.current
        result = 0
        minDiff = Infinity
        for border in @CCBORDERS
          diff = Math.abs(border.value - ccc)
          if diff < minDiff
            result = border.value
            minDiff = diff

        return @ccBorder.set result

    mousePos =
      x: 0
      y: 0

    class Animation
      constructor: (@locals, @updater) ->
      update: ->
        @updater.call(@locals)

    createFadeOutAnimation = (w, h) ->
      new Animation {opaque: 1}, ->
        contextState =>
          context.fillStyle = "rgba(0, 242, 213, #{@opaque})"
          context.fillRect(0, 0, w, h)

          @opaque -= 0.1 if @opaque != 0

    update = ->
      pointedElem = document.elementFromPoint(mousePos.x, mousePos.y)
      if pointedElem
        if pointedElem.tagName.toLowerCase() == 'a'
          hash = parseInt(md5(pointedElem.href), 16)
          dominator.crimeCoefficient.set(hash % 1000)
        else
          dominator.crimeCoefficient.set(0)

    indicateAnime          = null
    updateCCAnime          = null
    updateCCBorderAnime    = null
    updateTargetStateAnime = null

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
        ci = dominator.getIndicatorColor()
        if ci.isChanged()
          indicateAnime = new Animation {radian: 0}, ->
            contextState =>
              context.translate(-CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 4)

              context.rotate(@radian)
              context.fillStyle = ci.current

              for i in [1..3]
                context.rotate(1 / 25 * Math.PI)
                context.fillRect(0, -CIRCLE_RADIUS * 4, 20, 30)

              if @radian < (1 / 4 - 2 / 20) * Math.PI
                @radian += 1 / 20 * Math.PI

              return false

        indicateAnime.update()

      contextState -> #text
        context.translate(CIRCLE_RADIUS, CIRCLE_RADIUS - 25)

        context.fillStyle   = '#FFF'
        context.strokeStyle = '#000'
        context.lineWidth   = 0.5

        drawTextWithBanner('CRIME COEFFICIENT:', 10)

        context.translate(0, 30)
        contextState ->
          cc = dominator.crimeCoefficient.toString()
          w = getTextWidth(cc, 40)
          context.translate(90 - w, 0)
          drawText(cc, 40)

          context.translate(w - 90, 0)

          ccw = getTextWidth(dominator.crimeCoefficient.toString(padding: false), 40)
          if dominator.crimeCoefficient.isChanged()
            updateCCAnime = createFadeOutAnimation(ccw, 30)

          contextState ->
            context.translate(92 - ccw, -26)
            updateCCAnime?.update()

          context.translate(90, 0)
          drawText('-', 40)
          context.translate(getTextWidth('-', 40), 0)
          ccBorder = dominator.getCCBorder()
          if ccBorder.isChanged()
            w = getTextWidth(ccBorder.current.toString(), 25)
            updateCCBorderAnime = createFadeOutAnimation(w, 18)

          contextState ->
            context.translate(0, -15)
            updateCCBorderAnime?.update()

          drawText(ccBorder.current, 25)

        context.translate(0, 20)
        drawTextWithBanner('TARGET:', 10)

        context.translate(0, 20)
        targetState = dominator.getTargetState()
        if targetState.isChanged()
          w = getTextWidth(targetState.current, 20)
          updateTargetStateAnime = createFadeOutAnimation(w, 20)

        drawText(targetState.current, 20)

        contextState ->
          context.translate(0, -18)
          updateTargetStateAnime.update()

    setInterval (->
      update()
      draw()
    ), 1000 / 30

    document.onmousemove = (event) ->
      offsetX = 50
      offsetY = 50
      $canvas.css(left: "#{event.clientX + offsetX}px", top: "#{event.clientY + offsetY}px")

      mousePos.x = event.clientX
      mousePos.y = event.clientY

    return @
