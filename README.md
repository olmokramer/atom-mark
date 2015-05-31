# mark package

**Original package by [@mkleehammer](https://github.com/mkleehammer)**

Provides a single "mark" per editor with the ability select the text from the
mark to the cursor and to go to the mark, similar to marks in other editors.

To toggle the mark at the current position (not just line, but column), use Mark:Toggle.  The
mark appears as a push-pin in the gutter.

![](http://olmokramer.github.io/atom-mark/images/mark.png)

To select all text between the cursor and the mark, use Mark:Select To Mark.

![](http://olmokramer.github.io/atom-mark/images/select.png)

The mark can be cleared by toggling the mark at the same position, but Mark:Clear Mark
can be used to clear it from anywhere.

Finally, you can jump to the mark using Mark:Goto Mark.

Keybindings for all commands:

Mac OS X:

* <kbd>cmd-k cmd-k</kbd> : mark:toggle
* <kbd>cmd-k cmd-a</kbd> : mark:select-to-mark
* <kbd>cmd-k cmd-g</kbd> : mark:clear-mark
* <kbd>cmd-k space</kbd> : mark:goto-mark

Linux/Windows

* <kbd>ctrl-k ctrl-k</kbd> : mark:toggle
* <kbd>ctrl-k ctrl-a</kbd> : mark:select-to-mark
* <kbd>ctrl-k ctrl-g</kbd> : mark:clear-mark
* <kbd>ctrl-k space</kbd>  : mark:goto-mark
