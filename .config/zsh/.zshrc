# git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

# enable colors and set prompt
autoload -U colors && colors
PS1="%B%{$fg[blue]%}%~%{$reset_color%}$ "

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
# fuzzy completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
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
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# use lf
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'ranger\n'

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

bindkey '^[[1;5A' history-substring-search-up
bindkey '^[[1;5B' history-substring-search-down


# aliases
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias s="sudo "
alias p="pacman"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias g="git"
alias py="python"
alias r="ranger"
alias shutdown="sudo shutdown -h now"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias update-mirrors="reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias rc="~/bin/configs.sh"

# Other

# locations
alias apps="cd /usr/share/applications"
alias input="cd /usr/share/X11/xorg.conf.d"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# configs
alias fontrc="nvim .config/fontconfig/fonts.conf"
alias grubrc="sudo nvim /etc/default/grub"
alias vrc="sudo nvim /etc/xdg/nvim/init.vim"
alias zrc="nvim ~/.config/zsh/.zshrc"
alias i3rc="nvim ~/.config/i3/config"
alias sxhkdrc="nvim ~/.config/sxhkd/sxhkdrc"
alias strc="nvim ~/.config/suckless/st/config.h"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
