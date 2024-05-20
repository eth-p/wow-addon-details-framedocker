local addon = select(2, ...)
addon.Details = _G.Details
addon.DetailsFramework = _G.DetailsFramework

-- Create the plugin.
local plugin = Details:NewPluginObject ("Details_FrameDocker")
plugin:SetPluginDescription("Attach windows to arbitrary UI frames.")
addon.plugin = plugin

-- Create the plugin.
local readyCallbacks = {}
function addon:WhenReady(callback)
	table.insert(readyCallbacks, callback)
end

-- Wait to install the plugin.
local function InstallPlugin()
	local MIN_DETAILS_VERSION = 1

	local install, savedvars = _G.Details:InstallPlugin(
		"TOOLBAR",
		"Frame Docker",
		[[\NoTexture]],
		plugin,
		"DETAILS_PLUGIN_FRAME_DOCKER",
		MIN_DETAILS_VERSION,
		"eth-p",
		"v0.1"
	)

	if (type (install) == "table" and install.error) then
		print (install.error)
	end

	-- Initialize.
	plugin.options = savedvars
	for _, callback in pairs(readyCallbacks) do
		callback()
	end

	-- Register events to listen for.
	Details:RegisterEvent(plugin, "DETAILS_STARTED")
	Details:RegisterEvent(plugin, "DETAILS_PROFILE_APPLYED")
end

function plugin:OnEvent(_, event, ...)
	if (event == "ADDON_LOADED") then
		local addonName = select(1, ...)
		if (addonName == "Details_FrameDocker") then
			InstallPlugin()
		end
	end
end

function plugin:OnDetailsEvent(event, ...)
	if event == "DETAILS_STARTED" or event == "DETAILS_PROFILE_APPLYED" then
		addon.UpdateAllInstances()
		return
	end
end
