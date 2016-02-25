function! Actualise_makefile()
	let l:pwd = getcwd()
	while !filereadable('./Makefile')
		try
			cd ..
		catch
			exe ':cd '.l:pwd
			return
		endtry
	endwhile
	exe ':!vim -c ":wq" Makefile'
	exe ':cd '.l:pwd
endfunction
