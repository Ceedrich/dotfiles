# Zsh
alias reload="source $ZDOTDIR/.zshrc"

if cmd_exists eza; then
  alias ls="eza"
  alias l="eza --icons --git -al"
fi

if cmd_exists yazi; then
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
fi

# Pyhton
if cmd_exists python3; then
  alias py="python3"
  alias python="python3"
fi

# Vim
if cmd_exists nvim; then
  alias vim="nvim"
  alias vi="nvim"
  alias view="nvim -R"
fi

# Bat
if cmd_exists bat; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
  alias cat="bat --paging=never"
fi

# Git
if cmd_exists delta; then 
  alias gd='git diff -u | delta --side-by-side\
  --blame-palette "#1e1e2e #181825 #11111b #313244 #45475a"\
	--commit-decoration-style "box ul"\
	--dark \
	--file-decoration-style "#cdd6f4" \
	--file-style "#cdd6f4"\
	--hunk-header-decoration-style "box ul"\
	--hunk-header-file-style "bold"\
	--hunk-header-line-number-style "bold \"#a6adc8\""\
	--hunk-header-style "file line-number syntax"\
	--line-numbers \
	--line-numbers-left-style "#6c7086"\
	--line-numbers-minus-style "bold \"#f38ba8\""\
	--line-numbers-plus-style "bold \"#a6e3a1\""\
	--line-numbers-right-style "#6c7086"\
	--line-numbers-zero-style "#6c7086"\
	--minus-emph-style "bold syntax \"#53394c\""\
	--minus-style "syntax \"#34293a\"" \
	--plus-emph-style "bold syntax \"#404f4a\"" \
	--plus-style "syntax \"#2c3239\"" \
	--map-styles "\
		   bold purple => syntax \"#494060\", \
		   bold blue => syntax \"#384361\", \
		   bold cyan => syntax \"#384d5d\", \
		   bold yellow => syntax \"#544f4e\""\
	--syntax-theme "Catppuccin Mocha"'
elif cmd_exists bat; then
  alias gd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
else
  alias gd="git diff"
fi
alias gst="git status"
alias ga="git add"
alias gp="git push"
alias gc="git commit"
alias gco="git checkout"

# Zoxide
if cmd_exists zoxide; then
  alias zstats="zoxide query -las | less"
fi

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
alias -g ..="../"
alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../../"


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
