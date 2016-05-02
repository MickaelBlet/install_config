" File:        tabline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/>
" Description: Configure tabs within Terminal Vim.
" Last Change: 2012-10-21
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" Based On:    http://www.offensivethinking.org/data/dotfiles/vimrc

" Bail quickly if the plugin was loaded, disabled or compatible is set
if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
	finish
endif
let g:loaded_tabline_vim = 1

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

		"if bufmodified
			"let s .= "\*"
		"endif
	endfor

	let s .= '%#TabLineFill#%=%0* %{strftime("%H:%M")} '
	return s
endfunction

hi TabLine      ctermbg=240 ctermfg=231 cterm=bold
hi TabLineFill  ctermbg=236 ctermfg=231 cterm=bold
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

set showtabline=2
set tabline=%!Tabline()
