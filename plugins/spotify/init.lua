#!/usr/bin/env lua

local awful       = require("awful")
local watch       = require("awful.widget.watch")
local beautiful   = require("beautiful")
local wibox       = require("wibox")

-- Spotify Widget
-- Built on top of the amazing work from @streetturtle
-- Ref: https://github.com/streetturtle/awesome-wm-widgets/blob/master/spotify-widget/spotify.lua
local Spotify = {}

function Spotify:new(args)
	return setmetatable({}, {__index = self}):init(args)
end

function Spotify:init(args)
	self.icons  = args.icons      or {
		play    = args.play_icon  or beautiful.play,
		pause   = args.pause_icon or beautiful.pause
	}
	self.font   = args.font       or beautiful.font
	
	self.widget = wibox.widget {
		{
			id = "icon",
			widget = wibox.widget.imagebox,
		},
		{
			id = 'current_song',
			widget = wibox.widget.textbox,
			font = self.font
		},
		layout = wibox.layout.fixed.horizontal,
		set_status = function(self, image)
			self.icon.image = image
		end,
		set_text = function(self, text)
			self.current_song.markup = text
		end,
	}

	self:watch()
	self:signal()

	return self
end

function Spotify:escape_xml(str)
	str = string.gsub(str, "&", "&amp;")
	str = string.gsub(str, "<", "&lt;")
	str = string.gsub(str, ">", "&gt;")
	str = string.gsub(str, "'", "&apos;")
	str = string.gsub(str, '"', "&quot;")

	return str
end

function Spotify:update_widget_icon(stdout)
	stdout = string.gsub(stdout, "\n", "")
	self.widget:set_status(
		(stdout == 'Playing') and self.icons.play or self.icons.pause
	)
end

function Spotify:update_widget_text(stdout)
	if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
		self.widget:set_text('Spotify | Offline')
		self.widget:set_visible(false)
	else
		self.widget:set_text(self:escape_xml(stdout))
		self.widget:set_visible(true)
	end
end

function Spotify:watch()
	local update_widget_icon = function(_, stdout, _, _, _)
		self:update_widget_icon(stdout)
	end

	local update_widget_text = function(_, stdout, _, _, _)
		self:update_widget_text(stdout)
	end

	watch('sp status', 1, update_widget_icon)
	watch('sp current-oneline', 1, update_widget_text)
end

function Spotify:exec(command, callback)
	local spawn_update = function()
		awful.spawn.easy_async(
			'sp status',
			function(stdout, stderr, _, _)
				self:update_widget_icon(stdout)
		end)
	end

	awful.spawn.easy_async(command, callback or spawn_update)
end

function Spotify:signal()
	--- Adds the following mouse actions:
	--  - button 1: left click  - play/pause
	--  - button 4: scroll up   - next song
	--  - button 5: scroll down - previous song
	
	self.widget:buttons(awful.util.table.join(
		awful.button({}, 1, function() self:exec("sp play", _) end),
		awful.button({}, 4, function() self:exec("sp next", _) end),
		awful.button({}, 5, function() self:exec("sp prev", _) end)
	))
end

return setmetatable(Spotify, { __call = Spotify.new, })
