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

autocmd BufNewFile *.c				call s:New_Header_42_c()
autocmd BufNewFile *.cpp			call s:New_Header_42_cpp()
autocmd BufNewFile *.h				call s:New_Header_42_c()
autocmd BufNewFile *.hpp			call s:New_Header_42_cpp()
autocmd BufNewFile *.s				call s:New_Header_42_s()
autocmd BufNewFile *.sh				call s:New_Header_42_bash()
autocmd BufNewFile Makefile			call s:New_Header_42_bash()

autocmd BufRead *.c					call s:Header_42_c()
autocmd BufRead *.cpp				call s:Header_42_cpp()
autocmd BufRead *.h					call s:Header_42_c()
autocmd BufRead *.hpp				call s:Header_42_cpp()
autocmd BufRead *.s					call s:Header_42_s()
autocmd BufRead *.sh				call s:Header_42_bash()
autocmd BufRead Makefile			call s:Header_42_bash()

autocmd BufWritePre *.c				call s:Header_42_Updated()
autocmd BufWritePre *.cpp			call s:Header_42_Updated()
autocmd BufWritePre *.h				call s:Header_42_Updated()
autocmd BufWritePre *.hpp			call s:Header_42_Updated()
autocmd BufWritePre *.s				call s:Header_42_Updated()
autocmd BufWritePre *.sh			call s:Header_42_Updated()
autocmd BufWritePre Makefile		call s:Header_42_Updated()

function! s:Header_42_s()
	let s:comment_start	= "; "
	let s:comment_end	= " ;"
	call s:Header_Map_Keys()
endfunction

function! s:Header_42_c()
	let s:comment_start	= "/* "
	let s:comment_end	= " */"
	call s:Header_Map_Keys()
endfunction

function! s:Header_42_cpp()
	let s:comment_start	= "// "
	let s:comment_end	= " //"
	call s:Header_Map_Keys()
endfunction

function! s:Header_42_bash()
	let s:comment_start	= "# "
	let s:comment_end	= " #"
	call s:Header_Map_Keys()
endfunction

function! s:New_Header_42_s()
	call s:Header_42_s()
	call Header_42()
	call append(12, "")
	exe ":13"
endfunction

function! s:New_Header_42_c()
	call s:Header_42_c()
	call Header_42()
	call append(12, "")
	exe ":13"
endfunction

function! s:New_Header_42_cpp()
	call s:Header_42_cpp()
	call Header_42()
	call append(12, "")
	exe ":13"
endfunction

function! s:New_Header_42_bash()
	call s:Header_42_bash()
	call Header_42()
	call append(12, "")
	exe ":13"
endfunction

function! s:Header_Map_Keys()
	map		<C-C><C-H>	:call Header_42()<CR>
	imap	<C-C><C-H>	<Esc>:call Header_42()<CR>gi
	vmap	<C-C><C-H>	<Esc>:call Header_42()<CR>
endfunction

function! Header_42()
	let l:author = $USER
	let l:mail = $MAIL

	if s:Header_42_Check() == 0
		return
	endif

	while getline(1)[0] == s:comment_start[0]
				\&& getline(1)[1] == s:comment_start[1]
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
	if strlen(s:comment_start) < 3
		let l:line .= " "
	endif
	let l:line .= a:line
	if strlen(s:comment_end) < 3
		let l:line .= " "
	endif
	let l:line .= s:comment_end
	return l:line
endfunction

function! s:Add_Comment_Start_End(line)
	let l:line = s:comment_start
	if strlen(s:comment_start) < 3
		let l:line .= "*"
	endif
	let l:line .= a:line
	if strlen(s:comment_end) < 3
		let l:line .= "*"
	endif
	let l:line .= s:comment_end
	return l:line
endfunction

function! s:Header_42_Line_start_end()
	let l:line = "**************************************************************************"
	return s:Add_Comment_Start_End(l:line)
endfunction

function! s:Header_42_Line_empty()
	let l:line = "                                                                          "
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_Line42(index)
	let l:line = "                                               "
	let l:line .= get(s:ascii_42, a:index, '')
	let l:line .= "  "
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_File()
	let l:filename = expand('%:t')
	let l:line = "  "
	let l:line .= l:filename
	let l:space = 44 - strlen(l:filename)
	while l:space >= 0
		let l:line .= " "
		let l:space -= 1
	endwhile
	let l:line .= get(s:ascii_42, 1, '')
	let l:line .= "  "
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_By(author, mail)
	let l:line = "  "
	let l:line .= "By: " . a:author . " <" . a:mail . ">"
	let l:space = 37 - strlen(a:author . a:mail)
	while l:space >= 0
		let l:line .= " "
		let l:space -= 1
	endwhile
	let l:line .= get(s:ascii_42, 3, '')
	let l:line .= "  "
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_Info(info, author, index)
	let l:line = "  "
	let l:line .= a:info . ": " . strftime("%Y/%m/%d %H:%M:%S") . " by " . a:author
	let l:space = 12 - strlen(a:author)
	while l:space >= 0
		let l:line .= " "
		let l:space -= 1
	endwhile
	let l:line .= get(s:ascii_42, a:index, '')
	let l:line .= "  "
	return s:Add_Comment(l:line)
endfunction

function! s:Header_42_Updated()
	"if &mod == 0
	"	return
	"endif
	if getline(4) != s:Header_42_File()
		call setline(4, s:Header_42_File())
	endif
	if match(getline(9), s:comment_start . "  " . "Updated:") == -1
		return
	endif
	let l:author = $USER
	let l:line = "  "
	let l:line .= "Updated" . ": " . strftime("%Y/%m/%d %H:%M:%S") . " by " . l:author
	let l:space = 12 - strlen(l:author)
	while l:space >= 0
		let l:line .= " "
		let l:space -= 1
	endwhile
	let l:line .= get(s:ascii_42, 6, '')
	let l:line .= "  "
	call setline(9, s:Add_Comment(l:line))
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
	if match(getline(6)[3:76],
				\"^  By: [a-z-]\\+ <[a-z-]\\+@\\i\\+\.42\.fr> \\+\+\#\+  \+\:\+       \+\#\+      ") == -1
		let l:error = 1
	endif
	if getline(7) != s:Header_42_Line42(4)
		let l:error = 1
	endif
	if match(getline(8)[3:76],
				\"^  Created: [0-9]\\{4}/[0-9]\\{2}/[0-9]\\{2} [0-9]\\{2}:[0-9]\\{2}:[0-9]\\{2} by [a-z-]\\+ \\+\#\+\#    \#\+\#            ") == -1
		let l:error = 1
	endif
	if strlen(getline(9)) != 80
		let l:error = 1
	endif
	if match(getline(9)[3:76],
				\"^  Updated: [0-9]\\{4}/[0-9]\\{2}/[0-9]\\{2} [0-9]\\{2}:[0-9]\\{2}:[0-9]\\{2} by [a-z-]\\+ \\+\#\#\#   \#\#\#\#\#\#\#\#\.fr      ") == -1
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
