export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

autoload -U $ZSH/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY # don't execute history expansion commands immediately
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST # allow prompt to be modified for variables
setopt CORRECT # correct commands
setopt COMPLETE_IN_WORD # complete from both ends of a word
setopt IGNORE_EOF # do not exit on ctrl-d

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS # remove superfluous blanks from history

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt COMPLETE_ALIASES

