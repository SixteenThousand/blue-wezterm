local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}

local COLOURSCHEME_FILE = os.getenv("HOME").."/.config/wezterm/state/colour_scheme"

-- DECORATION
config.font = wezterm.font "FantasqueSansM Nerd Font"
config.font_size = 14.0
local fp = io.open(COLOURSCHEME_FILE,"r")
if fp then
    config.color_scheme = fp:read()
    fp:close()
else
    config.color_scheme = "Rosé Pine Moon (base16)"
end
-- disable ligatures
-- this may need to change if you change the font
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }

-- BACKGROUND
config.window_background_opacity = 0.95

-- WINDOW STUFF
config.window_padding = {
    left = 0,
    top = 0,
    right = 0,
    bottom = 0,
}
config.enable_wayland = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "NONE"

config.default_prog = { "bash" }

-- KEYBINDINGS
--[[
+++ NOTES +++
 - use CTRL|SHIFT F to search
--]]
config.leader = { key = "s",  mods = "CTRL" }
config.keys = {
    { key = "p", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "n", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
    { key = "g", mods = "LEADER", action = act.ScrollToTop },
    { key = "g", mods = "LEADER|SHIFT", action = act.ScrollToBottom },
    { key = "k", mods = "CTRL|SHIFT", action = act.ScrollByLine(-1) },
    { key = "j", mods = "CTRL|SHIFT", action = act.ScrollByLine(1) },
    { key = "a", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "d", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "c", mods = "LEADER", action = act.SpawnCommandInNewTab },
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane{ confirm = false } },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "h", mods = "LEADER", action = act.ActivateCommandPalette },
    { key = "v", mods = "LEADER", action = act.SplitPane{
        direction = "Right",
        size = { Percent = 50 },
    }},
    { key = "s", mods = "LEADER", action = act.SplitPane{
        direction = "Down",
        size = { Percent = 50 },
    }},
    { key = "H", mods = "LEADER", action = act.AdjustPaneSize{ 'Left', 10 } },
    { key = "J", mods = "LEADER", action = act.AdjustPaneSize{ 'Down', 10 } },
    { key = "K", mods = "LEADER", action = act.AdjustPaneSize{ 'Up', 10 } },
    { key = "L", mods = "LEADER", action = act.AdjustPaneSize{ 'Right', 10 } },
    { key = "w", mods = "LEADER|CTRL", action = act.PaneSelect },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "w", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
    { key = "x", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
    { key = "o", mods = "LEADER", action = wezterm.action_callback(
        function(window)
            local overrides = window:effective_config() or {}
            if overrides.window_background_opacity < 1.0 then
                overrides.window_background_opacity = 1.0
            else
                overrides.window_background_opacity = 0.95
            end
            window:set_config_overrides(overrides)
        end)
    },
    { key = "i", mods = "CTRL|SHIFT", action = wezterm.action_callback(
        function(window)
            local overrides = window:effective_config() or {}
            local fp = 
                io.open(COLOURSCHEME_FILE,"r")
            overrides.color_scheme = fp:read()
            fp:close()
            window:set_config_overrides(overrides)
        end)
    },
}
for tab_num = 1,9 do
    table.insert(config.keys,{
        key = tostring(tab_num),
        mods = "LEADER",
        action = act.ActivateTab(tab_num - 1),
    })
end
table.insert(config.keys, {
    key = "0",
    mods = "LEADER",
    action = act.ActivateTab(9)
})

-- terminal bell ('\a')
-- config.audible_bell = "SystemBeep" -- does not work on wayland
-- for some reason this gets called twice
wezterm.on("bell",function()
    os.execute("ffplay -nodisp -autoexit -hide_banner /usr/share/sounds/freedesktop/stereo/bell.oga &")
    return false
end)
config.visual_bell = {
    fade_in_duration_ms = 150,
    fade_in_function = "EaseIn",
    fade_out_duration_ms = 150,
    fade_out_function = "EaseOut",
}
config.colors = {
    visual_bell = "#ffffff",
}


return config
