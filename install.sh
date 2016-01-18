#!/bin/bash

echo ""
cols=`echo "$(tput cols)"`
cols1=`echo "$(tput cols)/2+14/2"|bc`
cols2=`echo "$(tput cols)/2-14/2"|bc`
result=`echo "$cols1+$cols2"|bc`
if [ $result != $cols ]; then
	cols1=`echo "$cols1+1"|bc`
fi
printf "\033[38;5;226m\033[7m"
printf "%*s%*s" $cols1 "INSTALL SPEED" $cols2 ""
printf "\033[0m\n\r"
printf "\n\r1. VIM + ZSH\n\r2. ZSH\n\r3. VIM\n\rChoose your option : "
read -s -n 1 C
case $C in
	1) printf "\r\033[K\n";;
	2) echo "ZSH";;
	3) echo "VIM";;
esac
tput up
tput up
tput up
tput up
printf "\033[K\n"
printf "\033[K\n"
printf "\033[K"
tput up
tput up
printf "\033[48;5;118m%*s\033[0m\n" $cols ""
printf "\033[48;5;118m%*s\033[0m\n" $cols ""
printf "\033[48;5;118m%*s\033[0m\n" $cols ""
echo ""
