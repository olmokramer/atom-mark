
{Subscriber} = require 'emissary'

module.exports=
class Mark
  Subscriber.includeInto(this)

  constructor: (editorView) ->
    {@editor, @gutter} = editorView

    @decoration = undefined

    @subscribe @editor, 'destroyed', => @unsubscribe()
    @subscribeToCommand editorView, 'mark:toggle', => @toggle()
    @subscribeToCommand editorView, 'mark:clear-mark', => @clearMark()
    @subscribeToCommand editorView, 'mark:select-to-mark', => @selectToMark()
    @subscribeToCommand editorView, 'mark:goto-mark', => @gotoMark()
    @subscribeToCommand editorView, 'mark:swap', => @swapWithMark()

  createMark: (point) ->
    marker = @editor.markBufferPosition(point)
    @decoration = @editor.decorateMarker(marker, { type: 'gutter', class: 'marked' })

    @subscribe marker, 'changed', ({ isValid }) =>
      if not isValid
        @unsubscribe(@decoration.getMarker())
        @decoration.getMarker().destroy()
        @decoration = undefined

  clearMark: () ->
    if @decoration
      @decoration.getMarker().destroy()
      @decoration = undefined

  toggle: ->
    if not @gutter.isVisible
      return

    markPoint   = @decoration?.getMarker().getHeadBufferPosition()
    cursorPoint = @editor.getCursorBufferPosition()

    if markPoint?
      @clearMark()

    if not markPoint or not cursorPoint.isEqual(markPoint)
      @createMark(cursorPoint)

  selectToMark: ->
    if @decoration
      markPoint   = @decoration?.getMarker().getHeadBufferPosition()
      cursorPoint = @editor.getCursorBufferPosition()
      if not cursorPoint.isEqual(markPoint)
        @editor.setSelectedBufferRange([markPoint, cursorPoint])

  gotoMark: ->
    if @decoration
      @editor.setCursorBufferPosition(@decoration.getMarker().getHeadBufferPosition())

  swapWithMark: ->
    if @decoration
      cursorPoint = @editor.getCursorBufferPosition()
      markPoint   = @decoration.getMarker().getHeadBufferPosition()
      if not cursorPoint.isEqual(markPoint)
        @decoration.getMarker().setHeadBufferPosition(cursorPoint)
        @editor.setCursorBufferPosition(markPoint)
