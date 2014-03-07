HighlightColumnView = require './highlight-column-view'

module.exports =
  highlightColumnView: null

  activate: (state) ->
    @highlightColumnView = new HighlightColumnView(state.highlightColumnViewState)

  deactivate: ->
    @highlightColumnView.destroy()

  serialize: ->
    highlightColumnViewState: @highlightColumnView.serialize()
