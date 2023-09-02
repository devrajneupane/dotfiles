# load bashrc (useful when using tmux)
if [ -f $HOME/.bashrc ]; then
    . $HOME/.bashrc
fi

# Less status line
# export LESS='i~JMRSF'
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'

# less colorscheme
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;4;31m'

# LS_COLORS with vivid
# export LS_COLORS="$(vivid generate nord)"

# NNN specific environment variables
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_OPTS="dDeHuU"
export NNN_BMS="d:$HOME/Documents;p:$HOME/Pictures;D:$HOME/Downloads/;P:$HOME/Projects;v:$HOME/Videos"
export NNN_TRASH=1
export NNN_USE_EDITOR=1
export NNN_FIFO=/tmp/nnn.fifo
export NNN_COLORS='1234' # set a distinct color for each context
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
export NNN_PLUG='d:diffs;f:finder;k:preview-tabbed;m:mimelist;o:fzopen;p:mocq;r:dragdrop;t:nmount;v:imgview;z:fzfcd'
export NNN_BATTHEME="gruvbox-dark"
export NNN_BATSTYLE="changes,header,numbers,rule"
# export NNN_TMPFILE="${XDG_CONFIG_HOME}/nnn/.lastd"
# NNN_SHELL_PLUGINS='l:-!git log;x:!chmod +x $nnn'
# NNN_PLUGINS='p:preview-tui-ext;c:fzcd;o:fzopen'
# export NNN_PLUG="$NNN_PLUGINS;$NNN_SHELL_PLUGINS"
# unset NNN_SHELL_PLUGINS NNN_PLUGINS

# Fzf configuration
if [ -x "$(command -v fzf)" ]; then
    if which fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --strip-cwd-prefix --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git .'
    fi

    export FZF_DEFAULT_OPTS="
        --color=bg+:#414868,bg:#24283b,spinner:#9ece6a,hl:#f7768e
        --color=fg:#c0caf5,header:#f7768e,info:#e0af68,pointer:#9ece6a
        --color=marker:#9ece6a,fg+:#c0caf5,prompt:#e0af68,hl+:#f7768e
        --color=gutter:#24283b
        --prompt='❯ '
        --pointer=''
        --marker='¤'
        --bind=ctrl-k:kill-line
        --bind=alt-p:toggle-preview
        --bind=ctrl-u:preview-up
        --bind=ctrl-d:preview-down
        --cycle
        --border"

    export FZF_ALT_C_OPTS="
        --prompt='CD ❯ '
        --preview 'eza --all --ignore-glob=.git --tree --icons {} | head -100'"

    export FZF_CTRL_R_OPTS="
        --prompt='History ❯ '
        --preview 'echo {}'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | xsel --input --clipboard)+abort'"

    export FZF_CTRL_T_OPTS="
        --prompt='Files ❯ '
        --preview 'bat --style=numbers --color=always --line-range :300 {}'
        --bind 'enter:become(nvim {})'"


    # Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments to fzf.
    _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
        export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
    esac
    }

fi


# Initialize cargo
if [ -f $CARGO_HOME/env ]; then
    . $CARGO_HOME/env
fi

# Start tmux on every shell login
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s 0 >/dev/null 2>&1
fi

# Launch SSH agent.
# eval $(ssh-agent -t 3600)
