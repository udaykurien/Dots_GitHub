-- Cycle layouts
-----------------
-- (https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#cycle-layout-for-current-workspace)

local cfg = require("config")
local main_mod = cfg.main_mod

hl.bind(main_mod .. " + period", function ()
    local layouts     = { "dwindle", "master", "scrolling" }
    local workspace   = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    -- hl.exec_cmd("notify-send -t 5000 'Layout:\n'" .. next_layout)
    hl.notification.create({ text = "Layout:\n" .. next_layout, timeout = 5000 })

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)

-- Master layout binds
hl.bind(main_mod .. " + return", hl.dsp.layout("swapwithmaster"))

