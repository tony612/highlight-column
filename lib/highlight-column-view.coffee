{$, View} = require 'atom'

module.exports =
class HighlightColumnView extends View
  configDefaults:
    opacity: "0.15"
    enableHighlight: true

  @activate: ->
    opacity = atom.config.get('highlight-column.opacity')
    atom.config.set('highlight-column.opacity', opacity || 0.15)
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        editorView.underlayer.append(new HighlightColumnView(editorView))

  @toggle: ->
    current = atom.config.get('highlight-column.enableHighlight')
    atom.config.set('highlight-column.enableHighlight', not current)

  @content: ->
    @div class: 'highlight-column'

  initialize: (@editorView) ->
    @subscribe @editorView, 'cursor:moved', => @updateHighlight()
    @subscribe atom.config.observe 'highlight-column.opacity', callNow: false, => @updateHighlight()
    @subscribe atom.config.observe 'highlight-column.enableHighlight', callNow: false, => @updateHighlight()

    @updateHighlight()

    atom.workspaceView.command 'highlight-column:toggle', '.editor', =>
      @toggle()

  highlightWidth: ->
    @editorView.charWidth

  cursorScreenLeft: ->
    @editorView.getCursorView().css('left')

  updateHighlight: ->
    @css('width', @highlightWidth())
    @css('left', @cursorScreenLeft()).show()
    if atom.config.get('highlight-column.enableHighlight')
      @css('opacity', atom.config.get('highlight-column.opacity'))
    else
      @css('opacity', 0)
