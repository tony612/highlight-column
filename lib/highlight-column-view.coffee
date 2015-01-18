{View} = require 'space-pen'

module.exports =
class HighlightColumnView extends View
  @content: ->
    @div class: 'highlight-column'

  update: (rect)->
    @css('left', rect.left)
    @css('width', rect.width)
