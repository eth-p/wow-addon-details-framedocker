local addon = select(2, ...)
local plugin = addon.plugin

local Details = addon.Details

-- Helper Functions --
local function HookInstance(id, instance)
	instance._hooked_by_framedocker = true
	instance._framedocker_real_parent = instance.baseframe:GetParent()
	instance._framedocker_was_locked = false
	instance._framedocker_docked = false
end

local function GetParent(name)
	if name == "" then return nil end

	local parent = _G[name]
	if parent == nil then return nil end
	if parent.GetObjectType == nil then return nil end
	return parent
end

-- Docking Functions --
local function DoUndock(instance, frame)
	frame:SetParent(instance._framedocker_real_parent)

	-- Show resize handles. --
	frame.resize_esquerda:Show()
	frame.resize_direita:Show()
	frame.lock_button:Show()

	-- Reset window locked state. --
	instance.isLocked = instance._framedocker_was_locked
	frame.isLocked = instance._framedocker_was_locked
	instance:RefreshLockedState()
end

local function DoDock(instance, frame, parent, opts)
	frame:SetParent(parent)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", opts.offset_tl_x, opts.offset_tl_y)
	frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", opts.offset_br_x, opts.offset_br_y)

	-- Hide resize handles. --
	frame.resize_esquerda:Hide()
	frame.resize_direita:Hide()
	frame.lock_button:Hide()

	-- Force window locked state. --
	instance._framedocker_was_locked = instance.isLocked
	instance.isLocked = true
	frame.isLocked = true
	instance:RefreshLockedState()
end

-- Update Functions --
function addon.UpdateInstance(id)
	print("Updating instance "..id)
	local instance = Details:GetInstance(id)
	local frame = instance.baseframe
	local opts = plugin.options.windows[id]

	-- Hook the functions.
	if not instance._hooked_by_framedocker then
		HookInstance(id, instance)
	end

	-- Undock if not enabled.
	if not opts.enabled and instance._framedocker_docked then
		DoUndock(instance, frame)
		instance._framedocker_docked = false
		return
	end

	-- Dock.
	if not instance._framedocker_docked then
		local parent = GetParent(opts.parent)
		if parent ~= nil then
			DoDock(instance, frame, parent, opts)
			instance._framedocker_docked = true
		end
	end
end

function addon.UpdateAllInstances()
	print("Want updating all instances")
	for id = 1, Details:GetNumInstancesAmount() do
		addon.UpdateInstance(id)
	end
end
