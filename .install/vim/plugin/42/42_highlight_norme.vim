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
highlight NotAutorised		ctermbg=52
highlight MyError			ctermbg=darkred
highlight MyWarning			ctermbg=166

highlight MyNorme			cterm=italic ctermfg=darkred ctermbg=black

" When vim open
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

	let s:errornorm = 0

	" Last empty line
	let s:errornorm += matchadd('MyNorme', '^\%#\@<!\n\(\_.\+\)\@!', -1)

	" > 80 COLLUM
	let s:errornorm += matchadd('MyNorme', '\%81v.', -1)

	" C++ Comment
	let s:errornorm += matchadd('NotAutorised', '\%(\*\*.*\)\@<!\/\/.*', -1)

	" Double return
	let s:errornorm += matchadd('MyError', '^\%#\@<!\n\(^\%#\@<!\n\)\+', -1)
	" TAB in parenthesis
	let s:errornorm += matchadd('MyError', '\(#.*\|\*\*.*\|\/\*.*\)\@<!(.*\zs\t\ze.*)', -1)
	" ';' AFTER while or if WHIT TAB
	let s:errornorm += matchadd('MyError', '^\t.*\<\(while\|if\)\>.*\zs;$', -1)

	" 'SPACE' AFTER @ WHIT TAB
	let s:errornorm += matchadd('MyError', '\(^\t\(\<\i\+\> *\)\+\)\@<= \ze\**\i\+;', -1)

	" TAB BEFORE ','
	let s:errornorm += matchadd('MyError', '\s\ze,', -1)
	" TAB BEFORE '_'
	let s:errornorm += matchadd('MyError', ' \ze)', -1)

	" TAB AFTER '('
	let s:errornorm += matchadd('MyError', '(\zs ', -1)

	" SPACE & TAB
	let s:errornorm += matchadd('MyError', '\<return\> \zs\i.*\>', -1)

	" ';'
	let s:errornorm += matchadd('MyWarning', '\(\%#.*\|#.*\|\*\/.*\|\*\*.*\|\/\/.*\|\/\*.*\|{\|}\|;\|^\|\<if\>.*\|\<else\>.*\|\<while\>.*\|,\n.*\|||.*\|&&.*\|,\|+\|-\|\*\|/\|%\)\@<!\n\(.*{\|\t\+\(+\|-\|*\|/\|%\|&&\|||\)\)\@!', -1)

	" ' ' after common utility
	let s:errornorm += matchadd('MyError', '\<\(if\|while\|continue\|break\|return\)\>\zs\( \)\@!', -1)

	" ' ' before ';'
	let s:errornorm += matchadd('MyError', '\(\<\(continue\|break\|return\)\>\|^\t\+\)\@<!\s\ze;', -1)

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

	" >25 lines / function
	syntax match myNorme '\(^{\n\)\ze\(^.*\n\(^}\)\@!\)\{25}\(^.*\n\(^\i\)\@!\)*\(^}\n\)'

	" '\t' && ' '
	syntax match myNorme '\t\zs \+'

	" ' ' && '\t'
	syntax match myNorme ' \+\ze\t'

	" ' ' || '\t' && Return
	syntax match myNorme '^\%#\@<!\(\s\%#\@<!\)\+$'

	" Double Space
	syntax match myNorme '\(# *\)\@<!  \+'

	" Maj and Min in same word
	syntax match myNorme '\(0\(x\|X\)\)\@!\<\i*\(\([a-z]\i*[A-Z]\)\|\([A-Z]\i*[a-z]\)\)\i*\>'

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
	syntax match myNorme '\(\]\|)\| \|\t\+\|+\|\( .*\)\@<!\t\)\@!.\zs+\ze.\(+\|=\)\@<!'
	syntax match myNorme '\( [0-9]\)\@<=+'
	" OTHER BEFORE '-'
	syntax match myNorme '\(\]\|)\| \|\t\+\|-\)\@!.\zs-\ze.\(-\|=\|>\)\@<!'
	syntax match myNorme '\( [0-9]\|\]\)\@<=-\ze.\(>\)\@<!'
	" CAST "
	syntax match myNorme '\()\)\@<!\<malloc\>'

	highlight link myNorme MyNorme

endfunction
