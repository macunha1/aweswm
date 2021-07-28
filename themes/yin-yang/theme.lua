--[[
     Megaman lcpz/copycatz custom Awesome WM theme

     github.com/macunha1
--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local dpi   = require("beautiful.xresources").apply_dpi

-- Plugins (external)
local calendar        = require("plugins.calendar")
local memory_piechart = require("plugins.memory")
local media_player    = require("plugins.media-player")

local awesome     = awesome
local client      = client
local config_path = awful.util.getdir("config")
local my_table    = awful.util.table or gears.table -- 4.{0,1} compatibility

local colors_hex      = {}
colors_hex.black      = "#000000"
colors_hex.red        = "#F84672"
colors_hex.blue       = "#00AAF9"
colors_hex.magenta    = "#FC71FF"
colors_hex.cyan       = "#00FCF8"
colors_hex.lightgray  = "#949C94"
colors_hex.darkgray   = "#666666"
colors_hex.lightgreen = "#00FFBB"
colors_hex.lightblue  = "#00FCF8"
colors_hex.lightcyan  = "#4DEEDD"
colors_hex.white      = "#FFFFFF"

icons_dir = config_path .. "/icons/simplicity"

local theme                                     = {}
theme.dir                                       = config_path .. "/themes/yin-yang"
theme.wallpaper                                 = nil
theme.font                                      = "Source Code Pro 9"
theme.bold_font                                 = "Source Code Pro Bold 9"
theme.separator                                 = "|"
theme.fg_normal                                 = colors_hex.white
theme.fg_focus                                  = colors_hex.darkgray
theme.fg_urgent                                 = colors_hex.lightgray
theme.bg_normal                                 = colors_hex.black
theme.bg_focus                                  = theme.bg_normal
theme.bg_urgent                                 = theme.bg_normal
theme.border_width                              = dpi(1)
theme.border_focus                              = colors_hex.white
theme.border_normal                             = theme.bg_normal -- change for a border highlight
-- Invert colors on taglist
theme.taglist_fg_focus                          = theme.bg_normal
theme.taglist_bg_focus                          = theme.fg_normal
theme.taglist_font                              = theme.bold_font
theme.taglist_bg_normal                         = theme.taglist_bg_focus -- same

theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_bg_focus                         = theme.bg_focus

theme.wibar_height                              = 18 -- apply_dpi here blurs the icon
theme.wibar_border_width                        = dpi(2) -- useless_gap * 2 for visual alignment
theme.wibar_border_color                        = theme.bg_normal .. "11" -- transparent alpha
theme.wibar_position                            = "top"
theme.tasklist_disable_icon                     = true

-- {{ Wibox Widgets (progress bars)
theme.widget_forced_height                      = dpi(4)
theme.widget_forced_width                       = dpi(59)
theme.widget_paddings                           = 2
theme.widget_ticks                              = true -- separators between the progress bar
theme.widget_ticks_size                         = 6
-- }}
theme.awesome_icon                              = icons_dir .. "/awesome.png"
theme.menu_submenu_icon                         = icons_dir .. "/submenu.png"
theme.taglist_squares_sel                       = icons_dir .. "/square_unsel.png"
theme.taglist_squares_unsel                     = icons_dir .. "/square_unsel.png"
theme.vol                                       = icons_dir .. "/vol.png"
theme.vol_low                                   = icons_dir .. "/vol_low.png"
theme.vol_no                                    = icons_dir .. "/vol_no.png"
theme.vol_mute                                  = icons_dir .. "/vol_mute.png"
theme.disk                                      = icons_dir .. "/disk.png"
theme.cpu                                       = icons_dir .. "/cpu.png"
theme.mem                                       = icons_dir .. "/mem.png"
theme.ac                                        = icons_dir .. "/ac.png"
theme.bat                                       = icons_dir .. "/bat.png"
theme.bat_low                                   = icons_dir .. "/bat_low.png"
theme.bat_no                                    = icons_dir .. "/bat_no.png"
theme.calendar                                  = icons_dir .. "/calendar.png"
theme.clock                                     = icons_dir .. "/clock.png"
theme.play                                      = icons_dir .. "/play.png"
theme.pause                                     = icons_dir .. "/pause.png"
theme.stop                                      = icons_dir .. "/stop.png"
-- {{ Layout icons
theme.layout_tile                               = icons_dir .. "/tile.png"
theme.layout_tileleft                           = icons_dir .. "/tileleft.png"
theme.layout_tilebottom                         = icons_dir .. "/tilebottom.png"
theme.layout_tiletop                            = icons_dir .. "/tiletop.png"
theme.layout_fairv                              = icons_dir .. "/fairv.png"
theme.layout_fairh                              = icons_dir .. "/fairh.png"
theme.layout_spiral                             = icons_dir .. "/spiral.png"
theme.layout_dwindle                            = icons_dir .. "/dwindle.png"
theme.layout_max                                = icons_dir .. "/max.png"
theme.layout_fullscreen                         = icons_dir .. "/fullscreen.png"
theme.layout_magnifier                          = icons_dir .. "/magnifier.png"
theme.layout_floating                           = icons_dir .. "/floating.png"
-- }}
theme.useless_gap                               = dpi(2)
theme.titlebar_close_button_focus               = icons_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = icons_dir .. "/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = icons_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = icons_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = icons_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = icons_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = icons_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = icons_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = icons_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = icons_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = icons_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = icons_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = icons_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = icons_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = icons_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = icons_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = icons_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = icons_dir .. "/titlebar/maximized_normal_inactive.png"

-- Lain related
theme.layout_centerfair                         = icons_dir .. "/centerfair.png"
theme.layout_termfair                           = icons_dir .. "/termfair.png"
theme.layout_centerwork                         = icons_dir .. "/centerwork.png"

local markup = lain.util.markup

local wibox_container_layout = function(args)
    return wibox.container.margin(args.bg, 2, 7, 4, 4)
end

local wibox_progressbar = function()
    return wibox.widget {
        forced_height    = theme.widget_forced_height,
        forced_width     = theme.widget_forced_width,
        color            = theme.fg_normal,
        background_color = theme.bg_normal,
        paddings         = theme.widget_paddings,
        ticks            = theme.widget_ticks,
        ticks_size       = theme.widget_ticks_size,
        widget           = wibox.widget.progressbar,
    }
end

-- Textclock
local clockicon  = wibox.widget.imagebox(theme.clock)
local mytextclock = wibox.widget.textclock(
    markup.font(
        theme.bold_font,
        markup.color(
            theme.bg_normal,
            theme.fg_normal,
            " %A %H:%M %d/%m/%Y "
        )
    ),
    1
)
mytextclock.font = theme.font

-- Calendar
calendar({
    today = markup.font(
        theme.bold_font,
        markup.color(
            theme.bg_normal,
            theme.fg_normal,
            "%2i"
        )
    ),
    fdow  = 7, -- Sunday as the first day of week
}):attach(mytextclock)

-- Media Player
local spotify_widget = media_player({
    icons  = {
        play   = theme.play,
        pause  = theme.pause,
        stop   = theme.stop
    },
    font         = theme.bold_font,
    name         = "spotify",
    refresh_rate = 0.7
}).widget

local mpv_widget = media_player({
    icons  = {
        play   = theme.play,
        pause  = theme.pause,
        stop   = theme.stop
    },
    font         = theme.bold_font,
    name         = "mpv",
    refresh_rate = 0.7
}).widget

-- Battery
local battery_icon = wibox.widget.imagebox(theme.bat)
local battery_bar = wibox_progressbar()

local bat = lain.widget.bat({
    settings = function()
        if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end

        if bat_now.status == "Charging" then
            battery_icon:set_image(theme.ac)
            if bat_now.perc >= 98 then
                battery_bar:set_color(theme.fg_focus)
            elseif bat_now.perc > 50 then
                battery_bar:set_color(theme.fg_normal)
            elseif bat_now.perc > 15 then
                battery_bar:set_color(theme.fg_normal)
            else
                battery_bar:set_color(colors_hex.lightgray)
            end
        else
            if bat_now.perc >= 98 then
                battery_bar:set_color(theme.fg_focus)
            elseif bat_now.perc > 50 then
                battery_bar:set_color(theme.fg_normal)
                battery_icon:set_image(theme.bat)
            elseif bat_now.perc > 15 then
                battery_bar:set_color(theme.fg_normal)
                battery_icon:set_image(theme.bat_low)
            else
                battery_bar:set_color(colors_hex.lightgray)
                battery_icon:set_image(theme.bat_no)
            end
        end
        battery_bar:set_value(bat_now.perc / 100)
    end
})

local battery_widget = wibox_container_layout({
    bg = wibox.container.background(
        battery_bar,
        theme.bg_normal,
        gears.shape.rectangle
    )
})

-- Memory (RAM)
local memicon  = wibox.widget.imagebox(theme.mem)
theme.memory = wibox_progressbar()

local mem_upd = lain.widget.mem({
    settings = function()
        theme.memory:set_color(mem_now.perc > 80 and theme.fg_urgent
                                              or theme.fg_normal)
        theme.memory:set_value(mem_now.perc / 100)
    end
})

local rambg = wibox.container.background(
    theme.memory,
    theme.fg_normal,
    gears.shape.rectangle
)
local ram_wid = wibox_container_layout({bg = rambg})

memory_piechart({
    colors = {
        theme.fg_urgent,
        theme.bg_normal,
        theme.fg_normal,
        colors_hex.darkgray,
    },
    font  = theme.font,
    fg    = theme.fg_normal,
    bg    = theme.bg_focus,

    border_width = theme.border_width,
    border_color = theme.border_color
}):attach(ram_wid)

-- CPU
local cpuicon  = wibox.widget.imagebox(theme.cpu)
local cpugraph = wibox_progressbar()

local cpu_upd = lain.widget.cpu({
    settings = function()
        cpugraph:set_color(cpu_now.usage > 80 and theme.fg_urgent
                                              or theme.fg_normal)
        cpugraph:set_value(cpu_now.usage / 100)
    end
})

local cpubg = wibox.container.background(
    cpugraph,
    theme.fg_normal,
    gears.shape.rectangle
)
local cpuwidget = wibox_container_layout({bg = cpubg})

-- ALSA volume bar
local volicon = wibox.widget.imagebox(theme.vol)
theme.volume = lain.widget.alsabar {
    width               = theme.widget_forced_width,
    border_width        = 0,
    ticks               = theme.widget_ticks,
    ticks_size          = theme.widget_ticks_size,
    notification_preset = { font = theme.font },
    --togglechannel     = "IEC958,3",

    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.vol_mute)
        elseif volume_now.level == 0 then
            volicon:set_image(theme.vol_no)
        elseif volume_now.level <= 50 then
            volicon:set_image(theme.vol_low)
        else
            volicon:set_image(theme.vol)
        end
    end,

    colors = {
        background   = theme.bg_normal,
        mute         = colors_hex.darkgray,
        unmute       = theme.fg_normal
    }
}

theme.volume.tooltip.wibox.fg = theme.fg_focus
theme.volume.bar:buttons(
    my_table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async(
                string.format("%s -e alsamixer", awful.util.terminal)
            )
        end),
        awful.button({}, 2, function()
            awful.spawn.easy_async(
                string.format(
                    "%s set %s 100%%",
                    theme.volume.cmd,
                    theme.volume.channel
                ),
                theme.volume.update
            )
        end),
        awful.button({}, 3, function()
            awful.spawn.easy_async(
                string.format(
                    "%s set %s toggle",
                    theme.volume.cmd,
                    theme.volume.togglechannel or theme.volume.channel
                ),
                theme.volume.update
            )
        end),
        awful.button({}, 4, function()
            awful.spawn.easy_async(
                string.format(
                    "%s set %s 1%%+",
                    theme.volume.cmd,
                    theme.volume.channel
                ),
                theme.volume.update
            )
        end),
        awful.button({}, 5, function()
            awful.spawn.easy_async(
                string.format(
                    "%s set %s 1%%-",
                    theme.volume.cmd,
                    theme.volume.channel
                ),
                theme.volume.update
            )
        end)
))

local volumewidget = wibox_container_layout({
    bg = wibox.container.background(
        theme.volume.bar,
        theme.bg_normal,
        gears.shape.rectangle
    )
})

-- Separators
local blank_space_separator = wibox.widget.textbox(
    markup.font(theme.font, " ")
)

local bar_separator = wibox.widget.textbox(
    markup.fontfg(
        theme.font,
        theme.fg_normal,
        theme.separator
    )
)

-- Eminent-like task filtering
local orig_filter = awful.widget.taglist.filter.all

-- Taglist label functions
awful.widget.taglist.filter.all = function (t, args)
    if t.selected or #t:clients() > 0 then
        return orig_filter(t, args)
    end
end

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    local wallpaper = theme.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end

    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget containing an icon for layout indicating.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mylayoutbox:buttons(
        my_table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        )
    )

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    })

    -- NOTE: Deactivated due to lack of use
    -- Uncomment to have the tasklist widget back
    -- s.mytasklist = awful.widget.tasklist({
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = awful.util.tasklist_buttons,
    -- })

    -- Create the wibox
    s.mywibar = awful.wibar({
        position     = theme.wibar_position,
        screen       = s,
        height       = theme.wibar_height,
        border_width = theme.wibar_border_width,
        border_color = theme.wibar_border_color,

        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            blank_space_separator,
            s.mylayoutbox,
            s.mytaglist,
            blank_space_separator,
            s.mypromptbox,
        },
        -- NOTE: Task list deactivated due to lack of usage
        -- s.mytasklist, -- Middle-left widget
        { -- Middle-right widgets
            layout = wibox.layout.fixed.horizontal,
            -- Battery
            battery_icon,
            battery_widget,
            -- Volume
            volicon,
            volumewidget,
            -- Media Player
            spotify_widget,
            mpv_widget,
            blank_space_separator,
            -- Textclock
            mytextclock,
            blank_space_separator,
            -- Memory
            memicon,
            ram_wid,
            -- CPU
            cpuicon,
            cpuwidget,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
        }
    }
end

return theme
