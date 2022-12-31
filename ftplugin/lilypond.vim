" ===================================================================
" LilyPond filetype plugin
" Language:     LilyPond
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists("b:did_ftplugin")
	finish
endif

if exists('g:vls_qf_mode')
else
	let g:vls_qf_mode = 0
endif

let b:did_ftplugin = 1

setlocal autoindent
setlocal shiftwidth=2
setlocal tabstop=2
setlocal complete-="k,t" complete+=k
setlocal iskeyword+=\
setlocal iskeyword+=-
setlocal shortmess+=c

hi QuickFixLine
	\ ctermfg=NONE cterm=bold 
	\ guifg=NONE gui=bold

compiler lilypond

if g:vls_qf_mode == "1"
	command! QFInfo $cc | redraw
	nnoremap <buffer> <F5> ma:MakeLilyPond<cr>:QFInfo<cr>`a
	inoremap <buffer> <F5> <esc>ma:MakeLilyPond<cr>:QFInfo<cr>`aa
else 
	command! QFInfo cw
	nnoremap <buffer> <F5> ma:MakeLilyPond<cr>:silent:QFInfo<cr><cr><C-l>`a
	inoremap <buffer> <F5> <esc>ma:MakeLilyPond<cr>:silent:QFInfo<cr><cr><C-l>`aa
endif

command! MakeLilyPond  silent:w | silent:make! | redraw!

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let $LILYDICTPATH = s:path . '/../lilywords'

setlocal dictionary+=$LILYDICTPATH/grobs
setlocal dictionary+=$LILYDICTPATH/keywords
setlocal dictionary+=$LILYDICTPATH/musicFunctions
setlocal dictionary+=$LILYDICTPATH/articulations
setlocal dictionary+=$LILYDICTPATH/grobProperties
setlocal dictionary+=$LILYDICTPATH/paperVariables
setlocal dictionary+=$LILYDICTPATH/headerVariables
setlocal dictionary+=$LILYDICTPATH/contextProperties
setlocal dictionary+=$LILYDICTPATH/clefs
setlocal dictionary+=$LILYDICTPATH/repeatTypes
setlocal dictionary+=$LILYDICTPATH/languageNames
setlocal dictionary+=$LILYDICTPATH/accidentalsStyles
setlocal dictionary+=$LILYDICTPATH/scales
setlocal dictionary+=$LILYDICTPATH/musicCommands
setlocal dictionary+=$LILYDICTPATH/markupCommands
setlocal dictionary+=$LILYDICTPATH/contextsCmd
setlocal dictionary+=$LILYDICTPATH/dynamics
setlocal dictionary+=$LILYDICTPATH/contexts
setlocal dictionary+=$LILYDICTPATH/translators

nnoremap <buffer> <F4> ma0O\version<space>
	\<Esc>:read<Space>!lilypond<Space>-v
  \<Bar>grep<Space>LilyPond<Bar>awk<Space>{'print<space>$3'}<cr>
	\kJi"<esc>6la"<esc>`a:echo ''<cr>

inoremap <buffer> <F4> <esc>ma0O\version<space>
	\<Esc>:read<Space>!lilypond<Space>-v
	\<Bar>grep<Space>LilyPond<Bar>cut<Space>-c<Space>14-19<cr>
	\kJi"<esc>6la"<esc>`a:echo ''<cr>a


nnoremap <buffer> <F6> :silent:!xdg-open "%<.pdf" 2>/dev/null &<cr>
inoremap <buffer> <F6> <esc>:silent:!xdg-open "%<.pdf" 2>/dev/null &<cr>a
