" ===================================================================
" TeX filetype plugin with embedded LilyPond
" Language:     TeX
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

function! g:DetectLilypondSyntax()
	if search("begin{lilypond}", "n")
		unlet b:current_syntax
		syntax include @TEX syntax/tex.vim
		unlet b:current_syntax
		syntax include @lilypond syntax/lilypond.vim
		syntax region litex 
			\ matchgroup=Snip 
			\ start="\\begin{lilypond}" 
			\ end="\\end{lilypond}" 
			\ containedin=@TEX 
			\ contains=@lilypond
		highlight Snip ctermfg=white cterm=bold
		filetype plugin on
		let b:current_syntax="litex"
	endif
endfunction

augroup LilypondSyntax
	autocmd!
	autocmd BufEnter,BufWrite * call DetectLilypondSyntax()
augroup END

function! g:SelectMakePrgType()
	if search("usepackage{lyluatex}", "n")
		setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
		noremap <buffer> <F5> :w<cr>
			\ :silent:make!<cr>
			\ :redraw!<cr>
			\ :$-1cc<cr>
	else 
		if search("begin{lilypond}", "n")
			let &makeprg = 'lilypond-book --output=tmpOutDir --pdf % && cd tmpOutDir/ && lualatex %:r.tex'
			noremap <buffer> <F5> :w<cr>
				\ :silent:make!<cr>:!mv tmpOutDir/%:r.pdf .<cr>
				\ :!rm -rf tmpOutDir<cr>
				\ :redraw!<cr>
				\ :$-1cc<cr>
		else
			setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
			noremap <buffer> <F5> :w<cr>
				\ :silent:make!<cr>
				\ :redraw!<cr>
				\ :$-1cc<cr>
		endif
	endif
endfunction

augroup MakePrgType
	autocmd!
	autocmd BufEnter,BufWrite,QuickFixCmdPre * call SelectMakePrgType()
augroup END

noremap <buffer> <F6> :!xdg-open "%<.pdf" 2>/dev/null &<cr><cr>
