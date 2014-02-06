--[[

  Wiboxes config

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

]]

local w = require("lib.widgets")

-- Create a textclock widget

top_wiboxes = {}
bot_wiboxes = {}
promptbox   = {}
layoutbox   = {}

taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({        }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({        }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({        }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({        }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

tasklist  = {}
tasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
    -- Without this, the following
    -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),

  awful.button({ }, 3, function ()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),

  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),

  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  promptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                         awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

  -- Create a tasklist widget
  tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

  -- Create the top wibox
  top_wiboxes[s] = awful.wibox({ position = "top", height="14", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(launcher)
  left_layout:add(w.spacer)
  left_layout:add(taglist[s])
  left_layout:add(promptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(w.volicon)
  right_layout:add(w.volwidget)
  right_layout:add(w.separator)
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(w.separator)
  right_layout:add(w.clock)
  right_layout:add(w.separator)
  right_layout:add(layoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist[s])
  layout:set_right(right_layout)

  top_wiboxes[s]:set_widget(layout)

  -- Create the bottom wibox
  bot_wiboxes[s] = awful.wibox({ position = "bottom", height="14", screen = s })

  -- Widgets that are aligned to the left
  local bl_layout = wibox.layout.fixed.horizontal()

  bl_layout:add(w.syswidget)
  bl_layout:add(w.separator)
  bl_layout:add(w.mpdicon)
  bl_layout:add(w.mpdwidget)

  -- Widgets that are aligned to the right
  local br_layout = wibox.layout.fixed.horizontal()

  br_layout:add(w.upicon)
  br_layout:add(w.netwidget)
  br_layout:add(w.downicon)
  br_layout:add(w.separator)
  br_layout:add(w.ramicon)
  br_layout:add(w.ramwidget)
  br_layout:add(w.separator)
  br_layout:add(w.cpuicon)
  br_layout:add(w.cpuwidget1)
  br_layout:add(w.separator)
  br_layout:add(w.cpuicon)
  br_layout:add(w.cpuwidget2)
  br_layout:add(w.separator)
  br_layout:add(w.batticon)
  br_layout:add(w.battwidget)
  br_layout:add(w.spacer)

  -- Now bring it all together (with the tasklist in the middle)
  local layout2 = wibox.layout.align.horizontal()
  layout2:set_left(bl_layout)
  layout2:set_right(br_layout)
  bot_wiboxes[s]:set_widget(layout2)
end

-- vim:ts=8:sw=2:sts=2:tw=80:et
