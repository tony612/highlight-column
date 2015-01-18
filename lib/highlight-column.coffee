HighlightColumnView = require './highlight-column-view'
{CompositeDisposable} = require 'atom'
{$} = require 'space-pen'

module.exports = HighlightColumn =
  subscriptions: null
  bindings: null
  enabled: true

  activate: (state) ->
    @hlViews = {}

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @bindings = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'highlight-column:toggle': => @toggle()

    @bindHighlights()

  deactivate: ->
    @subscriptions.dispose()
    @bindings.dispose()

  serialize: ->
    highlightColumnViewState: @hlColumnView.serialize()

  toggle: ->
    if @enabled
      @bindings.dispose()
      @hlColumnView.hide()
    else
      @bindHighlights()
    @enabled = !@enabled

  bindHighlights: ->
    @bindings.add atom.workspace.observeTextEditors (editor) =>
      editorElement = atom.views.getView(editor)

      getCursorRect = (cursor) ->
        rect = cursor.getPixelRect()
        rect.width = editor.getDefaultCharWidth() if !rect.width or rect.width is 0
        rect

      @bindings.add editor.observeCursors (cursor) =>
        hlColumnView = new HighlightColumnView
        $('.underlayer', editorElement).append(hlColumnView)
        hlColumnView.update(getCursorRect(cursor))
        @hlViews[cursor.id] = hlColumnView

      @bindings.add editor.onDidChangeCursorPosition (event) =>
        cursor = event.cursor
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.update(getCursorRect(event.cursor))

      @bindings.add editor.onDidRemoveCursor (cursor) =>
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.remove()
