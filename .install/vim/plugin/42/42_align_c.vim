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

" Init default map key
map  <silent> <S-Tab>	:call Preserve("normal gg=G")<CR>gi
imap <silent> <S-Tab>	<Esc>:call Preserve("normal gg=G")<CR>gi
vmap <silent> <S-Tab>	<Esc>:call Preserve("normal gg=G")<CR>gi

" specifique c files map
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
	let winview = winsaveview()
	call SortInclude()
	%s/\s\+$//e
	%s/\"/?????/eg
	%s/\//|||||/eg
	silent g/^\_$\n\_^$/d
	call AlignAll()
	call AlignPrepros()
	%s/?????/\"/eg
	%s/|||||/\//eg
	call winrestview(winview)
	call system("rm -fr ~/.vim/view")
endfunction

function! Align_speed_42()
	%s/\s\+$//e
	%s/\"/?????/eg
	%s/\//|||||/eg
	call AlignSpeedFunc()
	%s/?????/\"/eg
	%s/|||||/\//eg
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
	let pos = 0
	let line = 0
	let strline = getline(line)
	" Check all line of file
	while line <= line('$')
		" Check if in string of line find '#' and ('if' or 'el' or 'define' or 'include')
		if !empty(matchstr(strline, '^\#\s*if'))
					\ || !empty(matchstr(strline, '^\#\s*el'))
					\ || !empty(matchstr(strline, '^\#\s*define'))
					\ || !empty(matchstr(strline, '^\#\s*include'))
					\ || !empty(matchstr(strline, '^\#\s*end'))
			" replace with the real space
			call setline(line, substitute(strline, '\#\zs\s*', repeat(' ', pos), ""))
		endif
		" inc position
		if !empty(matchstr(strline, '^\#\s*if'))
			let pos += 1
		endif
		let line += 1
		" Get string of line
		let strline = getline(line)
		" dec position
		if !empty(matchstr(strline, '^\#\s*end'))
			let pos -= 1
		endif
		" inc count line
	endwhile
endfunction

function! AlignSpeedFunc()
	let maxlen_struct = 0
	let maxlen_func = 0
	let line = 0
	" Check all line of file
	while line <= line('$')
		" Get string of line
		let strline = getline(line)
		if !empty(matchstr(strline, '^\i.*(.*'))
			let tmplen = strlen(matchstr(strline, '^\i\(^(\)*\S.\{-}\ze\s\+\**\i*('))
			let maxlen_func = (tmplen > maxlen_func) ? tmplen : maxlen_func
		elseif !empty(matchstr(strline, '^\i.*'))
			let tmplen = strlen(matchstr(strline, '^\i.*\S\+\ze\s\+\**\i\+;*$'))
			let maxlen_struct = (tmplen > maxlen_struct) ? tmplen : maxlen_struct
		elseif !empty(matchstr(strline, '^{$'))
			let line += 1
			let strline = getline(line)
			while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
				let tmplen = strlen(matchstr(strline, '^\t\+\zs\i.*\S\+\ze\s\+\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!')) + 4
				let maxlen_struct = (tmplen > maxlen_struct) ? tmplen : maxlen_struct
				let line += 1
				let strline = getline(line)
			endwhile
		endif
		let line += 1
	endwhile
	let maxlen_struct = ((maxlen_struct % &tabstop) > 2) ? (maxlen_struct + &tabstop) : maxlen_struct
	let maxlen_func = ((maxlen_func % &tabstop) > 2) ? (maxlen_func + &tabstop) : maxlen_func
	let maxlen = (maxlen_struct > maxlen_func) ? maxlen_struct : maxlen_func
	let line = 0
	while line <= line('$')
		let strline = getline(line)
		if !empty(matchstr(strline, '^\i.*(.*'))
			let tmplen = strlen(matchstr(strline, '^\i\(^(\)*\S.\{-}\ze\s\+\**\i*('))
			if maxlen > tmplen
				let number_tab = 0
				let diff = maxlen - tmplen
				if tmplen < &tabstop
					let number_tab += 1
					let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
				elseif (tmplen % &tabstop) > 0
					let number_tab += (diff + tmplen % &tabstop) / &tabstop
				else
					let number_tab += diff / &tabstop
				endif
				let number_tab += 1
				call setline(line, substitute(strline, '\s\+\ze\**\i*(.*\(^\t\)\@<!', repeat('\t', number_tab), ""))
			else
				call setline(line, substitute(strline, '\s\+\ze\**\i*(.*\(^\t\)\@<!', '\t', ""))
			endif
		endif
		let line += 1
	endwhile
endfunction

function!	AlignAll()
	let maxlen_struct = 0
	let maxlen_func = 0
	let maxlen_var = 0
	let maxlen = 0
	let line = 0
	while line <= line('$')
		let strline = getline(line)
		if !empty(matchstr(strline, '^\i.*(.*'))
			let tmplen = strlen(matchstr(strline, '^\i\(^(\)*\S.\{-}\ze\s\+\**\i*('))
			let maxlen_func = (tmplen > maxlen_func) ? tmplen : maxlen_func
		elseif !empty(matchstr(strline, '^\i.*'))
			let tmplen = strlen(matchstr(strline, '^\i.*\S\+\ze\s\+\**\i\+;*$'))
			let maxlen_struct = (tmplen > maxlen_struct) ? tmplen : maxlen_struct
		elseif !empty(matchstr(strline, '^}.*;$'))
			let tmplen = maxlen_var + &tabstop - 1
			let maxlen_struct = (tmplen > maxlen_struct) ? tmplen : maxlen_struct
		elseif !empty(matchstr(strline, '^{$'))
			let lenlines = 0
			let maxlen_var = 0
			let line += 1
			let strline = getline(line)
			while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
				let lenlines += 1
				let line += 1
				let strline = getline(line)
			endwhile
			if empty(matchstr(strline, '^}$'))
				let line = line - lenlines
				let strline = getline(line)
				while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
					let tmplen = strlen(matchstr(strline, '^\t\+\zs\i.\{-}\S\+\ze\s\+\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!'))
					let maxlen_var = (tmplen > maxlen_var) ? tmplen : maxlen_var
					let line += 1
					let strline = getline(line)
				endwhile
				let maxlen_var = ((maxlen_var % &tabstop) > 2) ? (maxlen_var + &tabstop) : maxlen_var
				let line = line - lenlines
				let strline = getline(line)
				while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
					let tmplen = strlen(matchstr(strline, '^\t\+\zs\i.\{-}\S\+\ze\s\+\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!'))
					if maxlen_var > tmplen
						let number_tab = 0
						let diff = maxlen_var - tmplen
						if tmplen < &tabstop
							let number_tab += 1
							let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
						elseif (tmplen % &tabstop) > 0
							let number_tab += (diff + tmplen % &tabstop) / &tabstop
						else
							let number_tab += diff / &tabstop
						endif
						let number_tab += 1
						call setline(line, substitute(strline, '^\t\+\i.\{-}\S\+\zs\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!', repeat('\t', number_tab), ""))
					else
						call setline(line, substitute(strline, '^\t\+\i.\{-}\S\+\zs\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!', '\t', ""))
					endif
					let line += 1
					let strline = getline(line)
				endwhile
				let line -= 1
				let strline = getline(line)
			endif
		endif
		let line += 1
	endwhile
	let maxlen_struct = ((maxlen_struct % &tabstop) > 2) ? (maxlen_struct + &tabstop) : maxlen_struct
	let maxlen_func = ((maxlen_func % &tabstop) > 2) ? (maxlen_func + &tabstop) : maxlen_func
	let maxlen = (maxlen_struct > maxlen_func) ? maxlen_struct : maxlen_func
	let line = 0
	while line <= line('$')
		let strline = getline(line)
		if !empty(matchstr(strline, '\t\+||')) || !empty(matchstr(strline, '\t\+&&'))
			call setline(line, substitute(strline, '^\t\ze\t\+', '', ""))
		elseif !empty(matchstr(strline, '^\i.*(.*'))
			let tmplen = strlen(matchstr(strline, '^\i\(^(\)*\S.\{-}\ze\s\+\**\i*('))
			if maxlen > tmplen
				let number_tab = 0
				let diff = maxlen - tmplen
				if tmplen < &tabstop
					let number_tab += 1
					let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
				elseif (tmplen % &tabstop) > 0
					let number_tab += (diff + tmplen % &tabstop) / &tabstop
				else
					let number_tab += diff / &tabstop
				endif
				let number_tab += 1
				call setline(line, substitute(strline, '\s\+\ze\**\i*(\(^\t\)*', repeat('\t', number_tab), ""))
			else
				call setline(line, substitute(strline, '\s\+\ze\**\i*(\(^\t\)*', '\t', ""))
			endif
		elseif !empty(matchstr(strline, '^\i.*'))
			let tmplen = strlen(matchstr(strline, '^\i.*\S\+\ze\s\+\**\i\+;*$'))
			if maxlen > tmplen
				let number_tab = 0
				let diff = maxlen - tmplen
				if tmplen < &tabstop
					let number_tab += 1
					let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
				elseif (tmplen % &tabstop) > 0
					let number_tab += (diff + tmplen % &tabstop) / &tabstop
				else
					let number_tab += diff / &tabstop
				endif
				let number_tab += 1
				call setline(line, substitute(strline, '\s\+\ze\**\i\+;*$', repeat('\t', number_tab), ""))
			else
				call setline(line, substitute(strline, '\s\+\ze\**\i\+;*$', '\t', ""))
			endif
		elseif !empty(matchstr(strline, '^{$'))
			let lenlines = 0
			let line += 1
			let strline = getline(line)
			while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
				let lenlines += 1
				let line += 1
				let strline = getline(line)
			endwhile
			if !empty(matchstr(strline, '^}.*;$'))
				let line = line - lenlines
				let strline = getline(line)
				while !empty(matchstr(strline, '^\t.*')) && line <= line('$')
					let tmplen = strlen(matchstr(strline, '^\t\+\zs\i.\{-}\S\+\ze\s\+\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!'))
					if maxlen > tmplen
						let number_tab = 0
						let diff = (maxlen - &tabstop) - tmplen
						if tmplen < &tabstop
							let number_tab += 1
							let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
						elseif (tmplen % &tabstop) > 0
							let number_tab += (diff + tmplen % &tabstop) / &tabstop
						else
							let number_tab += diff / &tabstop
						endif
						let number_tab += 1
						call setline(line, substitute(strline, '\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!', repeat('\t', number_tab), ""))
					else
						call setline(line, substitute(strline, '\s\+\ze\(\(\**\S\+\( [\+\-\*\/\=\%\&\|]\+ .*\)*\)\|\(\**(.*)\)\);\(^\t\)\@<!', '\t', ""))
					endif
					let line += 1
					let strline = getline(line)
				endwhile
				let line -= 1
			endif
		elseif !empty(matchstr(strline, '^}.*;$'))
			let tmplen = 1
			if maxlen > tmplen
				let number_tab = 0
				let diff = maxlen - tmplen
				if tmplen < &tabstop
					let number_tab += 1
					let number_tab += (diff - (&tabstop - tmplen)) / &tabstop
				elseif (tmplen % &tabstop) > 0
					let number_tab += (diff + tmplen % &tabstop) / &tabstop
				else
					let number_tab += diff / &tabstop
				endif
				let number_tab += 1
				call setline(line, substitute(strline, '^}\zs\s\+\ze.*;$', repeat('\t', number_tab), ""))
			else
				call setline(line, substitute(strline, '^}\zs\s\+\ze.*;$', '\t', ""))
			endif
		endif
		let line += 1
	endwhile
endfunction

function!	SortInclude()
	let line = 0
	while line <= line('$')
		if !empty(matchstr(getline(line), '^#\s*include'))
			let select = line
			while select <= line('$') && (empty(getline(select)) || !empty(matchstr(getline(select), '^#\s*include')))
				let select += 1
			endwhile
			if (select >= line('$'))
				return
			endif
			let select -= 1
			exe ":" . line . "," . select . " sort"
			break
		endif
		let line += 1
	endwhile
	if (line >= line('$'))
		return
	endif
	call cursor(select, 1)
	s/$/\r\r/e
	let line = 0
	while line <= line('$')
		if !empty(matchstr(getline(line), '^#\s*include "'))
			let select = line
			while select <= line('$') && (!empty(matchstr(getline(select), '^$')) || !empty(matchstr(getline(select), '^#\s*include "')))
				let select += 1
			endwhile
			if (select == line('$'))
				return
			endif
			let select -= 1
			exe ":" . line . "," . select . " sort"
			break
		endif
		let line += 1
	endwhile
	if (line >= line('$'))
		return
	endif
	call cursor(select, 1)
	s/$/\r\r/e
	let line = 0
	while line <= line('$')
		if !empty(matchstr(getline(line), '^#\s*include <'))
			let select = line
			while select <= line('$') && (!empty(matchstr(getline(select), '^$')) || !empty(matchstr(getline(select), '^#\s*include <')))
				let select += 1
			endwhile
			if (select >= line('$'))
				return
			endif
			let select -= 1
			exe ":" . line . "," . select . " sort"
			break
		endif
		let line += 1
	endwhile
endfunction
