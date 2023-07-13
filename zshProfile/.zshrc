#!/bin/zsh
# -= OPTIONS RE: GLOBS & EXPANSION =-
setopt NOMATCH              # If a pattern for filename generation has no matches print an error
setopt MARK_DIRS            # add trailing slash always
setopt GLOB_DOTS            # don't require the leading . on filenames to match
setopt CASE_MATCH           # RegEx when globing % expansion (including matches with =~) sensitive to case
setopt BAD_PATTERN          # error on bad pattern
# -= OPTIONS RE: COMMAND AUTOCOMPLETE & CORRECTION =-
setopt ALWAYS_TO_END        # GoTo End of auto-completed
setopt LIST_ROWS_FIRST      # list auto-complete options side-by-side
unsetopt LIST_BEEP          # No beep on confusing completion
setopt MENU_COMPLETE        # instead of beeping complete first match
setopt CORRECT              # correct commands
# -= OPTIONS RE: SECURITY =-
setopt MAIL_WARNING         # warning message if a mail file accessed since been checked
# -= OPTIONS RE: COMMAND LINE HISTORY =-
HISTFILE=${ZDOTDIR:-$HOME}/.zshCommandLineHistory
HISTSIZE=4000
SAVEHIST=2000
setopt BANG_HIST                # expand !!
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS     # ignore and don't add duplicates
setopt HIST_REDUCE_BLANKS       # does what it says
setopt SHARE_HISTORY            # share history file
unsetopt INC_APPEND_HISTORY     # this goes with SHARE_HISTORY
setopt HIST_FCNTL_LOCK          # history file locked when in use
setopt BANG_HIST                # perform textual history expansion
# -= OPTIONS RE: PROMPT  =-
setopt PROMPT_PERCENT           # % treated special
setopt PROMPT_SUBST             # parameter expansion & command substitution are performed in prompts
setopt PROMPT_BANG
setopt PROMPT_SP PROMPT_CR      # SP: \r at end of partial line, CP: \r before prompt
# -= OPTIONS RE: TITLES =-
 DISABLE_AUTO_TITLE=true;
# -= Alert: Sound =-
setopt BEEP
# -= DOCK: HIDE/UNHIDE =-
defaults write com.apple.dock autohide-delay -float 0.0001; killall Dock;
# -= ENV: ALIASES =-
alias ll='ls -lhG';
alias la='ls -lhAG';
alias grep='grep --color=always'
alias egrep='egrep --color=always'
alias listening='lsof -i -P | egrep -i LISTEN'
alias numTabs='ps -afx | egrep -i \"\-(zsh|bash)\" | grep -iv \"grep\" | wc -l'
alias estab='sudo lsof -nP -i4TCP | grep EST';
# -= ENV: EXPORTS =-
# terminal foreground text colours
export RED=$( tput setaf 160);
export GREEN=$(tput setaf 40);
export BLUE=$(tput setaf 33);
export WHITE=$(tput setaf 15);
export YELLOW=$(tput setaf 220);
export CYAN=$(tput setaf 51);
export BLACK=$(tput setaf 232);
export PURPLE=$(tput setaf 56);
export PINK=$(tput setaf 201);
export TEAL=$(tput setaf 41);
# terminal text decorations
export BOLD=$(tput bold);
export UL=$(tput smul);
export LU=$(tput rmul);
export RESET=$(tput sgr0);
# terminal text colours, foreground & background
export redOnWhite=$(tput setab 15; tput setaf 1;);
export whiteOnRed=$(tput setab 1; tput setaf 15;);
export BlueOnBlue=$(tput setab 17; tput setaf 12;);
export PAGER=less;
export EDITOR=nano;
export GREP_COLOR=36;
export USERNAME=$LOGNAME;
export HOSTNAME=$HOST;
export du="/usr/local/lib/utils.d";
export dirCOMMON="/Users/stephen-harold/.local/profiles/common.d";
export dirZSH="~/.local/profiles/zsh.d";
export dirBASH="~/.local/profiles/bash.d";
export dirSHARE="~/.local/share";
export utilsDebug="Off";
# DON'T MOVE OR EDIT THESE NEXT 2 LINES OF CODE!
_tn=$( ps -afx | egrep -i '\-zsh' | grep -v 'grep' | wc -l );
export TerminalTabsCount=$( echo $_tn | tr -d '[:space:]' );
declare -f DEBUG;
export DEBUG_ENABLED=1; # SET TO 1 FOR ON
function DEBUG_FUNCTION() {
    local scriptName=$1;
    local message=$2;
    [[ "$DEBUG" = 1 ]] && echo "${WHITE}-${RED}-=|] $(date +%H:%M:%S) [|=-${WHITE}-${YELLOW}-=|] ${WHITE}{scriptName:-"Not Set!"} [|=-${WHITE}-${GREEN}-=|] ${message:-"Message Variable Not Set. [|=-${WHITE}-"}${RESET}";
}
export DEBUG=DEBUG_FUNCTION;

function precmd() {
    local _exitValue=$?;
    local _prefix="/Users/stephen-harold/.local/profiles/zshProfile";
    local _filePS1="$_prefix/zshPS01";
    local _filePS2="$_prefix/zshPS02";
    [[ -r "$_filePS1" ]] && PS1=$( "$_filePS1" "$_exitValue" || PS1="[%n@%M] (%2~)$: ")
    [[ -r "$_filePS2" ]] && PS2=$( "$_filePS2" "$_exitValue" || PS2="(%2~)$: ")
}
