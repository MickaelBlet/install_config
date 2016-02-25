autocmd filetype c,cpp call		Go_to_header()

function! Go_to_header()
	let l:pwd = getcwd()
	let l:dir1=expand("./includes")
	let l:dir2=expand("./include")
	while !filereadable('./Makefile')
				\ && !isdirectory(l:dir1)
				\ && !isdirectory(l:dir2)
		try
			cd ..
		catch
			exe ':cd '.l:pwd
			return
		endtry
	endwhile
	if isdirectory(l:dir1)
		cd ./includes
	endif
	if isdirectory(l:dir2)
		cd ./include
	endif
endfunction
