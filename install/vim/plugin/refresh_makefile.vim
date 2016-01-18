function! Actualise_makefile()
	let l:pwd = getcwd()
	while !filereadable('./Makefile')
		if isdirectory('./nfs')
			exe ':cd'.l:pwd
			break
		endif
		exe ':cd ..'
	endwhile
	exe ":sp " . "Makefile"
	call Refresh_files_list()
	:set hidden
	:setl autoread
	:silent! wq
	:silent! exe "bd 2"
	exe ':cd'.l:pwd
endfunction
