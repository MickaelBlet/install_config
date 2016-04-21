autocmd filetype c,cpp call		Go_to_header()

function! Go_to_header()
	let l:count = 0
	let l:pwd = getcwd()
	let l:dir1=expand("./includes")
	let l:dir2=expand("./include")
	while !filereadable('./Makefile')
				\ && !isdirectory(l:dir1)
				\ && !isdirectory(l:dir2)
		try
			cd ..
			let l:count += 1
			if l:count > 20
				exe ':cd '.l:pwd
				return
			endif
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
