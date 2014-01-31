--[[

  Rules setup

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)
  https://github.com/sergeyklay

]]

awful.rules.rules = {

  -- All clients will match this rule
  {
    rule       = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus        = awful.client.focus.filter,
      keys         = clientkeys,
      buttons      = clientbuttons
    }
  },

  {
    rule       = { class = "MPlayer" },
    properties = { floating = true }
  },

  {
    rule       = { class = "pinentry" },
    properties = { floating = true }
  },

  -- For Gimp with single windiw mode
  {
    rule       = { class = "gimp" },
    properties = { tag = tags[1][5] }
  },

  {
    rule       = { class = "Firefox" },
    properties = { tag = tags[1][2] }
  },

  {
    rule       = { class = "Chromium" },
    properties = { tag = tags[1][2] }
  },

  {
    rule       = { class = "jetbrains-phpstorm" },
    properties = { tag = tags[1][6] }
  },

  {
    rule_any   = { class = { "Psi-plus" } },
    except     = { instance = "main" },
    properties = { tag = tags[1][3] },
    callback   = awful.client.setslave
  },

  {
    rule       = { class = "Psi-plus", instance = "main" },
    properties = { tag = tags[1][3] }
  },

  {
    rule       = { class = "Skype" },
    except     = { role = "ConversationsWindow" },
    properties = { tag = tags[1][4] },
    callback   = awful.client.setslave
  }
}

--