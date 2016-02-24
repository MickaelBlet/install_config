"
" <This plugin generate 42 header>
" Copyright (C) <2013>  Quentin Perez <qperez42@gmail.com>
"
" This file is part of 42-toolkit.
"
" 42-toolkit is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"

autocmd	BufNewFile	*.h	call	Generate_h_42()
autocmd	BufNewFile	*.hpp	call	Generate_h_42()
autocmd BufNewFile	*.php call	Generate_php()

function! Generate_h_42()
	set paste
	let l:name = expand('%:t')
	let l:newname = toupper(l:name)
	let l:newname = substitute(l:newname, "\\.", "_", "g")
	let l:newname = substitute(l:newname, "\\n", "", "g")
	exe ":normal A" . "#ifndef " . l:newname . "\n# define " . l:newname . "\n\n\n\n#endif"
	"" /* !" . l:newname . " */"
	if exists("*Header_42")
		call Header_42()
		exe ":16"
	els
		exe ":4"
	endif
	set nopaste
endfunction

function! Generate_php()
	exe ":normal A" . "!/usr/bin/php\n<?php\n\n?>"
	%s/!/#!/e
	exe ":3"
endfunction
