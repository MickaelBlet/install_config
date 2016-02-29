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

autocmd FileType c,cpp		call Abbr_c()

function! Abbr_c()
	" #include
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
