{EditorView, WorkspaceView} = require 'atom'

describe "HighlightColumnView", ->
  [editorView, editor, hlColumn] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    waitsForPromise ->
      atom.packages.activatePackage('highlight-column')

    runs ->
      atom.workspaceView.attachToDom()
      atom.workspaceView.height(700)
      atom.workspaceView.width(1500)
      editorView = atom.workspaceView.getActiveView()
      editor = editorView.getEditor()
      hlColumn = atom.workspaceView.find('.highlight-column').view()
      editorView.trigger 'resize'

  describe "defaultConfigs", ->
    it "set default opacity to 0.15", ->
      expect(atom.config.get('highlight-column.opacity')).toBe 0.15

  describe "@initialize", ->
    it "appends self to each editorView's underlayer", ->
      expect(atom.workspaceView.panes.find('.pane').length).toBe 1
      expect(atom.workspaceView.panes.find('.underlayer > .highlight-column').length).toBe 1
      editorView.splitRight()
      expect(atom.workspaceView.find('.pane').length).toBe 2
      expect(atom.workspaceView.panes.find('.underlayer > .highlight-column').length).toBe 2

  describe "@highlightWidth", ->
    it "equles char width", ->
      expect(hlColumn.highlightWidth()).toBe(editorView.charWidth)

  describe "@cursorScreenLeft", ->
    it "calculates cursor's left positoin", ->
      spyOn(editorView.getCursorView(), "css").andReturn(32)
      expect(hlColumn.cursorScreenLeft()).toBe(32)

  describe "@updateHighlight", ->
    it "positions the highlight at the configured column", ->
      spyOn(hlColumn, "highlightWidth").andReturn(16)
      spyOn(hlColumn, "cursorScreenLeft").andReturn(32)
      editorView.trigger("cursor:moved")
      expect(hlColumn.width()).toBe(16)
      expect(hlColumn.position().left).toBe(32)
    it "change opacity when the config changes", ->
      atom.config.set('highlight-column.opacity', 0.3)
      expect(hlColumn.css('opacity')).toBeCloseTo(0.3, 2)
