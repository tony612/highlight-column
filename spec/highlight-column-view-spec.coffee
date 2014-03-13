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

  describe "@cursorScreenColumn", ->
    it "returns cursor's screen column", ->
      expect(hlColumn.cursorScreenColumn()).toBe(0)
      editor.setText("12345")
      editor.setCursorScreenPosition([0, 3])
      expect(hlColumn.cursorScreenColumn()).toBe(3)

  describe "@highlightWidth", ->
    it "equles char width", ->
      expect(hlColumn.highlightWidth()).toBe(editorView.charWidth)

  describe "@cursorScreenLeft", ->
    it "calculates cursor's left positoin", ->
      spyOn(hlColumn, "cursorScreenColumn").andReturn(13)
      spyOn(hlColumn, "highlightWidth").andReturn(20)
      expect(hlColumn.cursorScreenLeft()).toBe(260)

  describe "@updateHighlight", ->
    it "positions the highlight at the configured column", ->
      spyOn(hlColumn, "cursorScreenColumn").andReturn(13)
      spyOn(hlColumn, "highlightWidth").andReturn(20)
      editorView.trigger("cursor:moved")
      expect(hlColumn.width()).toBe(20)
      expect(hlColumn.position().left).toBe(260)
    it "change opacity when the config changes", ->
      atom.config.set('highlight-column.opacity', 0.3)
      expect(hlColumn.css('opacity')).toBeCloseTo(0.3, 2)
