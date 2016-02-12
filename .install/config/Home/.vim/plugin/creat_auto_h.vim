autocmd Filetype c,cpp	map		<C-H> :call Check_h_42()<CR>gi
autocmd Filetype c,cpp	imap	<C-H> <Esc>:call Check_h_42()<CR>gi
autocmd Filetype c,cpp	vmap	<C-H> <Esc>:call Check_h_42()<CR>gi

autocmd BufWritePre *.c	call	Actualise_h_42()

function! Creat_h_42()
	set paste
	let l:file = expand('%:f')
	let l:cmd = "basename " . l:file . " | tr -d '\n' | rev | cut -c 3- | rev | tr -d '\n'"
	let l:file = system(l:cmd)
	let l:file = l:file . '.h'

	let l:listprot = []

	let l:line = 0
	while l:line <= line('$')
		if !empty(matchstr(getline(l:line), '^\i.*')) && empty(matchstr(getline(l:line), '^static')) && empty(matchstr(getline(l:line), '^typedef'))
			if empty(l:listprot)
				:silent! call insert(l:listprot, getline(l:line))
			else
				:silent! call add(l:listprot, getline(l:line))
			endif
		endif
		let l:line += 1
	endwhile

	:silent! exe ":sp ". l:file
	if exists("*Generate_h_42")
		"call Generate_h_42()
		:silent! exe ":16"
		for prot in l:listprot
			:silent! exe "normal A". prot . ";\n"
		endfor
	else
		:silent! exe ":4"
	endif
	set nopaste
	if exists("*Align_42")
		:silent! call Align_42()
	endif
	:silent! wq
	:silent! exe "bd 2"
endfunction

function! Actualise_h_42()
	let l:file = expand('%:f')
	let l:cmd = "basename " . l:file . " | tr -d '\n' | rev | cut -c 3- | rev | tr -d '\n'"
	let l:file = system(l:cmd)
	let l:file = l:file . '.h'

	if filereadable(l:file)

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

		exe ":sp ". l:file
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
			exe "normal A \n"
		endif
		while !empty(matchstr(getline(line('.')), '^\i.*(')) && line('.') < line('$') && empty(matchstr(getline(l:line), '^typedef'))
			exe 'normal dd'
			while !empty(matchstr(getline(line('.')), '^\t')) && line('.') < line('$')
				exe 'normal dd'
			endwhile
		endwhile
		for prot in l:listprot
			exe "normal A". prot . ";\n"
		endfor
		:silent! g/^\_$\n\_^$/d
		if exists("*Align_speed_42")
			:silent! call Align_speed_42()
		endif
		:silent! wp
		:silent! exe "bd 2"
	endif
endfunction

function!	Check_h_42()
	if expand('%:e') ==? "c"
		let l:file = expand('%:f')
		let l:cmd = "basename " . l:file . " | tr -d '\n' | rev | cut -c 3- | rev | tr -d '\n'"
		let l:file = system(l:cmd)
		let l:file = l:file . '.h'
		if !filereadable(l:file)
			call Creat_h_42()
		else
			call Actualise_h_42()
		endif
	endif
endfunction
