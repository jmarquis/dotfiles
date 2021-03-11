# Dotfiles

## Management

### Forking

```bash
git clone git@github.com:/jmarquis/dotfiles
git remote rename origin upstream
git remote add origin name@server.com:/jmarquis/dotfiles
```

### Getting latest upstream changes

```bash
git fetch upstream master
git rebase upstream/master
git push --force origin
```

### Making forked changes

```bash
git commit -m "whatever"
git push
```

### Making upstream changes

```bash
git fetch upstream master
git checkout upstream/master
git checkout -b tmp
git commit -m "whatever"
git push upstream tmp:master
git checkout master
git branch -D tmp
git fetch upstream master
git rebase upstream/master
```
