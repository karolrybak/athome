#!/bin/zsh

r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else 
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name
}

r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

for key     kcap   seq        mode   widget (
    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history

    send    kEND   $'\E[1;2F' select   end-of-line
    send2   x      $'\E[4;2~' select   end-of-line
    
    shome   kHOM   $'\E[1;2H' select   beginning-of-line
    shome2  x      $'\E[1;2~' select   beginning-of-line

    # left    kcub1  $'\EOD'    deselect backward-char
    # right   kcuf1  $'\EOC'    deselect forward-char
    
   
    csleft  x      $'\E[1;6D'  select   backward-word
    csright x      $'\E[1;6C'  select   forward-word
    csend   x      $'\E[1;6F'  select   end-of-line
    cshome  x      $'\E[1;6H'  select   beginning-of-line
    
    del     kdch1   $'\E[3~'   delregion delete-char
    bs      x       $'^?'      delregion backward-delete-char
    cz      x       $'^Z'      deselect undo
    home    x       $'^[[H'    deselect beginning-of-line
    end     x       $'^[[F'    deselect end-of-line
    cright  x       $'^[[1;5C' deselect forward-word
    cleft   x       $'^[[1;5D' deselect backward-word

  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=('key-cright')

# restore backward-delete-char for Backspace in the incremental
# search keymap so it keeps working there:
bindkey -M isearch '^?' backward-delete-char

function j() {
  if [ $# -eq 0 ]; then
    if [ $(just -l | tail +2 | wc -l) -eq 1 ]; then
      just
    else
      just --choose
    fi
  else
    just "$@"
  fi
}
