# vim-lilypond-suite

This is a new filetype plugin for **LilyPond**, with updated syntax and dictionary for auto-completion. This repository also contains an ftplugin for **TeX** files which allows embedded LilyPond syntax highlighting, and makeprg which support `lilypond-book` or `lyluatex` package out of the box.

* [Features](#Features)
* [Installation](#Installation)
* [Mappings](#Mappings)
* [Settings](#Settings)
	* Recommended highlightings
	* Recommended settings for Auto-completion
	* Point & click configuration
* [LaTex](#LaTex)
* [License](#License)

## Features

* **Updated syntax file** using the last [Pygments syntax highlighter for LilyPond](https://github.com/pygments/pygments/blob/master/pygments/lexers/_lilypond_builtins.py)
* **Simple ftplugin for LilyPond** with `makeprg`, correct `errorformat`
* **ftplugin fo TeX files** whith detect and allows embedded LilyPond syntax, adaptive `makeprg` function for `lyluatex` or `lilypond-book`, correct `errorformat`

<p align="center">
<img src="https://github.com/martineausimon/vim-lilypond-suite/blob/main/screenshoot.png">
</p>

## Installation

If you use [vim-plug](https://github.com/junegunn/vim-plug), then add the following line to your `.vimrc` file:

```vim
Plug 'martineausimon/vim-lilypond-suite'
```

Or use some other plugin manager:

* [vundle](https://github.com/gmarik/vundle)
* [neobundle](https://github.com/Shougo/neobundle.vim)
* [pathogen](https://github.com/tpope/vim-pathogen)
* [packer](https://github.com/wbthomason/packer.nvim)

## Mappings

* `F3` : toggle LilyPond syntax (LaTeX only)
* `F4` : insert current version (LilyPond only)
* `F5` : save & make
* `F6` : view pdf (xdg-open)

## Settings

### Recommended highlightings

```vim
highlight Keyword 
	\ cterm=bold ctermfg=yellow 
	\ gui=bold guifg=yellow
highlight Tag 
	\ ctermfg=blue 
	\ guifg=blue
highlight Label 
	\ ctermfg=lightyellow 
	\ guifg=lightyellow
highlight StorageClass 
	\ cterm=bold ctermfg=lightgreen 
	\ gui=bold guifg=lightgreen
highlight SpecialComment 
	\ ctermfg=lightcyan 
	\ guifg=lightcyan
highlight PreCondit 
	\ ctermfg=cyan 
	\ guifg=cyan

```

### Recommended settings for Auto-completion

install [coc.nvim](https://github.com/neoclide/coc.nvim) and `coc-dictionary` & `coc-tabnine` : works out of the box !

#### My settings for coc.nvim

```vim
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ CheckBackspace() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
```

If you want to use another completion plugin like [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with [uga-rosa/cmp-dictionary](https://github.com/uga-rosa/cmp-dictionary), vim-lilypond-suite uses the following dictionary files :

```bash
$LILYDICTPATH/grobs
$LILYDICTPATH/keywords
$LILYDICTPATH/musicFunctions
$LILYDICTPATH/articulations
$LILYDICTPATH/grobProperties
$LILYDICTPATH/paperVariables
$LILYDICTPATH/headerVariables
$LILYDICTPATH/contextProperties
$LILYDICTPATH/clefs
$LILYDICTPATH/repeatTypes
$LILYDICTPATH/languageNames
$LILYDICTPATH/accidentalsStyles
$LILYDICTPATH/scales
$LILYDICTPATH/musicCommands
$LILYDICTPATH/markupCommands
$LILYDICTPATH/contextsCmd
$LILYDICTPATH/dynamics
$LILYDICTPATH/contexts
$LILYDICTPATH/translators
```

### My Neovim settings for Point & Click

Recommended pdf viewer : [zathura](https://pwmt.org/projects/zathura/) with [zathura-pdf-mupdf plugin](https://pwmt.org/projects/zathura-pdf-mupdf/)

Add this line to `~/.config/zathura/zathurarc` :

	set synctex-editor-command "lilypond-invoke-editor %s"

Install [neovim-remote](https://github.com/mhinz/neovim-remote) and add this line to `~/.profile` :

```bash
export LYEDITOR="nvr +:'call cursor(%(line)s,%(char)s)' %(file)s"
```

Follow the instructions on the [LilyPond website](https://lilypond.org/doc/v2.23/Documentation/usage/configuring-the-system-for-point-and-click#) to configure the system and create `lilypond-invoke-editor.desktop`

Reboot or reload with `. ~/.profile`

## LaTex

This plugin works with `lilypond-book` by default if the `.tex` file contains `\begin{lilypond}`. To use `lyluatex`, just add `\usepackage{lyluatex}` to your preamble. 

Syntax highlighting can be slow with embedded LilyPond, you can use `<F3>` to activate or deactivate it.

### Clean log files on exit

Add this line to your `.vimrc` to remove log files on exit :

```vim
let b:CleanTexFiles='1'
```

### Display Overfull messages in QuickFix

Add this line to your `.vimrc` :

```vim
let b:TexQfOverfull='1'
```

### Tricks for lilypond-book

Add this lines to your preamble to avoid the padding on the left side and keep the score justified :

```tex
\def\preLilyPondExample{\hspace*{-3mm}}
\newcommand{\betweenLilyPondSystem}[1]{\linebreak\hspace*{-3mm}}
```

Adjust space between systems using this line (in `\renewcommand` or `\newcommand`) :

```tex
{\betweenLilyPondSystem}[1]{\vspace{5mm}\linebreak\hspace*{-3mm}}
```


## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
