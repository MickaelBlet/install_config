autocmd Filetype c,cpp	map		<C-G> :call Switch()<CR>
autocmd Filetype c,cpp	imap	<C-G> <Esc>:call Switch()<CR>
autocmd Filetype c,cpp	vmap	<C-G> <Esc>:call Switch()<CR>

function! Switch()
	if exists("*Speed_open")
		call Speed_open("sp")
	endif
endfunction
