--[[--

  Definition of menu

  Part of Awesome WM config
  by Sergey Yakovlev (me@klay.me)

--]]--

awesome_menu = {
  { "&Manual",  terminal .. " -e man awesome"         },
  { "&Config",  editor_cmd .. " " .. awesome.conffile },
  { "&Restart", awesome.restart                       },
  { "&Quit",    awesome.quit                          }
}

develop_menu = {
  { "&PhpStorm",       "/opt/phpstorm/bin/phpstorm.sh" },
  { "&Sublime Text 3", "subl3"                         },
  { "&Vim",            editor_cmd                      }
}

www_menu = {
  { "&Chromium",     "chromium"         },
  { "&Firefox",      "firefox"          },
  { "&Pidgin",       "pidgin"           },
  { "&Transmission", "transmission-gtk" }
}

power_menu = {
  { "&Lock Screen", power.screensaver },
  { "&Suspend",     power.suspend     },
  { "&Hibernate",   power.hibernate   },
  { "Sl&eep",       power.sleep       },
  { "&Reboot",      power.reboot      },
  { "&Power Off",   power.poweroff    }
}

-- Create a main menu
mainmenu = awful.menu({
  items = {
    { "&Develop",  develop_menu },
    { "&Internet", www_menu     },
    { "&Awesome",  awesome_menu },
    { "&Power",    power_menu   }
  },
  theme = { width = 150 }
})