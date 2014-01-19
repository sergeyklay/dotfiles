local awful     = require("awful")
local wibox     = require("wibox")
local vicious   = require("vicious")
local beautiful = require("beautiful")

module("widgets")

-- Custom Variables
local blue_color = "#A9D7F2"
local gray_color = "#333333"

-- {{{ Spacer/Separator widget
    spacer = wibox.widget.textbox(' ')

    separator = wibox.widget.textbox()
    separator:set_markup('<span foreground="' .. gray_color .. '"> | </span>')
    separator:set_font('Clear Sans 10')
-- }}}


local function set_margin(bar)
    barmargin = wibox.layout.margin(bar, 2, 2)
    barmargin:set_top(3)
    barmargin:set_bottom(3)

    return barmargin
end

local function init_bar()
    bar  = awful.widget.progressbar()
    bar:set_width(55)
    bar:set_ticks(true)
    bar:set_ticks_size(6)
    bar:set_color(beautiful.bg_urgent)
    bar:set_background_color(gray_color)

    return bar
end

-- {{{ CPU load widget
    cpuicon = wibox.widget.imagebox(beautiful.cpu)
    cpubar1 = init_bar()
    vicious.register(cpubar1, vicious.widgets.cpu, "$1", 7)
    cpubar2 = init_bar()
    vicious.register(cpubar2, vicious.widgets.cpu, "$2", 7)
    cpuwidget1 = wibox.widget.background(set_margin(cpubar1))
    cpuwidget2 = wibox.widget.background(set_margin(cpubar2))
    --vicious.cache(vicious.widgets.cpu)
-- }}}

-- {{{ Memory usage widget
    ramicon = wibox.widget.imagebox(beautiful.ram)
    rambar  = init_bar()
    vicious.register(rambar, vicious.widgets.mem, "$1", 5)
    ramwidget = wibox.widget.background(set_margin(rambar))
-- }}}

-- {{{ OS info widget
    syswidget = wibox.widget.textbox()
    vicious.register(syswidget, vicious.widgets.os, "$1 $2")
-- }}}

-- {{{ Pacman updates widget
    pkgicon = wibox.widget.imagebox(beautiful.pac)
    pkgwidget = wibox.widget.textbox()
    vicious.register(pkgwidget, vicious.widgets.pkg, "$1", 1801, "Arch")
-- }}}

-- {{{ Gmail updates widget
    gmailicon = wibox.widget.imagebox(beautiful.mail)
    gmailwidget = wibox.widget.textbox()
    vicious.register(gmailwidget, vicious.widgets.gmail, "${count}", 61)
-- }}}

-- {{{ MPD Readout widget
    mpdicon = wibox.widget.imagebox(beautiful.mpd)
    mpdwidget = wibox.widget.textbox()
    mpdwidget:set_align("left")
    vicious.register(mpdwidget, vicious.widgets.mpd,
        function (widget, args)
            if args["{state}"] == "Stop" then 
                return " mpd stopped "
            else 
                return args["{Artist}"]..' - '.. args["{Title}"]
            end
        end, 10)
-- }}}

-- {{{ Battery Charge widget
    batticon = wibox.widget.imagebox(beautiful.batt)
    battbar = init_bar()
    vicious.register(battbar, vicious.widgets.bat, "$2", 61, "BAT0")
    battwidget = wibox.widget.background(set_margin(battbar))
-- }}}

-- {{{ Volume Indicator widget
    volicon = wibox.widget.imagebox(beautiful.vol)
    volwidget = wibox.widget.textbox()
    volwidget:set_align("right")
    vicious.register(volwidget, vicious.widgets.volume, "$1", 1, "Master")
-- }}}