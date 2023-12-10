-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Github'
config.font = wezterm.font "Iosevka Comfy"
config.font_size = 11
config.cell_width = 0.8

config.keys = {
  {
    key = 'p',
    mods = 'CTRL|ALT',
    action = wezterm.action.PaneSelect,
  },
  {
    key = 'v',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Right',
    },
  },
  {
    key = 'h',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
    },
  },
  {
    key = 'c',
    mods = 'CTRL|ALT',
    action = wezterm.action.CloseCurrentPane {
      confirm = true,
    },
  },
  {
    key = 'f',
    mods = 'CTRL|ALT',
    action = wezterm.action.ToggleFullScreen,
  },
}

config.window_frame = {
  font = wezterm.font "Noto",
  font_size = 10.5,
  -- inactive_titlebar_bg = '#cccccc',
  -- inactive_titlebar_fg = '#000000',
  -- active_titlebar_bg = '#f1f1f1',
  -- active_titlebar_fg = '#000000',
  -- inactive_titlebar_border_bottom = '#2b2042',
  -- active_titlebar_border_bottom = '#2b2042',
  -- button_fg = '#ffffff',
  -- button_bg = '#f1f1f1',
  -- button_hover_fg = '#ffffff',
  -- button_hover_bg = '#cccccc',
}

-- and finally, return the configuration to wezterm
return config
