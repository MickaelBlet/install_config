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

autocmd BufNewFile	Makefile	call Creat_Makefile_42()
autocmd BufRead		Makefile	call Makefile_refresh_files_list()

autocmd BufWritePost *.c		call Actualise_makefile()
autocmd BufWritePost *.h		call Actualise_makefile()

function! Actualise_makefile()
	let l:pwd = getcwd()
	while !filereadable('./Makefile')
		try
			cd ..
		catch
			exe ':cd '.l:pwd
			return
		endtry
	endwhile
	silent! exe ':!vim -c "redraw!|wq" Makefile&'
	exe ':cd '.l:pwd
endfunction

let s:makefile = [
			\'NAME		=	' . expand('%:p:h:t'),
			\'NAMEBASE    =   $(shell basename $(NAME))',
			\'LENGTHNAME	=	`printf "%s" $(NAMEBASE) | wc -c`',
			\'MAX_COLS	=	$$(echo "$$(tput cols)-24-$(LENGTHNAME)"|bc)',
			\'',
			\'CC			=	gcc',
			\'FLAGS		=	-Wall -Wextra -Werror',
			\'',
			\'SRCDIR		=	srcs/',
			\'OBJDIR		=	objs/',
			\'INCDIR		=	includes/',
			\'LIBFT_DIR	=	libft/',
			\'LIBFT_LIB	=	$(LIBFT_DIR)libft.a',
			\'',
			\'SRCBASE		=	\',
			\'',
			\'INCBASE		=	\',
			\'',
			\'SRCS		=	$(addprefix $(SRCDIR), $(SRCBASE))',
			\'INCS		=	$(addprefix $(INCDIR), $(INCBASE))',
			\'OBJS		=	$(addprefix $(OBJDIR), $(SRCBASE:.c=.o))',
			\'',
			\'.SILENT:',
			\'',
			\'all:		$(NAME)',
			\'	echo "\033[38;5;44m☑️  ALL    $(NAMEBASE) is done\033[0m\033[K"',
			\'',
			\'$(NAME):	$(OBJDIR) $(OBJS)',
			\'	make -C $(LIBFT_DIR)',
			\'	$(CC) $(FLAGS) -o $(NAME) $(OBJS) $(LIBFT_LIB)',
			\'	echo "\r\033[38;5;22m📗  MAKE   $(NAMEBASE)\033[0m\033[K"',
			\'	echo "\r\033[38;5;184m👥  GROUP MEMBER(S):\033[0m\033[K"',
			\'	echo "\r\033[38;5;15m`cat auteur | sed s/^/\ \ \ \ -/g`\033[0m\033[K"',
			\'',
			\'$(OBJDIR):',
			\'	mkdir -p $(OBJDIR)',
			\'	mkdir -p $(dir $(OBJS))',
			\'',
			\'$(OBJS):	$(INCS)',
			\'$(addprefix $(OBJDIR), %.o) : $(addprefix $(SRCDIR), %.c)',
			\'	$(CC) $(FLAGS) -c $< -o $@												\',
			\'		-I $(LIBFT_DIR)$(INCDIR)											\',
			\'		-I $(INCDIR)',
			\'	printf "\r\033[38;5;11m⌛  MAKE   %s plz wait ...%*s\033[0m\033[K"		\',
			\'		$(NAMEBASE) $(MAX_COLS) "($@)"',
			\'',
			\'clean:',
			\'	printf "\r\033[38;5;11m⌛  CLEAN  $(NAMEBASE) plz wait ...\033[0m\033[K"',
			\'	make -C $(LIBFT_DIR) clean',
			\'	if [[ `rm -R $(OBJDIR) &> /dev/null 2>&1; echo $$?` == "0" ]]; then		\',
			\'		echo "\r\033[38;5;124m📕  CLEAN  $(NAMEBASE)\033[0m\033[K";			\',
			\'	else																	\',
			\'		printf "\r";														\',
			\'	fi',
			\'',
			\'fclean:		clean',
			\'	printf "\r\033[38;5;11m⌛  FCLEAN $(NAMEBASE) plz wait ...\033[0m\033[K"',
			\'	make -C $(LIBFT_DIR) fclean',
			\'	if [[ `rm $(NAME) &> /dev/null 2>&1; echo $$?` == "0" ]]; then			\',
			\'		echo "\r\033[38;5;124m📕  FCLEAN $(NAMEBASE)\033[0m\033[K";			\',
			\'	else																	\',
			\'		printf "\r";														\',
			\'	fi',
			\'',
			\'re:			fclean all',
			\'',
			\'.PHONY:		fclean clean re debug'
			\]

function!	Creat_Makefile_42()
	set paste
	for line_file in s:makefile
		call append(line('$'), line_file)
	endfor
	set nopaste
	call Makefile_refresh_files_list()
endfunction

function!	s:Append_files_list(line_index, pattern_type_file)
	let in_dir = 0
	let maxlen = 59
	let filelist = ""
	for filelist_value in split(a:pattern_type_file, ';')
		let filelist .= glob(filelist_value)
	endfor
	let count_file = len(split(filelist, '\n'))
	if count_file > 0
		let count_line = a:line_index - 1
		for file_name in split(filelist, '\n')
			let len_file_name = strlen(file_name)
			if maxlen > len_file_name
				let ntab = 0
				let diff = l:maxlen - len_file_name
				if len_file_name < &tabstop
					let ntab += 1
					let ntab += (l:diff - (&tabstop - len_file_name)) / &tabstop
				elseif (len_file_name % &tabstop) > 0
					let ntab += (l:diff + len_file_name % &tabstop) / &tabstop
				else
					let ntab += (diff) / &tabstop
				endif
				let ntab += 1
			endif
			if count_file == 1
				call append(count_line, "\t\t\t\t" . file_name)
			else
				call append(count_line, "\t\t\t\t" . file_name . repeat("\t", ntab) . "\\")
			endif
			let count_line += 1
			let count_file -= 1
		endfor
	endif
	if l:in_dir > 0
		cd ..
	endif
endfunction

function!	Makefile_refresh_files_list()
	let index_line = 0
	while index_line < line('$')
		if !empty(matchstr(getline(index_line), '^SRCBASE'))
			let index_line += 1
			let start_line_element = index_line
			let end_line_element = index_line
			while !empty(matchstr(getline(end_line_element), '^\t'))
						\ && end_line_element < line('$')
				let end_line_element += 1
			endwhile
			if start_line_element != end_line_element
				exe start_line_element . ',' . (end_line_element-1) .  'd'
			endif
			let in_dir = 0
			if isdirectory("srcs")
				cd srcs
				let in_dir = 1
			endif
			call s:Append_files_list(start_line_element, "**/*.c;**/*.cpp")
			if in_dir == 1
				cd ..
			endif
		elseif !empty(matchstr(getline(index_line), '^INCBASE'))
			let index_line += 1
			let start_line_element = index_line
			let end_line_element = index_line
			while !empty(matchstr(getline(end_line_element), '^\t'))
						\ && end_line_element < line('$')
				let end_line_element += 1
			endwhile
			if start_line_element != end_line_element
				exe start_line_element . ',' . (end_line_element-1) .  'd'
			endif
			let in_dir = 0
			if isdirectory("includes")
				cd includes
				let in_dir = 1
			endif
			call s:Append_files_list(start_line_element, "**/*.h;**/*.hpp")
			if in_dir == 1
				cd ..
			endif
		elseif !empty(matchstr(getline(index_line), '^CLSBASE'))
			let index_line += 1
			let start_line_element = index_line
			let end_line_element = index_line
			while !empty(matchstr(getline(end_line_element), '^\t'))
						\ && end_line_element < line('$')
				let end_line_element += 1
			endwhile
			if start_line_element != end_line_element
				exe start_line_element . ',' . (end_line_element-1) .  'd'
			endif
			let in_dir = 0
			if isdirectory("class")
				cd class
				let in_dir = 1
			endif
			call s:Append_files_list(start_line_element, "**/*.hpp;**/*.cpp")
			if in_dir == 1
				cd ..
			endif
		endif
		let index_line += 1
	endwhile
endfunction
