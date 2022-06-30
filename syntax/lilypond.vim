" ===================================================================
" LilyPond syntax file for Vim
" Language:     LilyPond
" Maintainer:   Simon Martineau <martineau.simon@gmail.com>
" Website:      https://github.com/martineausimon/vim-lilypond-suite
" ===================================================================

if exists('b:current_syntax')
	finish 
endif

runtime! syntax/lilypond-words.vim
if exists("b:current_syntax")
	unlet b:current_syntax
endif

setlocal mps+=<:>

syn case match

"syn cluster lilyMatchGroup contains=lilyUsrVar,lilyString,lilyComment,lilyNumber,lilySpecial,lilyArticulation,lilyGrobs,lilyKeywords,lilyMusicCommands,lilyMusicFunctions,lilyMarkupCommands,lilyScales,lilyArticulations,lilyDynamics,lilyGrobProperties,lilyHeaderVariables,lilyPaperVariables,lilyContextProperties,lilyContextsCmd,lilyContexts,lilyTranslators,lilyPitches,lilyClefs,lilyRepeatTypes,lilyPitchLanguageNames,lilyAccidentalsStyles,lilyMisc

syn match  lilyValue         "#[^'(0-9 ]*[\n ]"ms=s+1
syn match  lilySymbol        "#'[^'(0-9 ]*[\n ]"ms=s+2
syn region lilyString        start=/"/ end=/"/ skip=/\\"/
syn region lilyComment       start="%{" skip="%$" end="%}"
syn region lilyComment       start="%\([^{]\|$\)" end="$"
syn match  lilyNumber        "[-_^.]\?\d\+[.]\?"
syn match  lilySpecial       "[(~)]\|[(*)]"
syn match  lilySpecial       "\\[()]"
syn match  lilySpecial       "\\[<!>\\]"
syn match  lilyArticulation  "[-_^][-_^+|>.]"

syn include @embeddedScheme syntax/scheme.vim
unlet b:current_syntax
syn region lilyScheme matchgroup=Delimiter start="#['`]\?(" matchgroup=Delimiter end=")" contains=@embeddedScheme

command -nargs=+ HiLink hi def link <args>
	HiLink lilyString              String
	HiLink lilyComment             Comment
	HiLink lilyPitches             Identifier
	HiLink lilyArticulations       Statement
	HiLink lilyKeywords            Statement
	HiLink lilyMusicCommands       Statement
	HiLink lilyMusicFunctions      Statement
	HiLink lilyDynamics            Statement
	HiLink lilyScales              Statement
	HiLink lilyMarkupCommands      Keyword
	HiLink lilyGrobs               Include
	HiLink lilyNumber              Constant
	HiLink lilySlur                Special
	HiLink lilySpecial             Special
	HiLink lilyArticulation        PreProc
	HiLink lilyGrobProperties      Tag
	HiLink lilyPaperVariables      Tag
	HiLink lilyHeaderVariables     Tag
	HiLink lilyContextProperties   Special
	HiLink lilyContextsCmd         StorageClass
	HiLink lilyContexts            Type
	HiLink lilyTranslators         Type
	HiLink lilyClefs               Label
	HiLink lilyAccidentalsStyles   Tag
	HiLink lilyRepeatTypes         Label
	HiLink lilyPitchLanguageNames  Label
	HiLink lilyMisc                SpecialComment
	HiLink lilyValue               PreCondit
	HiLink lilySymbol              PreCondit
delcommand HiLink

hi lilyUsrVar cterm=bold

let b:current_syntax = "lilypond"
