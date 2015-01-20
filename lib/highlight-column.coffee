HighlightColumnView = require './highlight-column-view'
{CompositeDisposable, TextEditor} = require 'atom'
{$} = require 'space-pen'

module.exports = HighlightColumn =
  subscriptions: null
  bindings: null
  enabled: true

  activate: (state) ->
    @hlViews = {}
    @paneBindings = {}

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @bindings = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'highlight-column:toggle': => @toggle()

    @bindHighlights()

  deactivate: ->
    @subscriptions.dispose()
    @bindings.dispose()
    bindings.dispose() for _, bindings of @paneBindings

  toggle: ->
    if @enabled
      @clearBindings()

      @bindings.dispose()
    else
      @bindHighlights()
    @enabled = !@enabled

  clearBindings: ->
    for id, view of @hlViews
      @hlViews[id].remove()
      delete @hlViews[id]

    for id, bindings of @paneBindings
      @paneBindings[id].dispose()
      delete @paneBindings[id]

  bindHighlights: ->

    @bindings.add atom.workspace.observeActivePaneItem (editor) =>
      return unless editor && editor instanceof TextEditor

      @clearBindings()

      editorElement = atom.views.getView(editor)

      paneBindings = new CompositeDisposable()

      getCursorRect = (cursor) ->
        rect = cursor.getPixelRect()
        rect.width = editor.getDefaultCharWidth() if !rect.width or rect.width is 0
        rect

      paneBindings.add editor.observeCursors (cursor) =>
        hlColumnView = new HighlightColumnView
        $('.underlayer', editorElement).append(hlColumnView)
        hlColumnView.update(getCursorRect(cursor))
        @hlViews[cursor.id] = hlColumnView

      paneBindings.add editor.onDidChangeCursorPosition (event) =>
        cursor = event.cursor
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.update(getCursorRect(event.cursor)) if hlColumnView

      paneBindings.add editor.onDidRemoveCursor (cursor) =>
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.remove()

      @paneBindings[editor.id] = paneBindings

    @bindings.add atom.workspace.onWillDestroyPaneItem (event) =>
      editor = event.item
      return unless editor && editor instanceof TextEditor
      @clearBindings()
