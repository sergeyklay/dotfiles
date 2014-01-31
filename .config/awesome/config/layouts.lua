--[[

  Definition of layouts

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

]]

-- Table of layouts to cover with awful.layout.inc, order matters
layouts = {
  awful.layout.suit.tile,            --  1
  awful.layout.suit.tile.left,       --  2
  awful.layout.suit.tile.bottom,     --  3
  awful.layout.suit.tile.top,        --  4
  awful.layout.suit.fair,            --  5
  awful.layout.suit.fair.horizontal, --  6
  awful.layout.suit.spiral,          --  7
  awful.layout.suit.spiral.dwindle,  --  8
  awful.layout.suit.max,             --  9
  awful.layout.suit.max.fullscreen,  -- 10
  awful.layout.suit.magnifier,       -- 11
  awful.layout.suit.floating         -- 12
}
