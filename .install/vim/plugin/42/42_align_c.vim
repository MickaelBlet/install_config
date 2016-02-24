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
" Use : Shift + TAB                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map  <silent> <S-Tab>	:call Preserve("normal gg=G")<CR>gi
imap <silent> <S-Tab>	<Esc>:call Preserve("normal gg=G")<CR>gi
vmap <silent> <S-Tab>	<Esc>:call Preserve("normal gg=G")<CR>gi

autocmd BufNewFile,BufRead *.c	call Align_Map()
autocmd BufNewFile,BufRead *.h	call Align_Map()

function! Align_Map()
	map  <silent> <S-Tab>	:call Align_42()<CR>gi
	imap <silent> <S-Tab>	<Esc>:call Align_42()<CR>gi
	vmap <silent> <S-Tab>	<Esc>:call Align_42()<CR>gi
endfunction

function! Preserve(command)
	let last_search=@/
	let save_cursor = getpos(".")
	normal H
	let save_window = getpos(".")
	call setpos('.', save_cursor)
	execute a:command
	let @/=last_search
	call setpos('.', save_window)
	normal zt
	call setpos('.', save_cursor)
endfunction

function! Align_42()
	call Preserve("normal gg=G")
	let l:winview = winsaveview()
	call SortInclude()
	%s/\s\+$//e
	%s/\"/?????/eg
	%s/\//|||||/eg
	silent g/^\_$\n\_^$/d
	call Align_All()
	call AlignPrepros()
	%s/?????/\"/eg
	%s/|||||/\//eg
	call winrestview(l:winview)
	call system("rm -fr ~/.vim/view")
endfunction

function! Align_speed_42()
	%s/\s\+$//e
	%s/\"/?????/eg
	%s/\//|||||/eg
	call Speed_Align_Func()
	%s/?????/\"/eg
	%s/|||||/\//eg
endfunction

function! Get_len_var(s)
	let l:cmd = "basename \"" . a:s . "\" | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:num = system(l:cmd)
	let l:ret = col("$") - l:num - 2
	return l:ret
endfunction

function! Get_len_func(s)
	let l:cmd = "basename \"" . a:s . "\" | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:num = system(l:cmd)
	let l:ret = col("$") - l:num - 1
	return l:ret
endfunction

function! Get_len_speed_func(s)
	let l:cmd = "basename \"" . a:s . "\" | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:num1 = system(l:cmd)
	let l:num1 = col("$") - l:num1 - 2
	let l:cmd = "dirname \"" . a:s . "\" | tr -dc '\\t' | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:num2 = system(l:cmd)
	let l:ret = l:num1 + ((l:num2 - 1) * (&tabstop - 1))
	return l:ret
endfunction

" [Align precmd]
"
" #ifndef
" #ifndef
" #define TEST
" #endif
" #endif
"
" to
"
" #ifndef
" # ifndef
" #  define TEST
" # endif
" #endif
"
function! AlignPrepros()
	let l:pos = 0
	let l:line = 0
	" Check all line of file
	while l:line <= line('$')
		" Get string of line
		let l:strline = getline(l:line)
		" Check if in string of line find '#' and ('if' or 'el' or 'define' or 'include')
		if !empty(matchstr(l:strline, '^\#\s*if'))
					\ || !empty(matchstr(l:strline, '^\#\s*el'))
					\ || !empty(matchstr(l:strline, '^\#\s*define'))
					\ || !empty(matchstr(l:strline, '^\#\s*include'))
					\ || !empty(matchstr(l:strline, '^\#\s*end'))
			" replace with the real space
			call setline(l:line, substitute(l:strline, '\#\zs\s*', repeat(' ', l:pos), ""))
		endif
		" inc position
		if !empty(matchstr(l:strline, '^\#\s*if'))
			let l:pos += 1
		endif
		" dec position
		if !empty(matchstr(l:strline, '^\#\s*end'))
			let l:pos -= 1
		endif
		" inc count line
		let l:line += 1
	endwhile
endfunction

function! Speed_Align_Func()
	let l:maxlen_struct = 0
	let l:maxlen_func = 0
	let l:lenlignes = 0
	let l:tmplen = 0
	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*(.*'))
			"""""Align Function"""""
			call cursor(l:line, 1)
			let save = getline(l:line)
			s/\s\+\ze\**\i*(.*\(^\t\)\@<!/\//e
			let l:tmplen = Get_len_func(getline(l:line))
			let l:maxlen_func = (l:tmplen > l:maxlen_func) ? l:tmplen : l:maxlen_func
			exe "normal cc"
			exe "normal A" . save
		elseif !empty(matchstr(getline(l:line), '^\i.*'))
			"""""Align Structur"""""
			call cursor(l:line, 1)
			let save = getline(l:line)
			s/\s\+\ze\**\i\+;*$/\//e
			let l:tmplen = Get_len_func(getline(l:line))
			let l:maxlen_struct = (l:tmplen > l:maxlen_struct) ? l:tmplen : l:maxlen_struct
			exe "normal cc"
			exe "normal A" . save
		elseif !empty(matchstr(getline(l:line), '^{$'))
			let l:line += 1
			while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
				call cursor(l:line, 1)
				let save = getline(l:line)
				s/\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ \S\+\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!/\//e
				let l:tmplen = Get_len_var(getline(l:line)) + 4
				let l:maxlen_struct = (l:tmplen > l:maxlen_struct) ? l:tmplen : l:maxlen_struct
				exe "normal cc"
				exe "normal A" . save
				let l:line += 1
			endwhile
		endif
		let l:line += 1
	endwhile
	let l:line = 0
	while l:line <= line('$')
		let l:lenlignes = 0
		let l:tmplen = 0
		if !empty(matchstr(getline(l:line), '^\i.*(.*'))
			call cursor(l:line, 1)
			s/\s\+\ze\**\i*(.*\(^\t\)\@<!/\//e
		endif
		let l:line += 1
	endwhile
	let l:line = 0
	if (l:maxlen_struct % &tabstop) > 2
		let l:maxlen_struct += &tabstop
	endif
	if (l:maxlen_func % &tabstop) > 2
		let l:maxlen_func += &tabstop
	endif
	if (l:maxlen_struct < l:maxlen_func)
		let l:maxlen_struct = l:maxlen_func
	endif
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*(.*'))
			"""""Align Function"""""
			call cursor(l:line, 1)
			let l:tmplen = Get_len_func(getline(l:line))
			if l:maxlen_struct > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen_struct - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/\//\=repeat("\t", l:ntab)/e
			else
				s/\//\t/e
			endif
		endif
		let l:line += 1
	endwhile
endfunction

function!	Align_All()
	"""""Align Variable"""""
	let l:maxlen_var = 0
	"""""Align Function"""""
	let l:maxlen_func = 0
	"""""Align Structur"""""
	let l:maxlen_struct = 0
	let l:line = 0
	while l:line <= line('$')
		let l:lenlignes = 0
		let l:tmplen = 0
		if !empty(matchstr(getline(l:line), '^\i.*(.*'))
			"""""Align Function"""""
			call cursor(l:line, 1)
			s/\s\+\ze\**\i*(.*\(^\t\)\@<!/\//e
			let l:tmplen = Get_len_func(getline(l:line))
			if l:tmplen > l:maxlen_func
				let l:maxlen_func = l:tmplen
			endif
		elseif !empty(matchstr(getline(l:line), '^\i.*'))
			"""""Align Structur"""""
			call cursor(l:line, 1)
			s/\s\+\ze\**\i\+;*$/\//e
			let l:tmplen = Get_len_func(getline(l:line))
			if l:tmplen > l:maxlen_struct
				let l:maxlen_struct = l:tmplen
			endif
		elseif !empty(matchstr(getline(l:line), '^}.*;$'))
			"""""Align Structur"""""
			call cursor(l:line, 1)
			s/\s\+\ze\**\i\+;$/\//e
			let l:tmplen = l:maxlen_var + &tabstop - 1
			if l:tmplen > l:maxlen_struct
				let l:maxlen_struct = l:tmplen
			endif
		elseif !empty(matchstr(getline(l:line), '^{$'))
			"""""Align Variable"""""
			let l:line += 1
			let l:lenlines = 0
			let l:maxlen_var = 0
			while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
				let l:line += 1
				let l:lenlines += 1
			endwhile
			if empty(matchstr(getline(l:line), '^}$'))
				let l:line = l:line - l:lenlines
				while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
					call cursor(l:line, 1)
					s/\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ \S\+\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!/\//e
					let l:tmplen = Get_len_var(getline(l:line))
					if l:tmplen > l:maxlen_var
						let l:maxlen_var = l:tmplen
					endif
					let l:line += 1
				endwhile
				if (l:maxlen_var % &tabstop) > 2
					let l:maxlen_var += &tabstop
				endif
				let l:line = l:line - l:lenlines
				while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
					call cursor(l:line, 1)
					let l:tmplen = Get_len_var(getline(l:line))
					if l:maxlen_var > l:tmplen
						let l:ntab = 0
						let l:diff = l:maxlen_var - l:tmplen
						if l:tmplen < &tabstop
							let l:ntab += 1
							let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
						elseif (l:tmplen % &tabstop) > 0
							let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
						else
							let l:ntab += (l:diff) / &tabstop
						endif
						let l:ntab += 1
						s/\//\=repeat("\t", l:ntab)/e
					else
						s/\//\t/e
					endif
					let l:line += 1
				endwhile
				let l:line -= 1
			endif
		endif
		let l:line += 1
	endwhile
	let l:line = 0
	if (l:maxlen_struct % &tabstop) > 2
		let l:maxlen_struct += &tabstop
	endif
	if (l:maxlen_func % &tabstop) > 2
		let l:maxlen_func += &tabstop
	endif
	if (l:maxlen_struct > l:maxlen_func)
		let l:maxlen_func = l:maxlen_struct
	elseif (l:maxlen_struct < l:maxlen_func)
		let l:maxlen_struct = l:maxlen_func
	endif
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '\t\+||')) || !empty(matchstr(getline(l:line), '\t\+&&'))
			call cursor(l:line, 1)
			s/^\t//e
		elseif !empty(matchstr(getline(l:line), '^\i.*(.*'))
			"""""Align Function"""""
			call cursor(l:line, 1)
			let l:tmplen = Get_len_func(getline(l:line))
			if l:maxlen_func > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen_func - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/\//\=repeat("\t", l:ntab)/e
			else
				s/\//\t/e
			endif
		elseif !empty(matchstr(getline(l:line), '^\i.*'))
			"""""Align Structur"""""
			call cursor(l:line, 1)
			let l:tmplen = Get_len_func(getline(l:line))
			if l:maxlen_struct > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen_struct - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/\//\=repeat("\t", l:ntab)/e
			else
				s/\//\t/e
			endif
		elseif !empty(matchstr(getline(l:line), '^{$'))
			"""""Align Structur"""""
			let l:line += 1
			let l:lenlines = 0
			while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
				if !empty(matchstr(getline(l:line), '\t\+||')) || !empty(matchstr(getline(l:line), '\t\+&&'))
					call cursor(l:line, 1)
					s/^\t//e
				endif
				let l:line += 1
				let l:lenlines += 1
			endwhile
			if !empty(matchstr(getline(l:line), '^}.*;$'))
				let l:line = l:line - l:lenlines
				while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
					call cursor(l:line, 1)
					s/\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ \S\+\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!/\//e
					let l:line += 1
				endwhile
				let l:line = l:line - l:lenlines
				while !empty(matchstr(getline(l:line), '^\t.*')) && l:line <= line('$')
					call cursor(l:line, 1)
					let l:tmplen = Get_len_var(getline(l:line))
					if (l:maxlen_struct - &tabstop) > l:tmplen
						let l:ntab = 0
						let l:diff = (l:maxlen_struct - &tabstop) - l:tmplen
						if l:tmplen < &tabstop
							let l:ntab += 1
							let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
						elseif (l:tmplen % &tabstop) > 0
							let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
						else
							let l:ntab += (l:diff) / &tabstop
						endif
						let l:ntab += 1
						s/\//\=repeat("\t", l:ntab)/e
					else
						s/\//\t/e
					endif
					let l:line += 1
				endwhile
				let l:line -= 1
			endif
		elseif !empty(matchstr(getline(l:line), '^}.*;$'))
			"""""Align Structur"""""
			call cursor(l:line, 1)
			let l:tmplen = 1
			if l:maxlen_struct > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen_struct - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/\//\=repeat("\t", l:ntab)/e
			else
				s/\//\t/e
			endif
		endif
		let l:line += 1
	endwhile
endfunction

function!	SortInclude()
	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^#\s*include'))
			let l:select = l:line
			while l:select <= line('$') && (empty(getline(l:select)) || !empty(matchstr(getline(l:select), '^#\s*include')))
				let l:select += 1
			endwhile
			if (l:select >= line('$'))
				return
			endif
			let l:select -= 1
			exe ":" . l:line . "," . l:select . " sort"
			break
		endif
		let l:line += 1
	endwhile
	if (l:line >= line('$'))
		return
	endif
	call cursor(l:select, 1)
	s/$/\r\r/e
	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^#\s*include "'))
			let l:select = l:line
			while l:select <= line('$') && (!empty(matchstr(getline(l:select), '^$')) || !empty(matchstr(getline(l:select), '^#\s*include "')))
				let l:select += 1
			endwhile
			if (l:select == line('$'))
				return
			endif
			let l:select -= 1
			exe ":" . l:line . "," . l:select . " sort"
			break
		endif
		let l:line += 1
	endwhile
	if (l:line >= line('$'))
		return
	endif
	call cursor(l:select, 1)
	s/$/\r\r/e
	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^#\s*include <'))
			let l:select = l:line
			while l:select <= line('$') && (!empty(matchstr(getline(l:select), '^$')) || !empty(matchstr(getline(l:select), '^#\s*include <')))
				let l:select += 1
			endwhile
			if (l:select >= line('$'))
				return
			endif
			let l:select -= 1
			exe ":" . l:line . "," . l:select . " sort"
			break
		endif
		let l:line += 1
	endwhile
endfunction
