'use babel';
import {CompositeDisposable} from 'atom';

export default class Mark {
  constructor(textEditor) {
    this.editor = textEditor;
    this.disposables = new CompositeDisposable(
      atom.commands.add(atom.views.getView(textEditor), {
        'mark:toggle': () => this.toggle(),
        'mark:clear-mark': () => this.clearMark(),
        'mark:select-to-mark': () => this.selectToMark(),
        'mark:go-to-mark': () => this.goToMark(),
        'mark:goto-mark': () => this.goToMark(),
        'mark:swap': () => this.swapWithMark(),
      }),
    );
  }

  dispose() {
    if(this.disposables.disposed) return;
    this.disposables.dispose();
    this.clearMark();
    [this.editor, this.marker, this.disposables] = [];
  }

  createMark(point) {
    this.clearMark();

    this.marker = this.editor.markBufferPosition(point);
    this.editor.decorateMarker(this.marker, {
      type: 'line-number',
      class: 'marked',
    });

    this.marker.onDidChange(({isValid}) =>
      !isValid && this.clearMark()
    );
  }

  clearMark() {
    if(!this.marker) return;
    this.marker.destroy();
    this.marker = null;
  }

  toggle() {
    if(!this.editor.gutterWithName('line-number').visible) return;
    if(this.marker) {
      this.clearMark();
    } else {
      this.createMark(this.getCursorPoint());
    }
  }

  selectToMark() {
    var markPoint = this.getMarkPoint();
    var cursorPoint = this.getCursorPoint();
    if(!markPoint || cursorPoint.isEqual(markPoint)) return;
    this.editor.setSelectedBufferRange([markPoint, cursorPoint]);
  }

  goToMark() {
    var markPoint = this.getMarkPoint();
    if(!markPoint) return;
    this.editor.setCursorBufferPosition(markPoint);
  }

  swapWithMark() {
    var markPoint = this.getMarkPoint();
    var cursorPoint = this.getCursorPoint();
    if(!markPoint || cursorPoint.isEqual(markPoint)) return;
    this.marker.setHeadBufferPosition(cursorPoint);
    this.editor.setCursorBufferPosition(markPoint);
  }

  getMarkPoint() {
    if(!this.marker) return;
    return this.marker.getHeadBufferPosition();
  }

  getCursorPoint() {
    return this.editor.getCursorBufferPosition();
  }
}
