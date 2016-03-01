function! Eatchar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction

function! GetReturnVar()
	let num_line = line('.')
	while num_line > 0 && empty(matchstr(getline(num_line), '^{$'))
		let num_line -= 1
	endwhile
	if num_line == 0
		return ""
	endif
	let varfunction = matchstr(getline(num_line - 1), '^\i\(^(\)*\S.\{-}\ze\s\+\i*(')
	let varfunction = matchstr(varfunction, '\(static \)*\zs.*')
	if varfunction == "void"
		return " ;"
	else
		return " ();\<Left>\<Left>"
	endif
endfunction

function! BracetteCharDetect()
	let c = nr2char(getchar(0))
	if c =~ '}'
		return "}\<Left>"
	else
		return "\<CR>}\<Up>\<CR>"
	endif
endfunction

func! CustomComplete()
	echom 'move to start of last word'
	normal b
	echom 'select word under cursor'
	let b:word = expand('<cword>')
	echom '->'.b:word.'<-'
	echom 'save position'
	let b:position = col('.')
	echom '->'.b:position.'<-'
	normal e
	normal l
	echom 'move to end of word'

	let b:list = ["spoogle test
				\\<CR>test","spangle","frizzle"]
	let b:matches = []

	echom 'begin checking for completion'
	for item in b:list
		echom 'checking '
		echom '->'.item.'<-'
		if(match(item,'^'.b:word)==0)
			echom 'adding to matches'
			echom '->'.item.'<-'
			call add(b:matches,item)
		endif
	endfor
	call complete(b:position, b:matches)
	return ''
endfunc

iab { {<c-r>=BracetteCharDetect()<CR>
inoremap <F8> <c-r>=CustomComplete()<CR>

autocmd FileType c,cpp		call Abbr_c()
function! Abbr_c()
	" #include
	iab #i #include
	iab #I #include
	iab ##i # include
	iab ##I # include
	iab #d #define
	iab #D #define
	iab ##d # define
	iab ##D # define

	iab _li #include <libft.h><c-r>=Eatchar('\s')<CR>
	iab _un #include <unistd.h><c-r>=Eatchar('\s')<CR>
	iab _st #include <stdlib.h><c-r>=Eatchar('\s')<CR>
	iab _fc #include <fcntl.h><c-r>=Eatchar('\s')<CR>

	iab while while ()<Left><c-r>=Eatchar('\s')<CR>
	iab if if ()<Left><c-r>=Eatchar('\s')<CR>
	iab continue continue ;<c-r>=Eatchar('\s')<CR>
	iab break break ;<c-r>=Eatchar('\s')<CR>
	" return abbr, auto detect void return
	iab return return<c-r>=GetReturnVar()<CR><c-r>=Eatchar('\s')<CR>
endfunction
