{$} = require 'space-pen'

describe "HighlightColumn", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('highlight-column')
      atom.workspace.open('sample.js')

  describe "defaultConfigs", ->
    it "set default opacity to 0.15", ->
      expect(atom.config.get('highlight-column.opacity')).toBe 0.15

  xdescribe "@activate", ->
    beforeEach ->
      @pane = atom.workspace.getActivePane()
      @editor = @pane.getActiveItem()

    it "appends self to each editorView's underlayer", ->
      view = atom.views.getView(@editor)
      console.log view
      expect($(".underlayer > .highlight-column", view).length).toBe 1

    it "create append to new pane when spliting", ->
      @pane.splitLeft(copyActiveItem: true)
      pane = atom.workspace.getActivePane()
      expect(pane).not.toEqual(@pane)
      editor = pane.getActiveItem()
      view = atom.views.getView(editor)
      expect($(".underlayer > .highlight-column", view).length).toBe 1

  xdescribe "@updateHighlight", ->
    it "positions the highlight at the configured column", ->
      spyOn(hlColumn, "highlightWidth").andReturn(16)
      spyOn(hlColumn, "cursorScreenLeft").andReturn(32)
      editorView.trigger("cursor:moved")
      expect(hlColumn.width()).toBe(16)
      expect(hlColumn.position().left).toBe(32)

    it "change opacity when the config changes", ->
      atom.config.set('highlight-column.opacity', 0.3)
      expect(hlColumn.css('opacity')).toBeCloseTo(0.3, 2)

  xdescribe "@opacity", ->
    beforeEach ->
      atom.config.set('highlight-column.opacity', 0.3)

    describe "when enable", ->
      it "returns config opacity", ->
        expect(hlColumn.opacity()).toBeCloseTo(0.3, 2)

    describe "when disable", ->
      it "returns 0", ->
        atom.config.set('highlight-column.opacity', 0.3)
        atom.config.set('highlight-column.enableHighlight', false)
        expect(hlColumn.opacity()).toBe(0)
