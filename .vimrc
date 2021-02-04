" Basic
set mouse=a

set nu

inor	<C-Z> <ESC>ua
nnor	ve :vnew $VIMRC<CR> 
nnor	vs :source $VIMRC<CR> 

set		hlsearch
nnor	<silent> <ESC>/ :set hlsearch!<CR>

nnor	; :
nnor	?? :h 
nnor	Q :q<CR>
nnor	S :w<CR>
nnor	Sq :wq<CR>
nnor	Sg :w<CR>:!gulp<CR>

set		shiftwidth=4
set		tabstop=4
set		softtabstop=4

set		nowrap
nnor	<silent> <ESC>w :set wrap!<CR>

set		foldmethod=indent
nnor	za zA
nnor	zA za

" Learner
map <Left>	<Nop>
map <Right>	<Nop>
map <Up>	<Nop>
map <Down>	<Nop>

" Highlight " Vim
set t_Co=256

hi LineNr					ctermfg=Black
hi CursorLine									cterm=underline
hi CursorLineNr									cterm=bold

hi qfLineNr					ctermfg=DarkGreen

" Highlight " Via
hi Annotation				ctermfg=Blue
hi AnnotationBracket		ctermfg=Grey
hi AnnotationSymbol			ctermfg=Red
hi AnnotationComma			ctermfg=Grey
hi AnnotationType			ctermfg=DarkBlue	cterm=underline
hi AnnotationNote			ctermfg=DarkGrey

" Highlight " JS
hi javaScriptFkUtilAPI              ctermfg=55              cterm=underline
hi javaScriptFkUtilConst            ctermfg=77              cterm=underline

hi javaScriptDefine                 ctermfg=69              cterm=bold
hi javaScriptDefineProper           ctermfg=21
hi javaScriptDefineException        ctermfg=196
hi javaScriptFuncKeyword            ctermfg=69              cterm=bold
hi javaScriptFuncDef                ctermfg=18
hi javaScriptFuncArg                ctermfg=99
hi javaScriptFuncComma              ctermfg=240
hi javaScriptFuncEq                 ctermfg=240

hi javaScriptOperatorKeyword        ctermfg=248             cterm=bold
hi javaScriptOperatorSymbol         ctermfg=248
hi javaScriptOperatorSymbolLogic    ctermfg=202

hi javaScriptNumber                 ctermfg=77
hi javaScriptGlobalLiteral          ctermfg=77
hi javaScriptBoolean                ctermfg=77
hi javaScriptNull                   ctermfg=77
hi javaScriptString                 ctermfg=128
hi javaScriptTemplate               ctermfg=128
hi javaScriptTemplateSubstitution   ctermfg=99
hi javaScriptRegexpString           ctermfg=77

hi javaScriptBraces                 ctermfg=74
hi javaScriptParens                 ctermfg=74

hi javaScriptModule                 ctermfg=199
hi javaScriptCommonModule           ctermfg=199

hi javaScriptGlobalObjects          ctermfg=168
hi javaScriptScope                  ctermfg=199

hi javaScriptDollar                 ctermfg=240
hi javaScriptSpecial                ctermfg=99
hi javaScriptDebug                  ctermfg=238             cterm=underline

hi javaScriptShebang                ctermfg=19              cterm=bold,underline
hi javaScriptLineComment            ctermfg=20              cterm=bold
hi javaScriptComment                ctermfg=20              cterm=bold
hi javaScriptCommentTodo            ctermfg=233             cterm=bold,underline

hi javaScriptAsync                  ctermfg=208             cterm=bold
hi javaScriptClass                  ctermfg=205             cterm=bold

hi javaScriptConditional            ctermfg=37              cterm=bold
hi javaScriptRepeat                 ctermfg=41              cterm=bold
hi javaScriptControl                ctermfg=27              cterm=bold
hi javaScriptExceptions             ctermfg=196             cterm=bold
hi javaScriptLabel                  ctermfg=202

" FtDetect
aug FtDetect | au!
	au BufRead,BufNewFile	*.via		setf via " VIm Annotated
	au FileType				via			cal VimAnn()
	au FileType				javascript	cal JS()
aug END

" Via

let g:via_map = 'English'
fun! VimAnn()
	setl	nofoldenable

	" Syntax
	fun! SynAnn()
		if exists('b:via_syn') | retu | endif
		let b:via_syn = 1
		" echom '[via] Syn: ' . (&ft == 'via' ? 'main' : 'loc') . '.'

		sy match	Annotation			/(.\{-})/				contains=
			\AnnotationBracket,AnnotationSymbol,AnnotationComma,
			\AnnotationType,AnnotationNote
		sy match	AnnotationBracket	/[()]/					contained
		sy match	AnnotationSymbol	/[@*!=<>#\-|:]/			contained
		sy match	AnnotationComma		/,/						contained
		sy match	AnnotationType		/#[^()@*!=<>#\-|:]\+\./	contained
		sy match	AnnotationNote		/\(:\)\@<=[^)]\+/		contained
	endfun
	cal SynAnn()

	" Map

	let s:umap_dict = g:via_map
	if s:umap_dict == 'English'
		let s:umap_dict = #{
		\ InsertAnn: '<C-A>a',
		\ OpenAnnWin: '<C-A>o',
		\ UpdOpenAnnWin: '<C-A>p',
		\ CloseAnnWin: '<C-A>q',
		\ NextAnnWin: '<C-A>]',
		\ PrevAnnWin: '<C-A>[',
		\ }
	elseif s:umap_dict == 'Chinese'
		let s:umap_dict = #{
		\ InsertAnn: '；',
		\ NextAnnInl: '】',
		\ PrevAnnInl: '【',
		\ EscBang: '！',
		\ EscComma: '，',
		\ EscAngleL: '《',
		\ EscAngleR: '》',
		\ OpenAnnWin: '。',
		\ UpdOpenAnnWin: '。。',
		\ CloseAnnWin: '。，',
		\ NextAnnWin: '｝',
		\ PrevAnnWin: '｛',
		\ CopyCurWord: '、'
		\ }
	endif

	cal _umap('InsertAnn', '<Right>()<Left>', 'i', { 'necessary': 1 })
	cal _umap('InsertAnn', 'a()<Left>', 'n')
	cal _umap('NextAnnInl', 'f(', 'ni')
	cal _umap('PrevAnnInl', 'F(', 'ni')

  	cal _umap('EscBang', '!', 'i')
  	cal _umap('EscBang', ',', 'i')
  	cal _umap('EscBang', '<', 'i')
  	cal _umap('EscBang', '>', 'i')
	
	cal _umap('OpenAnnWin', ':lop<CR><C-W>k', 'ni', { 'silent': 1 })
	cal _umap('UpdOpenAnnWin', ':cal UpdAnn()<CR>:lop<CR>:cal SynAnn()<CR><C-W>k', 'ni', { 'silent': 1 })
	cal _umap('CloseAnnWin', ':lclose<CR>', 'ni')

	cal _umap('NextAnnWin', ':lnext<CR>', 'ni', { 'silent': 1 })
	cal _umap('PrevAnnWin', ':lprev<CR>', 'ni', { 'silent': 1 })

	cal _umap('CopyCurWord', '<ESC>mUyiw`Ua', 'i')

	setl	iskeyword+=-
	iabb	via-h 
		\(Title          @)<CR>
		\(LocaleTitle    @)<CR>
		\(Author         @)<CR>

	" Annotation location window
	fun! GetAnn(fmt)
		let ls = getline(1, '$')
		let a = []
		let i = 0 | whi i < len(ls)
			let aR = { 'R': i, 'ann': [] }
			let j = 0 | whi 1
				let r = matchstrpos(ls[i], '[A-Za-z\-]\{-}(.\{-})', j)
				let j = r[2]
				if j == -1 | brea | endif
				let aC = { 'C': r[1], 'txt': r[0] }
				if type(a:fmt) == 2
					let f = a:fmt(r[0])
					for k in keys(f)
						let aC[k] = f[k]
					endfor
				endif
				cal add(aR.ann, aC)
			endwhi
			if len(aR.ann) > 0
				cal add(a, aR)
			endif
		let i += 1 | endwhi
		retu a
	endfun

	fun! UpdAnn()
		fun! EngAnn(t)
			let r = split(a:t[:-2], '(')
			if len(r) == 1 | let r = [ "" ] + r | endif
			let n = { 'tar': r[0], 'ann': r[1] }
			if match(r[1], '@') != -1
				let n.meta = split(r[1], '\s\?@')
			endif
			retu n
		endfun

		fun! TxtAnn(d)
			let is = getloclist(0, { 'id': a:d.id, 'items': 1 }).items
			let ls = []
			for i in range(a:d.start_idx - 1, a:d.end_idx - 1)
				let it = is[i]
				cal add(ls,
					\ it.type . '|' .
					\ _space(it.lnum, 4) . ', ' .
					\ _space(it.col, 5) . '| ' .
					\ it.text)
			endfor
			retu ls
		endfun

		cal setloclist(0, [])
		" echom '[via] Clr.'
		
		let a = GetAnn(funcref('EngAnn'))
		let is = []
		for aR in a
			for aC in aR.ann
				let m = aC.tar == "" && exists("aC.meta")
				let it = {
					\ 'lnum': (aR.R + 1), 'col': (aC.C + 1),
					\ 'type': (m ? 'M' : 'A'),
					\ 'text': (m ? aC.meta[0] . ' @ ' . aC.meta[1]
					\			 : aC.txt),
					\ 'bufnr': bufnr() }
				cal add(is, it)
			endfor
		endfor
		
		cal setloclist(0, [], 'r', {
			\ 'title': 'Annotations', 'items': is,
			\ 'quickfixtextfunc': 'TxtAnn' })
		" echom '[via] Upd.'
		if exists("b:via_syn") | unlet b:via_syn | endif
	endfun
endfun

" JS

fun! JS()
	" Abbreviate

	iabb cl( console.log()<Left>

	" Syntax
	setl iskeyword+=$

	sy clear
	sy sync fromstart
	
	sy match   javaScriptShebang                "^#!.*"
	
	sy keyword javaScriptModule                 import export as
	sy keyword javaScriptCommonModule           module exports require
	
	sy keyword javaScriptDefine                 let const var
	sy keyword javaScriptDefineProper           resolve then res
	sy keyword javaScriptDefineException        reject error err
	
	sy keyword javaScriptAsync                  yield async await
	sy keyword javaScriptClass                  class constructor get set static extends
	sy keyword javaScriptScope                  this that super global window arguments prototype
	sy keyword javaScriptGlobalObjects          Array Boolean Date Function Math Number Object RegExp String Symbol Promise
	sy keyword javaScriptGlobalLiteral          NaN Infinity
	
	sy keyword javaScriptOperatorKeyword        delete new instanceof typeof void
	sy match   javaScriptOperatorSymbol         "[+\-*/%@#\^~|&.?:=<>,;]\+"
	
	sy keyword javaScriptBoolean                true false
	sy keyword javaScriptNull                   null undefined
	
	sy keyword javaScriptConditional            if else switch
	sy keyword javaScriptRepeat                 do while for in of
	sy keyword javaScriptControl                break continue return with
	sy keyword javaScriptExceptions             try catch throw finally Error EvalError RangeError ReferenceError SyntaxError TypeError URIError
	sy keyword javaScriptLabel                  case default
	
	sy keyword javaScriptDebug                  console debugger
	
	sy keyword javaScriptCommentTodo            TODO FIXME XXX TBD contained
	sy match   javaScriptLineComment            "\/\/.*" contains=@Spell,javaScriptCommentTodo
	sy match   javaScriptCommentSkip            "^[ \t]*\*\($\|[ \t]\+\)"
	sy region  javaScriptComment                start="/\*"  end="\*/" contains=@Spell,javaScriptCommentTodo
	
	sy match   javaScriptSpecial                "\\\d\d\d\|\\."
	sy region  javaScriptString                 start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=javaScriptSpecial,@htmlPreproc
	sy region  javaScriptString                 start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=javaScriptSpecial,@htmlPreproc
	sy region  javascriptTemplate               start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/ contains=javascriptTemplateSubstitution nextgroup=@javascriptComments,@javascriptSymbols skipwhite skipempty
	sy region  javascriptTemplateSubstitution   matchgroup=javascriptTemplateSB contained start=/\(\\\)\@<!\${/ end=/}/ contains=@javascriptExpression
	
	sy match   javaScriptSpecialCharacter       "'\\.'"
	sy match   javaScriptNumber                 "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
	sy region  javaScriptRegexpString           start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gim]\{0,2\}\s*$+ end=+/[gim]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline
	sy match   javaScriptFloat                  /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
	sy match   javascriptDollar                 "\$"
	
	sy cluster javaScriptAll                    contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptString,javaScriptRegexpString,javascriptTemplate,javaScriptNumber,javaScriptFloat,javascriptDollar,javaScriptLabel,javaScriptSource,javaScriptWebAPI,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFuncKeyword,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptGlobalObjects,javaScriptMessage,javaScriptIdentifier,javaScriptExceptions,javaScriptReserved,javaScriptDeprecated,javaScriptDomErrNo,javaScriptDomNodeConsts,javaScriptHtmlEvents,javaScriptDotNotation,javaScriptBrowserObjects,javaScriptDOMObjects,javaScriptAjaxObjects,javaScriptPropietaryObjects,javaScriptDOMMethods,javaScriptHtmlElemProperties,javaScriptDOMProperties,javaScriptEventListenerKeywords,javaScriptEventListenerMethods,javaScriptAjaxProperties,javaScriptAjaxMethods,javaScriptFuncArg
	
	sy keyword javaScriptFuncKeyword            function contained
	sy region  javaScriptFuncExp                start=/\w\+\s\==\s\=function\>/ end="\([^)]*\)" contains=javaScriptFuncEq,javaScriptFuncKeyword,javaScriptFuncArg keepend
	sy match   javaScriptFuncArg                "\(([^()]*)\)" contains=javaScriptParens,javaScriptFuncComma contained
	sy match   javaScriptFuncComma              /,/ contained
	sy match   javaScriptFuncEq                 /=/ contained
	sy region  javaScriptFuncDef                start="\<function\>" end="\([^)]*\)" contains=javaScriptFuncKeyword,javaScriptFuncArg keepend
	
	sy match   javaScriptBraces                 "[{}\[\]]"
	sy match   javaScriptParens                 "[()]"
	sy match   javaScriptOperatorSymbolLogic    "\(&&\)\|\(||\)\|\(!\)"
	
	sy keyword javaScriptFkUtilAPI              Is Cc ski exTemplate Logger serialize sleep ajax
	sy keyword javaScriptFkUtilConst            EF
	
	sy cluster  htmlJavaScript                  contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError
	sy cluster  javaScriptExpression            contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError,@htmlPreproc
endfun

" Vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'

" Utility

fun! _space(s, n)
	retu a:s . repeat(' ', a:n - strlen(a:s))
endfun

fun! _umap(id, act, mode, opt = {})
	let o = a:opt
	
	if ! exists('s:umap_dict[a:id]')
		if exists('o.necessary')
			throw '_umap: map id `' . a:id . '` is empty.'
		endif
		retu
	endif

	let cmd = (exists('o.recusive') ? 'map' : 'nor') . ' ' .
			\ (exists('o.global') ? '' : '<buffer> ') .
			\ (exists('o.silent') ? '<silent> ' : '') .
			\ s:umap_dict[a:id] . ' '
	
	exe a:mode[0] . cmd . a:act

	if	a:mode == "ni"
		exe 'i' . cmd . '<ESC>' . a:act . 'a'
	endif
endfun

