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
	if search("begin{lilypond}", "n")
		syntax include @lilypond syntax/lilypond.vim
		unlet b:current_syntax
		syntax region LyTeX 
			\ matchgroup=Snip 
			\ start="\\begin{lilypond}" 
			\ end="\\end{lilypond}" 
			\ contains=@lilypond
		highlight Snip ctermfg=white cterm=bold
	else
		if search("\\lilypond", "n")
			syntax include @lilypond syntax/lilypond.vim
			unlet b:current_syntax
			syn region LyTeX 
				\ matchgroup=Delimiter
				\ start="\\lilypond{" 
				\ matchgroup=Delimiter
				\ end="}" 
				\ contains=@lilypond
			highlight Snip ctermfg=white cterm=bold
		endif
	endif
endfunction

function! g:CheckLilyPondCompile()
	if !empty(glob("tmpOutDir/*.tex"))
		let &makeprg = 'cd tmpOutDir/ && lualatex --shell-escape %:r.tex'
		execute 'silent:make!'
		execute 'silent:!mv tmpOutDir/%:r.pdf .'
		execute 'silent:!rm -rf tmpOutDir'
		execute "redraw!"
		execute "$-1cc"
		redraw!
	else
		execute 'silent:!rm -rf tmpOutDir'
		execute "redraw!"
		execute "$-1cc" 
		redraw!
	endif
endfunction

augroup LilypondSyntax
	autocmd!
	autocmd BufWinEnter,BufEnter,BufWrite * call DetectLilypondSyntax()
augroup END

function! g:MakeLaTex()
	execute 'silent:make!'
	execute "redraw!"
	execute "$-1cc"
	redraw!
endfunction

function! g:SelectMakePrgType()
	if search("usepackage{lyluatex}", "n")
		setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
		noremap <buffer> <F5> ma:w<cr>
			\ :call MakeLaTex()<cr>
			\ `a
	else 
		if search("begin{lilypond}", "n")
			let &makeprg="lilypond-book --output=tmpOutDir --pdf %"
			noremap <buffer> <F5> ma:w<cr>
				\ :silent:make!<cr>
				\ :call CheckLilyPondCompile()<cr>
				\ `a
		else
			setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
			noremap <buffer> <F5> ma:w<cr> 
				\ :call MakeLaTex()<cr>
				\ `a
		endif
	endif
endfunction

augroup MakePrgType
	autocmd!
	autocmd BufWinEnter,BufWrite,InsertLeave * call SelectMakePrgType()
augroup END

noremap <buffer> <F6> :!xdg-open "%<.pdf" 2>/dev/null &<cr><cr>
