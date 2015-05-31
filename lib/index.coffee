'use strict'
{CompositeDisposable} = require 'atom'
Mark = require './mark'

module.exports =
  activate: ->
    @disposables = new CompositeDisposable()
    @disposables.add atom.workspace.observeTextEditors (editor) =>
      @disposables.add new Mark(editor)

  deactivate: ->
    @disposables.dispose()
