--[[

     cyan-neon custom Awesome WM theme
     github.com/macunha1

--]]

local gears       = require("gears")
local lain        = require("lain")
local awful       = require("awful")
local wibox       = require("wibox")
local watch       = require("awful.widget.watch")
local dpi         = require("beautiful.xresources").apply_dpi

-- Plugins (external)
local calendar    = require("plugins.calendar")
local mem_widget  = require("plugins.memory")

local os = { execute = os.execute, getenv = os.getenv, setlocale = os.setlocale }

local awesome     = awesome
local client      = client
local config_path = awful.util.getdir("config")
local my_table    = awful.util.table or gears.table -- 4.{0,1} compatibility

local colors_hex      = {}
colors_hex.black      = "#232323"
colors_hex.red        = "#F84672"
colors_hex.blue       = "#00AAF9"
colors_hex.magenta    = "#FC71FF"
colors_hex.cyan       = "#00FCF8"
colors_hex.lightgray  = "#949C94"
colors_hex.darkgray   = "#666666"
colors_hex.lightgreen = "#00FFBB"
colors_hex.lightblue  = "#00FCF8"
colors_hex.lightcyan  = "#4DEEDD"
colors_hex.white      = "#FBF1C7"

local theme                                     = {}
theme.dir                                       = config_path .. "/themes/cyan-neon"
theme.wallpaper                                 = nil
theme.font                                      = "Source Code Pro 9"
theme.fg_normal                                 = colors_hex.white
theme.fg_focus                                  = colors_hex.cyan
theme.fg_urgent                                 = colors_hex.red
theme.bg_normal                                 = colors_hex.black
theme.bg_focus                                  = theme.bg_normal
theme.bg_urgent                                 = theme.bg_normal
theme.border_width                              = dpi(1)
theme.border_focus                              = colors_hex.lightgreen
theme.border_normal                             = theme.bg_normal -- change for a border highlight

theme.taglist_fg_focus                          = colors_hex.lightgreen
theme.taglist_bg_focus                          = colors_hex.black
theme.taglist_bg_normal                         = theme.taglist_bg_focus -- same

theme.titlebar_bg_normal                        = theme.fg_urgent -- colors_hex.lightgreen
theme.titlebar_bg_focus                         = theme.bg_focus

theme.wibar_height                              = 18 -- not used dpi to avoid icon resize
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
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_unsel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.vol                                       = theme.dir .. "/icons/vol.png"
theme.vol_low                                   = theme.dir .. "/icons/vol_low.png"
theme.vol_no                                    = theme.dir .. "/icons/vol_no.png"
theme.vol_mute                                  = theme.dir .. "/icons/vol_mute.png"
theme.disk                                      = theme.dir .. "/icons/disk.png"
theme.cpu                                       = theme.dir .. "/icons/cpu.png"
theme.mem                                       = theme.dir .. "/icons/mem.png"
theme.ac                                        = theme.dir .. "/icons/ac.png"
theme.bat                                       = theme.dir .. "/icons/bat.png"
theme.bat_low                                   = theme.dir .. "/icons/bat_low.png"
theme.bat_no                                    = theme.dir .. "/icons/bat_no.png"
theme.calendar                                  = theme.dir .. "/icons/calendar.png"
theme.clock                                     = theme.dir .. "/icons/clock.png"
theme.play                                      = theme.dir .. "/icons/play.png"
theme.pause                                     = theme.dir .. "/icons/pause.png"
theme.stop                                      = theme.dir .. "/icons/stop.png"
-- {{ Layout icons
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
-- }}
theme.useless_gap                               = dpi(2)
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

-- Lain related
theme.layout_centerfair                         = theme.dir .. "/icons/centerfair.png"
theme.layout_termfair                           = theme.dir .. "/icons/termfair.png"
theme.layout_centerwork                         = theme.dir .. "/icons/centerwork.png"

local markup = lain.util.markup

-- Textclock
local clockicon  = wibox.widget.imagebox(theme.clock)
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock(
    markup.font(theme.font, "%H:%M | %A | %d/%m/%Y"),
    1
)
mytextclock.font = theme.font

-- Calendar
calendar({
    today_color = theme.fg_focus,
    fdow        = 7, -- Sunday as the first day of week
}):attach(mytextclock)

-- Spotify Widget
-- Built on top of https://github.com/streetturtle/awesome-wm-widgets/blob/master/spotify-widget/spotify.lua
local GET_SPOTIFY_STATUS_CMD = 'sp status'
theme.spotify = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
    },
    {
        id = 'current_song',
        widget = wibox.widget.textbox,
        font = theme.font
    },
    layout = wibox.layout.align.horizontal,
    set_status = function(self, is_playing)
        if (is_playing) then
            self.icon.image = theme.play
        else
            self.icon.image = theme.pause
        end
    end,
    set_text = function(self, path)
        self.current_song.markup = path
    end,
}

local update_widget_icon = function(widget, stdout, _, _, _)
    stdout = string.gsub(stdout, "\n", "")
    if (stdout == 'Playing') then
        widget:set_status(true)
    else
        widget:set_status(false)
    end
end

local update_widget_text = function(widget, stdout, _, _, _)
    if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
        widget:set_text('')
        widget:set_visible(false)
    else
        widget:set_text(stdout)
        widget:set_visible(true)
    end
end

watch(GET_SPOTIFY_STATUS_CMD, 1, update_widget_icon, theme.spotify)
watch('sp current-oneline', 1, update_widget_text, theme.spotify)

--- Adds mouse controls to the widget:
--  - left click - play/pause
--  - scroll up - play next song
--  - scroll down - play previous song
theme.spotify:connect_signal("button::press", function(_, _, _, button)
    if (button == 1) then
        awful.spawn("sp play", false)  -- left click
    elseif (button == 4) then
        awful.spawn("sp next", false)  -- scroll up
    elseif (button == 5) then
        awful.spawn("sp prev", false)  -- scroll down
    end
    
    awful.spawn.easy_async(GET_SPOTIFY_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
        update_widget_icon(theme.spotify, stdout, stderr, exitreason, exitcode)
    end)
end)

-- MPD
-- Honestly, I never used it
local mpdicon = wibox.widget.imagebox()
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            title = mpd_now.title
            artist  = " " .. mpd_now.artist .. markup(
                theme.fg_normal,
                string.format(
                    " <span font='%s'> </span>|<span font='%s'> </span>",
                    theme.font,
                    theme.font
                )
            )
            mpdicon:set_image(theme.play)
        elseif mpd_now.state == "pause" then
            title = "mpd "
            artist  = "paused" .. markup(
                theme.fg_normal,
                " |<span font='".. theme.font .. "'> </span>"
            )
            mpdicon:set_image(theme.pause)
        else
            title  = ""
            artist = ""
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end

        widget:set_markup(markup.font(theme.font, markup(colors_hex.blue, title) .. artist))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.bat)
local batbar = wibox.widget {
    forced_height    = theme.widget_forced_height,
    forced_width     = theme.widget_forced_width,
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    paddings         = theme.widget_paddings,
    ticks            = theme.widget_ticks,
    ticks_size       = theme.widget_ticks_size,
    widget           = wibox.widget.progressbar,
}

local batupd = lain.widget.bat({
    settings = function()
        if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end

        if bat_now.status == "Charging" then
            baticon:set_image(theme.ac)
            if bat_now.perc >= 98 then
                batbar:set_color(theme.fg_focus)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
            else
                batbar:set_color(colors_hex.red)
            end
        else
            if bat_now.perc >= 98 then
                batbar:set_color(theme.fg_focus)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
                baticon:set_image(theme.bat)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
                baticon:set_image(theme.bat_low)
            else
                batbar:set_color(colors_hex.red)
                baticon:set_image(theme.bat_no)
            end
        end
        batbar:set_value(bat_now.perc / 100)
    end
})

local batbg = wibox.container.background(
    batbar,
    theme.bg_normal,
    gears.shape.rectangle
)
local batwidget = wibox.container.margin(batbg, 2, 7, 4, 4)

-- Memory (RAM)
local memicon  = wibox.widget.imagebox(theme.mem)
theme.memory = wibox.widget {
    forced_height    = theme.widget_forced_height,
    forced_width     = theme.widget_forced_width,
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    paddings         = theme.widget_paddings,
    ticks            = theme.widget_ticks,
    ticks_size       = theme.widget_ticks_size,
    widget           = wibox.widget.progressbar,
}

local mem_upd = lain.widget.mem({
    settings = function()
        theme.memory:set_color(mem_now.perc > 80 and theme.fg_urgent
                                              or theme.fg_normal)
        theme.memory:set_value(mem_now.perc / 100)
    end
})

local rambg   = wibox.container.background(
    theme.memory,
    theme.fg_normal,
    gears.shape.rectangle
)
local ram_wid = wibox.container.margin(rambg, 2, 7, 4, 4)

mem_widget({
    fg_normal = theme.fg_normal,
    fg_color  = theme.fg_focus
}):attach(ram_wid)

-- CPU
local cpuicon  = wibox.widget.imagebox(theme.cpu)
local cpugraph = wibox.widget {
    forced_height    = theme.widget_forced_height,
    forced_width     = theme.widget_forced_width,
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    paddings         = theme.widget_paddings,
    ticks            = theme.widget_ticks,
    ticks_size       = theme.widget_ticks_size,
    widget           = wibox.widget.progressbar,
}

local cpu_upd = lain.widget.cpu({
    settings = function()
        cpugraph:set_color(cpu_now.usage > 80 and theme.fg_urgent
                                              or theme.fg_normal)
        cpugraph:set_value(cpu_now.usage / 100)
    end
})

local cpubg     = wibox.container.background(
    cpugraph,
    theme.fg_normal,
    gears.shape.rectangle
)
local cpuwidget = wibox.container.margin(cpubg, 2, 7, 4, 4)

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
        mute         = colors_hex.red,
        unmute       = theme.fg_normal
    }
}

theme.volume.tooltip.wibox.fg = theme.fg_focus
theme.volume.bar:buttons(my_table.join (
          awful.button({}, 1, function()
            awful.spawn(string.format("%s -e alsamixer", awful.util.terminal))
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 3, function()
            os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end)
))
local volumebg = wibox.container.background(theme.volume.bar, theme.bg_normal, gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, 2, 7, 4, 4)

-- Separators
local blank_space_separator = wibox.widget.textbox(markup.font(theme.font, " "))
local bar_separator   = wibox.widget.textbox(
    markup.fontfg(theme.font, theme.fg_normal, "|")
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

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
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
        my_table.join(awful.button({ }, 1, function () awful.layout.inc( 1) end),
                      awful.button({ }, 3, function () awful.layout.inc(-1) end),
                      awful.button({ }, 4, function () awful.layout.inc( 1) end),
                      awful.button({ }, 5, function () awful.layout.inc(-1) end))
    )

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    })

    -- NOTE: Deactivated due to lack of use 
    -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist({
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = awful.util.tasklist_buttons,
    -- })

    -- Create the wibox
    s.mywibox = awful.wibar({
        position     = theme.wibar_position,
        screen       = s,
        height       = theme.wibar_height,
        border_width = theme.wibar_border_width,
        border_color = theme.wibar_border_color,

        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            blank_space_separator,
            s.mylayoutbox,
            bar_separator,
            s.mytaglist,
            blank_space_separator,
            s.mypromptbox,
        },
        -- s.mytasklist, -- Middle-left widget
        { -- Middle-right widgets
            layout = wibox.layout.fixed.horizontal,
            -- Enable the battery widget (if you have a battery)
            -- bar_separator,
            -- baticon,
            -- batwidget,
            volicon,
            volumewidget,
            -- Spotify
            bar_separator,
            theme.spotify,
            blank_space_separator,
            -- Textclock
            bar_separator,
            blank_space_separator,
            mytextclock,
            blank_space_separator,
            -- Memory
            bar_separator,
            memicon,
            ram_wid,
            -- CPU
            bar_separator,
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
