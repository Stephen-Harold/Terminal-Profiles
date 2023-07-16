#!/bin/bash

-f () {
	function functionDebug () {
		local scriptName=$1
		local message=$2
		[[ ${DEBUG} -eq 1 ]] && echo "${WHITE}-${RED}-=|] $(date +%H:%M:%S) [|=-${WHITE}-${YELLOW}-=|] $${WHITE}{scriptName:-"Script Name Not Set!"} [|=-${WHITE}-${GREEN}-=|] ${message:-"Message variable Not Set! (No argument passed to debug function). [|=-${WHITE}-"}${RESET}"
	}
}

add-zsh-hook () {
	emulate -L zsh
	local -a hooktypes
	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name)
	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes"
	local opt
	local -a autoopts
	integer del list help
	while getopts "dDhLUzk" opt
	do
		case $opt in
			(d) del=1  ;;
			(D) del=2  ;;
			(h) help=1  ;;
			(L) list=1  ;;
			([Uzk]) autoopts+=(-$opt)  ;;
			(*) return 1 ;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if (( list ))
	then
		typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
		return $?
	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
	then
		print -u$(( 2 - help )) $usage
		return $(( 1 - help ))
	fi
	local hook="${1}_functions"
	local fn="$2"
	if (( del ))
	then
		if (( ${(P)+hook} ))
		then
			if (( del == 2 ))
			then
				set -A $hook ${(P)hook:#${~fn}}
			else
				set -A $hook ${(P)hook:#$fn}
			fi
			if (( ! ${(P)#hook} ))
			then
				unset $hook
			fi
		fi
	else
		if (( ${(P)+hook} ))
		then
			if (( ${${(P)hook}[(I)$fn]} == 0 ))
			then
				typeset -ga $hook
				set -A $hook ${(P)hook} $fn
			fi
		else
			typeset -ga $hook
			set -A $hook $fn
		fi
		autoload $autoopts -- $fn
	fi
}
chpwd () {

}
declare () {
	functionDebug () {
		local scriptName=$1
		local message=$2
		[[ ${DEBUG} -eq 1 ]] && echo "${WHITE}-${RED}-=|] $(date +%H:%M:%S) [|=-${WHITE}-${YELLOW}-=|] $${WHITE}{scriptName:-"Script Name Not Set!"} [|=-${WHITE}-${GREEN}-=|] ${message:-"Message variable Not Set! (No argument passed to debug function). [|=-${WHITE}-"}${RESET}"
	}
}
functionDebug () {
	functionDebug () {
		local scriptName=$1
		local message=$2
		[[ ${DEBUG} -eq 1 ]] && echo "${WHITE}-${RED}-=|] $(date +%H:%M:%S) [|=-${WHITE}-${YELLOW}-=|] $${WHITE}{scriptName:-"Script Name Not Set!"} [|=-${WHITE}-${GREEN}-=|] ${message:-"Message variable Not Set! (No argument passed to debug function). [|=-${WHITE}-"}${RESET}"
	}
}
loadBackupProfile () {
	alias ll='ls -lhG'
	alias la='ls -lhAG'
	PS1="[%n@%M] (%2~)$: "
	PS2="(%2~)$: "
	echo "(.zshrc) Backup ZSH profile loaded,\n\r$zshProfile not found."
}
periodic () {
	if [ $_tn -gt 1 ]
	then
		print -Pn "\e]2;$(uptime);\a"
		print -Pn "\e]1; %m: %n  (  ${PWD/$HOME/'Home'}  ) \a"
	else
		print -Pn "\e]2;$(uptime);\a"
	fi
}
precmd () {
	local _exitValue=$?
	local _prefix="/Users/stephen-harold/.local/profiles/zsh.d"
	local _filePS1="$_prefix/zshPS01"
	local _filePS2="$_prefix/zshPS02"
	[[ -r "$_filePS1" ]] && PS1=$( "$_filePS1" "$_exitValue" || PS1="[%n@%M] (%2~)$: ")
	[[ -r "$_filePS2" ]] && PS2=$( "$_filePS2" "$_exitValue" || PS2="(%2~)$: ")
}
shell_session_delete_expired () {
	if [ ! -e "$SHELL_SESSION_TIMESTAMP_FILE" ] || [ -z "$(/usr/bin/find "$SHELL_SESSION_TIMESTAMP_FILE" -mtime -1d)" ]
	then
		local expiration_lock_file="$SHELL_SESSION_DIR/_expiration_lockfile"
		if /usr/bin/shlock -f "$expiration_lock_file" -p $$
		then
			echo -n 'Deleting expired sessions...' >&2
			local delete_count=$(/usr/bin/find "$SHELL_SESSION_DIR" -type f -mtime +2w -print -delete | /usr/bin/wc -l)
			[ "$delete_count" -gt 0 ] && echo $delete_count' completed.' >&2 || echo 'none found.' >&2
			(
				umask 077
				/usr/bin/touch "$SHELL_SESSION_TIMESTAMP_FILE"
			)
			/bin/rm "$expiration_lock_file"
		fi
	fi
}
shell_session_history_allowed () {
	if [ -n "$HISTFILE" ]
	then
		local allowed=0
		if [[ -o INC_APPEND_HISTORY ]] || [[ -o INC_APPEND_HISTORY_TIME ]] || [[ -o SHARE_HISTORY ]]
		then
			allowed=${SHELL_SESSION_HISTORY:-0}
		else
			allowed=${SHELL_SESSION_HISTORY:=1}
		fi
		if [ $allowed -eq 1 ]
		then
			return 0
		fi
	fi
	return 1
}
shell_session_history_check () {
	if [ ${SHELL_SESSION_DID_HISTORY_CHECK:-0} -eq 0 ]
	then
		SHELL_SESSION_DID_HISTORY_CHECK=1
		shell_session_history_allowed && shell_session_history_enable
		autoload -Uz add-zsh-hook
		add-zsh-hook -d precmd shell_session_history_check
	fi
}
shell_session_history_enable () {
	(
		umask 077
		/usr/bin/touch "$SHELL_SESSION_HISTFILE_NEW"
	)
	HISTFILE="$SHELL_SESSION_HISTFILE_NEW"
	SHELL_SESSION_HISTORY=1
}
shell_session_save () {
	if [ -n "$SHELL_SESSION_FILE" ]
	then
		echo -ne '\nSaving session...' >&2
		(
			umask 077
			echo 'echo Restored session: "$(/bin/date -r '$(/bin/date +%s)')"' >| "$SHELL_SESSION_FILE"
		)
		whence shell_session_save_user_state > /dev/null && shell_session_save_user_state "$SHELL_SESSION_FILE"
		local f
		for f in $shell_session_save_user_state_functions
		do
			$f "$SHELL_SESSION_FILE"
		done
		shell_session_history_allowed && shell_session_save_history
		echo 'completed.' >&2
	fi
}
shell_session_save_history () {
	shell_session_history_enable
	fc -AI
	if [ -f "$SHELL_SESSION_HISTFILE_SHARED" ] && [ ! -s "$SHELL_SESSION_HISTFILE" ]
	then
		echo -ne '\n...copying shared history...' >&2
		(
			umask 077
			/bin/cp "$SHELL_SESSION_HISTFILE_SHARED" "$SHELL_SESSION_HISTFILE"
		)
	fi
	echo -ne '\n...saving history...' >&2
	(
		umask 077
		/bin/cat "$SHELL_SESSION_HISTFILE_NEW" >> "$SHELL_SESSION_HISTFILE_SHARED"
	)
	(
		umask 077
		/bin/cat "$SHELL_SESSION_HISTFILE_NEW" >> "$SHELL_SESSION_HISTFILE"
	)
	/bin/rm "$SHELL_SESSION_HISTFILE_NEW"
	if [ -n "$SAVEHIST" ]
	then
		echo -n 'truncating history files...' >&2
		fc -p "$SHELL_SESSION_HISTFILE_SHARED" && fc -P
		fc -p "$SHELL_SESSION_HISTFILE" && fc -P
	fi
	echo -ne '\n...' >&2
}
shell_session_update () {
	shell_session_save && shell_session_delete_expired
}
update_terminal_cwd () {
	local url_path=''
	{
		local i ch hexch LC_CTYPE=C LC_COLLATE=C LC_ALL= LANG=
		for ((i = 1; i <= ${#PWD}; ++i)) do
			ch="$PWD[i]"
			if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]
			then
				url_path+="$ch"
			else
				printf -v hexch "%02X" "'$ch"
				url_path+="%$hexch"
			fi
		done
	}
	printf '\e]7;%s\a' "file://$HOST$url_path"
}
