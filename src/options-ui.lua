local addon = select(2, ...)
local plugin = addon.plugin

local Details = addon.Details
local Framework = addon.DetailsFramework

-- Frames --
local window_frame = nil
local content_frame = nil
local scroll_frame = nil
local generated_for_instances = 0

-- Constants --
local WINDOW_WIDTH = 300
local WINDOW_HEIGHT = 450

local WIDGET_WIDTH = 148
local WIDGET_HEIGHT = 18

local SCROLLER_X_OFFSET = 2
local SCROLLER_Y_OFFSET = 25
local SCROLLER_WIDTH_OFFSET = 25
local SCROLLER_HEIGHT_OFFSET = 2

-- Helper Functions --
local function AddWidgetsForInstance(menu, id, instance)
	addon.CreateDefaultOptionsForWindow(id)
	local opts = plugin.options.windows[id]

	table.insert(menu,{
		type = "label",
		text = "|cffffcc00Window #"..id
	})

	table.insert(menu, {
		name = "Enabled",
		desc = "If enabled, this window will be attached to a parent frame.",
		type = "toggle",
		get = function() return opts.enabled end,
		set = function (self, fixparam, value)
			opts.enabled = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		name = "Parent Frame",
		desc = "Toggly",
		type = "textentry",
		get = function() return opts.parent end,
		set = function (self, fixparam, value)
			opts.parent = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		type = "blank",
	})

	table.insert(menu, {
		name = "Top Offset",
		desc = "The top offset.",
		type = "range",
		min = -200,
		max = 200,
		step = 1,
		usedecimals = true,
		get = function() return opts.offset_tl_y end,
		set = function (self, fixparam, value)
			opts.offset_tl_y = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		name = "Bottom Offset",
		desc = "The bottom offset.",
		type = "range",
		min = -200,
		max = 200,
		step = 1,
		usedecimals = true,
		get = function() return opts.offset_br_y end,
		set = function (self, fixparam, value)
			opts.offset_br_y = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		name = "Left Offset",
		desc = "The left offset.",
		type = "range",
		min = -200,
		max = 200,
		step = 1,
		usedecimals = true,
		get = function() return opts.offset_tl_x end,
		set = function (self, fixparam, value)
			opts.offset_tl_x = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		name = "Right Offset",
		desc = "The right offset.",
		type = "range",
		min = -200,
		max = 200,
		step = 1,
		usedecimals = true,
		get = function() return opts.offset_br_x end,
		set = function (self, fixparam, value)
			opts.offset_br_x = value
			addon.UpdateInstance(id)
		end
	})

	table.insert(menu, {
		type = "blank",
	})
end

local function CreateOptionsMenu()
	local menu = {}
	menu.always_boxfirst = true
	menu.widget_width = WIDGET_WIDTH
	menu.widget_height = WIDGET_HEIGHT
	menu.align_as_pairs = true
	menu.align_as_pairs_string_space = 120
	menu.slider_buttons_to_left = true
	menu.use_scrollframe = true

	-- Add menu widgets for every window.
	for i = 1, Details:GetNumInstancesAmount() do
		AddWidgetsForInstance(menu, i, Details:GetInstance(i))
	end

	return menu
end

local function CreateOptionsFrame()
	window_frame = plugin:CreatePluginOptionsFrame(
        "FrameDockerOptionsWindow", "Frame Docker Options", 1
    )

	local width = WINDOW_WIDTH - SCROLLER_WIDTH_OFFSET - SCROLLER_X_OFFSET

	-- Create the content frame.
	content_frame = CreateFrame("frame", "FrameDockerOptionsWindowContents")
	content_frame:SetSize(width, WINDOW_HEIGHT)

	-- Allow the content frame to be used as an options panel.
	DetailsFramework:SetAsOptionsPanel(content_frame)

	-- Create the scroll frame.
	scroll_frame = DetailsFramework:CreateCanvasScrollBox(window_frame, content_frame)
	scroll_frame:SetPoint("TOPLEFT", window_frame, "TOPLEFT", SCROLLER_X_OFFSET, -SCROLLER_Y_OFFSET)
	scroll_frame:SetSize(
		width,
		WINDOW_HEIGHT - SCROLLER_Y_OFFSET - SCROLLER_HEIGHT_OFFSET
	)

end


local function UpdateOptionsFrame()
	local options_text_template = Framework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = Framework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = Framework:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = Framework:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = Framework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

	Framework:BuildMenuVolatile(
		scroll_frame,
		CreateOptionsMenu(),
		4,           -- xOffset
		-2,          -- yOffset
		est_height,  -- height
		false,       -- useColon
		options_text_template,
		options_dropdown_template,
		options_switch_template,
		true, -- switchIsCheckbox
		options_slider_template,
		options_button_template
	)

	window_frame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
end

plugin.OpenOptionsPanel = function()
	if window_frame == nil then
		CreateOptionsFrame()
	end

    if generated_for_instances ~= Details:GetNumInstancesAmount() then
		UpdateOptionsFrame()
    end

	-- Show the options frame.
	window_frame:Show()
end
