class HighlightColumnView extends HTMLDivElement
  initialize: ()->
    @classList.add('highlight-column')
    this

  update: (rect, opacity = 0.15, offset = 0) ->
    @style.left = "#{rect.left - offset}px"
    @style.width = "#{rect.width}px"
    @updateOpacity(opacity)

  updateOpacity: (opacity) ->
    @style.opacity = opacity

module.exports = document.registerElement('highlight-column',
  extends: 'div'
  prototype: HighlightColumnView.prototype
)
