" Basic
set mouse=a

set nu

inor	<C-z> <ESC>ua
nnor	ve :vnew $VIMRC<CR> 
nnor	vs :source $VIMRC<CR> 

set		hlsearch
nnor	<silent> <ESC>/ :set hlsearch!<CR>

set		shiftwidth=4
set		tabstop=4
set		softtabstop=4
set		foldmethod=indent

" FtDetect
aug FtDetect | au!
	au BufRead,BufNewFile	*.via	setf via
	au FileType				via		call VimAnnotated()
aug END

" Highlight

hi LineNr					ctermfg=Black
hi CursorLine									cterm=underline
hi CursorLineNr									cterm=bold

hi Annotation				ctermfg=Blue
hi AnnotationBracket		ctermfg=Grey
hi AnnotationSymbol			ctermfg=Red
hi AnnotationComma			ctermfg=Grey
hi AnnotationType			ctermfg=DarkBlue	cterm=underline
hi AnnotationNote			ctermfg=DarkGrey

" Via

fun! VimAnnotated()
	setl	nofoldenable

	" Syntaxing
	sy clear
	sy match	Annotation			/(.\{-})/				contains=AnnotationBracket,AnnotationSymbol,AnnotationComma,AnnotationType,AnnotationNote
	sy match	AnnotationBracket	/[()]/					contained
	sy match	AnnotationSymbol	/[*!=<>#\-|:]/			contained
	sy match	AnnotationComma		/,/						contained
	sy match	AnnotationType		/#[^()*!=<>#\-|:]\+\./	contained
	sy match	AnnotationNote		/\(:\)\@<=[^)]\+/		contained

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

	iabb via-h (Title<Tab><Tab><Tab>\|)<CR>(LocaleTitle<Tab>\|)<CR>(Author<Tab><Tab><Tab>\|)<CR>
endfun

