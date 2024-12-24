# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=( 
    git
    archlinux
    zsh-autosuggestions
#    zsh-syntax-highlighting
    fast-syntax-highlighting
    oh-my-matrix
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos



### From this line is for pywal-colors
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh

# My alias 

alias cty='tty-clock -S -c -C 6 -t -n -D'
alias fucking='sudo'
alias n='nvim'
# alias t='tmux'
# alias ta='tmux attach'
# alias tl='tmux ls'
alias cd..='cd ..'
alias gc='git clone '
alias ga='git add .'
alias gcm='git commit -m '
alias gp='git push -u orign main'
alias gs='git status'
# alias ll-'ls -Alh'
# alias ls='lsd --group-dirs first'
# alias cat='bat'
alias gc='g++ -o o'
alias py='python3'
alias icat='kitty +kitten icat'
alias hypr='exec hyprland'
alias vscode='code --disable-gpu'
alias heroicgameslauncher='heroic --enable-features=UseOzonePlatform --ozone-platform=x11'
alias nv='neovide'
alias lsa='lsd -la'
alias ls='lsd'
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
# source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
fastfetch
export PATH=~/bin:$PATH
export PATH="$HOME/.surrealdb:$PATH"

# Created by `pipx` on 2024-12-05 18:22:03
export PATH="$PATH:/home/migus/.local/bin"

# Yazi Setup
export EDITOR="nvim"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
