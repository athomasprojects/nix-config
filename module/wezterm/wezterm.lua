-- Pull in the wezterm API 
local wezterm = require "wezterm"

-- This table will hol the configuration
local config = {}

config.term = "wezterm"
config.max_fps = 240

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


-- Set background to same color as neovim
config.colors = {}
config.colors.background = "#111111"

-- config.colors.selection_fg = "black"
-- config.colors.selection_bg = "#fffacd"

-- Set fallback fonts
config.font = wezterm.font_with_fallback {
  "Berkeley Mono",
  "nonicons",
  -- "Symbols Nerd Font Mono",
  -- "Font Awesome Free 6",
  -- "DejaVu Sans Mono",
  -- "Hack Nerd Font Mono",
  -- "Noto Sans",
  -- { family = 'Terminus', weight = 'Bold' },
  -- 'Noto Color Emoji',
}

-- local my_default = wezterm.color.get_default_colors()

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

local function basename(_)
  return "wezterm"
  -- return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = " " .. (tab.tab_index + 1) .. ":" .. " " .. basename(pane.foreground_process_name)
  return {
    { Text = title .. " " },
  }
end)

return config
