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
        prevValue: 0
        value: 0
        setValue: (value) ->
          @prevValue = @value
          @value = value
        toString: ->
          str = (Math.floor(@value.toString() * 10) / 10).toString()
          str += '.0' if @value == parseInt(@value)
          ('   ' + str).slice(-5)
      getTargetState: ->
        @getMaxCCBorder().message
      getIndicatorColor: ->
        @getMaxCCBorder().color
      currentIndicatorColor: '#000000'
      getMaxCCBorder: ->
        ccc = @crimeCoefficient.value
        for border in @CCBORDERS by -1
          return border if ccc >= border.value
      getCCBorder: ->
        ccc = @crimeCoefficient.value
        result = 0
        minDiff = Infinity
        for border in @CCBORDERS
          diff = Math.abs(border.value - ccc)
          if diff < minDiff
            result = border.value
            minDiff = diff

        return result

    mousePos =
      x: 0
      y: 0

    animations =
      # [[animation, locals]]
      contents: []
      # animation: function
      #   アニメーション終了時、trueを返せばanimationsから消滅する
      commitAnimation: (locals, animation) ->
        @contents.push [animation, locals]
      removeAnimation: (index) ->
        @contents = @contents.filter (_, i) -> i == index
      update: ->
        deleteIndexes = []
        for [animation, locals], i in @contents
          if animation.call(locals)
            deleteIndexes.push i

        @contents = @contents.filter (_, i) -> !(i in deleteIndexes)

    update = ->
      pointedElem = document.elementFromPoint(mousePos.x, mousePos.y)
      if pointedElem
        if pointedElem.tagName.toLowerCase() == 'a'
          hash = parseInt(md5(pointedElem.href), 16)
          dominator.crimeCoefficient.setValue(hash % 1000)
        else
          dominator.crimeCoefficient.setValue(0)

    draw = ->
      context.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

      animations.update()

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
        animeId = null
        if ci != dominator.currentIndicatorColor
          dominator.currentIndicatorColor = ci

          animations.removeAnimation animeId
          animeId = animations.commitAnimation {radian: 0}, ->
            contextState =>
              context.translate(-CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 4)

              context.rotate(@radian)
              context.fillStyle = dominator.currentIndicatorColor

              for i in [1..3]
                context.rotate(1 / 25 * Math.PI)
                context.fillRect(0, -CIRCLE_RADIUS * 4, 20, 30)

              if @radian < (1 / 4 - 2 / 20) * Math.PI
                @radian += 1 / 20 * Math.PI

              return false

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

          context.translate(w, 0)
          drawText('-', 40)
          context.translate(context.measureText('-').width, 0)
          drawText(dominator.getCCBorder(), 25)

        context.translate(0, 20)
        drawTextWithBanner('TARGET:', 10)

        context.translate(0, 20)
        drawText(dominator.getTargetState(), 20)

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
