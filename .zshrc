# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:/opt/nvim-linux64/bin:$HOME/.local/bin:$HOME/.cargo/bin/"
export ZSH_CONFIG="$HOME/.config/zsh"
export ZSH_PLUGINS_DIR="$ZSH_CONFIG/plugins"
export ZSH_PLUGINS_CFG_DIR="$ZSH_PLUGINS_DIR/config"
export ZSH_THEMES_DIR="$ZSH_CONFIG/themes"
export ZSH_THEMES_CFG_DIR="$ZSH_THEMES_DIR/config"

# Alacritty
fpath+=$ZSH_CONFIG/.zsh_functions/
# LF
source $ZSH_CONFIG/lf.zsh

# Default editor

export EDITOR=nvim
export VISUAL="$EDITOR"

# Functions
source $ZSH_CONFIG/functions.zsh

zsh_add_file aliases.zsh
zsh_add_file nnn.zsh

# Plugins
zsh_add_plugin zsh-users/zsh-autosuggestions
zsh_add_plugin zsh-users/zsh-syntax-highlighting

source "$ZSH_CONFIG/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZSH_CONFIG/p10k.zsh"

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
setopt appendhistory

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ceedrich/.config/zsh/plugins/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ceedrich/.config/zsh/plugins/fzf/bin"
fi
source <(fzf --zsh)

