{View} = require 'space-pen'

module.exports =
class HighlightColumnView extends View
  @content: ->
    @div class: 'highlight-column'

  update: (rect, opacity = 0.15) ->
    @css('left', rect.left)
    @css('width', rect.width)
    @updateOpacity(opacity)

  updateOpacity: (opacity) ->
    @css('opacity', opacity)
