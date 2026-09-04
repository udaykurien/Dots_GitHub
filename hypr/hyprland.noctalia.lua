----------------------
-- SHARED SETTINGS ---
----------------------

local cfg = require("config")

------------------
-- ENVIRONMENT ---
------------------

hl.env("TZDIR", "/etc/zoneinfo")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "22")
hl.env("QT_QPA_PLATFORM", "wayland")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct") -- set to kde in nix config
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
-- hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/gcr/ssh", true)
-- hl.env("WLR_NO_HARWARE_CURSORS", "1")
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Multi-GPU/
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")

hl.plugin.load(os.getenv("HYPR_PLUGIN_DIR") .. "/lib/libhypr-dynamic-cursors.so")
-- hl.plugin.load(os.getenv("HYPR_PLUGIN_DIR") .. "/lib/libhyprspace.so")
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output          = "eDP-1",
    mode            = "2560x1600@165",
    position        = "auto",
    scale           = "1.25",
})

------------------
--- X SCALING ----
------------------

-- Disable scaling on x-wayland apps to sop pixellated look
hl.config({ xwayland = { force_zero_scaling = true } })

------------------
---- AUTOSTART ---
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    -- hl.exec_cmd("systemctl --user import-environment")
    -- hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    -- hl.exec_cmd("udiskie --tray")
    -- hl.exec_cmd("easyeffects --gapplication-service")
    hl.exec_cmd("flatpak run org.signal.Signal --start-in-tray")
    -- hl.exec_cmd("steam -silent")
    
    -- NOTE: Failsafe, incase gcr-ssh-agent doesn't auto enable as per configurations.nix.
    
    -- hl.exec_cmd("systemctl --user enable --now gcr-ssh-agent.socket")
    
    -- NOTE: Hyprland polkit should be enabled if shell polkit isn't.

    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")
    
    -- NOTE: Force display refresh on gdm login to remove ghost cursor. Option B is fragile.
    
    -- -- Option A
    -- hl.exec_cmd([[hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' && sleep 1 && hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })']])
    
    -- -- Option B
    -- hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    -- hl.timer(function()
    --     hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    -- end, { timeout = 1000, type = "oneshot" })

end)

-- Testing
hl.bind("SUPER + N", function()
    hl.notification.create({ text = "keybind fired", duration = 2000 })
    local t = hl.timer(function()
        hl.notification.create({ text = "timer fired", duration = 2000 })
    end, { timeout = 1000, type = "oneshot" })
end)

------------------
--- ANIMATION ----
------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#curves
-- See https://easings.net/#

hl.curve( "overshoot", { type = "bezier", points = { {0.5, 0.9}, {0.1, 1.1} } } )
hl.curve( "easeOutSine", { type = "bezier", points = { {0.61, 1}, {0.88, 1} } })
hl.curve( "easeInOutCubic", { type = "bezier", points = { {0.65, 0}, {0.35, 1} } })
-- hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "overshoot" })
hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "easeOutSine" })
hl.animation({ leaf = "border", enabled = true, speed = 1.5, bezier = "easeOutSine" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOutSine", style = "slidevert" })

-- -- Mango style animations
-- -- Curves matching mango's animation_curve values (cubic-bezier control points)
-- hl.curve("mangoOpen",  { type = "bezier", points = { {0.46, 1.0}, {0.29, 1} } })  -- snappy ease-out
-- hl.curve("mangoClose", { type = "bezier", points = { {0.08, 0.92}, {0, 1} } })    -- slower ease-in
--
-- -- -- Global animations toggle
-- -- hl.config({
-- --     animations = { enabled = true }
-- -- })
--
-- -- Window open: fast slide-in (mango: 400ms)
-- hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4, bezier = "mangoOpen",  style = "slide" })
--
-- -- Window close: slower slide-out (mango: 800ms)
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 8, bezier = "mangoClose", style = "slide" })
--
-- -- Window move/resize: keep snappy, no slide needed
-- hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "mangoOpen" })
--
-- -- Fade in/out paired with the slides (mango fades alongside its slide)
-- hl.animation({ leaf = "fadeIn",  enabled = true, speed = 4, bezier = "mangoOpen" })
-- hl.animation({ leaf = "fadeOut", enabled = true, speed = 8, bezier = "mangoClose" })
--
-- -- Workspace switch: mango-style slide between tags
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "mangoOpen", style = "slidevert" })
--
-- -- Layer surfaces (rofi, waybar, notifications) — mango uses zoom for launchers, fade for bars
-- hl.animation({ leaf = "layersIn",  enabled = true, speed = 3, bezier = "mangoOpen",  style = "popin" })
-- hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "mangoClose", style = "fade" })

------------------
------- MOD ------
------------------

local main_mod = cfg.main_mod -- Sets Super key as main modifier

------------------
---- NOC BINDS ---
------------------
local ipc = "noctalia msg"

hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(ipc .. " " .. "panel-toggle launcher"))
hl.bind(main_mod .. " + c", hl.dsp.exec_cmd(ipc .. " " .. "panel-toggle control-center"))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd(ipc .. " " .. "panel-toggle clipboard"))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd(ipc .. " " .. "panel-toggle session"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd(ipc .. " " .. "window-switcher"))

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        resize_on_border = true,
        col = {
            -- active_border = {colors = {"rgba(33ccffcc)", "rgba(00ff99cc)"}, angle = 45},
            active_border = "rgba(eeeeeeee)";
            -- active_border = {
            --     colors = {
            --         "rgb(4AD6A4)",
            --         "rgb(6CA6D7)",
            --         "rgb(9462BB)"
            --     },
            --     angle = 45,
            -- },
            inactive_border = "rgba(595959aa)";
        },
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled   = true,
            size      = 8,
            passes    = 4,
            vibrancy  = 0.1696,
            -- ignore_opacity = true,
        },
    },
    plugin = {
        dynamic_cursors = {
            enabled = true,
            mode = "stretch",
            rotate = {
                -- length in px of the simulated stick used to rotate the cursor
                -- most realistic if this is your actual cursor size
                length = 20,
                -- clockwise offset applied to the angle in degrees (applies to ALL shapes)
                offset = 0.0,
              },
            shake = {
                enabled = true,
                -- controls how soon a shake is detected; lower = sooner
                threshold = 4.0,
                -- magnification level immediately after shake starts
                base = 2.0,
                -- magnification increase per second while continuing to shake
                speed = 4.0,
                -- how much speed is influenced by current shake intensity
                influence = 0.0,
                -- max magnification the cursor can reach (values below 1 disable the limit)
                limit = 0.0,
                -- time in ms cursor stays magnified after shake ends
                timeout = 2000,
                -- show tilt/rotate/etc behaviour while shaking
                effects = true,
                -- enable IPC events for shake (spammy, off by default)
                ipc = false,
            },
        },
    },
})

hl.plugin.dynamic_cursors.shape_rule { shape = "text", mode = "none" }
hl.plugin.dynamic_cursors.shape_rule { shape = "grab", mode = "none" }
hl.plugin.dynamic_cursors.shape_rule { shape = "pointer", mode = "none" }

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
  },
  -- no_anim = true,
  ignore_alpha = 0.3,
  blur = true,
  blur_popups = true,
})

-- hl.layer_rule({
--   name = "noctalia",
--   match = {namespace = "noctalia-background-.*$"},
--   ignore_alpha = 0.5,
--   blur = true,
--   blur_popups = true,
-- })

---------------------
---- WINDOW RULE ----
---------------------

hl.window_rule({
    name = "no-maximize-celluloid",
    match = { class = "^io\\.github\\.celluloid_player\\.Celluloid$" },
    suppress_event = "maximize",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "ghostty"

---------------
---- INPUT ----
---------------
-- 2 finger scrolling (keep natural/reverse scrolling consistent with gesture directions)
hl.config({
    input = {
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Workspace switching gesture settings
hl.config({
    gestures = {
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_cancel_ratio = 0.4,
    },
})

-- Workspace switching gestures
hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = "workspace",
})

-- Window switching for scrolling layout
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 3,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Monitor control
hl.bind(main_mod .. " + SHIFT + CTRL + D", function()
    hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "enable" }))
    end, { timeout = 1000, type = "oneshot" })
end)

hl.bind(main_mod .. " + SHIFT + D", function()
  hl.dispatch(hl.dsp.dpms({ action = "disable" }))
end)

-- hl.bind(main_mod .. " + D", function()
--   hl.dispatch(hl.dsp.dpms({ action = "enable" }))
-- end)

hl.bind(main_mod .. " + D", function()
  hl.timer(function()
    hl.dispatch(hl.dsp.dpms({ action = "enable" }))
  end, { timeout = 500, type = "oneshot" })
end)

-- Essential binds
hl.bind(cfg.hypr_exit, hl.dsp.exit())
hl.bind(cfg.terminal_open, hl.dsp.exec_cmd(terminal))
hl.bind(cfg.win_close, hl.dsp.window.close())

-- Laptop multimedia keys for volume, brightness, and screenshots
hl.bind(cfg.speaker_raise_volume_large, hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(cfg.speaker_raise_volume_small, hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind(cfg.speaker_lower_volume_large, hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind(cfg.speaker_lower_volume_small, hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind(cfg.speaker_toggle_volume_mute,        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind(cfg.mic_toggle_volume_mute,     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind(cfg.screen_raise_brightness_large,  hl.dsp.exec_cmd("brightnessctl -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind(cfg.screen_raise_brightness_small,  hl.dsp.exec_cmd("brightnessctl -n2 set 1%+"),                  { locked = true, repeating = true })
hl.bind(cfg.screen_lower_brightness_large,hl.dsp.exec_cmd("brightnessctl -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind(cfg.screen_lower_brightness_small,hl.dsp.exec_cmd("brightnessctl -n2 set 1%-"),                  { locked = true, repeating = true })
hl.bind(cfg.screenshot, hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename -'))

-- Requires playerctl
hl.bind(cfg.media_next,  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind(cfg.media_pause, hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(cfg.media_play,  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(cfg.media_previous,  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Workspace switching
hl.bind(cfg.ws_prev, hl.dsp.focus({ workspace = "-1" }))
hl.bind(cfg.ws_next, hl.dsp.focus({ workspace = "+1" }))

-- Numbered (1-9) workspace binds
for i=1, 9, 1 do
    hl.bind("CTRL + " .. main_mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end

hl.bind("CTRL + " .. main_mod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Workspace names
for i=2, 5, 1 do
    hl.workspace_rule({ workspace = i, default_name = i .. "!C" }) -- Casual 1 - Casual 4
end

for i=6, 10, 1 do
    hl.workspace_rule({workspace = i, default_name = i .. "|W" }) -- Work 5 - Work 9
end

hl.workspace_rule({ workspace = 1, default_name = "1|M" }) -- Music 1o

-- Focus windows
hl.bind(cfg.focus_left,  hl.dsp.focus({ direction = "left" }))
hl.bind(cfg.focus_right, hl.dsp.focus({ direction = "right" }))
hl.bind(cfg.focus_up,    hl.dsp.focus({ direction = "up" }))
hl.bind(cfg.focus_down,  hl.dsp.focus({ direction = "down" }))

-- Maximize or fullscreen windows
hl.bind(cfg.win_fullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(cfg.win_maximize, hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Toggle split direction
hl.bind(cfg.win_split_direction_toggle, hl.dsp.layout('togglesplit'))

-- Move windows within a workspace
hl.bind(cfg.win_mv_left,  hl.dsp.window.move({ direction = "left"  }))
hl.bind(cfg.win_mv_right, hl.dsp.window.move({ direction = "right" }))
hl.bind(cfg.win_mv_up,    hl.dsp.window.move({ direction = "up"    }))
hl.bind(cfg.win_mv_down,  hl.dsp.window.move({ direction = "down"  }))

-- Move windows between workspaces
hl.bind(cfg.win_mv_to_prev_ws, hl.dsp.window.move({ workspace = "-1" }))
hl.bind(cfg.win_mv_to_next_ws, hl.dsp.window.move({ workspace = "+1" }))

-- -- Hyprspace
-- hl.bind("SUPER + grave", function()
--     hl.exec_cmd("hyprctl dispatch overview:toggle")
-- end)

------------------
---- LAYOUTS -----
------------------
hl.config({
    dwindle = {
        force_split = 2,
        preserve_split = true,
    },
})
------------------
---- SCRIPTS -----
------------------
require("hyprscripts/cycle_layouts")
require("hyprscripts/swap_windows")
require("hyprscripts/resize_windows")

------------------
---- TESTING -----
------------------

------------------
---- NOCTALIA ----
------------------
-- For Noctalia Color templates
require("noctalia").apply_theme()

-- Overwrite inactive borders
hl.config({
    general = {
        col = {
            inactive_border = "rgba(595959aa)";
    }
    }
})
