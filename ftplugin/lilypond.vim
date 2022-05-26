" LilyPond filetype plugin
" Language:     LilyPond (ft=ly)
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Last Change:  2022 Avr 25
" Installed As:         vim/ftplugin/lilypond.vim
" Uses Generated File:  vim/syntax/lilypond-words.vim

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

setlocal autoindent
setlocal shiftwidth=2

compiler lilypond

" <F4>  save & make and play midi with xdg-open
noremap <buffer> <F4> :w<Return> :make<Return>:!xdg-open "%<.midi"<Return><cr>

" <F5>  save & make
noremap <buffer> <F5> :w<cr>:silent:make!<cr>:$cc<cr>

" <F6>  view pdf with xdg-open
noremap <buffer> <F6> :!xdg-open "%<.pdf" 2>/dev/null &<Return><Return>

" <F7>  prev error
noremap <buffer> <F7> :cp<Return>

" <F8>  next error
noremap <buffer> <F8> :cn<Return>

" <F10> menu
source $VIMRUNTIME/menu.vim
setlocal wildmenu
setlocal cpo-=<
setlocal wcm=<C-Z>
noremap <buffer> <F10> :emenu <C-Z>

" List of words for completion
setlocal dictionary+=$VIMRUNTIME/lilywords/grobs
setlocal dictionary+=$VIMRUNTIME/lilywords/keywords
setlocal dictionary+=$VIMRUNTIME/lilywords/musicFunctions
setlocal dictionary+=$VIMRUNTIME/lilywords/articulations
setlocal dictionary+=$VIMRUNTIME/lilywords/grobProperties
setlocal dictionary+=$VIMRUNTIME/lilywords/paperVariables
setlocal dictionary+=$VIMRUNTIME/lilywords/headerVariables
setlocal dictionary+=$VIMRUNTIME/lilywords/contextProperties
setlocal dictionary+=$VIMRUNTIME/lilywords/clefs
setlocal dictionary+=$VIMRUNTIME/lilywords/repeatTypes
setlocal dictionary+=$VIMRUNTIME/lilywords/languageNames
setlocal dictionary+=$VIMRUNTIME/lilywords/accidentalsStyles
setlocal dictionary+=$VIMRUNTIME/lilywords/scales
setlocal dictionary+=$VIMRUNTIME/lilywords/musicCommands
setlocal dictionary+=$VIMRUNTIME/lilywords/markupCommands
setlocal dictionary+=$VIMRUNTIME/lilywords/contextsCmd
setlocal dictionary+=$VIMRUNTIME/lilywords/dynamics
setlocal dictionary+=$VIMRUNTIME/lilywords/contexts
setlocal dictionary+=$VIMRUNTIME/lilywords/translators

setlocal complete-="k,t" complete+=k

setlocal iskeyword+=\
setlocal iskeyword+=-

setlocal shortmess+=c
setlocal showmatch
