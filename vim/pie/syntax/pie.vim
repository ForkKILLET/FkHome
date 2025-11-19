if exists("b:current_syntax")
	finish
end

syn match	pieComment	";.*$"
syn keyword	pieKeyword	claim define λ Π Σ U
syn match	pieArrow	"→\|->"
syn match	pieAtom		"'[A-Za-z-]\+"
syn match	pieVariable	"[a-z][∀A-Za-z0-9+=*:._-]*"
syn match	pieType		"[A-Z][∀A-Za-z0-9+=*:._-]*"
syn match	pieNumber	"\<\d\+\>"
syn match	pieParen	"[()]"

hi link pieComment	Comment
hi link pieKeyword	Keyword
hi link pieArrow	Keyword
hi link pieNumber	Number
hi link pieAtom		Identifier
hi link pieVariable Normal
hi link pieType		Type
hi link pieParen	Special

let b:current_syntax = "pie"
