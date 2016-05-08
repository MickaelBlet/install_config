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


let g:font = 0

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

function!	StatusLine()
	let s = ''
	let bufnr = bufnr('%')
	let bufname = fnamemodify(bufname(bufnr), ':t')
	let bufmodified = getbufvar(bufnr, "&mod")
	let statemod = mode()
	if statemod == 'v' || statemod == 'V'
		let statemod = 'visual'
	elseif statemod == 'i'
		let statemod = 'insert'
	elseif statemod == 'n'
		let statemod = 'normal'
	endif
	if bufmodified
		let s .= '%#MSLName#'
		let s .= ' ' . bufname . ' '
	else
		let s .= '%#SLName#'
		let s .= ' ' . bufname . ' '
	endif
	if bufmodified
		let s .= '%#MSLNameIcon#'
		let s .= (g:font) ? ' ' : ""
		let s .= '%#MSLSep#'
	elseif statemod == 'insert'
		let s .= '%#ISLNameIcon#'
		let s .= (g:font) ? ' ' : ""
		let s .= '%#ISLSep#'
	elseif statemod == 'visual'
		let s .= '%#VSLNameIcon#'
		let s .= (g:font) ? ' ' : ""
		let s .= '%#VSLSep#'
	else
		let s .= '%#SLNameIcon#'
		let s .= (g:font) ? ' ' : ""
		let s .= '%#SLSep#'
	endif
	let s .= '%='
	if expand('%:e') ==? "c" || expand('%:e') ==? "h"
		let s .= s:StatusLineNorme(bufmodified, statemod)
	else
		let s .= s:StatusLineCommon(bufmodified, statemod)
	endif

	let c_state = 'N'
	if statemod == 'insert'
		let c_state = 'I'
	elseif statemod == 'visual'
		let c_state = 'V'
	endif

	let s .= '%#' . c_state . 'SLLineFile#'
	let s .= ' %3l/%3L '
	let s .= '%#' . c_state . 'SLLineFileIcon#'
	let s .= (g:font) ? '' : ""
	let s .= '%#' . c_state . 'SLPaste#'
	let s .= ' ' . s:Paste() . ' '
	let s .= '%#' . c_state . 'SLPasteIcon#'
	let s .= (g:font) ? '' : ""
	let s .= '%#' . c_state . 'SLState#'
	let s .= ' ' . s:Input() . ' '
	let s .= '%#' . c_state . 'SLStateIcon#'
	let s .= (g:font) ? '' : ""
	let s .= '%#' . c_state . 'SLType#'
	let s .= ' [%Y] '
	return s
endfunction

function!	s:StatusLineNorme(bufmodified, statemod)
	let bufmodified = a:bufmodified
	let statemod = a:statemod
	let s = ''

	let charcount = virtcol('$') - 1
	let funclinecount = s:GetFuncLineCount()
	let funccount = s:GetFuncCount()

	let c_state = 'N'
	if statemod == 'insert'
		let c_state = 'I'
	elseif statemod == 'visual'
		let c_state = 'V'
	endif
	let c_charcount = (charcount <= 80) ? 'V' : 'E'
	let c_funclinecount = (funclinecount <= 25) ? 'V' : 'E'
	let c_funccount = (funccount <= 5) ? 'V' : 'E'

	if bufmodified
		let s .= '%#MSLSepIconNorm' . c_charcount . '#'
	else
		let s .= '%#' . c_state . 'SLSepIconNorm' . c_charcount . '#'
	endif
	let s .= (g:font) ? '' : ""
	" CHAR COUNT
	let s .= '%#SLNbChar' . c_charcount . '#'
	let s .= ' '.s:PrePad(charcount, 2).'/80 '
	if funclinecount > -1 && funccount > -1
		let s .= '%#SLNbChar' . c_charcount . 'IcontoFuncLine' . c_funclinecount . '#'
		let s .= (g:font) ? '' : ""
		let s .= '%#SLFuncLine' . c_funclinecount . '#'
		let s .= ' '.s:PrePad(funclinecount, 2).'/25 '
		let s .= '%#SLFuncLine' . c_funclinecount . 'IcontoNbFunc' . c_funccount . '#'
		let s .= (g:font) ? '' : ""
		let s .= '%#SLNbFunc' . c_funccount . '#'
		let s .= ' '.funccount.'/5 '
		let s .= '%#' . c_state . 'SLNbFunc' . c_funccount . 'Icon#'
		let s .= (g:font) ? '' : ""
	elseif funccount > -1
		let s .= '%#SLNbChar' . c_charcount . 'IcontoNbFunc' . c_funccount . '#'
		let s .= (g:font) ? '' : ""
		let s .= '%#SLNbFunc' . c_funccount . '#'
		let s .= ' '.funccount.'/5 '
		let s .= '%#' . c_state . 'SLNbFunc' . c_funccount . 'Icon#'
		let s .= (g:font) ? '' : ""
	else
		let s .= '%#' . c_state . 'SLNbChar' . c_funccount . 'Icon#'
		let s .= (g:font) ? '' : ""
	endif
	return s
endfunction

function!	s:StatusLineCommon(bufmodified, statemod)
	let bufmodified = a:bufmodified
	let statemod = a:statemod
	let s = ''

	let c_state = 'N'
	if statemod == 'insert'
		let c_state = 'I'
	elseif statemod == 'visual'
		let c_state = 'V'
	endif

	if bufmodified
		let s .= '%#M' . c_state . 'SLCharCountIcon#'
	else
		let s .= '%#' . c_state . 'SLCharCountIcon#'
	endif
	let s .= (g:font) ? '' : ""
	let s .= '%#' . c_state . 'SLPaste#'
	let s .= ' %2c/%2 ' . col('$') . ' '
	let s .= '%#' . c_state . 'SLPasteIconR#'
	let s .= (g:font) ? '' : ""
	return s
endfunction

function!	s:GetFuncLineCount()
	let mycount = -1
	let line = line('.')
	while empty(matchstr(getline(line), '^{'))
		if line < 1
			return -1
		endif
		if !empty(matchstr(getline(line), '^}')) && line != line('.')
			return -1
		endif
		let line -= 1
	endwhile
	while empty(matchstr(getline(line), '^}$'))
		if line == line('$')
			return -1
		endif
		if !empty(matchstr(getline(line), '^}.*;'))
			return -1
		endif
		let line += 1
		let mycount += 1
	endwhile
	return mycount
endfunction

function!	s:GetFuncCount()
	let mycount = -1
	let line = 0
	while line < line('$')
		if !empty(matchstr(getline(line - 1), '^\t*\i.*'))
					\&& empty(matchstr(getline(line - 1), '^struct'))
					\&& empty(matchstr(getline(line - 1), '^enum'))
					\&& empty(matchstr(getline(line - 1), '^union'))
					\&& empty(matchstr(getline(line - 1), '^typedef'))
					\&& !empty(matchstr(getline(line), '^{'))
			if mycount == -1
				let mycount = 0
			endif
			let mycount += 1
		endif
		let line += 1
	endwhile
	return mycount
endfunction

function! s:Paste()
	if &paste
		return " PASTE "
	else
		return "NOPASTE"
	endif
endfunction

function! s:Input()
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
	return string
endfunction

function! s:PrePad(s,amt,...)
	if a:0 > 0
		let char = a:1
	else
		let char = ' '
	endif
	return repeat(char, a:amt - len(a:s)) . a:s
endfunction

"COLOR

"MOD COLOR
hi!	MSLName						ctermbg=221	ctermfg=232	cterm=bold
hi!	MSLNameIcon					ctermbg=229	ctermfg=221
hi!	MSLSep						ctermbg=229	ctermfg=0
hi!	MSLSepIconNormV				ctermbg=229	ctermfg=34
hi!	MSLSepIconNormE				ctermbg=229	ctermfg=160

"INSERT COLOR
hi!	ISLNameIcon					ctermbg=24	ctermfg=238
hi!	ISLSep						ctermbg=24	ctermfg=0
hi!	ISLSepIconNormV				ctermbg=24	ctermfg=34
hi!	ISLSepIconNormE				ctermbg=24	ctermfg=160
hi! ISLLineFile					ctermbg=31	ctermfg=231
hi! ISLLineFileIcon				ctermbg=31	ctermfg=117
hi! ISLPaste					ctermbg=117	ctermfg=23
hi! ISLPasteIcon				ctermbg=117	ctermfg=231
hi! ISLState					ctermbg=231	ctermfg=23	cterm=bold
hi! ISLStateIcon				ctermbg=231	ctermfg=245
hi! ISLType						ctermbg=245	ctermfg=232	cterm=bold

"VISUAL COLOR
hi!	VSLNameIcon					ctermbg=70	ctermfg=238
hi!	VSLSep						ctermbg=70	ctermfg=0
hi!	VSLSepIconNormV				ctermbg=70	ctermfg=34
hi!	VSLSepIconNormE				ctermbg=70	ctermfg=160
hi! VSLLineFile					ctermbg=22	ctermfg=148
hi! VSLLineFileIcon				ctermbg=22	ctermfg=70
hi! VSLPaste					ctermbg=70	ctermfg=22
hi! VSLPasteIcon				ctermbg=70	ctermfg=148
hi! VSLState					ctermbg=148	ctermfg=22	cterm=bold
hi! VSLStateIcon				ctermbg=148	ctermfg=245
hi! VSLType						ctermbg=245	ctermfg=232	cterm=bold

"NORMAL COLOR
hi!	NSLNameIcon					ctermbg=236	ctermfg=238
hi!	NSLSep						ctermbg=236	ctermfg=0
hi!	NSLSepIconNormV				ctermbg=236	ctermfg=34
hi!	NSLSepIconNormE				ctermbg=236	ctermfg=160
hi! NSLLineFile					ctermbg=238	ctermfg=231
hi! NSLLineFileIcon				ctermbg=238	ctermfg=236
hi! NSLPaste					ctermbg=236	ctermfg=231
hi! NSLPasteIcon				ctermbg=236	ctermfg=130
hi! NSLState					ctermbg=130	ctermfg=231	cterm=bold
hi! NSLStateIcon				ctermbg=130	ctermfg=245
hi! NSLType						ctermbg=245	ctermfg=232	cterm=bold

"COMMON COLOR
hi! MISLCharCountIcon			ctermbg=229	ctermfg=117
hi! MVSLCharCountIcon			ctermbg=229	ctermfg=70
hi! MNSLCharCountIcon			ctermbg=229	ctermfg=236
hi! ISLCharCountIcon			ctermbg=24	ctermfg=117
hi! VSLCharCountIcon			ctermbg=70	ctermfg=70
hi! NSLCharCountIcon			ctermbg=236	ctermfg=236
hi! ISLPasteIconR				ctermbg=117	ctermfg=31
hi! VSLPasteIconR				ctermbg=70	ctermfg=22
hi! NSLPasteIconR				ctermbg=236	ctermfg=238

"NORM COLOR
hi! SLNbCharV					ctermbg=34	ctermfg=231
hi! SLNbCharE					ctermbg=160 ctermfg=231
hi!	SLNbCharVIcontoFuncLineV	ctermbg=34	ctermfg=28
hi!	SLNbCharEIcontoFuncLineV	ctermbg=160	ctermfg=28
hi!	SLNbCharVIcontoFuncLineE	ctermbg=34	ctermfg=196
hi!	SLNbCharEIcontoFuncLineE	ctermbg=160	ctermfg=196
hi!	SLNbCharVIcontoNbFuncV		ctermbg=34	ctermfg=22
hi!	SLNbCharEIcontoNbFuncV		ctermbg=160	ctermfg=22
hi!	SLNbCharVIcontoNbFuncE		ctermbg=34	ctermfg=124
hi!	SLNbCharEIcontoNbFuncE		ctermbg=160	ctermfg=124
hi!	ISLNbCharVIcon				ctermbg=34	ctermfg=31
hi!	ISLNbCharEIcon				ctermbg=160	ctermfg=31
hi!	VSLNbCharVIcon				ctermbg=34	ctermfg=22
hi!	VSLNbCharEIcon				ctermbg=160	ctermfg=22
hi!	NSLNbCharVIcon				ctermbg=34	ctermfg=238
hi!	NSLNbCharEIcon				ctermbg=160	ctermfg=238
hi! SLFuncLineV					ctermbg=28	ctermfg=231
hi! SLFuncLineE					ctermbg=196 ctermfg=231
hi!	SLFuncLineVIcontoNbFuncV	ctermbg=28	ctermfg=22
hi!	SLFuncLineEIcontoNbFuncV	ctermbg=196	ctermfg=22
hi!	SLFuncLineVIcontoNbFuncE	ctermbg=28	ctermfg=124
hi!	SLFuncLineEIcontoNbFuncE	ctermbg=196	ctermfg=124
hi!	ISLFuncLineVIcon			ctermbg=28	ctermfg=31
hi!	ISLFuncLineEIcon			ctermbg=196	ctermfg=31
hi!	VSLFuncLineVIcon			ctermbg=28	ctermfg=22
hi!	VSLFuncLineEIcon			ctermbg=196	ctermfg=22
hi!	NSLFuncLineVIcon			ctermbg=28	ctermfg=238
hi!	NSLFuncLineEIcon			ctermbg=196	ctermfg=238
hi! SLNbFuncV					ctermbg=22	ctermfg=231
hi! SLNbFuncE					ctermbg=124 ctermfg=231
hi!	ISLNbFuncVIcon				ctermbg=22	ctermfg=31
hi!	ISLNbFuncEIcon				ctermbg=124	ctermfg=31
hi!	VSLNbFuncVIcon				ctermbg=22	ctermfg=22
hi!	VSLNbFuncEIcon				ctermbg=124	ctermfg=22
hi!	NSLNbFuncVIcon				ctermbg=22	ctermfg=238
hi!	NSLNbFuncEIcon				ctermbg=124	ctermfg=238

hi!	SLName						ctermbg=238	ctermfg=231	cterm=bold
hi!	SLNameIcon					ctermbg=236	ctermfg=238	cterm=bold
hi!	SLSep						ctermbg=236	ctermfg=0

set laststatus=2
set statusline=%!StatusLine()
