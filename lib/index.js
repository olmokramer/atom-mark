'use babel';
import {CompositeDisposable} from 'atom';
import Mark from './mark.js';

module.exports = {
  activate() {
    this.disposables = new CompositeDisposable();
    this.disposables.add(
      atom.workspace.observeTextEditors(textEditor => {
        var textEditorDisposable = new CompositeDisposable(
          new Mark(textEditor),

          textEditor.onDidDestroy(() => {
            textEditorDisposable.dispose();
            this.disposables.remove(textEditorDisposable);
          }),
        );

        this.disposables.add(textEditorDisposable);
      }),
    );
  },

  deactivate() {
    this.disposables.dispose();
    this.disposables = null;
  },
};
