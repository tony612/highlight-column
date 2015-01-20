HighlightColumnView = require './highlight-column-view'
{CompositeDisposable, TextEditor} = require 'atom'
{$} = require 'space-pen'

module.exports = HighlightColumn =
  subscriptions: null
  bindings: null

  config:
    opacity:
      type: 'number'
      default: 0.15
      minimum: 0
      maximum: 1

  opacity: -> atom.config.get('highlight-column.opacity')

  activate: (state) ->
    @hlViews = {}
    @paneBindings = {}
    @enabled = true

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @bindings = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'highlight-column:toggle': => @toggle()
    @subscriptions.add atom.config.observe 'highlight-column.opacity', (newValue) =>
      for id, view of @hlViews
        view.updateOpacity(@opacity) if view


    @bindHighlights()

  deactivate: ->
    @subscriptions.dispose()
    @bindings.dispose()
    bindings.dispose() for _, bindings of @paneBindings

  toggle: ->
    @enabled = !@enabled
    if @enabled
      @bindHighlights()
    else
      @clearBindings()
      @bindings.dispose()

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
        return unless @enabled
        hlColumnView = new HighlightColumnView
        $('.underlayer', editorElement).append(hlColumnView)
        hlColumnView.update(getCursorRect(cursor), @opacity)
        @hlViews[cursor.id] = hlColumnView

      paneBindings.add editor.onDidChangeCursorPosition (event) =>
        return unless @enabled
        cursor = event.cursor
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.update(getCursorRect(event.cursor), @opacity) if hlColumnView

      paneBindings.add editor.onDidRemoveCursor (cursor) =>
        hlColumnView = @hlViews[cursor.id]
        hlColumnView.remove()

      @paneBindings[editor.id] = paneBindings

    @bindings.add atom.workspace.onWillDestroyPaneItem (event) =>
      editor = event.item
      return unless editor && editor instanceof TextEditor
      @clearBindings()
