-- Keybinds to resize windows via submaps
-- (Ref: https://wiki.hypr.land/Configuring/Basics/Binds/)
-- --------------------------------------------------------
local cfg = require("config")
local main_mod = cfg.main_mod

-- Set rules to highlighted selected windows

local window_to_resize = nil
local win = nil
local notification_on_time = 2000

hl.window_rule({
    match = { tag = "marked_for_resize" },
    border_color = "rgb(FF00AA) rgb(FF00AA)",
    border_size = 2,
})

-- Switch to a submap called `resize`.
hl.bind(main_mod .. " + R", function()
    win = hl.get_active_window()
    if not win or not win.address then
        hl.notification.create({ text = "Resize submap not activated.", timeout = notification_on_time})
        return
    end
    window_to_resize = win.address
    hl.dispatch(hl.dsp.window.tag({ tag = "+marked_for_resize", window = "address:" .. window_to_resize }))
    hl.notification.create({ text = "Resize submap active on: " .. win.address, timeout = notification_on_time})
    hl.dispatch(hl.dsp.submap("resize"))
end)

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
    local function unmark_resize()
        hl.dispatch(hl.dsp.window.tag({ tag = "-marked_for_resize", window = "address:" .. window_to_resize }))
        hl.notification.create({ text = "Resize submap cleared from: " .. win.address, timeout = notification_on_time})
        window_to_resize = nil
    end

    hl.bind("escape", function()
        unmark_resize()
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind(main_mod .. " + R", function()
        unmark_resize()
        hl.dispatch(hl.dsp.submap("reset"))
    end)

end)

-- Keybinds further down will be global again...
