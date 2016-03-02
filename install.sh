#!/bin/bash

##
#    install.sh                                         :+:      :+:    :+:    #
##

menu=(	"ZSH + PROMPT + VIM"\
		"ZSH + PROMPT"\
		"PROMPT"\
		"VIM"\
		"SAVE CURRENT CONFIG")

menulength=${#menu[@]}
menulengthend=`echo "${menulength}-1"|bc`

##
## List functions menu
##

function menu0()
{
	rm -rf ~/#_my_config/
	rm -rf ~/.vim/
	rm ~/.myvimrc
	rm ~/.vimrc
	rm ~/.myzshrc
	rm ~/.zshrc
	cp -r .install/config/ ~/#_my_config
	cp -r .install/vim ~/.vim
	cp -r .install/myvimrc ~/.myvimrc
	cp -r .install/vimrc ~/.vimrc
	cp -r .install/myzshrc ~/.myzshrc
	cp -r .install/zshrc ~/.zshrc
	git config --global core.excludesfile ~/.gitignore_global
	printf "*.s\n" >> ~/.gitignore_global
	printf "*.o\n" >> ~/.gitignore_global
	printf "*.a\n" >> ~/.gitignore_global
	printf "*.out\n" >> ~/.gitignore_global
	cp -r .install/pref/* ~/Library/Preferences/
	echo "sleep 2" > ~/reinstall.sh
	echo "open /Applications/iTerm\ 2.app" >> ~/reinstall.sh
	echo "rm -fr ~/reinstall.sh" >> ~/reinstall.sh
	screen -d -m sh ~/reinstall.sh && killall -9 Finder && killall -9 Dock && killall -9 iTerm
}
function menu1()
{
	printf "yolo1\n\r"
}
function menu2()
{
	printf "yolo2\n\r"
}
function menu3()
{
	printf "yolo3\n\r"
}
function menu4()
{
	rm -rf .install/config
	rm -rf .install/vim
	rm .install/myvimrc
	rm .install/vimrc
	rm .install/myzshrc
	rm .install/zshrc
	cp -r ~/#_my_config .install/config
	cp -r ~/.vim .install/vim
	cp -r ~/.myvimrc .install/myvimrc
	cp -r ~/.vimrc .install/vimrc
	cp -r ~/.myzshrc .install/myzshrc
	cp -r ~/.zshrc .install/zshrc
}

##
## Prepare shell
##

clear
cols1=`echo "$(tput cols)/2+14/2"|bc`
cols2=`echo "$(tput cols)/2-14/2"|bc`
result=`echo "$cols1+$cols2"|bc`

if [ $result != $(tput cols) ]; then
	cols1=`echo "$cols1+1"|bc`
fi

printf "\033[48;5;244m\033[38;5;231m"
printf "%*s%*s\n\r" $cols1 "MBLET CONFIGS" $cols2 ""
printf "\033[38;5;226m\033[7m"
printf "%*s%*s" $cols1 "INSTALL SPEED" $cols2 ""
printf "\033[0m\n\r"

tput civis # hide cursor

trap ctrl_c INT

function ctrl_c() {
	tput cnorm
	exit
}

##
## function print
##

function print_middle()
{
	local _str=`echo "$1"`
	local _len="${#_str}"
	local _cols1=`echo "$(tput cols)/2+$_len/2"|bc`
	local _cols2=`echo "$(tput cols)/2-$_len/2"|bc`

	if [ $result != $(tput cols) ]; then
		cols1=`echo "$cols1+1"|bc`
	fi

	printf "%*s" $_cols1 "$_str"
	printf "%*s\n\r" $_cols2 ""
}

function print_menu()
{
	local index=$1

	printf "\n\r"
	for (( i=0; i<${menulength}; i++ ));
	do
		if [[ $index == "$i" ]]; then
			printf "\033[7m"
		else
			printf "\033[0m"
		fi
		print_middle "${menu[$i]}"
		printf "\033[0m"
	done
}

##
## while
##

index=0

print_menu $index

while read -r -n 1 C; do
case $C in
	$'\x1b')
		read -srn1 -t 1 D
		if [[ "$D" == "[" ]]; then
			read -rsn1 -t 1 E
			case $E in
				A) index=$(($index - 1));;
				B) index=$(($index + 1));;
				C) index=$(($index + 1));;
				D) index=$(($index - 1));;
			esac
			if [[ $index > "${menulengthend}" ]]; then
				index=${menulengthend}
			fi
			if [[ $index < "0" ]]; then
				index=0
			fi
			printf "\r\033[K"
			for i in "${menu[@]}"
			do
				tput up
			done
			tput up
			print_menu $index
		fi;;
	*)	break;;
esac
done

tput cnorm
clear
menu$index
exit
