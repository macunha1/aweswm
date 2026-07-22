local Mpris = {}

local dbus_proxy_available, dbus_proxy = pcall(require, "dbus_proxy")

local mpris = {
    path = "/org/mpris/MediaPlayer2",
    player_interface = "org.mpris.MediaPlayer2.Player",
    dbus_interface = "org.freedesktop.DBus",
    dbus_name = "org.freedesktop.DBus",
    dbus_path = "/org/freedesktop/DBus",
    player_name_prefix = "org.mpris.MediaPlayer2.",
    player_proxies = {},
}

local function notify_error(naughty, message)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Media control failed",
        text = message,
    })
end

local function preferred_mpris_name(preferred_player)
    return mpris.player_name_prefix .. preferred_player
end

local function is_mpris_player_name(name)
    return name:sub(1, #mpris.player_name_prefix) == mpris.player_name_prefix
end

local function get_dbus_proxy()
    if mpris.dbus_proxy then
        return mpris.dbus_proxy
    end

    mpris.dbus_proxy = dbus_proxy.Proxy:new({
        bus = dbus_proxy.Bus.SESSION,
        name = mpris.dbus_name,
        interface = mpris.dbus_interface,
        path = mpris.dbus_path,
    })

    return mpris.dbus_proxy
end

local function get_mpris_player_name(preferred_player)
    local names = get_dbus_proxy():ListNames()
    local preferred_name = preferred_mpris_name(preferred_player)
    local fallback_name = nil

    for _, name in ipairs(names or {}) do
        if name == preferred_name then
            return name
        end

        if not fallback_name and is_mpris_player_name(name) then
            fallback_name = name
        end
    end

    return fallback_name
end

local function get_mpris_player_proxy(name)
    if mpris.player_proxies[name] then
        return mpris.player_proxies[name]
    end

    mpris.player_proxies[name] = dbus_proxy.Proxy:new({
        bus = dbus_proxy.Bus.SESSION,
        name = name,
        interface = mpris.player_interface,
        path = mpris.path,
    })

    return mpris.player_proxies[name]
end

local function run_mpris_command(command, preferred_player, naughty)
    if not dbus_proxy_available then
        notify_error(naughty, "dbus_proxy is not available in Awesome's Lua path")
        return
    end

    local ok, err = pcall(function()
        local player_name = get_mpris_player_name(preferred_player)
        if not player_name then
            notify_error(naughty, "No MPRIS media player is available on the session bus")
            return
        end

        local player = get_mpris_player_proxy(player_name)
        player[command .. "Async"](player, function(_, _, _, failure)
            if failure then
                mpris.player_proxies[player_name] = nil
                notify_error(naughty, tostring(failure))
            end
        end, { player_name = player_name })
    end)

    if not ok then
        notify_error(naughty, tostring(err))
    end
end

function Mpris.new(args)
    local preferred_player = args.preferred_player
    local naughty = args.naughty

    return {
        play = function() run_mpris_command("PlayPause", preferred_player, naughty) end,
        prev = function() run_mpris_command("Previous", preferred_player, naughty) end,
        next = function() run_mpris_command("Next", preferred_player, naughty) end,
        stop = function() run_mpris_command("Stop", preferred_player, naughty) end,
    }
end

return Mpris
