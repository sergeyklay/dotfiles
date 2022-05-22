# `~/.*`

All my dotfiles that I port around from system to system with me.  The
purpose of this project is to organize my shell scripts and configs and sync
them between machines.  This started out fairly simple, but now can also
handle my `.zshrc` and keep things synchronized between machines like
`.zshenv`, etc.

## Shell support

These dotfiles are meant to be used with Zsh, but some scripts may
work as Bash accepts Zsh interpreter.  Also, your shell should support
colors so everything works well.  Wherever possible, compatibility with
Linux as well as macOS is maintained.

## Project Structure

### Zsh startup files

There are five startup files that Zsh will read commands from in order:

```sh
zshenv
zprofile
zshrc
zlogin
zlogout
```

### Zsh locations

The default location for zsh system-wide files is in `/etc`. The default
location for zsh user files is in `$HOME`; this can be customized by
setting `$ZDOTDIR`.

Thus the default locations are:

```sh
/etc/zshenv
/etc/zprofile
/etc/zshrc
/etc/zlogin
/etc/zlogout

$HOME/.zshenv
$HOME/.zprofile
$HOME/.zshrc
$HOME/.zlogin
$HOME/.zlogout
```

## License

This project is open source software licensed under the GNU General Public
Licence version 3.  © 2014-2022 [Serghei Iakovlev](https://github.com/sergeyklay)
