-- Keybinds to resize windows via submaps
-- (Ref: https://wiki.hypr.land/Configuring/Basics/Binds/)
-- --------------------------------------------------------
local cfg = require("config")
local main_mod = cfg.main_mod

-- Switch to a submap called `resize`.
hl.bind(main_mod .. " + R", hl.dsp.submap("resize"))

-- Start a submap called "resize".
hl.define_submap("resize", function()

    -- Set repeating binds for resizing the active window.
    -- NOTE: Wayland co-ordinate systems starts at top left.
    -- x increases rightwards, y increases downwards.
    
    hl.bind("right", hl.dsp.window.resize({ x = 30, y = 0, relative = true}), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -30, y = 0, relative = true}), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -30, relative = true}), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 30, relative = true}), { repeating = true })
    
    hl.bind("SHIFT + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
    hl.bind("SHIFT + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
    hl.bind("SHIFT + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
    hl.bind("SHIFT + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind(main_mod .. " + R", hl.dsp.submap("reset"))

end)

-- Keybinds further down will be global again...
