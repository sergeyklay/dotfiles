--[[--

  Power management

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)

  For systems with systemd only! Modify this for your system if it needed.
  Polkit is necessary for power management as an unprivileged user.
  See https://wiki.archlinux.org/index.php/systemd#Power_management

--]]--

local awful = require("awful")

module("lib.power")

-- Suspend the system
function suspend()
  awful.util.spawn_with_shell("zenity --question --text 'Suspend the system' && systemctl suspend")
end

-- Put the system into hibernation
function hibernate()
  awful.util.spawn_with_shell("zenity --question --text 'Put the system into hibernation' && systemctl hibernate")
end

-- Put the system into hybrid-sleep state (or suspend-to-both)
function sleep()
  awful.util.spawn_with_shell("zenity --question --text 'Sleep the system' && systemctl hibrid-sleep")
end

-- Shut down and reboot the system
function reboot()
  awful.util.spawn_with_shell("zenity --question --text 'Shut down and reboot the system' && systemctl reboot")
end

-- Shut down and power-off the system
function poweroff()
  awful.util.spawn_with_shell("zenity --question --text 'Shut down and power-off the syste' && systemctl poweroff")
end
