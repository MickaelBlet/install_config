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
"

highlight MyTable								ctermfg=28

" highlight >> 's_exemple' && 't_exemple' && 'u_exemple' && 'e_exemple'
syntax match myTable '\<s_\i\+\>'
syntax match myTable '\<t_\i\+\>'
syntax match myTable '\<u_\i\+\>'
syntax match myTable '\<e_\i\+\>'
highlight link myTable MyTable


highlight MyGlobal								ctermfg=169

" highlight >> 'g_exemple'
syntax match myGlobal '\<g_\i\+\>'
highlight link myGlobal MyGlobal

highlight MyElementAfterStruct					ctermfg=202

" highlight >> 'g_exemple'
syntax match myElementAfterStruct '\(\(->\)\|\(\.\)\)\@<=\(\<\i\+\>\)\(\(->\)\|\(\.\)\)\@!'
highlight link myElementAfterStruct MyElementAfterStruct

highlight MyElementBetweenStruct					ctermfg=215

" highlight >> 'g_exemple'
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

highlight MyMacro							ctermfg=red
syntax match myMacro '\<\([0-9A-Z_]\)*\>'
highlight link myMacro MyMacro

"__________________________________________________________

highlight MyFunction							ctermfg=blue

" highlight basic function
syntax match myFunction '\<\i\+\>\ze('
highlight link myFunction MySyntax

"__________________________________________________________

highlight MyFunctionFT							ctermfg=lightblue

" highlight >> 'ft_exemple'
syntax match myFunctionFT '\<ft_\i\+\>\ze('
highlight link myFunctionFT MyFunctionFT
