# vim-lilypond-suite

This is a new filetype plugin for Lilypond, with updated syntax and dictionary for auto-completion. This repository also contains an ftplugin for TeX files which allows embedded LilyPond syntax highlighting, and makeprg which support lilypond-book or lyluatex package out of the box.

* [Features](#Features)
* [Installation](#Installation)
* [Mappings](#Quick\ Start)
* [Settings](#Settings)
	* [Recommended highlightings](#Recommended\ highlightings)
	* [Recommended settings for Auto-completion](#Recommended\ settings\ for\ Auto-completion)
		* [coc.nvim](#COC.NVIM)
		* [nvim-cmp](#NVIM-CMP)
	* [Point & click configuration](#My\ Neovim\ settings\ for\ Point\ &\ Click)
	* [License](#License)

## Features

* **Updated syntax file** using the last [Pygments syntax highlighter for LilyPond](https://github.com/pygments/pygments/blob/master/pygments/lexers/_lilypond_builtins.py)
* **Simple ftplugin for LilyPond** with `makeprg`, correct `errorformat`
* **ftplugin fo TeX files** whith detect and allows embedded LilyPond syntax, and adaptive `makeprg` function for `lyluatex` or `lilypond-book`

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

* `F5` : save & make
* `F6` : view pdf (xdg-open)

## Settings

### Recommended highlightings

```vim
highlight Keyword cterm=bold ctermfg=yellow
highlight Tag ctermfg=blue
highlight Label ctermfg=lightyellow
highlight StorageClass cterm=bold ctermfg=lightgreen
highlight SpecialComment ctermfg=lightcyan
highlight PreCondit ctermfg=cyan
```

### Recommended settings for Auto-completion

##### COC.NVIM 

install [coc.nvim](https://github.com/neoclide/coc.nvim) and `coc-dictionary` & `coc-tabnine` : works out of the box

Settings exemples :

###### LUA

```lua
function escape_keycode(keycode)
	return vim.api.nvim_replace_termcodes(keycode, true, true, true)
end

local function check_back_space()
	local col = vim.fn.col(".") - 1
	return col <= 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

function tab_completion()
	if vim.fn.pumvisible() > 0 then
		return escape_keycode("<C-n>")
	end
	if check_back_space() then
		return escape_keycode("<TAB>")
	end
	return vim.fn["coc#refresh"]()
end

function shift_tab_completion()
	if vim.fn.pumvisible() > 0 then
		return escape_keycode("<C-p>")
	else
		return escape_keycode("<C-h>")
	end
end

map = vim.api.nvim_set_keymap

if vim.fn.exists("*complete_info") then
	map(
		"i", "<CR>", 
		"complete_info(['selected'])['selected'] != -1 ?" ..
		"'<C-y>' : '<C-G>u<CR>'", 
		{silent = true, expr = true, noremap = true}
	)
end

map("i", "<TAB>", "v:lua.tab_completion()", { expr = true })
map("i", "<S-TAB>", "v:lua.shift_tab_completion()", { expr = true })

vim.o.completeopt="menu,menuone,noselect"

vim.o.shortmess = vim.o.shortmess .. "c"
```

###### VIMSCRIPT

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
##### NVIM.CMP

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
			"$LILYDICTPATH/grobs",
			"$LILYDICTPATH/keywords",
			"$LILYDICTPATH/musicFunctions",
			"$LILYDICTPATH/articulations",
			"$LILYDICTPATH/grobProperties",
			"$LILYDICTPATH/paperVariables",
			"$LILYDICTPATH/headerVariables",
			"$LILYDICTPATH/contextProperties",
			"$LILYDICTPATH/clefs",
			"$LILYDICTPATH/repeatTypes",
			"$LILYDICTPATH/languageNames",
			"$LILYDICTPATH/accidentalsStyles",
			"$LILYDICTPATH/scales",
			"$LILYDICTPATH/musicCommands",
			"$LILYDICTPATH/markupCommands",
			"$LILYDICTPATH/contextsCmd",
			"$LILYDICTPATH/dynamics",
			"$LILYDICTPATH/contexts",
			"$LILYDICTPATH/translators",
		}
	},
})
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

### License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
