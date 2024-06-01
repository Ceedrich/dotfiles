zsh_add_file() {
    [ -f "$ZSH_CONFIG/$1" ] && source "$ZSH_CONFIG/$1"
}

zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$ZSH_CONFIG/plugins/$PLUGIN_NAME" ]; then
        git clone --quiet "https://github.com/$1.git" "$ZSH_CONFIG/plugins/$PLUGIN_NAME"
    fi
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    zsh_add_file "plugins/config/$PLUGIN_NAME.zsh"
}
