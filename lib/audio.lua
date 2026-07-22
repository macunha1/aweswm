local Audio = {}

local action_configs = {
    ["volume-up"] = '{"action":"volume-up"}',
    ["volume-down"] = '{"action":"volume-down"}',
    ["mute-audio"] = '{"action":"mute-audio"}',
    ["mute-mic"] = '{"action":"mute-mic"}',
}

local function notify_error(naughty, message)
    if not naughty then
        return
    end

    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Audio control failed",
        text = message,
    })
end

local function run_wireplumber_action(action, args)
    args.awful.spawn.easy_async(
        { "wpexec", args.script_path, action_configs[action] },
        function(_, stderr, _, exit_code)
            if exit_code ~= 0 then
                notify_error(args.naughty, stderr)
                return
            end

            if args.beautiful.volume and args.beautiful.volume.update then
                args.beautiful.volume.update()
            end
        end
    )
end

function Audio.new(args)
    local controls = {}

    controls.volume_up = function()
        run_wireplumber_action("volume-up", args)
    end

    controls.volume_down = function()
        run_wireplumber_action("volume-down", args)
    end

    controls.mute_audio = function()
        run_wireplumber_action("mute-audio", args)
    end

    controls.mute_mic = function()
        run_wireplumber_action("mute-mic", args)
    end

    return controls
end

return Audio
