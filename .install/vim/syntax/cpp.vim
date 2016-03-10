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

highlight MyPrivateVar							ctermfg=202

" highlight >> 'g_exemple'
syntax match myPrivateVar '\<_\ze\i\+\>'
highlight link myPrivateVar MyPrivateVar

"__________________________________________________________

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

"__________________________________________________________

" highlight cpp
syntax match myStatement '::'
syntax match myStatement '\~'

"__________________________________________________________

highlight MyClass							ctermfg=159

" highlight >> 'std::'
syntax match myFunctionFT '\<\i\+\>\ze::'
highlight link myFunctionFT MyFunctionFT

"__________________________________________________________

" highlight >> ''
syntax match myType '\<\i\+\>\ze&\?\s\+&\?\**\<\i\+\>\(\(^#.*\)\|\(//.*\)\)\@<!'
highlight link myType Type
