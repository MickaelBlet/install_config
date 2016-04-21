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

highlight Parenthesis		ctermfg=160 term=bold cterm=bold
highlight NotAutorised		ctermbg=88
highlight MyError			ctermbg=darkred
highlight MyWarning			ctermbg=166

let s:errornorm = 0

let s:errornorm += matchadd('MyError', '\%#\@<!\s\+\%#\@<!$', -1) " Space Error
let s:errornorm += matchadd('MyError', '\t\zs \+', -1) " Space Error
let s:errornorm += matchadd('MyError', ' \+\ze\t', -1) " Space Error
let s:errornorm += matchadd('MyError', '^\%#\@<!\n\(\_.\+\)\@!', -1) " Last Line

autocmd BufNewFile,BufRead *.c		call Norme()
autocmd BufNewFile,BufRead *.h		call Norme()
autocmd BufNewFile,BufRead *.cpp	call NormeCpp()

function NormeCpp()
	" Format comments norme 42
	set comments=sr:/*,mr:**,er:*/
endfunction

function Norme()
	" Format comments norme 42
	set comments=sr:/*,mr:**,er:*/

	" C++ Comment
	let s:errornorm += matchadd('NotAutorised', '\%(\*\*.*\)\@<!\/\/.*', -1)
	" > 80 COLLUM
	let s:errornorm += matchadd('MyError', '\%>80v.\+', -1)

	" Double return
	let s:errornorm += matchadd('MyError', '^\%#\@<!\n\(^\%#\@<!\n\)\+', -1)
	" TAB in parenthesis
	let s:errornorm += matchadd('MyError', '\(#.*\|\*\*.*\|\/\*.*\)\@<!(.*\zs\t\ze.*)', -1)
	" ';' AFTER while WHIT TAB
	let s:errornorm += matchadd('MyError', '^\t.*\<while\>.*\zs;$', -1)
	" ';' AFTER if WHIT TAB
	let s:errornorm += matchadd('MyError', '^\t.*\<if\>.*\zs;$', -1)

	" 'SPACE' AFTER @ WHIT TAB
	let s:errornorm += matchadd('MyError', '\(^\t\(\<\i\+\> *\)\+\)\@<= \ze\**\i\+;', -1)

	" TAB BEFORE ','
	let s:errornorm += matchadd('MyError', '\s\ze,', -1)
	" TAB BEFORE '_'
	let s:errornorm += matchadd('MyError', ' \ze)', -1)

	" TAB AFTER '('
	let s:errornorm += matchadd('MyError', '(\zs ', -1)

	" SPACE & TAB
	let s:errornorm += matchadd('MyError', '\<if\>\zs \@!', -1)
	let s:errornorm += matchadd('MyError', '\<while\>\zs \@!', -1)
	let s:errornorm += matchadd('MyError', '\<return\>\zs \@!', -1)
	let s:errornorm += matchadd('MyError', '\<continue\>\zs \@!', -1)
	let s:errornorm += matchadd('MyError', '\<break\>\zs \@!', -1)
	let s:errornorm += matchadd('MyError', '\<return\> \zs\i.*\>', -1)

	" ';'
	let s:errornorm += matchadd('MyWarning', '\(\%#.*\|#.*\|\*\/.*\|\*\*.*\|\/\/.*\|\/\*.*\|{\|}\|;\|^\|\<if\>.*\|\<else\>.*\|\<while\>.*\|||.*\|&&.*\|,\|+\|-\|\*\|/\|%\)\@<!\n\(.*{\|\t\+\(+\|-\|*\|/\|%\|&&\|||\)\)\@!', -1)

	" SPACE BEFORE ';'
	let s:errornorm += matchadd('MyError', '\(continue\|break\|return\|\t\+\)\@<!\s\ze;', -1)

	" +25 line / func
	let s:errornorm += matchadd('MyError', '\(^{\n\)\ze\(^.*\n\(^}\)\@!\)\{25}\(^.*\n\(^\i\)\@!\)*\(^}\n\)', -1)

	" 2 return / func
	let s:errornorm += matchadd('MyError', '\(^{\n\)\(.\+\n\(^}\)\@!\)\+\n\+\(.\+\n\(^}\)\@!\)\+\zs\%#\@<!\n\+\ze', -1)

	" no MAJ after define
	let s:errornorm += matchadd('MyError', '# *\<define\>\s\+\zs\(\<\([0-9A-Z_]\)*\>\)\@!\i*', -1)

	" no MAJ after ifndef
	let s:errornorm += matchadd('MyError', '# *\<ifndef\>\s\+\zs\(\<\([0-9A-Z_]\)*\>\)\@!\i*', -1)

	" Syntax norme
	let &syntax=&syntax

	syntax match notAutorised '\<printf\>'
	syntax match notAutorised '\%<12l\(\/.*\)\@<!\i\+'

	highlight link notAutorised NotAutorised

	highlight MyNorme			cterm=italic ctermfg=darkred ctermbg=black

	" Double Space
	syntax match myNorme '\(# *\)\@<!  \+'

	" Triple Tab
	syntax match myNorme '\(\t\+[^\t]\+\)\@<=\t\+\ze[^\t]\+\t\+'

	" ' ' || '\t' before ','
	syntax match myNorme '\s\ze,'

	" ' ' || '\t' before ']'
	syntax match myNorme '\s\ze\]'
	" ' ' || '\t' after '['
	syntax match myNorme '\(\[\)\@<=\s'

	" ' ' after ','
	syntax match myNorme ',\ze.\( \)\@<!'

	" ' ' after '||'
	syntax match myNorme '\(||\)\ze.\( \)\@<!'
	" ' ' after '&&'
	syntax match myNorme '\(&&\)\ze.\( \)\@<!'
	" ' ' after '=='
	syntax match myNorme '\(==\)\ze.\( \)\@<!'
	" ' ' after '!='
	syntax match myNorme '\(!=\)\ze.\( \)\@<!'
	" ' ' before '||'
	syntax match myNorme '\(\S\)\@<=\(||\)'
	" ' ' before '&&'
	syntax match myNorme '\(\S\)\@<=\(&&\)'
	" ' ' before '=='
	syntax match myNorme '\(\S\)\@<=\(==\)'
	" ' ' before '!='
	syntax match myNorme '\(\S\)\@<=\(!=\)'
	" ' ' after '='
	syntax match myNorme '=\ze.\( \|=\)\@<!'
	" ' ' after '%'
	syntax match myNorme '%\ze.\( \|=\)\@<!'

	" ' ' before '++'
	syntax match myNorme '\(\[\)\@<=\s\ze++'

	syntax match myNorme '\(\/\*.*\)\@!\/\ze.\( \|=\)\@<!'
	" OTHER BEFORE '/'
	syntax match myNorme '\(\S\)\@<=\/'
	" * BEFORE '='
	syntax match myNorme '\(\/\|\*\|%\|+\|-\|&\|>>\|<<\|!\|=\)\@!\(\S\)\@<=='
	" OTHER BEFORE '%'
	syntax match myNorme '\(\S\)\@<=%'
	" OTHER BEFORE '*'
	syntax match myNorme '\(\S|)\)\@<=\(!\|\*\|(\|\[\)\@<!\*'

	" ' ' after '+'
	syntax match myNorme '\(+\)\@!.\zs+\ze.\( \|+\|=\)\@<!'
	" OTHER BEFORE '+'
	syntax match myNorme '\(\]\|)\| \|+\|\( .*\)\@<!\t\)\@!.\zs+\ze.\(+\|=\)\@<!'
	syntax match myNorme '\( [0-9]\)\@<=+'
	" OTHER BEFORE '-'
	syntax match myNorme '\(\]\|)\| \|-\)\@!.\zs-\ze.\(-\|=\|>\)\@<!'
	syntax match myNorme '\( [0-9]\|\]\)\@<=-\ze.\(>\)\@<!'
	" CAST "
	syntax match myNorme '\()\)\@<!\<malloc\>'

	highlight link myNorme MyNorme

endfunction
