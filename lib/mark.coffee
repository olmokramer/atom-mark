
{Subscriber} = require 'emissary'

module.exports=
class Mark
  Subscriber.includeInto(this)

  constructor: (editorView) ->
    {@editor, @gutter} = editorView

    @marker = undefined

    @subscribe editorView, 'editor:display-updated', => @updateGutter()
    @subscribe @editor, 'destroyed', => @unsubscribe()
    @subscribeToCommand editorView, 'mark:toggle', => @toggle()
    @subscribeToCommand editorView, 'mark:clear-mark', => @clearMark()
    @subscribeToCommand editorView, 'mark:select-to-mark', => @selectToMark()
    @subscribeToCommand editorView, 'mark:goto-mark', => @gotoMark()
    @subscribeToCommand editorView, 'mark:swap', => @swapWithMark()

  updateGutter: ->
    if @marker?
      @gutter.addClassToLine(@marker.getHeadBufferPosition().row, 'marked')

  createMark: (point) ->
    @marker = @editor.markBufferPosition(point)
    @gutter.addClassToLine(point.row, 'marked')

    @subscribe @marker, 'changed', ({ isValid }) =>
      if not isValid
        @unsubscribe(@marker)
        @marker.destroy()
        @marker = undefined

  clearMark: () ->
    if @marker
      @gutter.removeClassFromLine(@marker.getHeadBufferPosition().row, 'marked')
      @marker.destroy()
      @marker = undefined

  toggle: ->
    if not @gutter.isVisible
      return

    markPoint = @marker?.getHeadBufferPosition()
    cursorPoint = @editor.getCursorBufferPosition()

    if markPoint?
      @clearMark()

    if not markPoint or not cursorPoint.isEqual(markPoint)
      @createMark(cursorPoint)

  selectToMark: ->
    if @marker?
      markPoint   = @marker.getHeadBufferPosition()
      cursorPoint = @editor.getCursorBufferPosition()
      if not cursorPoint.isEqual(markPoint)
        @editor.setSelectedBufferRange([markPoint, cursorPoint])

  gotoMark: ->
    if @marker?
      @editor.setCursorBufferPosition(@marker.getHeadBufferPosition())

  swapWithMark: ->
    if @marker?
      cursorPoint = @editor.getCursorBufferPosition()
      markPoint   = @marker.getHeadBufferPosition()
      if not cursorPoint.isEqual(markPoint)
        @gutter.removeClassFromLine(markPoint.row, 'marked')
        @marker.setHeadBufferPosition(cursorPoint)
        @editor.setCursorBufferPosition(markPoint)
