autocmd Filetype c,cpp call Key_C()

" No Bug

function Key_C()
	imap <silent><C-N> <C-N>
	imap <expr> <silent> <C-P> pumvisible() ? "\<Up>" : "\<C-P>\<Up>"
	imap <expr> <silent> <C-L> pumvisible() ? "\<Up>" : "\<C-X>\<C-K>\<Up>"
	imap <expr> <silent> <C-O> pumvisible() ? "\<Up>" : "\<C-X>\<C-L>\<Up>"
	imap <expr> <silent> <C-End> pumvisible() ? "\<Up>" : "#include \"\"\<Left>\<C-X>\<C-F>\<Up>"
endfunction
