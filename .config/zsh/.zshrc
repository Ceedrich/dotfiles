export PATH="$PATH:/opt/nvim-linux64/bin:$HOME/.local/bin:$HOME/.cargo/bin/"

# compinstall
zstyle :compinstall filename "/home/ceedrich/.zshrc"
autoload -Uz compinit
compinit
# end compinstall

bindkey -v

# Useful stuff
source $ZDOTDIR/functions.zsh
zsh_add_file options.zsh
zsh_add_file aliases.zsh

# Alacritty
fpath+=$ZDOTDIR/.zsh_functions/
# LF
source $ZDOTDIR/lf.zsh

# Default editor

export EDITOR=nvim
export VISUAL="$EDITOR"

# Prompt
#eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
eval "$(starship init zsh)"
# Plugins
zsh_add_plugin zsh-users/zsh-autosuggestions
zsh_add_plugin zsh-users/zsh-syntax-highlighting

# zoxide
eval "$(zoxide init --cmd cd zsh)"
# zoxide end

# pnpm
export PNPM_HOME="/home/ceedrich/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ceedrich/.config/zsh/plugins/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ceedrich/.config/zsh/plugins/fzf/bin"
fi
source <(fzf --zsh)

