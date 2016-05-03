""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        ________ ++     ________                                "
"       /VVVVVVVV\++++  /VVVVVVVV\                               "
"       \VVVVVVVV/++++++\VVVVVVVV/                               "
"        |VVVVVV|++++++++/VVVVV/'                                "
"        |VVVVVV|++++++/VVVVV/'              :::      ::::::::   "
"       +|VVVVVV|++++/VVVVV/'+             :+:      :+:    :+:   "
"     +++|VVVVVV|++/VVVVV/'+++++         +:+ +:+         +:+     "
"   +++++|VVVVVV|/VVVVV/'+++++++++     +#+  +:+       +#+        "
"     +++|VVVVVVVVVVV/'+++++++++     +#+#+#+#+#+   +#+           "
"       +|VVVVVVVVV/'+++++++++           #+#    #+#              "
"        |VVVVVVV/'+++++++++            ###   ########.fr        "
"        |VVVVV/'+++++++++                                       "
"        |VVV/'+++++++++                                         "
"        'V/'   ++++++                                           "
"                 ++                                             "
"                       <mblet@student.42.fr>                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" #      

let g:font = 1

hi!	SLName			ctermbg=231		ctermfg=238		cterm=bold
hi!	SLNameIcon		ctermbg=231		ctermfg=238		cterm=bold
hi!	SLSep			ctermbg=231		ctermfg=238		cterm=bold
hi!	SLSepIcon		ctermbg=231		ctermfg=238		cterm=bold
hi!	SLLineFunc		ctermbg=231		ctermfg=238		cterm=bold
hi!	SLLineFuncIcon	ctermbg=231		ctermfg=238		cterm=bold

hi!	StatusLineSep	ctermbg=231		ctermfg=238		cterm=bold

hi! User1	ctermbg=231		ctermfg=238		cterm=bold
hi! User2	ctermbg=240		ctermfg=0
hi! User3	ctermbg=22		ctermfg=15
hi! User4	ctermbg=28		ctermfg=15
hi! User5	ctermbg=238		ctermfg=15
hi! User6	ctermbg=236		ctermfg=15
hi! User7	ctermbg=130		ctermfg=231
hi! User8	ctermbg=245		ctermfg=232		cterm=bold
hi! User9	ctermbg=34		ctermfg=15

set statusline=
set statusline+=%1*\ %t\ %*
set statusline+=%2*%=%*
set statusline+=%6*\ %2c/%2{col('$')}\ %*
set statusline+=%5*\ %3l/%3L\ %*
set statusline+=%6*\ %{Paste()}\ %*
set statusline+=%7*\ %{Input()}\ %*
set statusline+=%8*\ [%Y]\ %*

autocmd BufNewFile,BufRead *.c	call StatusLine_C()
autocmd BufNewFile,BufRead *.h	call StatusLine_C()
autocmd BufWrite			*	call After_save()
autocmd BufNewFile,BufRead	*	call After_save()

function! StatusLine_C()
	if g:font
		set statusline=
		set statusline+=%#StatusLineName#\ %t\ %*
		set statusline+=%#StatusLineNameIcon#%{''}\ %*
		set statusline+=%2*%=%*
		set statusline+=%3*%{Line_Func()}%*
		set statusline+=%4*\ %{Line_Count()}/80\ %*
		set statusline+=%9*%{Count_Func()}%*
		set statusline+=%5*\ %3l/%3L\ %*
		set statusline+=%6*\ %{Paste()}\ %*
		set statusline+=%7*\ %{Input()}\ %*
		set statusline+=%8*\ [%Y]\ %*
	else
		set statusline=
		set statusline+=%#StatusLineName#\ %t\ %*
		set statusline+=%2*%=%*
		set statusline+=%3*%{Line_Func()}%*
		set statusline+=%4*\ %{Line_Count()}/80\ %*
		set statusline+=%9*%{Count_Func()}%*
		set statusline+=%5*\ %3l/%3L\ %*
		set statusline+=%6*\ %{Paste()}\ %*
		set statusline+=%7*\ %{Input()}\ %*
		set statusline+=%8*\ [%Y]\ %*
	endif
endfunction

au InsertLeave * call	Input()

let g:line_func = 0
let g:count_func = 0
let g:line_caract = 0
let g:last_state = ""
let g:last_color_line_func = ""
let g:last_color_line_caract = ""
let g:ismodifed = 0

function! PrePad(s,amt,...)
	if a:0 > 0
		let char = a:1
	else
		let char = ' '
	endif
	return repeat(char, a:amt - len(a:s)) . a:s
endfunction

function! Line_Func()
	let g:line_func = -1
	let ligne = line('.')
	if empty(matchstr(getline(ligne), '^}'))
		while empty(matchstr(getline(ligne), '^{'))
			if ligne < 1
				let g:line_func = -1
				return ""
			endif
			if !empty(matchstr(getline(ligne), '^}'))
				let g:line_func = -1
				return ""
			endif
			let ligne -= 1
		endwhile
	else
		while empty(matchstr(getline(ligne), '^{'))
			if ligne < 1
				let g:line_func = -1
				return ""
			endif
			let ligne -= 1
		endwhile
	endif
	let save_begin = ligne
	while empty(matchstr(getline(ligne), '^}$'))
		if ligne == line('$')
			let g:line_func = -1
			return ""
		endif
		if !empty(matchstr(getline(ligne), '^}.*;'))
			let g:line_func = -1
			return ""
		endif
		let ligne += 1
		let g:line_func += 1
	endwhile
	"highlight SignColumn cterm=NONE ctermbg=NONE
	"highlight SignColor ctermfg=white ctermbg=22
	"sign unplace *
	"if g:line_func < 100
	"if g:line_func < 10
	"exe 'sign define SignSymbol'.ligne.' text=⭐ texthl=SignColor'
	"else
	"exe 'sign define SignSymbol'.ligne.' text='.g:line_func.' texthl=SignColor'
	"endif
	"exe 'sign place 1 line='. save_begin .' name=SignSymbol'.ligne.' buffer=' . winbufnr(1)
	"exe 'sign place 1 line='. ligne .' name=SignSymbol'.ligne.' buffer=' . winbufnr(1)
	"endif
	return "\ ".PrePad(g:line_func, 2)."/25\ "
endfunction

function! Count_Func()
	let g:count_func = 0
	let l:prepadn = 1
	let ligne = 0
	while ligne < line('$')
		if !empty(matchstr(getline(ligne - 1), '^\t*\i.*')) && empty(matchstr(getline(ligne - 1), '^struct')) && empty(matchstr(getline(ligne - 1), '^enum')) && empty(matchstr(getline(ligne - 1), '^union')) && empty(matchstr(getline(ligne - 1), '^typedef')) && !empty(matchstr(getline(ligne), '^{'))
			let g:count_func += 1
		endif
		let ligne += 1
	endwhile
	if g:count_func > 0
		return "\ ".PrePad(g:count_func, l:prepadn). "/5\ "
	els
		return ""
	endif
endfunction

function! Line_Count()
	let g:line_caract = virtcol('$') - 1
	return PrePad(g:line_caract, 2)
endfunc

function! Paste()
	let passed = &paste
	if passed == 1
		return " PASTE "
	else
		return "NOPASTE"
	endif
endfunction

function! Color_to_insert()
	let l:modifier = &modified
	if l:modifier == 0
		hi! StatusLineName		ctermbg=238 ctermfg=231 cterm=bold
		hi! StatusLineNameIcon	ctermbg=24 ctermfg=238 cterm=bold
		hi! User2		ctermbg=24 ctermfg=0
	else
		hi! StatusLineName		ctermbg=221 ctermfg=232 cterm=bold
		hi! StatusLineNameIcon	ctermbg=229 ctermfg=221 cterm=bold
		hi! User2		ctermbg=229 ctermfg=0
	endif
	if g:count_func > 5
		hi! User9		ctermbg=160 ctermfg=15
	else
		hi! User9		ctermbg=34 ctermfg=15
	endif
	if g:line_func > 25
		hi! User3		ctermbg=160 ctermfg=15
	else
		hi! User3		ctermbg=22 ctermfg=15
	endif
	if g:line_caract > 80
		hi! User4		ctermbg=160 ctermfg=15
	else
		hi! User4		ctermbg=28 ctermfg=15
	endif
	hi! User5			ctermbg=31 ctermfg=15
	hi! User6			ctermbg=117 ctermfg=23
	hi! User7			ctermbg=231 ctermfg=23 cterm=bold
	hi! User8			ctermbg=245 ctermfg=232 cterm=bold
endfunction

function! Color_to_visual()
	let l:modifier = &modified
	hi! User1			ctermbg=238 ctermfg=231 cterm=bold
	if l:modifier == 0
		hi! User1		ctermbg=238 ctermfg=231 cterm=bold
		hi! User2		ctermbg=70 ctermfg=0
	else
		hi! User1		ctermbg=221 ctermfg=232 cterm=bold
		hi! User2		ctermbg=229 ctermfg=0
	endif
	if g:count_func > 5
		hi! User9		ctermbg=160 ctermfg=15
	else
		hi! User9		ctermbg=34 ctermfg=15
	endif
	if g:line_func > 25
		hi! User3		ctermbg=160 ctermfg=15
	else
		hi! User3		ctermbg=22 ctermfg=15
	endif
	if g:line_caract > 80
		hi! User4		ctermbg=160 ctermfg=15
	else
		hi! User4		ctermbg=28 ctermfg=15
	endif
	hi! User5			ctermbg=22 ctermfg=148
	hi! User6			ctermbg=70 ctermfg=22
	hi! User7			ctermbg=148 ctermfg=22 cterm=bold
	hi! User8			ctermbg=245 ctermfg=232 cterm=bold
endfunction

function! Color_to_normal()
	let l:modifier = &modified
	if l:modifier == 0
		hi! User1		ctermbg=238 ctermfg=231 cterm=bold
		hi! User2		ctermbg=236 ctermfg=0
	else
		hi! User1		ctermbg=221 ctermfg=232 cterm=bold
		hi! User2		ctermbg=229 ctermfg=0
	endif
	if g:count_func > 5
		hi! User9		ctermbg=160 ctermfg=15
	else
		hi! User9		ctermbg=34 ctermfg=15
	endif
	if g:line_func > 25
		hi! User3		ctermbg=196 ctermfg=15
	else
		hi! User3		ctermbg=22 ctermfg=15
	endif
	if g:line_caract > 80
		hi! User4		ctermbg=160 ctermfg=15
	else
		hi! User4		ctermbg=28 ctermfg=15
	endif
	hi! User5			ctermbg=238 ctermfg=15
	hi! User6			ctermbg=236 ctermfg=15
	hi! User7			ctermbg=130 ctermfg=231
	hi! User8			ctermbg=245 ctermfg=232 cterm=bold
endfunction

function! Input()
	let mode = mode()
	let string = "[" . mode() . "]"
	if mode == 'v' || mode == 'V'
		let string = "VISUAL"
	elseif mode == 'i'
		let string = "INSERT"
	elseif mode == 'R' || mode == 'Rv'
		let string = "REPLAC"
	elseif mode == 'c'
		let string = "CMDLIN"
	elseif mode == 'n'
		let string = "NORMAL"
	elseif mode == 's' || mode == 'S'
		let string = "SELECT"
	endif
	if (g:ismodifed != &modified)
				\ || (mode != g:last_state)
				\ || (g:line_func != g:last_color_line_func)
				\ || (g:line_caract > 80 && g:last_color_line_caract <= 80)
				\ || (g:line_caract <= 80 && g:last_color_line_caract > 80)
		call Refresh_status_line()
	endif
	let g:ismodifed = &modified
	let g:last_state = mode
	let g:last_color_line_func = g:line_func
	let g:last_color_line_caract = g:line_caract
	return string
endfunction

function! Refresh_status_line()
	let mode = mode()
	if mode == 'v' || mode == 'V'
		call Color_to_visual()
	elseif mode == 'i'
		call Color_to_insert()
	elseif mode == 'n'
		call Color_to_normal()
	endif
endfunction

function! After_save()
	let &modified = 0
	call Refresh_status_line()
endfunction
