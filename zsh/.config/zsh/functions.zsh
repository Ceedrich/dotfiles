zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
        git clone --quiet "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    zsh_add_file "plugins/config/$PLUGIN_NAME.zsh"
}
