" Basic
set mouse=a

set nu

inor	<C-z> <ESC>ua
nnor	ve :vnew $VIMRC<CR> 
nnor	vs :source $VIMRC<CR> 

set		hlsearch
nnor	<silent> <ESC>/ :set hlsearch!<CR>
nnor	?? :h 

nnor	Q :q<CR>

set		shiftwidth=4
set		tabstop=4
set		softtabstop=4

set		foldmethod=indent
nnor	za zA
nnor	zA za

" Learner
map <Left>	<Nop>
map <Right>	<Nop>
map <Up>	<Nop>
map <Down>	<Nop>

" FtDetect
aug FtDetect | au!
	au BufRead,BufNewFile	*.via	setf via " VIm Annotated
	au FileType				via		cal VimAnn()
aug END

" Highlight

hi LineNr					ctermfg=Black
hi CursorLine									cterm=underline
hi CursorLineNr									cterm=bold

hi qfLineNr					ctermfg=DarkGreen

hi Annotation				ctermfg=Blue
hi AnnotationBracket		ctermfg=Grey
hi AnnotationSymbol			ctermfg=Red
hi AnnotationComma			ctermfg=Grey
hi AnnotationType			ctermfg=DarkBlue	cterm=underline
hi AnnotationNote			ctermfg=DarkGrey

" Via

fun! VimAnn()
	setl	nofoldenable

	" Syntaxing
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

	" Operating annotations
	inor <buffer> ； <Right>()<Left>
  	nnor <buffer> ； a()<Left>
  	inor <buffer> 】 <ESC>f(a
  	nnor <buffer> 】 f(
  	inor <buffer> 【 <ESC>F(a
  	nnor <buffer> 【 F(

  	inor <buffer> ！ !
  	inor <buffer> ， ,
  	inor <buffer> 《 <
  	inor <buffer> 》 >
	
	nnor <buffer> <silent> 。 :lop<CR><C-w>k
	inor <buffer> <silent> 。 <ESC>:lop<CR><C-w>ka
	nnor <buffer> <silent> 。。 :cal UpdAnn()<CR>:lop<CR>:cal SynAnn()<CR><C-w>k
	inor <buffer> <silent> 。。 <ESC>:cal UpdAnn()<CR>:lop<CR>:cal SynAnn()<CR><C-w>ka
	nnor <buffer> <silent> 。， :lclose<CR>
	inor <buffer> <silent> 。， <ESC>:lclose<CR>a

	nnor <buffer> <silent> ｛ :lprev<CR>
	inor <buffer> <silent> ｛ <ESC>:lprev<CR>a
	nnor <buffer> <silent> ｝ :lnext<CR>
	inor <buffer> <silent> ｝ <ESC>:lnext<CR>a

	inor <buffer> 、 <ESC>mayiw`aa

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
					\ StrSpace(it.lnum, 4) . ', ' .
					\ StrSpace(it.col, 5) . '| ' .
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

" Utility Funs

fun! s:space(s, n)
	retu a:s . repeat(' ', a:n - strlen(a:s))
endfun

