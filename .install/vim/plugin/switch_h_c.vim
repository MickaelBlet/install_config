autocmd Filetype c,cpp	map		<C-G> :call Switch()<CR>
autocmd Filetype c,cpp	imap	<C-G> <Esc>:call Switch()<CR>
autocmd Filetype c,cpp	vmap	<C-G> <Esc>:call Switch()<CR>

function! Switch()
	if expand('%:e') ==? "c"
		let filepath = expand('%:p')
		let filepath = substitute(filepath, "srcs", "includes", "")
		let filepath = substitute(filepath, "\\.c", "\\.h", "")
		if filereadable(filepath)
			exe "tabnew ".filepath. " | start"
		endif
	elseif expand('%:e') ==? "h"
		let filepath = expand('%:p')
		let filepath = substitute(filepath, "includes", "srcs", "")
		let filepath = substitute(filepath, "\\.h", "\\.c", "")
		if filereadable(filepath)
			exe "tabnew ".filepath. " | start"
		endif
	endif
endfunction
