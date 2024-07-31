tms () {
  case "$1" in 
    web|pnpm)
      __tms_pnpm
      ;;
    ""|conf|config)
      __tms_config
      ;;
    *)
      >&2 echo "unknown option: $1"
      return 1
      ;;
  esac
}

__tms_pnpm() {
  tmux new-session -s $(basename $PWD)\; \
    send-keys "nvim" C-m \; \
    split-window -v \; \
    resize-pane -y 5 \; \
    send-keys "pnpm dev" C-m \; \
    split-window -h \;
    select-pane -t 1 \;
}

__tms_config() {
  tmux new-session -s $(basename $PWD)\; \
    send-keys "nvim" C-m \; \
    split-window -h \; \
    select-pane -t 1 \;
}
