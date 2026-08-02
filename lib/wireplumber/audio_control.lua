local config = ... or {}

local actions = {
    ["volume-up"] = {
        media_class = "Audio/Sink",
        volume_delta = 0.05,
    },
    ["volume-down"] = {
        media_class = "Audio/Sink",
        volume_delta = -0.05,
    },
    ["volume-max"] = {
        media_class = "Audio/Sink",
        volume = 1.0,
    },
    ["mute-audio"] = {
        media_class = "Audio/Sink",
        toggle_mute = true,
    },
    ["mute-mic"] = {
        media_class = "Audio/Source",
        toggle_mute = true,
    },
}

local function quit_after_sync()
    Core.sync(function()
        Core.quit()
    end)
end

local function set_default_node_volume(default_nodes, mixer, action)
    local node_id = default_nodes:call("get-default-node", action.media_class)
    if not node_id or node_id == 0 then
        Core.quit()
        return
    end

    local current_volume = mixer:call("get-volume", node_id)
    if not current_volume then
        Core.quit()
        return
    end

    if action.volume ~= nil then
        mixer:call("set-volume", node_id, { volume = action.volume })
    elseif action.volume_delta then
        local new_volume = (current_volume.volume or 1.0) + action.volume_delta
        mixer:call("set-volume", node_id, {
            volume = math.min(math.max(new_volume, 0.0), 1.0),
        })
    elseif action.toggle_mute then
        mixer:call("set-volume", node_id, { mute = not current_volume.mute })
    end

    quit_after_sync()
end

-- wpexec passes command-line arguments as Lua varargs, not decoded JSON.
local action = actions[config]
if not action then
    Core.quit()
    return
end

Core.require_api("default-nodes", "mixer", function(...)
    local default_nodes, mixer = ...

    mixer.scale = "cubic"
    set_default_node_volume(default_nodes, mixer, action)
end)
