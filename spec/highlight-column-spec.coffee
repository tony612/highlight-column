describe "HighlightColumn", ->
  [editor, editorElement, highlight, workspaceElement] = []

  getLeftPosition = (element) ->
    parseInt(element.style.left)

  getWidth = (element) ->
    parseInt(element.style.width)

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    workspaceElement.style.height = "400px"
    workspaceElement.style.width = "600px"

    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage('highlight-column')

    waitsForPromise ->
      atom.workspace.open('sample.js')

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)
      highlight = editorElement.rootElement.querySelector(".highlight-column")

  describe ".activate", ->
    getHighlights  = ->
      highlights = []
      atom.workspace.getTextEditors().forEach (editor) ->
        highlight = atom.views.getView(editor).rootElement.querySelectorAll(".highlight-column")
        Array::push.apply highlights, highlight if highlight
      highlights

    it "appends a highlight to all existing and new editors", ->
      expect(atom.workspace.getPanes().length).toBe 1
      expect(getHighlights().length).toBe 1
      expect(getWidth(getHighlights()[0])).toBeGreaterThan(0)

      atom.workspace.getActivePane().splitRight(copyActiveItem: true)
      expect(atom.workspace.getPanes().length).toBe 2
      expect(getHighlights().length).toBe 2
      expect(getWidth(getHighlights()[0])).toBeGreaterThan(0)
      expect(getWidth(getHighlights()[1])).toBeGreaterThan(0)

    it "width of the highlight is right", ->
      width = editor.getDefaultCharWidth()
      expect(width).toBeGreaterThan(0)
      expect(getWidth(highlight)).toBe(width)
      expect(highlight).toBeVisible()

    it "appends highlights to where cursors are", ->
      editor.setText("abc")
      expect(editor.getCursors().length).toBe 1
      expect(getHighlights().length).toBe 1

      editor.addCursorAtScreenPosition([0, 1])
      expect(editor.getCursors().length).toBe 2
      expect(getHighlights().length).toBe 2
      expect(getLeftPosition(getHighlights()[0])).toBeGreaterThan(0)
      expect(getLeftPosition(getHighlights()[1])).toBeGreaterThan(0)

  describe "cursor moves", ->
    it "highlight moves", ->
      editor.setText("abc")

      editor.moveToBeginningOfLine()
      expect(getLeftPosition(highlight)).toEqual(0)

      editor.moveRight()
      expect(getLeftPosition(highlight)).toBeGreaterThan(0)

  describe "fontsize changes", ->
    it "highlight width changes", ->
      initial = getWidth(highlight)
      expect(initial).toBeGreaterThan(0)
      fontSize = atom.config.get("editor.fontSize")
      atom.config.set("editor.fontSize", fontSize + 10)

      advanceClock(1)
      expect(getWidth(highlight)).toBeGreaterThan(initial)
      expect(highlight).toBeVisible()
