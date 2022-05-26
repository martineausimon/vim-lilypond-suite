# vim-lilypond-suite

This is a new filetype plugin for Lilypond, with updated syntax and auto-completion module.

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

## Quick Start

* `F4` : save & make and play midi (xdg-open)
* `F5` : save & make
* `F6` : view pdf (xdg-open)
* `F7` : prev error
* `F8` : next error
* `F10` : menu

## Recommended Colors

```vim
highlight Keyword cterm=bold ctermfg=yellow
highlight Tag ctermfg=blue
highlight Label ctermfg=lightyellow
highlight StorageClass cterm=bold ctermfg=lightgreen
highlight SpecialComment ctermfg=lightcyan
highlight PreCondit ctermfg=cyan
```

## Recommended settings for Auto-completion

### DICTIONARY COMPLETION

This option is faster, and allows to identify the character `\`.

Create a symlink of the `lilywords/` folder to your `$VIMRUNTIME` (type `:echo $VIMRUNTIME` to find it) and choose one of the following options

#### RECOMMENDED

install [coc.nvim](https://github.com/neoclide/coc.nvim) and `coc-dictionary` & `coc-tabnine` : works out of the box

#### VIMSCRIPT ONLY

Add the following lines to your `ftplugin/lilypond.vim` :

```vim
function! OpenCompletion()
	if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
		call feedkeys("\<C-n>", "n")
	endif
endfunction

autocmd InsertCharPre * call OpenCompletion()

set completeopt=menu,menuone,noselect

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
```

#### LUA

Install [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and [uga-rosa/cmp-dictionary](https://github.com/uga-rosa/cmp-dictionary)

Add this lines to your `nvim/init.lua` :

```lua
local cmp = require('cmp')

require("cmp").setup({
	mapping = {
		['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
	},
})
```

Add this lines to your `ftplugin/lilypond.lua` :

```lua
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append([[\]])

require('cmp').setup.buffer {
	formatting = {
		format = function(entry, item)
			item.kind = ({
				Text = "",
				})[item.kind]
			item.menu = ({
				buffer = "ﰮ ",
				dictionary = " ",
				path = " ",
				})[entry.source.name]
			return item
		end,
	},
	sources = {
		{ 
			name = 'buffer',
			keyword_length = 2,
		},
		{ name = 'path' },
		{ 
			name = 'dictionary',
			keyword_length = 2,
		},
	},
}

require("cmp_dictionary").setup({
	dic = {
		["lilypond"] = {
			"$VIMRUNTIME/lilywords/grobs",
			"$VIMRUNTIME/lilywords/keywords",
			"$VIMRUNTIME/lilywords/musicFunctions",
			"$VIMRUNTIME/lilywords/articulations",
			"$VIMRUNTIME/lilywords/grobProperties",
			"$VIMRUNTIME/lilywords/paperVariables",
			"$VIMRUNTIME/lilywords/headerVariables",
			"$VIMRUNTIME/lilywords/contextProperties",
			"$VIMRUNTIME/lilywords/clefs",
			"$VIMRUNTIME/lilywords/repeatTypes",
			"$VIMRUNTIME/lilywords/languageNames",
			"$VIMRUNTIME/lilywords/accidentalsStyles",
			"$VIMRUNTIME/lilywords/scales",
			"$VIMRUNTIME/lilywords/musicCommands",
			"$VIMRUNTIME/lilywords/markupCommands",
			"$VIMRUNTIME/lilywords/contextsCmd",
			"$VIMRUNTIME/lilywords/dynamics",
			"$VIMRUNTIME/lilywords/contexts",
			"$VIMRUNTIME/lilywords/translators",
		}
	},
})
```

### OMNI-COMPLETION

#### Warning : this option can be slow with long files.

Add the following line to your `.vimrc` (for [vim-plug](https://github.com/junegunn/vim-plug) users) :

```vim
Plug 'BrandonRoehl/auto-omni'
```

Add the following lines to your `ftplugin/lilypond.vim` :

```vim
let g:omni_syntax_group_include_lilypond = 'lilyGrobs,lilyKeywords,lilyMusicCommands,lilyMusicFunctions,lilyMarkupCommands,lilyArticulations,lilyGrobProperties,lilyHeaderVariables,lilyPaperVariables,lilyContextProperties,lilyDynamics,lilyScales,lilyContexts,lilyTranslators,lilyClefs,lilyRepeatTypes,lilyAccidentalsStyles'

setlocal omnifunc=syntaxcomplete#Complete

set completeopt=menu,menuone,noselect

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
```

## My Neovim settings for Point & Click

Recommended pdf viewer : [zathura](https://pwmt.org/projects/zathura/) with [zathura-pdf-mupdf plugin](https://pwmt.org/projects/zathura-pdf-mupdf/)

Add this line to `~/.config/zathura/zathurarc` :

	set synctex-editor-command "lilypond-invoke-editor %s"

Install [neovim-remote](https://github.com/mhinz/neovim-remote) and add this line to `~/.profile` :

```bash
export LYEDITOR="nvr +:'call cursor(%(line)s,%(char)s)' %(file)s"
```

Follow the instructions on the [LilyPond website](https://lilypond.org/doc/v2.23/Documentation/usage/configuring-the-system-for-point-and-click#) to configure the system and create `lilypond-invoke-editor.desktop`

Reboot or reload with `. ~/.profile`

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
