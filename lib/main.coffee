HighlightColumnElement = require './highlight-column-element'

module.exports = HighlightColumn =
  config:
    opacity:
      type: 'number'
      default: 0.15
      minimum: 0
      maximum: 1
    enabled:
      type: 'boolean'
      default: true
    lineMode:
      type: 'boolean'
      default: false


  activate: ->
    atom.commands.add 'atom-workspace', 'highlight-column:toggle', =>
      atom.config.set('highlight-column.enabled', !atom.config.get('highlight-column.enabled'))

    atom.workspace.observeTextEditors (editor) ->
      editor.observeCursors (cursor) =>
        editorElement = atom.views.getView(editor)
        highlightColumnElement = new HighlightColumnElement().initialize(editor, editorElement, cursor)
