# Neovim

## Keymaps

### Base

Based on [LazyVim keymaps](https://www.lazyvim.org/keymaps), with some additional key bindings added.

| Mode  | Key                                         | Description                                                             |
| ----- | ------------------------------------------- | ----------------------------------------------------------------------- |
| n,v   | <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Move to (the end of the previous / the beginning of the next) paragraph |
| n,v,i | <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Backward word / Forward word                                            |
| i     | <kbd>Ctrl</kbd>+<kbd>/</kbd>                | Undo                                                                    |
| i     | <kbd>Ctrl</kbd>+<kbd>r</kbd>                | Redo                                                                    |
| i     | <kbd>jj</kbd>                               | Esc                                                                     |

### Emacs-like

Emacs-like shortcuts are configured in insert mode.

- <kbd>Ctrl</kbd>+<kbd>[abdefhnpuwy]</kbd>

| Mode  | Key                 | Description                                                             |
| ----- | ------------------- | ----------------------------------------------------------------------- |
| i     | <kbd>Ctrl</kbd>+<kbd>a</kbd>   | Move the cursor to the beginning of the line.                           |
| i     | <kbd>Ctrl</kbd>+<kbd>e</kbd>   | Move the cursor to the end of the line.                                 |
| i     | <kbd>Ctrl</kbd>+<kbd>d</kbd>   | Delete the character under the cursor.                                  |
| i     | <kbd>Ctrl</kbd>+<kbd>h</kbd>   | Delete the character before the cursor (backspace).                     |
| i     | <kbd>Ctrl</kbd>+<kbd>b</kbd>   | Move the cursor one character backward.                                 |
| i     | <kbd>Ctrl</kbd>+<kbd>f</kbd>   | Move the cursor one character forward.                                  |
| i     | <kbd>Ctrl</kbd>+<kbd>p</kbd>   | Move the cursor to the previous line.                                   |
| i     | <kbd>Ctrl</kbd>+<kbd>n</kbd>   | Move the cursor to the next line.                                       |
| i     | <kbd>Ctrl</kbd>+<kbd>u</kbd>   | Delete all characters before the cursor on the current line.            |
| i     | <kbd>Ctrl</kbd>+<kbd>w</kbd>   | Delete the word before the cursor.                                      |
| i     | <kbd>Ctrl</kbd>+<kbd>y</kbd>   | Paste (yank) the most recently deleted text at the cursor position.     |

- <kbd>Alt</kbd>+<kbd>[bdf]</kbd>

| Mode | Key               | Description   |
| ---- | ----------------- | ------------- |
| i    | <kbd>Alt</kbd>+<kbd>d</kbd>  | Delete word   |
| i    | <kbd>Alt</kbd>+<kbd>b</kbd>  | Backward word |
| i    | <kbd>Alt</kbd>+<kbd>f</kbd>  | Forward word  |
