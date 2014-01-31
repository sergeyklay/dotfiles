--[[--

  Definition of tags

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)

--]]--

-- Define a tag table which hold all screen tags.
tags = {
    -- Impractical in the tag names use words
    -- because they will spend valuable panel space
    names   = { "⌘", "☮", "❤", "☢", "✿", "★", "✪", "❖", "☯" },

    layout  = {
        layouts[3],
        layouts[9], -- fullscreen for browsers
        layouts[1],
        layouts[2],
        layouts[9], -- fullscreen for Gimp (I use single windows mode)
        layouts[9], -- fullscreen for IDEs
        layouts[1],
        layouts[9], -- fullscreen for Libre Office
        layouts[1]
    }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag( tags.names, s, tags.layout )

    -- Psi and qutIM
    awful.tag.setncol(2, tags[s][3])
    awful.tag.setnmaster(1, tags[s][3])
    awful.tag.setmwfact(0.2, tags[s][3])

    -- Skype
    awful.tag.setncol(2, tags[s][4])
    awful.tag.setnmaster(1, tags[s][4])
    awful.tag.setmwfact(0.8, tags[s][4])
end
