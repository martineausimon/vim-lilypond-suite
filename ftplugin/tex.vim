" ===================================================================
" TeX filetype plugin with embedded LilyPond
" Language:     TeX
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists('b:current_syntax')
	finish 
endif

if exists("b:current_syntax")
	unlet b:current_syntax
endif

function! g:DetectLilypondSyntax()
unlet b:current_syntax
syntax include @TEX syntax/tex.vim
	if search("begin{lilypond}", "n")
		unlet b:current_syntax
		syntax include @lilypond syntax/lilypond.vim
		syntax region LyTeX 
			\ matchgroup=Snip 
			\ start="\\begin{lilypond}" 
			\ end="\\end{lilypond}" 
			\ containedin=@TEX contains=@lilypond
		highlight Snip ctermfg=white cterm=bold
	endif
	if search("\\lilypond", "n")
		unlet b:current_syntax
		syntax include @lilypond syntax/lilypond.vim
		syn region LyTeX 
			\ matchgroup=Snip
			\ start="\\lilypond{" 
			\ end="}" 
			\ containedin=@TEX contains=@lilypond
		highlight Snip ctermfg=white cterm=bold
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

function! g:MakeLaTex()
	execute 'silent:make!'
	execute "redraw!"
	execute "$-1cc"
	redraw!
endfunction

function! g:SelectMakePrgType()
	if search("usepackage{lyluatex}", "n")
		setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
		call MakeLaTex()
	else 
		if search("begin{lilypond}", "n")
			let &makeprg="lilypond-book --output=tmpOutDir --pdf %"
			execute "silent:make!"
			call CheckLilyPondCompile()
		else
			setlocal makeprg=lualatex\ --shell-escape\ \"%<\"
			call MakeLaTex()
		endif
	endif
endfunction

noremap <buffer> <F5> ma:w<cr>:call DetectLilypondSyntax()<cr>:call SelectMakePrgType()<cr>`a

augroup LilypondSyntax
	autocmd!
	autocmd BufWinEnter,BufEnter * call DetectLilypondSyntax()
augroup END

noremap <buffer> <F6> :!xdg-open "%<.pdf" 2>/dev/null &<cr><cr>
