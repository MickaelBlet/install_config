""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        ________ ++     ________                                "
"       /VVVVVVVV\++++  /VVVVVVVV\                               "
"       \VVVVVVVV/++++++\VVVVVVVV/                               "
"        |VVVVVV|++++++++/VVVVV/'                                "
"        |VVVVVV|++++++/VVVVV/'              :::      ::::::::   "
"       +|VVVVVV|++++/VVVVV/'+             :+:      :+:    :+:   "
"     +++|VVVVVV|++/VVVVV/'+++++         +:+ +:+         +:+     "
"   +++++|VVVVVV|/VVVVV/'+++++++++     +#+  +:+       +#+        "
"     +++|VVVVVVVVVVV/'+++++++++     +#+#+#+#+#+   +#+           "
"       +|VVVVVVVVV/'+++++++++           #+#    #+#              "
"        |VVVVVVV/'+++++++++            ###   ########.fr        "
"        |VVVVV/'+++++++++                                       "
"        |VVV/'+++++++++                                         "
"        'V/'   ++++++                                           "
"                 ++                                             "
"                       <mblet@student.42.fr>                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use : C-C C-H                                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufNewFile	*.c,*.cpp,*.h,*.hpp,*.s,*.sh,*.htm,*.html,Makefile call s:New_Header()
autocmd BufRead		*.c,*.cpp,*.h,*.hpp,*.s,*.sh,*.htm,*.html,Makefile call s:Header_Comment()
autocmd BufWritePre	*.c,*.cpp,*.h,*.hpp,*.s,*.sh,*.htm,*.html,Makefile call s:Header_Updated()

function! s:Header_Map_Keys()
	map		<C-C><C-H>	:call Header_42()<CR>
	imap	<C-C><C-H>	<Esc>:call Header_42()<CR>gi
	vmap	<C-C><C-H>	<Esc>:call Header_42()<CR>
endfunction

function! s:Header_Comment()
	if expand('%:e') ==? "c" || expand('%:e') ==? "h"
		let s:comment_start	= "/*"
		let s:comment_middle = "*"
		let s:comment_end	= "*/"
	elseif &filetype == "cpp"
		let s:comment_start	= "//"
		let s:comment_middle = "*"
		let s:comment_end	= "//"
	elseif &filetype == "vim"
		let s:comment_start	= "\""
		let s:comment_middle = "*"
		let s:comment_end	= "\""
	elseif &filetype == "html"
		let s:comment_start	= "<!--"
		let s:comment_middle = "*"
		let s:comment_end	= "-->"
	elseif &filetype == "sh" || &filetype == "zsh"
		let s:comment_start	= "#"
		let s:comment_middle = "*"
		let s:comment_end	= "#"
	elseif &filetype == "asm"
		let s:comment_start	= ";"
		let s:comment_middle = "*"
		let s:comment_end	= ";"
	endif
	call s:Header_Map_Keys()
endfunction

function! s:New_Header()
	call s:Header_Comment()
	call Header_42()
	call append(12, "")
	exe ":13"
endfunction

function! Header_42()
	let l:author = $USER
	let l:mail = $MAIL

	if s:Header_42_Check() == 0
		return
	endif

	while !empty(matchstr(getline(1)[0:strlen(s:comment_start)], "^".s:comment_start))
		:0d1
	endwhile

	call append(0, s:Header_42_Line_start_end())
	call append(1, s:Header_42_Line_empty())
	call append(2, s:Header_42_Line42(0))
	call append(3, s:Header_42_File())
	call append(4, s:Header_42_Line42(2))
	call append(5, s:Header_42_By(l:author, l:mail))
	call append(6, s:Header_42_Line42(4))
	call append(7, s:Header_42_Info("Created", l:author, 5))
	call append(8, s:Header_42_Info("Updated", l:author, 6))
	call append(9, s:Header_42_Line_empty())
	call append(10, s:Header_42_Line_start_end())

	if strlen(getline(12)) > 0
		call append(11, "")
	endif
endfunction

let s:ascii_42 = [
			\'        :::      ::::::::',
			\'      :+:      :+:    :+:',
			\'    +:+ +:+         +:+  ',
			\'  +#+  +:+       +#+     ',
			\'+#+#+#+#+#+   +#+        ',
			\'     #+#    #+#          ',
			\'    ###   ########.fr    '
			\]

function! s:Add_Comment(line)
	let l:line = s:comment_start
	let l:line .= " "
	let l:line .= repeat(" ", 5 - strlen(s:comment_start))
	let l:line .= a:line
	let l:line .= repeat(" ", 5 - strlen(s:comment_end))
	let l:line .= " "
	let l:line .= s:comment_end
	return l:line
endfunction

function! s:Add_Comment_Start_End(line)
	let l:line = s:comment_start
	let l:line .= " "
	let l:line .= repeat(s:comment_middle, 5 - strlen(s:comment_start))
	let l:line .= a:line
	let l:line .= repeat(s:comment_middle, 5 - strlen(s:comment_end))
	let l:line .= " "
	let l:line .= s:comment_end
	return l:line
endfunction

function! s:Header_42_Line_start_end()
	let l:line = repeat(s:comment_middle, 68)
	return s:Add_Comment_Start_End(l:line)
endfunction

function! s:Header_42_Line_empty()
	let l:line = repeat(" ", 68)
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_Line42(index)
	let l:line = repeat(" ", 43)
	let l:line .= s:ascii_42[a:index]
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_File()
	let l:filename = expand('%:t')
	let l:line = l:filename
	let l:space = 43 - strlen(l:filename)
	let l:line .= repeat(" ", l:space)
	let l:line .= s:ascii_42[1]
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_By(author, mail)
	let l:line = "By: " . a:author . " <" . a:mail . ">"
	let l:space = 36 - strlen(a:author . a:mail)
	let l:line .= repeat(" ", l:space)
	let l:line .= s:ascii_42[3]
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_Info(info, author, index)
	let l:line = a:info . ": " . strftime("%Y/%m/%d %H:%M:%S") . " by " . a:author
	let l:space = 11 - strlen(a:author)
	let l:line .= repeat(" ", l:space)
	let l:line .= s:ascii_42[a:index]
	return s:Add_Comment(l:line)
endfunction

function! s:Header_Updated()
	"if &mod == 0
	"	return
	"endif
	if match(getline(9), "Updated:") == -1
		return
	endif
	if getline(4) != s:Header_42_File()
		call setline(4, s:Header_42_File())
	endif
	let l:author = $USER
	call setline(9, s:Header_42_Info("Updated", l:author, 6))
endfunction

function! s:Header_42_Check()
	let l:error = 0
	if getline(1) != s:Header_42_Line_start_end()
		let l:error = 1
	endif
	if getline(2) != s:Header_42_Line_empty()
		let l:error = 1
	endif
	if getline(3) != s:Header_42_Line42(0)
		let l:error = 1
	endif
	if getline(4) != s:Header_42_File()
		let l:error = 1
	endif
	if getline(5) != s:Header_42_Line42(2)
		let l:error = 1
	endif
	if match(getline(6)[5:74],
				\"^By: [a-z-]\\+ <[a-z-]\\+@\\i\\+\.42\.fr> \\+\+\#\+  \+\:\+       \+\#\+    ") == -1
		let l:error = 1
	endif
	if getline(7) != s:Header_42_Line42(4)
		let l:error = 1
	endif
	if match(getline(8)[5:74],
				\"^Created: [0-9]\\{4}/[0-9]\\{2}/[0-9]\\{2} [0-9]\\{2}:[0-9]\\{2}:[0-9]\\{2} by [a-z-]\\+ \\+\#\+\#    \#\+\#          ") == -1
		let l:error = 1
	endif
	if strlen(getline(9)) != 80
		let l:error = 1
	endif
	if match(getline(9)[5:74],
				\"^Updated: [0-9]\\{4}/[0-9]\\{2}/[0-9]\\{2} [0-9]\\{2}:[0-9]\\{2}:[0-9]\\{2} by [a-z-]\\+ \\+\#\#\#   \#\#\#\#\#\#\#\#\.fr    ") == -1
		let l:error = 1
	endif
	if getline(10) != s:Header_42_Line_empty()
		let l:error = 1
	endif
	if getline(11) != s:Header_42_Line_start_end()
		let l:error = 1
	endif
	return l:error
endfunction
