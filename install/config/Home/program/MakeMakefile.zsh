######################
####</\Makefile/\>####
######################

getlentab()
{
	local len=`echo "$1" | wc -c | awk '{print $1}' | tr -d '\n'`
	len=`echo "$len - 3" | bc`
	local diff=`echo "58 - $len" | bc`
	local tab="0"
	local tmp=`echo "$len % 4" | bc`
	if [ $tmp -gt 0 ]; then
		tab=`echo "$diff - $tmp % 4" | bc`
		tab=`echo "$tab / 4" | bc`
	else
		tab=`echo "$diff / 4" | bc`
	fi
	tab=`echo "$tab + 2" | bc`
	echo "$tab"
}

getsrc()
{
	local src=`find ./srcs -iname "*.c" | sed '/.\/libft\//d' | sed 's/^..srcs\///'`

	local str=""
	local last=0
	local first="1"
	INPUT=$src
	IFS=$'\n'
	set -- $src
	for i in $@ENDOFSRC
	do
		if [[ "$i" == *ENDOFSRC* ]]; then
			last=`echo "STOP"`
			i=`echo $i | sed 's/ENDOFSRC//'`
		fi
		str="$str\t\t\t\t$i"
		if [[ "$first" == "1" ]]; then
			first=`echo "0"`
			ntab=$(getlentab `echo "\t\t\t\t$i"` 1)
		else
			ntab=$(getlentab `echo "\t\t\t\t$i"`)
		fi
		if [[ "$last" == *STOP* ]]; then
			str="$str"
		else
			tab=""
			for ((i=1; i<=$ntab; ++i )) ;
			do
				tab+="\t"
			done
			str="$str$tab\\\\\r\n"
		fi
	done
	echo "$str" > srcs.tmp
}

getinc()
{
	local inc=`find ./includes -iname "*.h" | sed '/.\/libft\//d' |  sed 's/^..includes\///'`

	local str=""
	local last=0
	local first="1"
	INPUT=$inc
	IFS=$'\n'
	set -- $inc
	for i in $@ENDOFSRC
	do
		if [[ "$i" == *ENDOFSRC* ]]; then
			last=`echo "STOP"`
			i=`echo $i | sed 's/ENDOFSRC//'`
		fi
		str="$str\t\t\t\t$i"
		if [[ "$first" == "1" ]]; then
			first=`echo "0"`
			ntab=$(getlentab `echo "\t\t\t\t$i"` 1)
		else
			ntab=$(getlentab `echo "\t\t\t\t$i"`)
		fi
		if [[ "$last" == *STOP* ]]; then
			str="$str"
		else
			tab=""
			for ((i=1; i<=$ntab; ++i )) ;
			do
				tab+="\t"
			done
			str="$str$tab\\\\\r\n"
		fi
	done
	echo "$str" > includes.tmp
}

insert_header_info()
{
	echo "#    " | tr -d '\n' >> Makefile.tmp
	echo "$1" | tr -d '\n' >> Makefile.tmp
	date +"%Y/%m/%d %T" | tr -d '\n' >> Makefile.tmp
	echo " by " | tr -d '\n' >> Makefile.tmp
	echo $USER | tr -d '\n' >> Makefile.tmp
	local len=`echo "$author" | wc -c | awk '{print $1}' | tr -d '\n'`
	local space=`echo "17 - $len" | bc`
	for ((i=0; i<=$space; ++i )) ;
	do
		echo " " | tr -d '\n' >> Makefile.tmp
	done
	echo "$2" >> Makefile.tmp
}

insert_header_mail()
{
	local author=`echo $USER`
	echo "#    By: $author <$MAIL>" | tr -d '\n' >> Makefile.tmp
	local len=`echo "$author$MAIL" | wc -c | awk '{print $1}' | tr -d '\n'`
	local space=`echo "40 - $len" | bc`
	for ((i=0; i<=$space; ++i )) ;
	do
		echo " " | tr -d '\n' >> Makefile.tmp
	done
	echo "+#+  +:+       +#+         #" >> Makefile.tmp
}

insert_header_file()
{
	local author=`echo $USER`

}

insertAfter()
{
   local file="$1" line="$2" newText="$3"
   sed -e "/${line}/r${newText}" "$file" > tmp
   mv tmp Makefile.tmp
}

__refresh_()
{
	getsrc
	getinc

	insertAfter Makefile.tmp \
		"SRCBASE		=	\\\\" \
		srcs.tmp
	insertAfter Makefile.tmp \
		"INCBASE		=	\\\\" \
		includes.tmp

}

creat_makefile()
{
	local author=`echo $USER`
	echo "# **************************************************************************** #" > Makefile.tmp
	echo "#                                                                              #" >> Makefile.tmp
	echo "#                                                         :::      ::::::::    #" >> Makefile.tmp
	echo "#    Makefile                                           :+:      :+:    :+:    #" >> Makefile.tmp
	echo "#                                                     +:+ +:+         +:+      #" >> Makefile.tmp
	insert_header_mail
	echo "#                                                 +#+#+#+#+#+   +#+            #" >> Makefile.tmp
	insert_header_info "Created: " " #+#    #+#              #"
	insert_header_info "Updated: " "###   ########.fr        #"
	echo "#                                                                              #" >> Makefile.tmp
	echo "# **************************************************************************** #" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "NAME		=	" | tr -d '\n' >> Makefile.tmp
	local dirname="$(basename "$PWD")"
	echo $dirname >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "NAMEBASE	=	\$(shell basename \$(NAME))" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "CC			=	gcc" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "FLAGS		=	-Wall -Wextra -Werror" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "SRCDIR		=	srcs/" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "OBJDIR		=	objs/" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "INCDIR		=	includes/" >> Makefile.tmp
	echo "" >> Makefile.tmp
	if [ -d ./libft ]; then
		echo "LIBFT_DIR	=	libft/" >> Makefile.tmp
		echo "" >> Makefile.tmp
		echo "LIBFT_LIB	=	libft/libft.a" >> Makefile.tmp
		echo "" >> Makefile.tmp
		lib="y"
	else
		if [ -d ../libft ]; then
			echo "LIBFT_DIR	=	../libft/" >> Makefile.tmp
			echo "" >> Makefile.tmp
			echo "LIBFT_LIB	=	../libft/libft.a" >> Makefile.tmp
			echo "" >> Makefile.tmp
			lib="y"
		fi
	fi
	echo "SRCBASE		=	\\" >> Makefile.tmp
	getsrc
	cat srcs.tmp >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "INCBASE		=	\\" >> Makefile.tmp
	getinc
	cat includes.tmp >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "SRCS		=	\$(addprefix \$(SRCDIR), \$(SRCBASE))" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "INCS		=	\$(addprefix \$(INCDIR), \$(INCBASE))" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "OBJS		=	\$(addprefix \$(OBJDIR), \$(SRCBASE:.c=.o))" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo ".SILENT:" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "all:		\$(NAME)" >> Makefile.tmp
	#echo "	echo \"\\033[38;5;44mm☑️  ALL    \$(NAMEBASE) is done\\033[0m\\033[K\"" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "\$(NAME):	\$(OBJS)" >> Makefile.tmp
	if [ -d ./libft ]; then
		echo "	gcc \$(FLAGS) -o \$(NAME) \$(OBJS) -L ./libft/ -lft" >> Makefile.tmp
		yn="y"
	else
		while true; do
			read -p "libft or not ? (y/n) " yn
			case $yn in
				[YyOo]* ) echo "	gcc \$(FLAGS) -o \$(NAME) \$(OBJS) -L ./libft/ -lft" >> Makefile.tmp;break;;
				[Nn]* ) echo "	gcc \$(FLAGS) -o \$(NAME) \$(OBJS)" >> Makefile.tmp;break;;
					* ) echo "Please answer yes or no.";;
			esac
		done
	fi
	echo "" >> Makefile.tmp
	echo "\$(OBJS):	\$(OBJDIR) \$(SRCS)" >> Makefile.tmp
	echo "	cd \$(OBJDIR);\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\\" >> Makefile.tmp
	echo "	gcc \$(FLAGS) -c \$(addpefix \$(OBJDIR), \$(OBJS))\t\t\t\t\t\t\t\\" >> Makefile.tmp
	if [[ $yn == [Yy]* ]]; then
		echo "	-I ../libft/ \\" >> Makefile.tmp
		echo "	-I ../libft/includes \\" >> Makefile.tmp
	fi
	echo "	-I \$(addprefix ../, \$(SRC))" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "clean:" >> Makefile.tmp
	if [[ $yn == [Yy]* ]]; then
		echo "	make -C ./libft/ clean" >> Makefile.tmp
	fi
	echo "	rm -Rf \$(OBJDIR)" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "fclean:		clean" >> Makefile.tmp
	if [[ $yn == [Yy]* ]]; then
		echo "	make -C ./libft/ fclean" >> Makefile.tmp
	fi
	echo "	rm -f \$(NAME)" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo "re:			fclean all" >> Makefile.tmp
	echo "" >> Makefile.tmp
	echo ".PHONY:		fclean clean re" >> Makefile.tmp
}

insert_after_srcbase()
{
	local start=0
	local end=0

	old_IFS=$IFS
	IFS=$'\n'
	lines=($(cat -e Makefile.tmp)) # array
	IFS=$old_IFS
	countline=`echo ${#lines[@]}`
	for k in $(seq $1 ${countline})
	do
		if [[ "${lines[$k]}" != \$ ]]; then
			start=`echo "$k + 1" | bc`
			while [[ "${lines[$k]}" != \$ ]]
			do
				k=`echo "$k + 1" | bc`
			done
			end=`echo "$k" |bc`
			break
		else
			return
		fi
	done
	sed -e "${start},${end}d" Makefile.tmp > tmp
	mv tmp Makefile.tmp
}


if [ -f ./Makefile.tmp ]; then
	old_IFS=$IFS
	IFS=$'\n'
	lines=($(cat -e Makefile.tmp)) # array
	IFS=$old_IFS
	countline=`echo ${#lines[@]}`
	for k in $(seq 0 ${countline})
	do
		if [[ "${lines[$k]}" == *SRCBASE* ]]; then
			insert_after_srcbase `echo "$k + 1" | bc`
			break
		fi
	done

	old_IFS=$IFS
	IFS=$'\n'
	lines=($(cat -e Makefile.tmp)) # array
	IFS=$old_IFS
	countline=`echo ${#lines[@]}`
	for k in $(seq 0 ${countline})
	do
		if [[ "${lines[$k]}" == *INCBASE* ]]; then
			insert_after_srcbase `echo "$k + 1" | bc`
			break
		fi
	done

	__refresh_
else
    creat_makefile
fi

cat Makefile.tmp | expand -t4

rm srcs.tmp
rm includes.tmp
