if (exists("g:tabline_42") && g:tabline_42) || &cp
	finish
endif

let g:tabline_42 = 1

function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tab = i + 1
		let winnr = tabpagewinnr(tab)
		let buflist = tabpagebuflist(tab)
		let bufnr = buflist[winnr - 1]
		let bufname = bufname(bufnr)
		let bufmodified = getbufvar(bufnr, "&mod")

		let s .= '%' . tab . 'T'
		let s .= ((tab == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#')
		if bufmodified
			let s .= ' +'
		else
			let s .= ' '
		endif
		let s .= (bufname != '' ? ''. fnamemodify(bufname, ':t') . ' %#TabLineFill# ' : '[No Name] ')
	endfor

	let s .= '%#TabLineFill#%=%0* %{strftime("%H:%M:%S")} '
	return s
endfunction

hi TabLine      ctermbg=240 ctermfg=231 cterm=bold
hi TabLineFill  ctermbg=236 ctermfg=231 cterm=bold
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

set showtabline=2
set tabline=%!Tabline()

"au! CursorHold *.[ch] nested call Refresh()
