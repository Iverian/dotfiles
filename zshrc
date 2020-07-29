export PATH=$HOME/.local/scripts:$HOME/.local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

if [ -f "$HOME/.cache/wal/sequences" ]; then
	cat "$HOME/.cache/wal/sequences"
fi

ZSH_THEME="simple"

plugins=(
    git
    git-flow
    archlinux
    virtualenv
    vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration
source "/usr/share/fzf/key-bindings.zsh"
source "/usr/share/fzf/completion.zsh"
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

paccleanup() {
    yay -Rns $(yay -Qtdq)
}

alias la='ls --group-directories-first -AlhX'
