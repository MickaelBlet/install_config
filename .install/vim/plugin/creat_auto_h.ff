autocmd Filetype c,cpp	map		<C-H> :call Check_h_42()<CR>gi
autocmd Filetype c,cpp	imap	<C-H> <Esc>:call Check_h_42()<CR>gi
autocmd Filetype c,cpp	vmap	<C-H> <Esc>:call Check_h_42()<CR>gi

autocmd BufWritePre *.c	call	Actualise_h_42()

function! Creat_h_42(filepath)
	let l:dirpath = system("dirname " . a:filepath)
	let l:dirpath = system("mkdir -p " . l:dirpath)

	" list prot function
	let l:listprot = []

	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*')) && empty(matchstr(getline(l:line), '^static')) && empty(matchstr(getline(l:line), '^typedef')) && empty(matchstr(getline(l:line), '.*;$'))
			let l:tmp_line = ""
			let l:count_line = 1
			while l:line <= line('$') && empty(matchstr(getline(l:line), '^{'))
				if l:count_line > 1
					let l:tmp_line .= "\n"
				endif
				let l:tmp_line .= getline(l:line)
				let l:line += 1
				let l:count_line += 1
			endwhile
			if empty(l:listprot)
				call insert(l:listprot, l:tmp_line)
			else
				call add(l:listprot, l:tmp_line)
			endif
			let l:tmp_line = ""
		endif
		let l:line += 1
	endwhile

	exe ":sp ". a:filepath

	call cursor(16, 1)
	for prot in l:listprot
		exe "normal A". prot . ";\n"
	endfor

	:silent! g/^\_$\n\_^$/d
	if exists("*Align_speed_42")
		:silent! call Align_speed_42()
	endif
	:silent! wq!
	:silent! wq!
	:silent! wq!
endfunction

function! Actualise_h_42()
	let l:filepath = expand('%:f')
	let l:filepath = substitute(l:filepath, "srcs", "includes", "")
	let l:filepath = substitute(l:filepath, "\\.c", "\\.h", "")

	if !filereadable(l:filepath)
		return
	endif
	let l:listprot = []

	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*')) && empty(matchstr(getline(l:line), '^static')) && empty(matchstr(getline(l:line), '^typedef')) && empty(matchstr(getline(l:line), '.*;$'))
			let l:tmp_line = ""
			let l:count_line = 1
			while l:line <= line('$') && empty(matchstr(getline(l:line), '^{'))
				if l:count_line > 1
					let l:tmp_line .= "\n"
				endif
				let l:tmp_line .= getline(l:line)
				let l:line += 1
				let l:count_line += 1
			endwhile
			if empty(l:listprot)
				:silent! call insert(l:listprot, l:tmp_line)
			else
				:silent! call add(l:listprot, l:tmp_line)
			endif
			let l:tmp_line = ""
		endif
		let l:line += 1
	endwhile

	:silent! exe ":sp ". l:filepath
	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*(')) && empty(matchstr(getline(l:line), '^typedef'))
			call cursor(l:line, 1)
			break
		endif
		let l:line += 1
	endwhile
	if l:line >= line('$')
		call cursor(line('$') - 1, 1)
		:silent! exe "normal A \n"
	endif
	while !empty(matchstr(getline(line('.')), '^\i.*(')) && line('.') < line('$') && empty(matchstr(getline(l:line), '^typedef'))
		:silent! exe 'normal dd'
		while !empty(matchstr(getline(line('.')), '^\t')) && line('.') < line('$')
			:silent! exe 'normal dd'
		endwhile
	endwhile
	for prot in l:listprot
		:silent! exe "normal A". prot . ";\n"
	endfor
	:silent! g/^\_$\n\_^$/d
	if exists("*Align_speed_42")
		:silent! call Align_speed_42()
	endif
	:silent! wp
	:silent! exe "bd 2"
endfunction

function!	Check_h_42()
	if expand('%:e') ==? "c"
		let l:filepath = expand('%:f')
		let l:filepath = substitute(l:filepath, "srcs", "includes", "")
		let l:filepath = substitute(l:filepath, "\\.c", "\\.h", "")
		if !filereadable(l:filepath)
			call Creat_h_42(l:filepath)
		else
			call Actualise_h_42()
		endif
	endif
endfunction
