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

Below is the explanation about each of these files, when it is loaded,
and what it does.

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

### Zsh startup files

#### `zshenv`

`zshenv` is sourced on all invocations of the shell, unless the `-f`
option is set.

What goes in it:

- Set up the command search path
- Other important environment variables
- Commands to set up aliases and functions that are needed for other
  scripts

What does NOT go in it:

- Commands that produce output
- Anything that assumes the shell is attached to a tty

#### `zprofile`

`zprofile` is sourced in login shells. It is meant as an alternative
to `zlogin` for `ksh` fans; the two are not intended to be used together,
although this could certainly be done if desired.

What goes in it:

- Commands that should be executed only in login shells
- As a general rule, it should not change the shell environment at all
- As a general rule, set the terminal type then run a series of external
  commands e.g. fortune, msgs, etc

What does NOT go in it:

- Alias definitions
- Function definitions
- Options
- Environment variable settings

#### `zshrc`

`zshrc` is sourced in interactive shells.

What goes in it:

- Commands to set up aliases and functions that are needed for other
  scripts

#### `zlogin`

`zlogin` is like `zprofile`, except sourced after zshrc.

#### `zlogout`

`zlogout` is sourced when login shells exit.

## License

This project is open source software licensed under the GNU General Public
Licence version 3.  © 2014-2022 [Serghei Iakovlev](https://github.com/sergeyklay)
