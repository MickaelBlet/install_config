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

autocmd BufNewFile,BufRead *.c	call s:Map_C()
autocmd BufWritePre *.c			call Refresh_H_42()

function! s:Map_C()
	map		<C-H> :call Check_H_42()<CR>gi
	imap	<C-H> <Esc>:call Check_H_42()<CR>gi
	vmap	<C-H> <Esc>:call Check_H_42()<CR>gi
endfunction

function! s:Get_prototype()
	let list_prototype = ""
	let line = 0
	while line <= line('$')
		let strline = getline(line)
		if !empty(matchstr(strline, '^\i.*'))
					\&& empty(matchstr(strline, '^static'))
					\&& empty(matchstr(strline, '^typedef'))
					\&& empty(matchstr(strline, '.*;$'))
			let tmpline = ""
			let lenlines = 0
			while line <= line('$') && empty(matchstr(getline(line), '^{'))
				if lenlines > 0
					let tmpline .= "?"
				endif
				let tmpline .= getline(line)
				let line += 1
				let lenlines += 1
			endwhile
			let list_prototype .= tmpline.';?'
		endif
		let line += 1
	endwhile
	return list_prototype
endfunction

function! Extern_Actualise_H_42(list_prototype)
	try
		let line = 0
		while line <= line('$')
			let strline = getline(line)
			if !empty(matchstr(strline, '^\i.*('))
						\&& empty(matchstr(strline, '^typedef'))
				break
			endif
			let line += 1
		endwhile
		if line >= line('$')
			let line = line('$') - 1
			call append(line, "")
		endif
		let start_line_element = line
		let end_line_element = line
		while !empty(matchstr(getline(end_line_element), '^\i.*('))
					\&& empty(matchstr(getline(end_line_element), '^typedef'))
					\&& line(end_line_element) <= line('$')
			let end_line_element += 1
			while !empty(matchstr(getline(end_line_element), '^\t'))
						\&& line(end_line_element) <= line('$')
				let end_line_element += 1
			endwhile
		endwhile
		if start_line_element != end_line_element
			exe start_line_element . ',' . (end_line_element-1) .  'd'
		endif
		let line = (start_line_element-1)
		for proto in split(a:list_prototype, '?')
			call append(line, proto)
			let line += 1
		endfor
		call Align_42()
		:silent! wq!
	catch
		exit
	endtry
endfunction

function! Actualise_H_42(filepath)
	let list_prototype = s:Get_prototype()

	silent! exe ':!screen -d -m vim -c "call Extern_Actualise_H_42(\"'.list_prototype.'\")" '.a:filepath

	exit
endfunction

function! Extern_Creat_H_42(list_prototype)
	try
		let line = 15
		for proto in split(a:list_prototype, '?')
			call append(line, proto)
			let line += 1
		endfor
		call Align_42()
		:silent! wq!
	catch
		exit
	endtry
endfunction

function! Creat_H_42(filepath)
	" Creat dir in 'includes' folder
	let l:dirpath = system("dirname " . a:filepath)
	let l:dirpath = system("mkdir -p " . l:dirpath)

	let list_prototype = s:Get_prototype()

	silent! exe ':!screen -d -m vim -c "call Extern_Creat_H_42(\"'.list_prototype.'\")" '.a:filepath

	exit
endfunction

function! Extern_Check_H_42(bool)
	if expand('%:e') ==? "c"
		let filepath = expand('%:f')
		let filepath = substitute(filepath, "srcs", "includes", "")
		let filepath = substitute(filepath, "\\.c", "\\.h", "")
		if filereadable(filepath)
			call Actualise_H_42(filepath)
		elseif a:bool == 1
			call Creat_H_42(filepath)
		endif
	endif
	exit
endfunction

function! Refresh_H_42()
	silent! exe ':!screen -d -m vim -c "call Extern_Check_H_42(0)" '.expand('%:f')
	exe 'redraw!'
endfunction

function! Check_H_42()
	silent! exe ':!screen -d -m vim -c "call Extern_Check_H_42(1)" '.expand('%:f')
	exe 'redraw!'
endfunction
