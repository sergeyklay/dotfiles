--[[

  Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

]]

-- Libraries
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
mousefinder     = require("awful.mouse.finder")()
wibox           = require("wibox")
vicious         = require("vicious")
beautiful       = require("beautiful")
naughty         = require("naughty")
menubar         = require("menubar")

-- Variable definitions
__dir__         = os.getenv('HOME') .. "/.config/awesome"
terminal        = "urxvtc" or "xterm"
editor          = os.getenv("EDITOR") or "vim"
editor_cmd      = terminal .. " -e " .. editor
browser         = "chromium"
screensaver     = "xscreensaver-command -activate"
modkey          = "Mod4"

-- Open system files and execute their contents as Lua chunks
dofile(__dir__ .. "/config/errors.lua")
dofile(__dir__ .. "/config/theme.lua")
dofile(__dir__ .. "/config/layouts.lua")
dofile(__dir__ .. "/config/tags.lua")
dofile(__dir__ .. "/config/menu.lua")
dofile(__dir__ .. "/config/bindings.lua")
dofile(__dir__ .. "/config/wiboxes.lua")
dofile(__dir__ .. "/config/rules.lua")
dofile(__dir__ .. "/config/signals.lua")

power           = require("lib.power")
widgets         = require("lib.widgets")
