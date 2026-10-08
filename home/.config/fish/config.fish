set -U fish_greeting ""

if status is-interactive
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
    if type -q zoxide
        zoxide init fish | source
    end
end

# format man pages
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# PATH additions
for p in $HOME/.local/bin $HOME/Applications/depot_tools
    if test -d $p
        if not contains -- $p $PATH
            set -p PATH $p
        end
    end
end

# vim keybinding
set -g fish_key_bindings fish_vi_key_bindings

# Always block cursor (disable cursor switching)
function fish_mode_prompt
    echo -n ''
end

# !! and !$ support
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function lt
    set -l eza_args -aT --color=always --group-directories-first --icons
    set -l ignore_patterns
    set -l ignoring 0
    for arg in $argv
        if test "$ignoring" = 1
            set ignore_patterns $ignore_patterns (string split ' ' -- "$arg")
            set ignoring 0
        else if test "$arg" = "-I"
            set ignoring 1
        else if string match -qr -- '^[0-9]+$' "$arg"
            set eza_args $eza_args --level=$arg
        else
            set eza_args $eza_args $arg
        end
    end
    if test (count $ignore_patterns) -gt 0
        set eza_args $eza_args -I (string join '|' $ignore_patterns)
    end
    eza $eza_args
end

# Bind history expansion to BOTH Vi Insert and Vi Normal/Default modes
bind -M default ! __history_previous_command
bind -M insert ! __history_previous_command

bind -M default '$' __history_previous_command_arguments
bind -M insert '$' __history_previous_command_arguments

# Better history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (string trim -r -c '/' $argv[1])
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

# mkcd DIR
function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end

# Extract archives
function extract
    set file $argv[1]
    if test -f $file
        switch $file
            case '*.tar.bz2'
                tar xjf $file
            case '*.tar.gz'
                tar xzf $file
            case '*.bz2'
                bunzip2 $file
            case '*.rar'
                unrar x $file
            case '*.gz'
                gunzip $file
            case '*.tar'
                tar xvf $file
            case '*.tbz2'
                tar xjf $file
            case '*.tgz'
                tar xzf $file
            case '*.zip'
                unzip $file
            case '*.Z'
                uncompress $file
            case '*.7z'
                7z x $file
            case '*'
                echo "'$file' cannot be extracted via extract()"
        end
    else
        echo "'$file' is not a valid file"
    end
end

# Alias
# ls replacements
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias l.='eza -a | grep -e "^\."'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# program alias
alias tmux="tmux -u"
alias sway="exec sway"
alias vi="nvim"

# shortcuts
alias q='exit'
alias h='history'
alias c='clear'

# git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcl='git clone'
alias gl='git log --oneline'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'

set -gx EDITOR nvim
set -gx VISUAL nvim

# environment variables (portable: $HOME works on any machine/user)
fish_add_path $HOME/.opencode/bin
fish_add_path $HOME/go/bin
