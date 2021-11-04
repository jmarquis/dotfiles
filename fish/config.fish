export EDITOR=nvim
alias vi="nvim"
alias vim="nvim"
alias gdiff="gist -t diff"
alias g="git"
alias vm="mosh vm -- sh -c 'tmux -u a || tmux -u'"

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
set -U fish_color_command '--bold'
