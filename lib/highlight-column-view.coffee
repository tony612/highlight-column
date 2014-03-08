{$, View} = require 'atom'

module.exports =
class HighlightColumnView extends View
  @activate: ->
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        editorView.underlayer.append(new HighlightColumnView(editorView))

  @content: ->
    @div class: 'highlight-column'

  initialize: (@editorView) ->
    @subscribe @editorView, 'cursor:moved', => @updateHighlight()

    @updateHighlight()

  cursorScreenColumn: ->
    @editorView.getCursorView().getScreenPosition().column

  highlightWidth: ->
    @editorView.charWidth

  cursorScreenLeft: ->
    @cursorScreenColumn() * @highlightWidth()

  updateHighlight: ->
    @css('width', @highlightWidth())
    @css('left', @cursorScreenLeft()).show()
