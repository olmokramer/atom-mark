# mark package

Provides a single "mark" per editor with the ability select the text from the
mark to the cursor and to go to the mark, similar to marks in other editors.

To toggle the mark at the current position (not just line, but column), use Mark:Toggle.  The
mark appears as a push-pin in the gutter.

![](http://mkleehammer.github.com/atom-mark/images/mark.png)

To select all text between the cursor and the mark, use Mark:Select To Mark.

![](http://mkleehammer.github.com/atom-mark/images/select.png)

The mark can be cleared by toggling the mark at the same position, but Mark:Clear Mark
can be used to clear it from anywhere.

Finally, you can jump to the mark using Mark:Goto Mark.

Keybindings for all commands:

* `cmd-k cmd-k` : mark:toggle
* `cmd-k cmd-a` : mark:select-to-mark
* `cmd-k cmd-g` : mark:clear-mark
* `cmd-k space` : mark:goto-mark
