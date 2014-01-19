--[[
                               
     Copland Awesome WM config 
     github.com/copycat-killer 
                               
--]]

theme                                           = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/copland"
--
theme.wallpaper                                 = theme.dir .. "/wall.jpg"
--
theme.font                                      = "Tamsyn 10.5"

theme.fg_normal                                 = "#BBBBBB"
theme.fg_focus                                  = "#78A4FF"
theme.fg_urgent                                 = "#000000"
theme.bg_normal                                 = "#111111"
theme.bg_focus                                  = "#111111"
theme.bg_urgent                                 = "#FFFFFF"
theme.border_normal                             = "#141414"
theme.border_focus                              = "#93B6FF"
theme.taglist_fg_focus                          = "#FFFFEF"
theme.taglist_bg_focus                          = "#111111"
theme.taglist_bg_normal                         = "#111111"
--
theme.taglist_font                              = "Droid Sans Japanese 9"
--
theme.titlebar_bg_normal                        = "#191919"
theme.titlebar_bg_focus                         = "#262626"

theme.menu_height                               = "15"
theme.menu_width                                = "100"


theme.tasklist_sticky                           = ""
theme.tasklist_ontop                            = ""
theme.tasklist_floating                         = ""
theme.tasklist_maximized_horizontal             = ""
theme.tasklist_maximized_vertical               = ""
theme.tasklist_disable_icon                     = true

theme.menu_submenu_icon                         = theme.dir .."/icons/submenu.png"
--
theme.border_width                              = 1
theme.layout_fairh                              = theme.dir .. "/icons/layout/fairh.png"
theme.layout_fairv                              = theme.dir .. "/icons/layout/fairv.png"
theme.layout_floating                           = theme.dir .. "/icons/layout/floating.png"
theme.layout_magnifier                          = theme.dir .. "/icons/layout/magnifier.png"
theme.layout_max                                = theme.dir .. "/icons/layout/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/layout/fullscreen.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/layout/tilebottom.png"
theme.layout_tileleft                           = theme.dir .. "/icons/layout/tileleft.png"
theme.layout_tile                               = theme.dir .. "/iconslayout/tile.png"
theme.layout_tiletop                            = theme.dir .. "/icons/layout/tiletop.png"
theme.layout_spiral                             = theme.dir .. "/icons/layout/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/layou/dwindle.png"

theme.awesome_icon                              = theme.dir .."/icons/awesome.png"

theme.taglist_squares_sel                       = theme.dir .. "/icons/taglist/squaref.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/taglist/square.png"

theme.cpu                                       = theme.dir .. "/icons/cpu.png"
theme.ram                                       = theme.dir .. "/icons/ram.png"
theme.pac                                       = theme.dir .. "/icons/pac.png"
theme.mail                                      = theme.dir .. "/icons/mail.png"
theme.mpd                                       = theme.dir .. "/icons/mpd.png"
theme.batt                                      = theme.dir .. "/icons/batt.png"
theme.vol                                       = theme.dir .. "/icons/vol.png"
--

theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

theme.useless_gap_width                         = 10

return theme
