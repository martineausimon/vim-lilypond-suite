" ===================================================================
" TeX filetype plugin with embedded LilyPond
" Language:     TeX
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists('b:current_syntax')
	finish 
endif

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
	endif
	if search("\\lilypond", "n")
		syntax include @lilypond syntax/lilypond.vim
		unlet b:current_syntax
		syn region LyTeX 
			\ matchgroup=Snip
			\ start="\\lilypond{" 
			\ end="}" 
			\ containedin=@TEX contains=@lilypond
	endif
	highlight Snip ctermfg=white cterm=bold
endfunction

command! CleanTmpFolder     silent execute ":!rm -rf tmpOutDir" | redraw!
command! QFInfo             $-1cc | redraw
command! Make               silent:make! | redraw!
command! MakeLaTex          silent:w | call SelectMakePrgType()

function! g:CheckLilyPondCompile()
	if !empty(glob("tmpOutDir/*.tex"))
		let &makeprg = 'cd tmpOutDir/ && lualatex --shell-escape %:r.tex'
		:Make
		execute 'silent:!mv tmpOutDir/%:r.pdf .'
		:CleanTmpFolder
	else
		:CleanTmpFolder
	endif
endfunction

function! g:SelectMakePrgType()
	if search("usepackage{lyluatex}", "n")
		setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
		:Make
	else 
		if search("begin{lilypond}", "n")
			let &makeprg="lilypond-book --output=tmpOutDir --pdf %"
			:Make
			call CheckLilyPondCompile()
		else
			setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
			:Make
		endif
	endif
endfunction

noremap <buffer> <F5> ma:MakeLaTex<cr>`a:QFInfo<cr>
noremap <buffer> <F6> :!xdg-open "%<.pdf" 2>/dev/null &<cr><cr>

augroup LilypondSyntax
	autocmd!
	autocmd BufWinEnter,BufEnter,BufWrite * call DetectLilypondSyntax()
augroup END
