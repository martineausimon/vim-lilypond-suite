" ===================================================================
" TeX filetype plugin with embedded LilyPond
" Language:     TeX
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists('b:current_syntax')
	finish 
endif

function! g:ToggleLyTeXSyntax()
	if exists('b:lytexSyn')
		unlet b:lytexSyn
		set syntax=tex
	else
		call DetectLilypondSyntax()
	endif
endfunction

function! g:DetectLilypondSyntax()
	if exists("b:current_syntax")
		unlet b:current_syntax
	endif
	syntax include @TEX syntax/tex.vim
	if search("begin{lilypond}", "n")
		syntax include @lilypond syntax/lilypond.vim
		unlet b:current_syntax
		syntax region LyTeX 
			\ matchgroup=Snip 
			\ start="\\begin{lilypond}" 
			\ end="\\end{lilypond}" 
			\ containedin=@TEX contains=@lilypond
		let b:lytexSyn = 1
	endif
	if search("\\lilypond", "n")
		syntax include @lilypond syntax/lilypond.vim
		unlet b:current_syntax
		syn region LyTeX 
			\ matchgroup=Snip
			\ start="\\lilypond{" 
			\ end="}" 
			\ containedin=@TEX contains=@lilypond
		let b:lytexSyn = 1
	endif
	highlight Snip ctermfg=white cterm=bold guifg=white gui=bold
endfunction

command! CleanTmpFolder silent execute ":!rm -rf tmpOutDir" | redraw!
command! QFInfo         $cc | redraw
command! Make           silent:make! | redraw!
command! MakeLaTex      silent:w | call SelectMakePrgType()
command! ToggleSyn      silent:call ToggleLyTeXSyntax()

function! g:CheckLilyPondCompile()
	if !empty(glob("tmpOutDir/*.tex"))
		let &makeprg = 'cd tmpOutDir/ && lualatex --shell-escape %:r.tex'
		call LuaLaTexEfm()
		Make
		execute 'silent:!mv tmpOutDir/%:r.pdf .'
		CleanTmpFolder
	else
		CleanTmpFolder
	endif
endfunction

function! g:SelectMakePrgType()
	if search("usepackage{lyluatex}", "n")
		setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
		call LuaLaTexEfm()
		Make
	else 
		if search("begin{lilypond}", "n")
			let &makeprg="lilypond-book --output=tmpOutDir --pdf %"
			call LilyPondEfm()
			Make
			call CheckLilyPondCompile()
		else
			setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
			call LuaLaTexEfm()
			Make
		endif
	endif
endfunction

function! g:LuaLaTexEfm()
	setlocal efm=%+G!\ LaTeX\ %trror:\ %m,
		\%+GLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
		\%GLaTeX\ %.%#Warning:\ %m,
		\%+G!\ %m
	setlocal efm+=%El.%l\ %m
	setlocal efm+=%+G%.%#Fatal%.%#
	setlocal efm+=%+G%.%#Output%.%#
	setlocal efm+=%-G%.%#,
	if exists('b:TexQfOverfull')
		setlocal efm+=%+G%.%#\ at\ lines\ %l--%*\\d
	endif
endfunction

function! g:LilyPondEfm()
	setlocal efm=%+G%f:%l:%c:,\ %f:%l:%c:\ %m
	setlocal efm+=%+G%.%#err%.%#
	setlocal efm+=%+G%.%#succ%.%#
	setlocal efm+=%-G%.%#
endfunction

function! g:CleanTexFiles()
	if exists('b:CleanTexFiles')
		silent! | !rm -rf %<.log %<.aux %<.out tmp-ly/
	endif
endfunction

nnoremap <buffer> <F3> :ToggleSyn<cr>
inoremap <buffer> <F3> <esc>:ToggleSyn<cr>a
nnoremap <buffer> <F5> ma:MakeLaTex<cr>:QFInfo<cr>`a
inoremap <buffer> <F5> <esc>ma:MakeLaTex<cr>:QFInfo<cr>`aa
nnoremap <buffer> <F6> :silent:!xdg-open "%<.pdf" 2>/dev/null &<cr>
inoremap <buffer> <F6> <esc>:silent:!xdg-open "%<.pdf" 2>/dev/null &<cr>a

augroup LilypondSyntax
	autocmd!
	autocmd BufWinEnter,BufEnter * call DetectLilypondSyntax()
augroup END

augroup CleanFiles
	autocmd!
	autocmd VimLeave *.tex call CleanTexFiles()
augroup END
