--[[

    Awesome WM configuration

    Built on top of https://github.com/lcpz/awesome-copycats

--]]

-- {{{ Required libraries
local awesome, client, tag = awesome, client, tag
local mouse, screen, ipars = mouse, screen, ipars 
local string, table, os    = string, table, os
local tostring, type       = tostring, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")

local config_path   = awful.util.getdir("config")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify(
            {
                preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = tostring(err)
            }
        )

        in_error = false
    end)
end
-- }}}

-- {{{ Run once during AwesomeWM startup
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(
            string.format(
                "pgrep -u $USER -fx '%s' > /dev/null || (%s)",
                cmd,
                cmd
            )
        )
    end
end

-- Usage example
-- run_once({
--     'dex -a -s /etc/xdg/autostart/:~/.config/autostart/',
--     'gtk-launch entryname',
-- })
-- }}}

-- {{{ Variable definitions
local theme        = "cyan-neon"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local editor       = os.getenv("EDITOR") or "vim"
local gui_editor   = "emacs"
local browser      = os.getenv("BROWSER") or "chromium"
local media_player = "spotify"

local screenlock   =  function ()
    awful.spawn.with_shell(os.getenv("HOME") .. "/.local/bin/screenlock.sh")
end

local playerctl = {
    play = function() awful.spawn.with_shell("playerctl play-pause") end,
    prev = function() awful.spawn.with_shell("playerctl previous") end,
    next = function() awful.spawn.with_shell("playerctl next") end,
    stop = function() awful.spawn.with_shell("playerctl stop") end,
}

local alsa_exec = function(args, channel)
    awful.spawn.easy_async(
        string.format(
            "amixer -q set %s %s",
            args.channel or
                beautiful.volume.togglechannel or
                beautiful.volume.channel,
            args.command
        ),
        callback or beautiful.volume.update
    )
end

local alsa = {
    volume_up   = function() alsa_exec({command="5%+"}) end,
    volume_down = function() alsa_exec({command="5%-"}) end,
    mute_audio  = function() alsa_exec({command="toggle"}) end,
    mute_mic    = function() alsa_exec({command="toggle", channel="Mic"}) end,
    mute_audio  = function() alsa_exec({command="toggle"}) end,
}

awful.util.terminal = terminal
awful.util.tagnames = { "fn", "main", "void", "args", "*" }
awful.layout.layouts = {
    -- Full list https://awesomewm.org/doc/api/libraries/awful.layout.html#Client_layouts
    awful.layout.suit.magnifier,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile.left,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),

    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button(
        { }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ),

    awful.button(
        { }, 3,
        function ()
            local instance = nil

            return function ()
                if instance and instance.wibox.visible then
                    instance:hide()
                    instance = nil
                else
                    instance = awful.menu.clients({theme = {width = dpi(250)}})
                end
            end
        end
    ),

    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%sthemes/%s/theme.lua", config_path, theme))
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    {
        "edit config",
        string.format(
            "%s -e %s %s",
            terminal,
            editor,
            awesome.conffile
        )
    },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or dpi(16),
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
beautiful.wallpaper = config_path .. "wallpapers/default.jpg"

screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key(
        {}, "Print",
        function () awful.spawn("xfce4-screenshooter") end,
        {description = "take a screenshot", group = "hotkeys"}
    ),

    awful.key(
        { altkey }, "p",
        function() awful.spawn("screenshot") end,
        {description = "take a screenshot", group = "hotkeys"}
    ),

    -- Screen locker
    awful.key(
        { modkey, }, "Home",
        screenlock,
        {description = "lock screen", group = "hotkeys"}
    ),

    -- File manager
    awful.key(
        { modkey, }, "e",
        function () awful.spawn("pcmanfm") end,
        {description = "open file manager", group="hotkeys"}
    ),

    -- Tag browsing
    awful.key(
        { modkey,           }, "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),

    awful.key(
        { modkey,           }, "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),

    awful.key(
        { modkey,           }, "Escape",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}
    ),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Directional client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),

    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),

    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),

    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    awful.key(
        { modkey,           }, "w",
        function () awful.util.mymainmenu:show() end,
        {description = "show main menu", group = "awesome"}
    ),

    -- Layout manipulation
    awful.key(
        { modkey, "Shift"   }, "j",
        function() awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}
    ),

    awful.key(
        { modkey, "Shift"   }, "k",
        function() awful.client.swap.byidx(-1) end,
        {description = "swap with previous client by index", group = "client"}
    ),

    awful.key(
        { modkey, "Control" }, "j",
        function() awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}
    ),

    awful.key(
        { modkey, "Control" }, "k",
        function() awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}
    ),

    awful.key(
        { modkey, }, "u",
        awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}
    ),

    awful.key({ modkey, }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),

    -- On the fly useless gaps change
    awful.key(
        { altkey, "Control" }, "+",
        function () lain.util.useless_gaps_resize(1) end,
        {description = "increment useless gaps", group = "tag"}
    ),

    awful.key(
        { altkey, "Control" }, "-",
        function () lain.util.useless_gaps_resize(-1) end,
        {description = "decrement useless gaps", group = "tag"}
    ),

    -- Dynamic tagging
    awful.key(
        { modkey, "Shift" }, "n",
        function () lain.util.add_tag() end,
        {description = "add new tag", group = "tag"}
    ),

    awful.key(
        { modkey, "Shift" }, "r",
        function () lain.util.rename_tag() end,
        {description = "rename tag", group = "tag"}
    ),

    awful.key(
        { modkey, "Shift" }, "Left",
        function () lain.util.move_tag(-1) end,
        {description = "move tag to the left", group = "tag"}
    ),

    awful.key(
        { modkey, "Shift" }, "Right",
        function () lain.util.move_tag(1) end,
        {description = "move tag to the right", group = "tag"}
    ),

    awful.key(
        { modkey, "Shift" }, "d",
        function () lain.util.delete_tag() end,
        {description = "delete tag", group = "tag"}
    ),

    -- Standard program
    awful.key(
        { modkey,           }, "Return",
        function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}
    ),

    awful.key(
        { modkey, "Control" }, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),

    awful.key(
        { modkey, "Shift"   }, "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),

    awful.key(
        { altkey, "Shift"   }, "l",
        function () awful.tag.incmwfact( 0.05) end,
        {description = "increase master width factor", group = "layout"}
    ),

    awful.key(
        { altkey, "Shift"   }, "h",
        function () awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}
    ),

    awful.key(
        { modkey, "Shift"   }, "h",
        function () awful.tag.incnmaster(1, nil, true) end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),

    awful.key(
        { modkey, "Shift"   }, "l",
        function () awful.tag.incnmaster(-1, nil, true) end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),

    awful.key(
        {modkey, "Control"}, "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),

    awful.key(
        {modkey, "Control"}, "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),

    awful.key(
        {modkey}, "space",
        function() awful.layout.inc(1) end,
        {description = "select next", group = "layout"}
    ),

    awful.key(
        {modkey, "Shift"}, "space",
        function() awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}
    ),

    -- Un-minimize all
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key(
        { modkey, }, "z",
        function () awful.screen.focused().quake:toggle() end,
        {description = "dropdown application", group = "launcher"}
    ),

    -- Widgets popups
    awful.key(
        { altkey, }, "c",
        function () if beautiful.cal then beautiful.cal.show(7) end end,
            {description = "show calendar", group = "widgets"}
    ),

    awful.key(
        { altkey, }, "h",
        function () if beautiful.fs then beautiful.fs.show(7) end end,
            {description = "show filesystem", group = "widgets"}
    ),

    awful.key(
        { altkey, }, "w",
        function () if beautiful.weather then beautiful.weather.show(7) end end,
            {description = "show weather", group = "widgets"}
    ),

    -- Brightness
    awful.key(
        { }, "XF86MonBrightnessUp",
        function () awful.spawn.easy_async("xbacklight -inc 10") end,
        {description = "+10%", group = "hotkeys"}
    ),

    awful.key(
        { }, "XF86MonBrightnessDown",
        function () awful.spawn.easy_async("xbacklight -dec 10") end,
        {description = "-10%", group = "hotkeys"}
    ),

    -- {{ Media Player Control (uses playerctl)
    awful.key(
        { modkey, "Shift" }, "m",
        function () awful.spawn.easy_async(media_player) end,
        {description = "open default media player client", group = "player"}
    ),

    awful.key(
        {}, "XF86AudioPrev",
        playerctl.prev,
        {description = "go to previous song on player", group = "player"}
    ),

    awful.key(
        {}, "XF86AudioNext",
        playerctl.next,
        {description = "go to next song on player", group = "player"}
    ),

    awful.key(
        {}, "XF86AudioPlay",
        playerctl.play,
        {description = "play current song on player", group = "player"}
    ),

    awful.key(
        {}, "XF86AudioStop",
        playerctl.stop,
        {description = "stop current song on player", group = "player"}
    ),

    awful.key(
        { modkey , "Control"}, "s",
        playerctl.play, -- same as XF86AudioPlay
        {description = "play current song on player", group = "player"}
    ),

    awful.key(
        { modkey , "Control"}, "d",
        playerctl.next, -- same as XF86AudioNext
        {description = "go to next song on player", group = "player"}
    ),

    awful.key(
        { modkey , "Control"}, "a",
        playerctl.prev, -- same as XF86AudioPrev
        {description = "go to previous song on player", group = "player"}
    ),
    -- Media Player Control }}

    -- ALSA volume control
    awful.key({}, "XF86AudioRaiseVolume", alsa.volume_up),
    awful.key({}, "XF86AudioLowerVolume", alsa.volume_down),
    awful.key({}, "XF86AudioMute", alsa.mute_audio),
    awful.key({}, "XF86AudioMicMute", alsa.mute_mic),

    awful.key(
        { altkey }, "m",
        alsa.mute_audio,
        {description = "toggle audio mute", group = "hotkeys"}
    ),

    awful.key(
        { altkey, "Control" }, "m",
        alsa.mute_audio,
        {description = "toggle mic mute", group = "hotkeys"}
    ),

    awful.key(
        { altkey }, "0",
        alsa.volume_up,
        {description = "volume +5%", group = "hotkeys"}
    ),

    awful.key(
        { altkey }, "9",
        alsa.volume_down,
        {description = "volume -5%", group = "hotkeys"}
    ),

    -- Browser
    awful.key(
        { modkey }, "b",
        function () awful.spawn(browser) end,
        {description = "run browser", group = "launcher"}
    ),

    -- Slack
    awful.key(
        { modkey, "Shift" }, "s",
        function() awful.spawn("slack") end,
              {description = "opens slack messaging application", group =
                   "messaging"}
    ),

    -- Launcher
    awful.key(
        { modkey }, "r",
        function () awful.spawn('rofi -show drun -columns 2') end,
        {description = "run program", group = "launcher"}
    )
    --]]
)

clientkeys = my_table.join(
    awful.key(
        {altkey, "Shift"}, "m",
        lain.util.magnify_client,
        {description = "magnify client", group = "client"}
    ),

    awful.key(
        {modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),

    awful.key(
        {modkey, "Shift"}, "c",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),

    awful.key(
        {modkey, "Control"}, "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),

    awful.key(
        {modkey, "Control"}, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),

    awful.key(
        {modkey}, "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),

    awful.key(
        {modkey}, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),

    -- Uncomment these lines to enable minimize
    -- awful.key({ modkey,           }, "n",
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end ,
    --     {description = "minimize", group = "client"}),

    awful.key(
        { modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}
    )
)

-- Bind all key numbers to tags. From 1 to 9
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}

        descr_toggle_focus = {
            description = "toggle focused client on tag #",
            group = "tag"
        }
    end

    globalkeys = my_table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button(
        { }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),

    awful.button(
        { modkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),

    awful.button(
        { modkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap+awful.placement.no_offscreen,
          size_hints_honor = false
      }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
      properties = { maximized = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = beautiful.wibar_height}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Focus follows mouse pointer.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal(
    "property::maximized",
    border_adjust
)

client.connect_signal(
    "focus",
    border_adjust
)

client.connect_signal(
    "unfocus",
    function(c) c.border_color = beautiful.border_normal end
)
-- }}}
