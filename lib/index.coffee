
Mark = require './mark'

module.exports =
  activate: ->
    atom.workspaceView.eachEditorView (editor) ->
      if editor.attached and editor.getPane()?
        new Mark(editor)
