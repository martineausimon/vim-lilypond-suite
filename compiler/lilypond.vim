" LilyPond compiler file
" Language:     LilyPond
" Maintainer:   Heikki Junes <hjunes@cc.hut.fi>
" License:      This file is part of LilyPond, the GNU music typesetter.
"
"               Copyright (C) 2004, 2007 Heikki Junes <hjunes@cc.hut.fi>
"
"               LilyPond is free software: you can redistribute it and/or modify
"               it under the terms of the GNU General Public License as published by
"               the Free Software Foundation, either version 3 of the License, or
"               (at your option) any later version.
"
"               LilyPond is distributed in the hope that it will be useful,
"               but WITHOUT ANY WARRANTY; without even the implied warranty of
"               MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"               GNU General Public License for more details.
"
"               You should have received a copy of the GNU General Public License
"               along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.
"
" Last Change:  2007 Aug 19
"
" Installed As:	vim/compiler/lilypond.vim
"
" Only load this indent file when no other was loaded.

if exists("current_compiler")
  finish
endif
let current_compiler = "lilypond"

setlocal makeprg=lilypond\ %

setlocal efm=%+G%f:%l:%c:,\ %f:%l:%c:\ %m
setlocal efm+=%+G%.%#err%.%#
setlocal efm+=%+G%.%#succ%.%#
setlocal efm+=%-G%.%#
