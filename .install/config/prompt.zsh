stty -ixon

autoload -U colors && colors

rm -fr ~/Library/Fonts/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.otf
cp ~/#_my_config/Fonts/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.otf ~/Library/Fonts/

TMOUT=60
TRAPALRM() {
	if [[ ${commands[(r)$LBUFFER]} == $LBUFFER ]] ; then
		#sed -i '' -e "1s/solution(X)\:\-maisons(5, X)\./solution(X)\:\-maisons(5, X)\,/" step2.pl &> /dev/null
		zle reset-prompt
	fi
}

arrowright="⬤ "

reset="%{$reset_color%}"

fg_color=$'%{\e[38;5;231m%}'

home_bg=$reset
home_fg=$reset

home_bg_color=$'%{\e[48;5;25m%}'
home_fg_color=$'%{\e[38;5;25m%}'
home_bg_color2=$'%{\e[48;5;32m%}'
home_fg_color2=$'%{\e[38;5;32m%}'

dir_bg=$reset
dir_fg=$reset

dir_bg_color=$'%{\e[48;5;237m%}'
dir_fg_color=$'%{\e[38;5;237m%}'
dir_bg_color2=$'%{\e[48;5;239m%}'
dir_fg_color2=$'%{\e[38;5;239m%}'

root_bg=$reset
root_fg=$reset

root_bg_color=$'%{\e[48;5;166m%}'
root_fg_color=$'%{\e[38;5;166m%}'
root_bg_color2=$'%{\e[48;5;208m%}'
root_fg_color2=$'%{\e[38;5;208m%}'

red_bg=$'%{\e[48;5;124m%}'
red_fg=$'%{\e[38;5;124m%}'

git_bg=$reset
git_fg=$reset

git_bg_color=$'%{\e[48;5;164m%}'
git_fg_color=$'%{\e[38;5;164m%}'
not_git_bg_color=$'%{\e[48;5;242m%}'
not_git_fg_color=$'%{\e[38;5;242m%}'
not_git_bg_color2=$'%{\e[48;5;240m%}'
not_git_fg_color2=$'%{\e[38;5;240m%}'

fgplus0=$'%{\e[38;5;242m%}'
fgplus1=$'%{\e[38;5;245m%}'
fgplus2=$'%{\e[38;5;250m%}'

PR_TITLEBAR=$'%{\e]0;%D{%H:%M} %m %~/\a%}'
PR_STITLE=$'%{\e\e%}'

GIT_STATS=1

# ╔════════════════╗
# ║     PROMPT     ║
# ╚════════════════╝

function precmd()
{
	my_prompt
}

function my_prompt()
{
	local HOME_DIR=`echo $HOME\/`
	local my_pwd
	my_pwd=`echo $PWD | sed 's/\/Volumes\/Data//'`
	if [[ -z ${TOGGLE} ]]; then
		TOGGLE=1
		home_bg=$home_bg_color
		home_fg=$home_fg_color
		dir_bg=$dir_bg_color
		dir_fg=$dir_fg_color
		root_bg=$root_bg_color
		root_fg=$root_fg_color
	else
		unset TOGGLE
		home_bg=$home_bg_color2
		home_fg=$home_fg_color2
		dir_bg=$dir_bg_color2
		dir_fg=$dir_fg_color2
		root_bg=$root_bg_color2
		root_fg=$root_fg_color2
	fi

	if [[ "$my_pwd" == $HOME ]]; then
		prompt_in_home
	elif [[ "$my_pwd" == $HOME_DIR* ]]; then
		prompt_in_home
	else
		prompt_in_not_home
	fi

	___Right_Prompt
}

# ╔════════════════╗ #
# ║  LEFT  PROMPT  ║ #
# ╚════════════════╝ #

function prompt_in_home()
{
	local locallast="$(basename "$PWD")"
	local localhome
	localhome=`echo $PWD | sed 's/\/Volumes\/Data//'`
	localhome=`echo $localhome | sed 's/'"${HOME//\//\\/}"'//'`
	if [[ -n $localhome ]]; then
		localhome=`echo $localhome | sed 's/\(.*\)'${locallast}'/\1/'`
		localhome=`echo ${localhome%?}`
		localhome=`echo ${localhome:1}`
		local tmp=$localhome
		localhome=`echo $localhome | sed 's/\//  /g'`
		___Left_Prompt "~" $localhome $tmp $locallast
	else
		PROMPT="$PR_STITLE${PR_TITLEBAR}${root_bg}${fg_color} ~ ${reset}${root_fg}$(___Check_Permition) ${reset}"
	fi
}

function prompt_in_not_home()
{
	local locallast="$(basename "$PWD")"
	local localhome
	if [ `echo $PWD | wc -c` -gt '2' ]; then
		localhome=`echo $PWD`
		localhome=`echo $localhome | sed 's/\(.*\)'${locallast}'/\1/'`
		localhome=`echo ${localhome%?}`
		localhome=`echo ${localhome:1}`
		local tmp=$localhome
		localhome=`echo $localhome | sed 's/\//  /g'`
		___Left_Prompt "@" $localhome $tmp $locallast
	else
		PROMPT="$PR_STITLE${PR_TITLEBAR}${root_bg}${fg_color} @ ${reset}${root_fg}$(___Check_Permition) ${reset}"
	fi
}

function ___Left_Prompt()
{
	local tmp=$2
	PROMPT="$PR_STITLE${PR_TITLEBAR}${root_bg}${fg_color} $1 "
	if [ `echo $tmp | wc -c` -gt '30' ]; then
		tmp="${fgplus0}.${fgplus1}.${fgplus2}.${reset}${dir_bg}${fg_color}  $(basename "$3")"
	fi
	if [[ -n $4 ]]; then
		PROMPT+="${dir_bg}${root_fg}${reset}${dir_bg}${fg_color} $tmp ${reset}"
		PROMPT+="${home_bg}${dir_fg}"
		PROMPT+="${reset}${home_bg}${fg_color} $4 ${reset}${home_fg}$(___Check_Permition) ${reset}"
	else
		PROMPT+="${home_bg}${root_fg}"
		PROMPT+="${reset}${home_bg}${fg_color} $2 ${reset}${home_fg}$(___Check_Permition) ${reset}"
	fi
}

function ___Check_Permition()
{
	permition=""
	if [ ! -w $PWD ]; then
		permition="${red_bg}${fg_color}  ${reset}${red_fg}"
	fi
	permition+=""
	echo $permition
}
# ╔════════════════╗ #
# ║  RIGHT PROMPT  ║ #
# ╚════════════════╝ #

function ___Right_Prompt()
{
	git_bg=$not_git_bg_color
	git_fg=$not_git_fg_color
	if [[ -n $(___Check_Git_Branch) ]]; then
		if [[ -n $(___Check_Git_Status) ]]; then
			git_bg=$git_bg_color
			git_fg=$git_fg_color
		fi
		RPROMPT="${git_fg}${git_bg}${fg_color} $(___Check_Git_Branch)  "
		git_bg=$not_git_bg_color2
		git_fg=$not_git_fg_color2
		RPROMPT+="${git_fg}${git_bg}${fg_color} %D{%H:%M} ${reset}"
	else
		RPROMPT="${git_fg}${git_bg}${fg_color} %D{%H:%M} ${reset}"
	fi
}

function ___Check_Git_Branch()
{
	if [ -n $PROMPT_GIT ]; then
		if [[ $PROMPT_GIT == "true" ]]; then
			if gittest=`git symbolic-ref -q HEAD` &> /dev/null; then
				branch=`basename $gittest`
				echo $branch
			fi
		fi
	fi
}

function ___Check_Git_Status()
{
	if [ -n $PROMPT_GIT ]; then
		if [[ $PROMPT_GIT == "true" ]]; then
			if gittest=`git status --ignore-submodules` &> /dev/null; then
				testgit="nothing to commit"
				if [[ "$gittest" == *$testgit* ]]; then

				else
					echo "0"
				fi
			fi
		fi
	fi
}

function Prompt_git()
{
	export PROMPT_GIT="true"
}

function Prompt_nogit()
{
	export PROMPT_GIT="false"
}
