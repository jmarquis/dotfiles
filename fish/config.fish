export EDITOR=nvim
alias vi="nvim"
alias vim="nvim"
alias gdiff="gist -t diff"
alias g="git"
alias vm="mosh vm -- sh -c 'tmux -u a || tmux -u'"

if test -e /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

if test -e /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

if type -q rvm
    rvm default
end

if type -q rbenv
    status --is-interactive; and rbenv init - fish | source
end

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

set pure_symbol_prompt "➜"
set pure_color_prompt_on_success (set_color green)
set -U fish_color_command --bold

fish_add_path /home/linuxbrew/.linuxbrew/sbin

export NODE_OPTIONS=--max_old_space_size=8192
export GPG_TTY=$(tty)
export PRETTIERD_LOCAL_PRETTIER_ONLY=1

if status is-interactive
    if type -q zellij

        function zellij_tab_name_update --on-variable PWD
            if set -q ZELLIJ
                set tab_name $PWD
                if test "$tab_name" = "$HOME"
                    set tab_name "~"
                else
                    set tab_name (basename "$tab_name")
                end
                command nohup zellij action rename-tab $tab_name >/dev/null 2>&1 &
            end
        end

        function zellij_pane_name_update_pre --on-event fish_preexec
            if set -q ZELLIJ
                set -l cmd_line (string split " " -- $argv)
                set -l process_name $cmd_line[1]
                zellij action rename-pane $process_name
            end
        end

        function zellij_pane_name_update_post --on-event fish_postexec
            if set -q ZELLIJ
                sleep 0.00001 && zellij action rename-pane fish
            end
        end

        zellij_tab_name_update
        zellij_pane_name_update_post

    end
end
