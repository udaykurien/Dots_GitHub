-- Swap windows
---------------
--[[
Updates from version 1:
1. Uses a single key bind to mark and swap windows.
2. Marked windows can be swapped with itself, thereby cancelling its marking.
--]]

local cfg = require("config")
local main_mod = cfg.main_mod

local window_to_swap = nil
local win = nil
local notification_on_time = 4000
local border_color = "rgb(AEFF00)"

-- Set rules to highlighted selected windows
hl.window_rule({
    match = { tag = "marked_for_swap" },
    border_color = border_color .. " " .. border_color,
    border_size = 2,
})

-- Switch to submap called swap
hl.bind(main_mod .. " + S", function()
    win = hl.get_active_window()
    if not win or not win.address then
        hl.notification.create({ text = "Swap submap not activated.", timeout = notification_on_time, color = border_color })
        return
    end
    window_to_swap = win.address
    hl.dispatch(hl.dsp.window.tag({ tag = "+marked_for_swap", window = "address:" .. window_to_swap }))
    hl.notification.create({ text = "Swap submap active on: " .. win.address, timeout = notification_on_time, color = border_color })
    hl.dispatch(hl.dsp.submap("swap"))
end)

-- Start swap submap
hl.define_submap("swap", function()
    hl.bind(cfg.ws_prev, hl.dsp.focus({ workspace = "-1" }))
    hl.bind(cfg.ws_next, hl.dsp.focus({ workspace = "+1" }))

    hl.bind(cfg.focus_left,  hl.dsp.focus({ direction = "left" }))
    hl.bind(cfg.focus_right, hl.dsp.focus({ direction = "right" }))
    hl.bind(cfg.focus_up,    hl.dsp.focus({ direction = "up" }))
    hl.bind(cfg.focus_down,  hl.dsp.focus({ direction = "down" }))
--
    hl.bind(main_mod .. " + S", function()
        hl.dispatch(hl.dsp.window.swap({ target = "address:" .. window_to_swap }))
        hl.dispatch(hl.dsp.focus({ window = "address:" .. window_to_swap }))
        hl.dispatch(hl.dsp.window.tag({ tag = "-marked_for_swap", window = "address:" .. window_to_swap }))
        hl.notification.create({ text = "Swapped:\n" .. window_to_swap, timeout = notification_on_time, color = border_color })
        window_to_swap = nil
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    
    hl.bind("escape", function()
        hl.dispatch(hl.dsp.window.tag({ tag = "-marked_for_swap", window = "address:" .. window_to_swap }))
        hl.notification.create({ text = "Swap submap deactivated\n" .. window_to_swap, timeout = notification_on_time, color = border_color })
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    
end)

-- -- Handle marked_for_swap windows being closed
-- hl.on("window.close", function(win)
--     if win and win.address == window_to_swap then
--         window_to_swap = nil
--         hl.notification.create({ text = "Mark cleared (window closed)", timeout = notification_on_time, color = border_color })
--     end
-- end)
