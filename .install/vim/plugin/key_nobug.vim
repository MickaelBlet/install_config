autocmd Filetype c,cpp call Key_C()

" No Bug

function!	Include_pum()
	let l:char=getline('.')[col('.')-2]
	if l:char == '/'
		return "\<C-X>\<C-F>\<Up>"
	elseif empty(matchstr(getline('.'), '#include'))
		return "#include \"\"\<Left>\<C-X>\<C-F>\<Up>"
	else
		return ""
	endif
endfunction

function Key_C()
	imap <silent><C-N> <C-N>
	imap <expr> <silent> <C-P> pumvisible() ? "\<Up>" : "\<C-P>\<Up>"
	imap <expr> <silent> <C-L> pumvisible() ? "\<Up>" : "\<C-X>\<C-K>\<Up>"
	imap <expr> <silent> <C-O> pumvisible() ? "\<Up>" : "\<C-X>\<C-L>\<Up>"
	imap <expr> <silent> <C-End> pumvisible() ? "\<Up>" : Include_pum()
endfunction
