# Vi bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down

# make delete key work
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] ||
	     [[ ${KEYMAP} == viins ]] ||
	     [[ ${KEYMAP} = '' ]] ||
	     [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select
zle-line-init() {
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Set window title to current directory
DISABLE_AUTO_TITLE="true"

case $TERM in
	st*)
		precmd () {print -Pn "\e]0;%~\a"}
		;;
esac

CASE_SENSITIVE="false"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

ZSH_THEME="gruvbox"

# enable colors
autoload -U colors && colors
. "/usr/share/LS_COLORS/dircolors.sh"

# set prompt
PROMPT="%B%F{10}%n%F{15}@%F{14}%m%f:%F{4}%~%F{15}$ %f"

# git prompt
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*' formats '%B%F{15} %F{9}%u%F{15}%b%F{10}%c%f%a'
precmd() { vcs_info }

RPROMPT='${vcs_info_msg_0_}'

# tab complete
zstyle :compinstall filename '/home/ak/.config/zsh/.zshrc'
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# fuzzy completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric


# aliases
alias startx="startx $XDG_CONFIG_HOME/X11/xinitrc"
alias irssi="irssi --config $XDG_CONFIG_HOME/irssi/config"
alias units="units --history $XDG_CACHE_HOME/unitshst"
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias s="sudo "
alias se="sudoedit"
alias p="pacman"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vifm="vifm-previewer.sh"
alias g="git"
alias py="python"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias update-mirrors="reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias yacc="byacc" # I did this so that something would install right

# Other

# locations
alias apps="cd /usr/share/applications"
alias themes="cd /usr/share/themes"
alias input="cd /usr/share/X11/xorg.conf.d"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# global configs
alias grubrc="sudoedit /etc/default/grub"
alias tlprc="sudoedit /etc/tlp.conf"
alias libinputrc="cd /etc/X11/xorg.conf.d"

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
source /usr/share/doc/find-the-command/ftc.zsh
