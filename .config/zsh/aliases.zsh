# Zsh
alias reload="source ~/.zshrc"

alias ls="eza"
alias l="eza --icons --git -al"

# Pyhton
alias py="python3"
alias python="python3"

# Vim
alias vim="nvim"
alias vi="nvim"
alias view="nvim -R"

# Bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias cat="bat --paging=never"

# Git
alias gd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
alias gst="git status"
alias ga="git add"
alias gp="git push"
alias gc="git commit"

# Zoxide
alias zstats="zoxide query -las | less"

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Utitlities
cdd() {mkdir $1 && cd $1}
alias open="gio open"
alias ..="cd ../"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../../"


zshconfig() {
    dir=""
    while getopts "p:t:" opt; do
        case $opt in
            p)
                if [ -n "$dir" ]; then
                    echo "Error: -p and -t options are mutually exclusive." >&2
                    return 1
                fi
                dir="p"
                ;;
            t)
                if [ -n "$dir" ]; then
                    echo "Error: -p and -t options are mutually exclusive." >&2
                    return 1
                fi
                dir="t"
                ;;
            \?)
                echo "Invalid option. Use -t for themes or -p for plugins">&2
                return 1
                ;;
        esac
    done
    if [[ "$dir" == "p" ]]; then
        file="$ZDOTDIR/plugins/$2.zsh"
    elif [[ "$dir" == "t" ]]; then
        file="$ZDOTDIR/config/$2.zsh"
    elif [[ -n "$1" ]]; then
        file="$ZDOTDIR/$1.zsh"
    else
        file="$ZDOTDIR/.zshrc"
    fi
    
    if ! [[ -f $file ]]; then
        echo "The file $file does not exist. Do you want to create one anyways? (y/n)"
        read -r response
        case $response in
            [yY][eE][sS]|[yY])
                ;;
            *)
                echo "File creation aborted"
                return 0
                ;;
        esac
    fi
    nvim $file
}

_zshconfig() {
    echo $ZSH_PLUGINS_CFG_DIR/$1.zsh
    if [[ -z "$1" ]]; then
        echo Home
        nvim "$HOME/.zshrc"
    elif [[ "$1" == plugins/* ]] && [[ -f "$ZSH_PLUGINS_CFG_DIR/$1.zsh" ]]; then
        echo plugins
        nvim "$ZSH_PLUGINS_CFG_DIR/$1.zsh"
    elif [[ -f "$ZSH_CONFIG/$1.zsh" ]]; then
        nvim "$ZSH_CONFIG/$1.zsh"
    else
        echo "File $ZSH_CONFIG/$1.zsh does not exist." # Create the file (y/n)?
    fi
}

