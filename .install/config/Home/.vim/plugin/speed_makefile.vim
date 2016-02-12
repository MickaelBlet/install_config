autocmd BufNewFile	Makefile call	Creat_Makefile_42()
autocmd BufRead		Makefile call	Refresh_files_list()

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
	let l:mail = system("echo $MAIL42 | tr -d '\n'")
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
	let s:author = system("echo $USER42 | tr -d '\n'")
	call append(0, "# **************************************************************************** #")
	call append(1, "#                                                                              #")
	call append(2, "#                                                         :::      ::::::::    #")
	call Insert_header_42_add_file_Makefile()
	call append(4, "#                                                     +:+ +:+         +:+      #")
	call Insert_header_42_add_mail_Makefile()
	call append(6, "#                                                 +#+#+#+#+#+   +#+            #")
	call Insert_header_42_add_info_Makefile("Created", " #+#    #+#              #", 7, 0)
	call Insert_header_42_add_info_Makefile("Updated", "###   ########.fr        #", 8, 0)
	call append(9, "#                                                                              #")
	call append(10, "# **************************************************************************** #")
	call Insert_line("")
	call Insert_line("NAME		=	" . system("echo " . expand('%:p') . " | rev | cut -d/ -f2 | rev | tr -d '\n'"))
	call Insert_line("")
	call Insert_line("NAMEBASE    =   $(shell basename $(NAME))")
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
	call Get_files_list()
	call Insert_line("")
	call Insert_line("INCBASE		=	\\")
	call Get_files_list_h()
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
	call Insert_line("$(NAME):	$(OBJS)")
	call Insert_line('	$(CC) $(FLAGS) -o $(NAME) $(OBJS) $(LIBFT_LIB)')
	call Insert_line('	echo -en "\r\033[38;5;22m☑️  MAKE   $(NAMEBASE)\033[0m\033[K"')
	call Insert_line('	echo "\r\033[38;5;184m👥  GROUP MEMBER(S):\033[0m\033[K"')
	call Insert_line('	echo "\r\033[38;5;15m`cat auteur | sed s/^/\ \ \ \ -/g`\033[0m\033[K"')
	call Insert_line("")
	call Insert_line('$(OBJS):	$(SRCS) $(INCS)')
	call Insert_line('	printf "\r\033[38;5;11m⌛  MAKE   $(NAMEBASE) plz wait ...\033[0m\033[K"')
	call Insert_line("	mkdir -p $(OBJDIR)")
	call Insert_line("	make -C $(LIBFT_DIR)")
	call Insert_line("	(cd $(OBJDIR);															\\")
	call Insert_line("	$(CC) $(FLAGS) -c $(addprefix ../, $(SRCS))								\\")
	call Insert_line("	-I $(addprefix ../, $(LIBFT_DIR)/$(INCDIR))								\\")
	call Insert_line("	-I $(addprefix ../, $(INCDIR)))")
	call Insert_line("")
	call Insert_line("clean:")
	call Insert_line('	printf "\r\033[38;5;11m⌛  CLEAN  $(NAMEBASE) plz wait ...\033[0m\033[K"')
	call Insert_line("	make -C $(LIBFT_DIR) clean")
	call Insert_line('	if [[ `rm -R $(OBJDIR) &> /dev/null 2>&1; echo $$?` == "0" ]]; then		\')
	call Insert_line('		echo -en "\r\033[38;5;124m🔘  CLEAN  $(NAMEBASE)\033[0m\033[K";		\')
	call Insert_line('	else																	\')
	call Insert_line('		printf "\r";														\')
	call Insert_line('	fi')
	call Insert_line("")
	call Insert_line("fclean:		clean")
	call Insert_line('	printf "\r\033[38;5;11m⌛  FCLEAN $(NAMEBASE) plz wait ...\033[0m\033[K"')
	call Insert_line("	make -C $(LIBFT_DIR) fclean")
	call Insert_line('	if [[ `rm $(NAME) &> /dev/null 2>&1; echo $$?` == "0" ]]; then			\')
	call Insert_line('		echo -en "\r\033[38;5;124m🔘  FCLEAN $(NAMEBASE)\033[0m\033[K";		\')
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
	call setline(line("$"), ".PHONY:		fclean clean re")
	unlet s:author
	set nopaste
endfunction

function! Get_len_file(s)
	let l:cmd = "wc -c | awk '{print $1}' | tr -d '\n'"
	let l:num = system(l:cmd)
	let l:ret = col("$") - l:num - 5
	return l:ret
endfunction

function!	Get_files_list()
	let l:in_dir = 0
	if isdirectory("srcs")
		let l:in_dir = 1
		cd srcs
	endif
	let filelist = glob('**/*.c')
	let filelist .= glob('*.cpp')
	if len(filelist)
		let count_line = line(".")
		for file in split(filelist, '\n')
			exe 'normal A' . "\t\t\t\t" . file . "\n"
			call cursor(line(".") - 1, 1)
			let l:maxlen = 59
			let l:tmplen = Get_len_file(getline(line(".")))
			if l:maxlen > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/$/\=repeat("\t", l:ntab)/e
				s/$/\\/e
			endif
			call cursor(line(".") + 1, 1)
		endfor
		call cursor(line(".") - 1, 1)
		s/\t\+\\$//e
		call cursor(line(".") + 1, 1)
	endif
	if l:in_dir > 0
		cd ..
	endif
endfunction

function!	Get_files_list_h()
	let l:in_dir = 0
	if isdirectory("includes")
		let l:in_dir = 1
		cd includes
	endif
	let filelist = glob('*.h')
	let filelist .= glob('*.hpp')
	if len(filelist)
		let count_line = line(".")
		for file in split(filelist, '\n')
			exe 'normal A' . "\t\t\t\t" . file . "\n"
			call cursor(line(".") - 1, 1)
			let l:maxlen = 59
			let l:tmplen = Get_len_file(getline(line(".")))
			if l:maxlen > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/$/\=repeat("\t", l:ntab)/e
				s/$/\\/e
			endif
			call cursor(line(".") + 1, 1)
		endfor
		call cursor(line(".") - 1, 1)
		s/\t\+\\$//e
		call cursor(line(".") + 1, 1)
	endif
	if l:in_dir > 0
		cd ..
	endif
endfunction

function!	Get_files_list_class_cpp()
	let l:in_dir = 0
	if isdirectory("class")
		let l:in_dir = 1
		cd class
	endif
	let filelist = glob('*.cpp')
	if len(filelist)
		let count_line = line(".")
		for file in split(filelist, '\n')
			exe 'normal A' . "\t\t\t\t" . file . "\n"
			call cursor(line(".") - 1, 1)
			let l:maxlen = 59
			let l:tmplen = Get_len_file(getline(line(".")))
			if l:maxlen > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/$/\=repeat("\t", l:ntab)/e
				s/$/\\/e
			endif
			call cursor(line(".") + 1, 1)
		endfor
	endif
	call cursor(line(".") - 1, 1)
	s/\t\+\\$//e
	call cursor(line(".") + 1, 1)
	if l:in_dir > 0
		cd ..
	endif
endfunction

function!	Get_files_list_class_hpp()
	let l:in_dir = 0
	if isdirectory("class")
		let l:in_dir = 1
		cd class
	endif
	let filelist = glob('*.hpp')
	if len(filelist)
		let count_line = line(".")
		for file in split(filelist, '\n')
			exe 'normal A' . "\t\t\t\t" . file . "\n"
			call cursor(line(".") - 1, 1)
			let l:maxlen = 59
			let l:tmplen = Get_len_file(getline(line(".")))
			if l:maxlen > l:tmplen
				let l:ntab = 0
				let l:diff = l:maxlen - l:tmplen
				if l:tmplen < &tabstop
					let l:ntab += 1
					let l:ntab += (l:diff - (&tabstop - l:tmplen)) / &tabstop
				elseif (l:tmplen % &tabstop) > 0
					let l:ntab += (l:diff + l:tmplen % &tabstop) / &tabstop
				else
					let l:ntab += (l:diff) / &tabstop
				endif
				let l:ntab += 1
				s/$/\=repeat("\t", l:ntab)/e
				s/$/\\/e
			endif
			call cursor(line(".") + 1, 1)
		endfor
	endif
	call cursor(line(".") - 1, 1)
	s/\t\+\\$//e
	call cursor(line(".") + 1, 1)
	if l:in_dir > 0
		cd ..
	endif
endfunction

function!	Insert_line(s)
	exe 'normal A' . a:s . "\n"
endfunction

function!	Refresh_files_list()
	let l:line = 0
	while l:line < line('$')
		if !empty(matchstr(getline(l:line), '^SRCBASE'))
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
		call Get_files_list()
	endif
	call Refresh_files_list_2()
endfunct

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
	call Refresh_files_list_3()
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
	call Refresh_files_list_4()
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
