export EDITOR=nvim
alias vi="nvim"
alias vim="nvim"

if type -q rvm
  rvm default
end

set -g fish_user_paths "/usr/local/opt/mysql@5.6/bin" $fish_user_paths

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
