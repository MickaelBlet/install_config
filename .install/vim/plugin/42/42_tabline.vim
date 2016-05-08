let g:font = 1

function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tab = i + 1
		if i == 0
			let s.= ''
		elseif i == tabpagenr()
			let s .= '%#TabLineSelIconF#'
			let s .= (g:font) ? ' ' : " "
		elseif tab == tabpagenr()
			let s .= '%#TabLineSelIconS#'
			let s .= (g:font) ? ' ' : " "
		else
			let s .= (g:font) ? ' ' : " "
		endif
		let winnr = tabpagewinnr(tab)
		let buflist = tabpagebuflist(tab)
		let bufnr = buflist[winnr - 1]
		let bufname = bufname(bufnr)
		let bufmodified = getbufvar(bufnr, "&mod")

		let s .= '%' . tab . 'T'
		let s .= ((tab == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#')
		if bufmodified
			let s .= '+'
		elseif i == 0
			let s .= ' '
		else
			let s .= ''
		endif
		"" #      

		let s .= (bufname != '' ? ''. fnamemodify(bufname, ':t') . ' ' : '[No Name] ')
	endfor

	if (tab == tabpagenr())
		let s .= '%#TabLineSelIconE#'
	else
		let s.= '%#TabLineIconE#'
	endif
	let s .= (g:font) ? ' ' : ""

	let s .= '%#TabLineFill#%=%#TabLineClose#%999X'

	let s .= (g:font) ? '' : "X"
	"' %0* %{strftime("%H:%M")} '
	return s
endfunction

hi	TabLine			ctermbg=237	ctermfg=231	cterm=bold
hi	TabLineIcon		ctermbg=236	ctermfg=240	cterm=NONE
hi	TabLineIconE	ctermbg=245	ctermfg=237	cterm=NONE
hi	TabLineSel		ctermbg=25	ctermfg=231	cterm=NONE
hi	TabLineSelIconF	ctermbg=237	ctermfg=25	cterm=NONE
hi	TabLineSelIconS	ctermbg=25	ctermfg=237	cterm=NONE
hi	TabLineSelIconE	ctermbg=245	ctermfg=25	cterm=NONE
hi	TabLineFill		ctermbg=245	ctermfg=231	cterm=bold
hi	TabLineClose	ctermfg=232	ctermbg=160	cterm=NONE

set showtabline=2
set tabline=%!Tabline()

"au! CursorHold *.[ch] nested call Refresh()
