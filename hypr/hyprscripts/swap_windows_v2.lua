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
local notification_on_time = 2000

-- Set rules to highlighted selected windows
hl.window_rule({
    match = { tag = "marked_for_swap" },
    border_color = "rgb(AEFF00) rgb(AEFF00)",
    border_size = 2,
})

-- Mark window to swap
hl.bind(main_mod .. " + m", function()
    if not window_to_swap then
        local win = hl.get_active_window()
        if win and win.address then
            window_to_swap = win.address
            hl.dispatch(hl.dsp.window.tag({ tag = "+marked_for_swap", window = "address:" .. window_to_swap }))
            hl.notification.create({ text = "marked_for_swap:\n" .. window_to_swap, timeout = notification_on_time })
            -- hl.exec_cmd("notify-send -t 2000 'Swap Windows' 'Window markded: '" .. win.address)
        else
            hl.notification.create({ text = "Window or address not found", timeout = notification_on_time })
        end
    else
        hl.dispatch(hl.dsp.window.swap({ target = "address:" .. window_to_swap }))
        hl.dispatch(hl.dsp.focus({ window = "address:" .. window_to_swap }))
        hl.dispatch(hl.dsp.window.tag({ tag = "-marked_for_swap", window = "address:" .. window_to_swap }))
        hl.notification.create({ text = "Swapped:\n" .. window_to_swap, timeout = notification_on_time })
        window_to_swap = nil
    end
end)

-- Handle marked_for_swap windows being closer
hl.on("window.close", function(win)
    if win and win.address == window_to_swap then
        window_to_swap = nil
        hl.notification.create({ text = "Mark cleared (window closed)", timeout = notification_on_time })
    end
end)
