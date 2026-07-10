------------------
-- ENVIRONMENT ---
------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "2560x1600@165",
    position = "auto",
    scale    = "1.25",
})

------------------
---- AUTOSTART ---
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")

    -- Force a display refresh on startup
    hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "enable" }))
    end, { timeout = 1000, type = "oneshot" })
end)

------------------
------- MOD ------
------------------

local main_mod = "SUPER" -- Sets "Windows" key as main modifier

------------------
---- NOC BINDS ---
------------------

hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

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
            active_border = {colors = {"rgba(ddddddff)", "rgba(ddddddff)"}, angle = 45},
            inactive_border = "rgba(595959aa)";
        },
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled   = true,
            size      = 7,
            passes    = 3,
            vibrancy  = 1,
            ignore_opacity = true,
        },
    },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
  },
  -- no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "ghostty"

---------------
---- INPUT ----
---------------

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Monitor control
hl.bind("SUPER + SHIFT + D", function()
    hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "enable" }))
    end, { timeout = 1000, type = "oneshot" })
end)
hl.bind("SUPER + D", function()
  hl.dispatch(hl.dsp.dpms({ action = "enable" }))
end)

-- Essential binds
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind(main_mod .. " + Q", hl.dsp.window.close())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("SHIFT+XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("SHIFT+XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -n2 set 1%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("SHIFT+XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -n2 set 1%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Workspace switching
hl.bind("CTRL + " .. main_mod .. " + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + " .. main_mod .. " + right", hl.dsp.focus({ workspace = "+1" }))

-- Move windows between workspaces
hl.bind("CTRL + SHIFT + " .. main_mod .. " + left", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("CTRL + SHIFT + " .. main_mod .. " + right", hl.dsp.window.move({ workspace = "+1" }))

-- Focus windows
hl.bind(main_mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move windows within a workspace
hl.bind(main_mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(main_mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(main_mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))

-- Maximize or fullscreen windows
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
