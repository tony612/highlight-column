{$, View} = require 'atom'

module.exports =
class HighlightColumnView extends View
  configDefaults:
    opacity: "0.15"

  @activate: ->
    opacity = atom.config.get('highlight-column.opacity')
    atom.config.set('highlight-column.opacity', opacity || 0.15)
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        editorView.underlayer.append(new HighlightColumnView(editorView))

  @content: ->
    @div class: 'highlight-column'

  initialize: (@editorView) ->
    @subscribe @editorView, 'cursor:moved', => @updateHighlight()
    @subscribe atom.config.observe 'highlight-column.opacity', callNow: false, => @updateHighlight()

    @updateHighlight()

  highlightWidth: ->
    @editorView.charWidth

  cursorScreenLeft: ->
    @editorView.getCursorView().css('left')

  updateHighlight: ->
    @css('width', @highlightWidth())
    @css('left', @cursorScreenLeft()).show()
    @css('opacity', atom.config.get('highlight-column.opacity'))
