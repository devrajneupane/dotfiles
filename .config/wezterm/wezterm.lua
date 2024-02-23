local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "wezterm"
config.unicode_version = 14
config.default_prog = { "/usr/bin/bash" }
config.use_dead_keys = false

-- Colorscheme
config.color_scheme_dirs = { "${XDG_DATA_HOME}/nvim/lazy/tokyonight.nvim/extras/wezterm" }
config.color_scheme = "tokyonight_storm"

-- Command Palette
config.command_palette_bg_color = "#24283b"
config.command_palette_fg_color = "#c0caf5"
config.command_palette_rows = 15

-- FONTS
config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_rules = {
    {
        intensity = "Bold",
        font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font("JetBrainsMono Nerd Font", { weight = "DemiBold", style = "Italic" }),
    },
    {
        italic = true,
        intensity = "Half",
        font = wezterm.font({
            family = "JetBrainsMono Nerd Font",
            weight = "DemiBold",
            style = "Italic",
        }),
    },
    {
        intensity = "Normal",
        italic = true,
        font = wezterm.font("JetBrainsMono Nerd Font", { style = "Italic" }),
    },
}

-- Tab bar.
config.hide_tab_bar_if_only_one_tab = true

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.cursor_thickness = 1.5
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Hyperlinks
-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable
table.insert(config.hyperlink_rules, {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = "https://www.github.com/$1/$3",
})

-- Window
-- window_background_opacity = 0.9,
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.scrollback_lines = 10000

-- GPU
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

return config
