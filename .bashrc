# TODO: i'm intrgued by fish Alt-Left(prevd) Alt-Right(nextd) may be i can build that too
# set default editor to neovim
export EDITOR=nvim
export MANPAGER='nvim +Man!' # use nvim as pager
# export MANWIDTH=999             # let nvim handle wraparound

# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL='erasedups:ignoreboth' # ignoreboth = ignoredups:ignorespace

# ignore frequently used command from history
export HISTIGNORE='ls:la:pwd:[bf]g:history:clear:$:[ ]*:exit'
export HISTTIMEFORMAT="[%F %T] "

# bigger history
HISTSIZE=9999999
HISTFILESIZE=9999999

# Store bash history immediately
PROMPT_COMMAND='history -a'

# Append to the history file, don't overwrite it
shopt -s histappend

# save multiline commands to the history as one
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enables automatic directory change feature,
# allowing it to change to a directory when a directory name is entered on the command line.
shopt -s autocd

# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Lists the status of any stopped and running jobs before exiting an interactive
# shell. If any jobs are running, this causes the exit to be deferred until a
# second exit is attempted without an intervening command.
shopt -s checkjobs

# Automatically expand directory globs when completing
shopt -s direxpand

# Autocorrect directory typos when completing
shopt -s dirspell

# disable completion when the input buffer is empty.  i.e. hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable autocompletion for aliases
shopt -s expand_aliases

# Prevent regular files to be overwritten by redirection of shell output
set -o noclobber

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Include filenames beginning with a ‘.' in the results of pathname expansion
shopt -s dotglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# After a history expansion, don't execute the resulting command immediately.
# Instead, write the expanded command into the readline editing  buffer for
# further modification.
shopt -s histverify

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# colored grep output
# export GREP_OPTIONS='--color=auto'
export GREP_COLORS='mt=color'

# Alias definitions.
if [ -f ~/.config/bash_aliases ]; then
  . ~/.config/bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# command not found hook
[ -s "/usr/share/doc/pkgfile/command-not-found.bash" ] && source "/usr/share/doc/pkgfile/command-not-found.bash"

# Keybinds
bind Space:magic-space # Any ! combination will be automatically expanded when hitting space

# Mimic Zsh run-help ability
# invoke the manual for the command preceding the cursor by pressing Alt+h
function run_help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE" || "$READLINE_LINE" --help; }
bind -m vi-insert -x '"\eh": run_help'
bind -m emacs -x '"\eh": run_help'

# get a random command line tips
function taocl() {
  curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
    sed '/cowsay[.]png/d' |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80 | iconv -t US
}

# nnn
# useful when used ! to spawn a shell in the current directory
#NOTE: not working with starship
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# cd on quit (Ctrl-G) for nnn
if [ -f /usr/share/nnn/quitcd/quitcd.bash_sh_zsh ]; then
  source /usr/share/nnn/quitcd/quitcd.bash_sh_zsh
fi

export PATH="${NVM_DIR}/versions/node/v18.16.0/bin":$PATH
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use

# since we manually add node path to PATH to decrease nvm startup, but the nvm startup script
# also adds node path to PATH which leads to duplicate entires in PATH. so let's remove it
PATH=$(sort <<< $(echo $PATH | tr ":" "\n") | uniq | tr '\n' ':')


# fzf keybindings && completion
[ -s "/usr/share/fzf/key-bindings.bash" ] && \. "/usr/share/fzf/key-bindings.bash"
[ -s "/usr/share/fzf/completion.bash" ] && \. "/usr/share/fzf/completion.bash"

# initialize zoxide
eval "$(zoxide init bash)"

# initialize starship
eval "$(starship init bash)"

# initialize conda
# [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# initialize ruby
# eval "$(rbenv init - bash)"

source $HOME/.config/broot/launcher/bash/br

export PATH="$PATH:$HOME/.local/bin"
