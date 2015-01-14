HighlightColumnView = require './highlight-column-view'
{CompositeDisposable} = require 'atom'

module.exports = HighlightColumn =
  hlColumnView: null
  subscriptions: null
  enabled: true

  activate: (state) ->
    @hlColumnView = new HighlightColumnView(state.highlightColumnViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @bindings = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'highlight-column:toggle': => @toggle()

    @bindHighlights()

  deactivate: ->
    @subscriptions.dispose()
    @bindings.dispose()
    @hlColumnView.destroy()

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
      @bindings.add editor.observeCursors (cursor) =>
        @hlColumnView.addHighlight(cursor)

      @bindings.add editor.onDidChangeCursorPosition (event) =>
        @hlColumnView.updateMarker event.cursor

      @bindings.add editor.onDidRemoveCursor (cursor) =>
        @hlColumnView.destroyMarker cursor
