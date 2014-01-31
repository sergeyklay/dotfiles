--[[

  Wiboxes config

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

]]

-- Create a textclock widget
textclock = awful.widget.textclock(" %H:%M ")

-- Create a wibox for each screen and add it
top_wiboxes     = {}
bottom_wiboxes  = {}
promptbox       = {}
layoutbox       = {}

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
  left_layout:add(lib.widgets.spacer)
  left_layout:add(taglist[s])
  left_layout:add(promptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(lib.widgets.volicon)
  right_layout:add(lib.widgets.volwidget)
  right_layout:add(lib.widgets.separator)
  if s == 1 then right_layout:add(wibox.widget.systray()) end   
  right_layout:add(lib.widgets.separator)
  right_layout:add(textclock)
  right_layout:add(lib.widgets.separator)
  right_layout:add(layoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist[s])
  layout:set_right(right_layout)

  top_wiboxes[s]:set_widget(layout)

  -- Create the bottom wibox
  top_wiboxes[s] = awful.wibox({ position = "bottom", height="14", screen = s })

  -- Widgets that are aligned to the left
  local left_layout2 = wibox.layout.fixed.horizontal()

  -- Widgets that are aligned to the right
  local right_layout2 = wibox.layout.fixed.horizontal()
  left_layout2:add(lib.widgets.spacer)
  left_layout2:add(lib.widgets.syswidget)
  left_layout2:add(lib.widgets.separator)
  left_layout2:add(lib.widgets.mpdicon)
  left_layout2:add(lib.widgets.mpdwidget)

  right_layout2:add(lib.widgets.separator)
  right_layout2:add(lib.widgets.ramicon)
  right_layout2:add(lib.widgets.ramwidget)
  right_layout2:add(lib.widgets.separator)
  right_layout2:add(lib.widgets.cpuicon)
  right_layout2:add(lib.widgets.cpuwidget1)
  right_layout2:add(lib.widgets.separator)
  right_layout2:add(lib.widgets.cpuicon)
  right_layout2:add(lib.widgets.cpuwidget2)
  right_layout2:add(lib.widgets.separator)
  right_layout2:add(lib.widgets.batticon)
  right_layout2:add(lib.widgets.battwidget)
  right_layout2:add(lib.widgets.spacer)

  -- Now bring it all together (with the tasklist in the middle)
  local layout2 = wibox.layout.align.horizontal()
  layout2:set_left(left_layout2)
  layout2:set_right(right_layout2)

  top_wiboxes[s]:set_widget(layout2)
end

--