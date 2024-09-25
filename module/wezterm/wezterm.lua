-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hol the configuration
local config = {}

config.term = "wezterm"
-- config.max_fps = 240

config.set_environment_variables = {
	TERMINFO_DIRS = "/etc/profiles/per-user/amanda/share/terminfo",
}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Set background to same color as neovim
config.colors = {}
config.colors.background = "#111111"

-- Set fallback fonts
config.font = wezterm.font_with_fallback({
	"Berkeley Mono",
	"nonicons",
})

config.enable_scroll_bar = false

-- nothing on the edges
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Window decorations
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

local function basename(s)
	-- return "wezterm"
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = " " .. (tab.tab_index + 1) .. ":" .. " " .. basename(pane.foreground_process_name)
	return {
		{ Text = title .. " " },
	}
end)

return config
