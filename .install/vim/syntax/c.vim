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

"__________________________________________________________
"__________________________SYNTAX__________________________
"__________________________________________________________

highlight Visual		term=bold				ctermbg=236
highlight CursorLine	term=bold cterm=bold	ctermbg=234
highlight CursorLineNr	term=bold cterm=bold	ctermbg=204
highlight Identifier							ctermfg=11
highlight Statement								ctermfg=yellow
highlight String								ctermfg=darkyellow
highlight Comment								ctermfg=238
highlight PreProc								ctermfg=9
highlight Type									ctermfg=10
highlight LineNr								ctermfg=242
highlight Pmenu			term=reverse			ctermbg=239	ctermfg=white
highlight PmenuSel		term=reverse			ctermbg=27	ctermfg=white
highlight Number								ctermfg=magenta
highlight Character		term=bold				ctermfg=white

highlight MyTable								ctermfg=28
" highlight >> 's_exemple' && 't_exemple' && 'u_exemple' && 'e_exemple'
syntax match myTable '\<s_\i\+\>\((\)\@!'
syntax match myTable '\<t_\i\+\>\((\)\@!'
syntax match myTable '\<u_\i\+\>\((\)\@!'
syntax match myTable '\<e_\i\+\>\((\)\@!'
highlight link myTable MyTable

highlight MyElementAfterStruct					ctermfg=202
" highlight >> 'g_exemple'
syntax match myElementAfterStruct '\(\(->\)\|\(\.\)\)\@<=\(\<\i\+\>\)\(\(->\)\|\(\.\)\)\@!'
highlight link myElementAfterStruct MyElementAfterStruct


highlight MyElementBetweenStruct				ctermfg=215
" highlight >> 'test->test.test'
syntax match myElementBetweenStruct '\(\(->\)\|\(\.\)\)\@<=\(\<\i\+\>\)\(\(->\)\|\(\.\)\)\@='
highlight link myElementBetweenStruct MyElementBetweenStruct

"__________________________________________________________

highlight MyStatement							ctermfg=yellow

" highlight all operators
syntax match myStatement '->'
syntax match myStatement '\.'
syntax match myStatement '!'
syntax match myStatement '\s\zs-\ze '
syntax match myStatement '\s\zs+\ze '
syntax match myStatement '\s\zs\*\ze '
syntax match myStatement '\s\zs\/\ze '
syntax match myStatement '\s\zs%\ze '
syntax match myStatement '\s\zs<\ze '
syntax match myStatement '\s\zs<<\ze '
syntax match myStatement '\s\zs>\ze '
syntax match myStatement '\s\zs>>\ze '
syntax match myStatement '\s\zs=\ze '
syntax match myStatement '\s\zs==\ze '
syntax match myStatement '\s\zs+=\ze '
syntax match myStatement '\s\zs-=\ze '
syntax match myStatement '\s\zs\*=\ze '
syntax match myStatement '\s\zs/=\ze '
syntax match myStatement '\s\zs%=\ze '
syntax match myStatement '\s\zs!=\ze '
syntax match myStatement '\s\zs>=\ze '
syntax match myStatement '\s\zs<=\ze '
syntax match myStatement '\s\zs&=\ze '
syntax match myStatement '\s\zs|=\ze '
syntax match myStatement '\s\zs&&\ze '
syntax match myStatement '\s\zs||\ze '
highlight link myStatement MyStatement

highlight MyMacro								ctermfg=red
syntax match myMacro '\<\([0-9A-Z_]\)*\>'
highlight link myMacro MyMacro

highlight MyDefine								ctermfg=13
syntax match myDefine '\<\([0-9A-Z_]\)*_FT\>'
syntax keyword myDefine get set false true
highlight link myDefine MyDefine

"__________________________________________________________

highlight MyFunction							ctermfg=blue

" highlight basic function
syntax match myFunction '\<\i\+\>\ze('
highlight link myFunction MySyntax

"__________________________________________________________

highlight MyGlobal								ctermfg=169
" highlight >> 'g_exemple'
" highlight >> 'sgt_exemple'
syntax match myGlobal '\<g_\i\+\>'
syntax match myGlobal '\<sgt_\i\+\>\ze('
highlight link myGlobal MyGlobal

"__________________________________________________________

highlight MyFunctionFT							ctermfg=lightblue

" highlight >> 'ft_exemple'
syntax match myFunctionFT '\<ft_\i\+\>\ze('
highlight link myFunctionFT MyFunctionFT

"__________________________________________________________

highlight MyFunctionST							ctermfg=blue

" highlight >> 's_exemple'
syntax match myFunctionST '\(\(s_\)\|\(\.\)\)\@<=\(\i\+\)\((\)\@='
highlight link myFunctionST MyFunctionST
"__________________________________________________________

highlight MyFunctionST2				cterm=bold	ctermfg=lightblue

" highlight >> 's_exemple'
syntax match myFunctionST2 '\<\zss_\ze\i\+\>('
highlight link myFunctionST2 MyFunctionST2

highlight MyLibrary					cterm=bold	ctermfg=215
syntax match myLibrary '<lib.*ft.h>' containedin=ALL
highlight link myLibrary MyLibrary
