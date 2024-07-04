export PATH="$PATH:/opt/nvim-linux64/bin:$HOME/.local/bin:$HOME/.cargo/bin/:$HOME/.deno/bin"

# compinstall
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 
zstyle ':completion:*' menu select
# end compinstall

bindkey -v

# Useful stuff
source $ZDOTDIR/functions.zsh
zsh_add_file options.zsh
zsh_add_file aliases.zsh
if cmd_exists tmux; then
  zsh_add_file tmux-sessions.zsh
fi

# Alacritty
fpath+=$ZDOTDIR/.zsh_functions/
# LF Icons
if cmd_exists lf; then
  source $ZDOTDIR/lf.zsh
fi

# Default editor
if cmd_exists nvim; then
  export EDITOR=nvim
  export VISUAL="$EDITOR"
fi

# Prompt
if cmd_exists oh-my-posh; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
fi
#eval "$(starship init zsh)"
# Plugins
zsh_add_plugin zsh-users/zsh-autosuggestions
zsh_add_plugin zsh-users/zsh-syntax-highlighting

# zoxide
if cmd_exists zoxide; then
  eval "$(zoxide init --cmd cd zsh)"
fi
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

