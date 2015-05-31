'use strict'
{CompositeDisposable} = require 'atom'

module.exports =
class Mark
  constructor: (@editor) ->
    @disposed = false
    @disposables = new CompositeDisposable()

    editorView = atom.views.getView @editor
    @disposables.add atom.commands.add editorView,
      'mark:toggle': => @toggle()
      'mark:clear-mark': => @clearMark()
      'mark:select-to-mark': => @selectToMark()
      'mark:go-to-mark': => @goToMark()
      'mark:goto-mark': => @goToMark()
      'mark:swap': => @swapWithMark()

    @disposables.add @editor.onDidDestroy =>
      @dispose()

  dispose: ->
    return if @disposed
    @disposed = true
    @disposables.dispose()
    @clearMark()
    [@editor, @marker, @disposables] = []

  createMark: (point) ->
    @clearMark()

    @marker = @editor.markBufferPosition point
    @editor.decorateMarker @marker,
      type: 'line-number'
      class: 'marked'

    @marker.onDidChange ({isValid}) =>
      @clearMark() unless isValid

  clearMark: ->
    @marker?.destroy()
    @marker = null

  toggle: ->
    return unless @editor.gutterWithName('line-number').visible
    if @marker
      @clearMark()
    else
      @createMark @getCursorPoint()

  selectToMark: ->
    markPoint = @getMarkPoint()
    cursorPoint = @getCursorPoint()
    return if not markPoint or cursorPoint.isEqual markPoint
    @editor.setSelectedBufferRange [markPoint, cursorPoint]

  goToMark: ->
    markPoint = @getMarkPoint()
    return unless markPoint?
    @editor.setCursorBufferPosition markPoint

  swapWithMark: ->
    markPoint = @getMarkPoint()
    cursorPoint = @getCursorPoint()
    return if not markPoint or cursorPoint.isEqual markPoint
    @marker.setHeadBufferPosition cursorPoint
    @editor.setCursorBufferPosition markPoint

  getMarkPoint: ->
    @marker?.getHeadBufferPosition()

  getCursorPoint: ->
    @editor.getCursorBufferPosition()
