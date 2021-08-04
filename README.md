# `~/.*`

All my dotfiles that I port around from system to system with me.  The
purpose of this project is to organize my shell scripts and configs and sync
them between machines.  This started out fairly simple, but now can also
handle my `.bash_profile` and keep things synchronized between machines like
`.inputrc`, etc.

## Shell support

These dotfiles are meant to be used with Bash >= 5.x, but some scripts may
work as Zsh accepts Bash interpreter.  Also, your shell should support
colors so everything works well.  Wherever possible, compatibility with
Linux as well as macOS is maintained.

## Project Structure

Below is the structure of the project and the location of the main
files. The diagram below is not exhaustive and describes my Bash / readline
configuration only.

```
.
├── .bash_logout
├── .bash_profile
├── .bashrc
├── .config
│   └── bash.d
│       ├── conf.d
│       │   ├── OS
│       │   │   ├── Linux
│       │   │   │   ├── aliases.sh
│       │   │   │   ├── bashrc.sh
│       │   │   │   ├── comp.sh
│       │   │   │   ├── editor.sh
│       │   │   │   ├── env.sh
│       │   │   │   ├── paths.sh
│       │   │   │   └── xdg-dirs.sh
│       │   │   └── OSX
│       │   │       ├── aliases.sh
│       │   │       ├── comp.sh
│       │   │       ├── editor.sh
│       │   │       ├── env.sh
│       │   │       └── paths.sh
│       │   ├── aliases.sh
│       │   ├── ble.sh
│       │   ├── comp.sh
│       │   ├── editor.sh
│       │   ├── fun.sh
│       │   ├── gpg.sh
│       │   ├── hist.sh
│       │   ├── info.sh
│       │   ├── mans.sh
│       │   ├── paths.sh
│       │   └── prompt.sh
│       ├── lib
│       │   ├── bashenv.sh
│       │   ├── dirstack.sh
│       │   ├── locknwait.sh
│       │   ├── pathmunge.sh
│       │   └── utils.sh
│       └── plugins
│           ├── plugin.nvm.sh
│           ├── plugin.pyenv.sh
│           ├── plugin.rbenv.sh
│           └── plugin.sdkman.sh
└── .inputrc
```

## Links

Other projects I also support from time to time are:

- [GNU Emacs configuration](https://github.com/sergeyklay/.emacs.d): My personal configuration for GNU Emacs
- [Lenovo Y520 (Legion) Setup](https://github.com/sergeyklay/lenovo-legion-y520-15ikbn): My personal configuration for the Linux laptop I use on the daily as a secondary workstation

## License

This project is open source software licensed under the GNU General Public
Licence version 3.  © 2014-2020 [Serghei Iakovlev](https://github.com/sergeyklay)
