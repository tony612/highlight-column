{$, View} = require 'atom'

module.exports =
class HighlightColumnView extends View
  configDefaults:
    opacity: "0.15"
    enableHighlight: true

  @activate: ->
    opacity = atom.config.get('highlight-column.opacity')
    isEnable = atom.config.get('highlight-column.enableHighlight')
    atom.config.set('highlight-column.opacity', opacity || 0.15)
    atom.config.set('highlight-column.enableHighlight', !!isEnable)
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        editorView.underlayer.append(new HighlightColumnView(editorView))

  @content: ->
    @div class: 'highlight-column'

  initialize: (@editorView) ->
    @subscribe @editorView, 'cursor:moved', => @updateHighlight()
    @subscribe atom.config.observe 'highlight-column.opacity', callNow: false, => @updateHighlight()

    atom.workspaceView.command 'highlight-column:toggle', '.editor', =>
      atom.config.toggle('highlight-column.enableHighlight')
    @subscribe atom.config.observe 'highlight-column.enableHighlight', callNow: false, => @updateHighlight()

    @updateHighlight()

  highlightWidth: ->
    @editorView.charWidth

  cursorScreenLeft: ->
    if @editorView.getCursorView?
      @editorView.getCursorView().css('left')
    else
      @editorView.editor.getCursor().getPixelRect().left

  opacity: ->
    if atom.config.get('highlight-column.enableHighlight')
      atom.config.get('highlight-column.opacity')
    else
      0

  updateHighlight: ->
    @css('width', @highlightWidth())
    @css('left', @cursorScreenLeft()).show()
    @css('opacity', @opacity())
