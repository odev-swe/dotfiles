local wezterm = require 'wezterm'
local act = wezterm.action

return {
    color_scheme = "Catppuccin Mocha",

    keys = {
        -- tab reorder (existing)
        { key = "[", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
        { key = "]", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },

        -- split panes
        { key = "d", mods = "CMD",       action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical   { domain = "CurrentPaneDomain" } },

        -- move between panes
        { key = "h", mods = "CMD|ALT", action = act.ActivatePaneDirection "Left" },
        { key = "l", mods = "CMD|ALT", action = act.ActivatePaneDirection "Right" },
        { key = "k", mods = "CMD|ALT", action = act.ActivatePaneDirection "Up" },
        { key = "j", mods = "CMD|ALT", action = act.ActivatePaneDirection "Down" },

        -- resize panes
        { key = "LeftArrow",  mods = "CMD|SHIFT", action = act.AdjustPaneSize { "Left", 5 } },
        { key = "RightArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize { "Right", 5 } },
        { key = "UpArrow",    mods = "CMD|SHIFT", action = act.AdjustPaneSize { "Up", 5 } },
        { key = "DownArrow",  mods = "CMD|SHIFT", action = act.AdjustPaneSize { "Down", 5 } },

        -- zoom / close pane
        { key = "z", mods = "CMD", action = act.TogglePaneZoomState },
        { key = "w", mods = "CMD", action = act.CloseCurrentPane { confirm = true } },

        -- tabs
        { key = "t", mods = "CMD", action = act.SpawnTab "CurrentPaneDomain" },
        { key = "1", mods = "CMD", action = act.ActivateTab(0) },
        { key = "2", mods = "CMD", action = act.ActivateTab(1) },
        { key = "3", mods = "CMD", action = act.ActivateTab(2) },
        { key = "4", mods = "CMD", action = act.ActivateTab(3) },
        { key = "5", mods = "CMD", action = act.ActivateTab(4) },
    },

    font = wezterm.font("JetBrainsMono Nerd Font"),

    font_size = 15,

    window_decorations = "RESIZE",

    hide_tab_bar_if_only_one_tab = true,

    enable_scroll_bar = false,

    window_background_opacity = 0.95,

    macos_window_background_blur = 30,

    adjust_window_size_when_changing_font_size = false,

    use_fancy_tab_bar = false,

    tab_bar_at_bottom = false,

    animation_fps = 120,

    max_fps = 120,

    window_padding = {
        left = 10,
        right = 10,
        top = 8,
        bottom = 8,
    },
}
