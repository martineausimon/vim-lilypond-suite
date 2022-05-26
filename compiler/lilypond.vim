" ===================================================================
" LilyPond compiler file
" Language:     LilyPond
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists("current_compiler")
	finish
endif

let current_compiler = "lilypond"

setlocal makeprg=lilypond\ %

setlocal efm=%+G%f:%l:%c:,\ %f:%l:%c:\ %m
setlocal efm+=%+G%.%#err%.%#
setlocal efm+=%+G%.%#succ%.%#
setlocal efm+=%-G%.%#
