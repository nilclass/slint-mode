[![MELPA](https://melpa.org/packages/slint-mode-badge.svg)](https://melpa.org/#/slint-mode)
![](https://github.com/nilclass/slint-mode/actions/workflows/melpazoid.yml/badge.svg)

# slint-mode

This package contains a very simple major-mode for the Slint UI language, to enable editing Slint files with emacs.

To learn more about slint, visit https://slint.dev/.

## Features

This mode is very limited at this point. Supported so far is:
- Syntax highlighting (aka font-lock)
- Indentation (configurable via `slint-indent-level` custom variable)
- Comment / uncomment region
- LSP integration using [lsp-mode](https://emacs-lsp.github.io/lsp-mode/) together with [slint-lsp](https://github.com/slint-ui/slint/blob/master/tools/lsp/README.md).

## Screenshot

This is how the "Hello World" example from Slint looks like:

![](./misc/Screenshot.png)

## Prerequisites

- Emacs: I've tested this with GNU Emacs 28.2. ymmv. Please file an issue if you run into any problems.
- [lsp-mode](https://emacs-lsp.github.io/lsp-mode/): Adds LSP support to Emacs. Can be installed via melpa.
- [slint-lsp](https://github.com/slint-ui/slint/blob/master/tools/lsp/README.md): The slint language server. Follow the link for installation instructions.
