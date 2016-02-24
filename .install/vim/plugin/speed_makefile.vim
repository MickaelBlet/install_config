autocmd BufNewFile	Makefile call	Creat_Makefile_42()
autocmd BufRead		Makefile call	Makefile_refresh_files_list()

function!	Insert_header_42_add_info_Makefile(begin, end, nul_line, setline)
	let l:line = "#    " . a:begin . ": " . strftime("%Y/%m/%d %H:%M:%S") . " by " . s:author
	let l:cmd = "echo " . s:author . " | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:len = system(l:cmd)
	let l:space = 17 - l:len
	while l:space >= 0
		let l:line = l:line . " "
		let l:space -= 1
	endwhile
	let l:line = l:line . a:end
	if a:setline ==? '1'
		call setline(a:nul_line, l:line)
	else
		call append(a:nul_line, l:line)
	endif
endfunction

function!	Insert_header_42_add_mail_Makefile()
	let l:mail = system("echo $MAIL | tr -d '\n'")
	let l:line = "#    By: " . s:author . " <" . l:mail . ">"
	let l:cmd = "echo " . s:author . l:mail . " | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:len = system(l:cmd)
	let l:space = 40 - l:len
	while l:space >= 0
		let l:line = l:line . " "
		let l:space -= 1
	endwhile
	let l:line = l:line . "+#+  +:+       +#+         #"
	call append(5, l:line)
endfunction

function!	Insert_header_42_add_file_Makefile()
	let l:line = "#    "
	let l:file = expand('%:f')
	let l:cmd = "/usr/bin/basename " . l:file . " | tr -d '\n'"
	let l:file = system(l:cmd)
	let l:line = l:line . l:file
	let l:cmd = "echo " . l:file . " | wc -c | awk '{print $1}' | tr -d '\n'"
	let l:len = system(l:cmd)
	let l:space = 51 - l:len
	while l:space >= 0
		let l:line = l:line . " "
		let l:space -= 1
	endwhile
	let l:line = l:line . ":+:      :+:    :+:    #"
	call append(3, l:line)
endfunction

function!	Creat_Makefile_42()
	set paste
	let s:author = system("echo $USER | tr -d '\n'")
	call Insert_line("NAME		=	" . system("echo " . expand('%:p') . " | rev | cut -d/ -f2 | rev | tr -d '\n'"))
	call Insert_line("")
	call Insert_line("NAMEBASE    =   $(shell basename $(NAME))")
	call Insert_line("")
	call Insert_line('LENGTHNAME	=	`printf "%s" $(NAMEBASE) | wc -c`')
	call Insert_line("")
	call Insert_line('MAX_COLS	=	$$(echo "$$(tput cols)-24-$(LENGTHNAME)"|bc)')
	call Insert_line("")
	call Insert_line("CC			=	gcc")
	call Insert_line("")
	call Insert_line("FLAGS		=	-Wall -Wextra -Werror")
	call Insert_line("")
	call Insert_line("SRCDIR		=	srcs/")
	call Insert_line("")
	call Insert_line("OBJDIR		=	objs/")
	call Insert_line("")
	call Insert_line("INCDIR		=	includes/")
	call Insert_line("")
	call Insert_line("LIBFT_DIR	=	libft/")
	call Insert_line("")
	call Insert_line("LIBFT_LIB	=	libft/libft.a")
	call Insert_line("")
	call Insert_line("SRCBASE		=	\\")
	call Insert_line("")
	call Insert_line("INCBASE		=	\\")
	call Insert_line("")
	call Insert_line("SRCS		=	$(addprefix $(SRCDIR), $(SRCBASE))")
	call Insert_line("")
	call Insert_line("INCS		=	$(addprefix $(INCDIR), $(INCBASE))")
	call Insert_line("")
	call Insert_line("OBJS		=	$(addprefix $(OBJDIR), $(SRCBASE:.c=.o))")
	call Insert_line("")
	call Insert_line(".SILENT:")
	call Insert_line("")
	call Insert_line("all:		$(NAME)")
	call Insert_line('	echo "\033[38;5;44m☑️  ALL    $(NAMEBASE) is done\033[0m\033[K"')
	call Insert_line("")
	call Insert_line("$(NAME):	$(OBJDIR) $(OBJS)")
	call Insert_line('	make -C $(LIBFT_DIR)')
	call Insert_line('	$(CC) $(FLAGS) -o $(NAME) $(OBJS) $(LIBFT_LIB)')
	call Insert_line('	echo "\r\033[38;5;22m📗  MAKE   $(NAMEBASE)\033[0m\033[K"')
	call Insert_line('	echo "\r\033[38;5;184m👥  GROUP MEMBER(S):\033[0m\033[K"')
	call Insert_line('	echo "\r\033[38;5;15m`cat auteur | sed s/^/\ \ \ \ -/g`\033[0m\033[K"')
	call Insert_line("")
	call Insert_line("$(OBJDIR):")
	call Insert_line("	mkdir -p $(OBJDIR)")
	call Insert_line("	mkdir -p $(dir $(OBJS))")
	call Insert_line("")
	call Insert_line("$(OBJS):	$(INCS)")
	call Insert_line("")
	call Insert_line("$(addprefix $(OBJDIR), %.o) : $(addprefix $(SRCDIR), %.c)")
	call Insert_line('	$(CC) $(FLAGS) -c $< -o $@												\')
	call Insert_line('		-I $(LIBFT_DIR)$(INCDIR)											\')
	call Insert_line('		-I $(INCDIR)')
	call Insert_line('	printf "\r\033[38;5;11m⌛  MAKE   %s plz wait ...%*s\033[0m\033[K"		\')
	call Insert_line('		$(NAMEBASE) $(MAX_COLS) "($@)"')
	call Insert_line("")
	call Insert_line("clean:")
	call Insert_line('	printf "\r\033[38;5;11m⌛  CLEAN  $(NAMEBASE) plz wait ...\033[0m\033[K"')
	call Insert_line("	make -C $(LIBFT_DIR) clean")
	call Insert_line('	if [[ `rm -R $(OBJDIR) &> /dev/null 2>&1; echo $$?` == "0" ]]; then		\')
	call Insert_line('		echo "\r\033[38;5;124m📕  CLEAN  $(NAMEBASE)\033[0m\033[K";			\')
	call Insert_line('	else																	\')
	call Insert_line('		printf "\r";														\')
	call Insert_line('	fi')
	call Insert_line("")
	call Insert_line("fclean:		clean")
	call Insert_line('	printf "\r\033[38;5;11m⌛  FCLEAN $(NAMEBASE) plz wait ...\033[0m\033[K"')
	call Insert_line("	make -C $(LIBFT_DIR) fclean")
	call Insert_line('	if [[ `rm $(NAME) &> /dev/null 2>&1; echo $$?` == "0" ]]; then			\')
	call Insert_line('		echo "\r\033[38;5;124m📕  FCLEAN $(NAMEBASE)\033[0m\033[K";			\')
	call Insert_line('	else																	\')
	call Insert_line('		printf "\r";														\')
	call Insert_line('	fi')
	call Insert_line("")
	call Insert_line("re:			fclean all")
	call Insert_line("")
	call Insert_line("debug:		CC = cc")
	call Insert_line("debug:		FLAGS += --analyze")
	call Insert_line("debug:		re")
	call Insert_line("")
	call setline(line("$"), ".PHONY:		fclean clean re debug")
	unlet s:author
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

function!	Insert_line(s)
	exe 'normal A' . a:s . "\n"
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

function!	Refresh_files_list_2()
	let l:line = 0
	while l:line < line('$')
		if !empty(matchstr(getline(l:line), '^INCBASE'))
			let l:line += 1
			call cursor(l:line, 1)
			break
		endif
		let l:line += 1
	endwhile
	if l:line < line('$')
		while !empty(matchstr(getline(line('.')), '^\t')) && line('.') < line('$')
			exe 'normal dd'
		endwhile
		call Get_files_list_h()
	endif
	"call Refresh_files_list_3()
endfunction

function!	Refresh_files_list_3()
	let l:line = 0
	while l:line < line('$')
		if !empty(matchstr(getline(l:line), '^CLSBASE'))
			let l:line += 1
			call cursor(l:line, 1)
			break
		endif
		let l:line += 1
	endwhile
	if l:line < line('$')
		while !empty(matchstr(getline(line('.')), '^\t')) && line('.') < line('$')
			exe 'normal dd'
		endwhile
		call Get_files_list_class_cpp()
	endif
	"call Refresh_files_list_4()
endfunction

function!	Refresh_files_list_4()
	let l:line = 0
	while l:line < line('$')
		if !empty(matchstr(getline(l:line), '^HLSBASE'))
			let l:line += 1
			call cursor(l:line, 1)
			break
		endif
		let l:line += 1
	endwhile
	if l:line < line('$')
		while !empty(matchstr(getline(line('.')), '^\t')) && line('.') < line('$')
			exe 'normal dd'
		endwhile
		call Get_files_list_class_hpp()
	endif
endfunction
