module.exports =
class HighlightColumnView
  constructor: (state) ->
    @markers = {}

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    for _, marker of @markers
      marker.destroy()
    @markers = {}

  hide: ->
    @destroy()

  addHighlight: (cursor) ->
    editor = cursor.editor
    range = cursor.getScreenRange().copy()
    marker = editor.markScreenRange(range, invalidate: "never")
    decoration = editor.decorateMarker(marker, type: 'highlight', class: "highlight-column")
    @markers[cursor.id] = marker

  updateMarker: (cursor) ->
    marker = @markers[cursor.id]
    range = cursor.getScreenRange().copy()
    marker.setScreenRange(range)

  destroyMarker: (cursor) ->
    marker = @markers[cursor.id]
    marker.destroy()
