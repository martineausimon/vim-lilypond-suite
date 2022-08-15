# vim-lilypond-suite

This is a filetype plugin for **LilyPond**, with updated syntax and dictionary for auto-completion. This repository also contains an ftplugin for **TeX** files which allows embedded LilyPond syntax highlighting, and makeprg which support `lilypond-book` or `lyluatex` package out of the box.

**EDIT** : If you use Neovim, you should have a look to [nvim-lilypond-suite](https://github.com/martineausimon/nvim-lilypond-suite)

* [Features](#Features)
* [Installation](#Installation)
* [Mappings](#Mappings)
* [Settings](#Settings)
	* Lighter syntax highlighting
	* QuickFix mode
	* Recommended highlightings
	* Recommended settings for Auto-completion
	* Point & click configuration
* [LaTex](#LaTex)
	* Clean log files on exit
	* Overfull messages in QuickFix
	* Tricks for lilypond-book
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

### Lighter syntax highlighting

Since the last big update [c5ee51b](https://github.com/martineausimon/vim-lilypond-suite/commit/c5ee51b1a03423d42e0feebad31d65623a92f1fa), I changed my method for syntax highlighting and avoided word lists as much as possible, for more lightness. For now only the default language works for note pitches.

>TODO : create pitches pattern for other languages

### QuickFix mode

By default this plugin uses `:cw` after compile. To display only a result message in vim's message line after make, add this line to your `.vimrc` :

```vim
let g:vls_qf_mode='1'
```

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
highlight SpecialComment 
	\ ctermfg=lightcyan 
	\ guifg=lightcyan
highlight SpecialChar
	\ cterm=bold ctermfg=lightmagenta
	\ gui=bold guifg=lightcyan
highlight PreCondit 
	\ ctermfg=cyan 
	\ guifg=cyan

```

### Recommended settings for Auto-completion

install [coc.nvim](https://github.com/neoclide/coc.nvim) and `coc-dictionary` & `coc-tabnine` : works out of the box !

#### My settings for coc.nvim

```vim
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ <SID>check_back_space() ? "\<Tab>" :
	\ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() : "\<C-g>u\<CR>"
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
let g:vls_clean_tex_files='1'
```

### Display Overfull messages in QuickFix

Add this line to your `.vimrc` :

```vim
let g:vls_tex_qf_overfull='1'
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
