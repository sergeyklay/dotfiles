--[[

  Power management

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

  For systems with systemd only! Modify this for your system if it needed.
  Polkit is necessary for power management as an unprivileged user.
  See https://wiki.archlinux.org/index.php/systemd#Power_management

]]

local awful = require("awful")
local run   = awful.util.spawn_with_shell
local zqt   = "zenity --question --text "

module("lib.power")

-- Suspend the system
function suspend()
  run(zqt .. "'Suspend the system' && systemctl suspend")
end

-- Put the system into hibernation
function hibernate()
  run(zqt .. "'Put the system into hibernation' && systemctl hibernate")
end

-- Put the system into hybrid-sleep state (or suspend-to-both)
function sleep()
  run(zqt .. "'Sleep the system' && systemctl hibrid-sleep")
end

-- Shut down and reboot the system
function reboot()
  run(zqt .. "'Shut down and reboot the system' && systemctl reboot")
end

-- Shut down and power-off the system
function poweroff()
  run(zqt .. "'Shut down and power-off the system' && systemctl poweroff")
end

-- vim:ts=8:sw=2:sts=2:tw=80:et
