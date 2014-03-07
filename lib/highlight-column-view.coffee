{View} = require 'atom'

module.exports =
class HighlightColumnView extends View
  @content: ->
    @div class: 'highlight-column overlay from-top', =>
      @div "The HighlightColumn package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "highlight-column:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "HighlightColumnView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
