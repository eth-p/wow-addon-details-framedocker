local addon = select(2, ...)
local plugin = addon.plugin

local Details = addon.Details

-- Initialize saved variables. --
addon:WhenReady(function()
	plugin.options.windows = plugin.options.windows or {}

	for i = 1, Details:GetNumInstancesAmount() do
		addon.CreateDefaultOptionsForWindow(i)
	end
end)

function addon.CreateDefaultOptionsForWindow(id)
	if plugin.options.windows[id] ~= nil then
		return
	end

	plugin.options.windows[id] = {
		enabled = false,
		parent = "",
		offset_tl_x = 0,
		offset_tl_y = 0,
		offset_br_x = 0,
		offset_br_y = 0,
	}
end
