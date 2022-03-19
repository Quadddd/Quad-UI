--[[
    bad ui lib
    
    -> Quadromatic!#8992
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local screenGui = CoreGui:FindFirstChild("loglizzy-UILib-edit") or Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Name = "loglizzy-UILib-edit"
screenGui.Parent = CoreGui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)

local roundedCorner = Instance.new("UICorner")
roundedCorner.CornerRadius = UDim.new(0, 25)


local squareConstraint = Instance.new("UIAspectRatioConstraint")
squareConstraint.AspectRatio = 1
squareConstraint.DominantAxis = Enum.DominantAxis.Width
squareConstraint.AspectType = Enum.AspectType.ScaleWithParentSize

local syn = syn
local library = {}

local colors = {
	FadedRed = Color3.fromRGB(255, 100, 100),
	FadedGreen = Color3.fromRGB(100, 255, 100)
}

local toggle_colors = {
	[true] = colors.FadedGreen,
	[false] = colors.FadedRed
}

local window = {}
window.__index = window

function window.new(windowTitle, intialPosition)
	local self = {}

	local frame = Instance.new("Frame")
	local title = Instance.new("TextLabel")
	local close = Instance.new("TextButton")
	local scroll = Instance.new("ScrollingFrame")
	local wrapper = Instance.new("Frame")
	local listLayout = Instance.new("UIListLayout")

	frame.Parent = screenGui
	do -- properties
		frame.Size = UDim2.new(0.1875, 0, .35, 0)
		frame.Position = intialPosition or UDim2.new(.25, 0, .25, 0)

		frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		frame.Selectable = true
		frame.Active = true
		frame.Draggable = true

		roundedCorner:Clone().Parent = frame
	end

	title.Parent = frame
	do
		title.Size = UDim2.new(1, 0, .125, 0)
		title.Text = windowTitle
		title.TextScaled = true
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.FredokaOne
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	scroll.Parent = frame
	do
		scroll.Size = UDim2.new(.95, 0, .85, 0)
		scroll.Position = UDim2.new(.025, 0, .125, 0)
		scroll.BackgroundColor3 = Color3.fromRGB(0,0,0)
		scroll.BackgroundTransparency = 1
		scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
		scroll.BorderSizePixel = 0
	end

	wrapper.Parent = scroll
	do
		wrapper.Size = UDim2.new(1, 0, 1, 0)
		wrapper.SizeConstraint = Enum.SizeConstraint.RelativeXX
		wrapper.BackgroundTransparency = 1
		
		roundedCorner:Clone().Parent = wrapper
	end

	listLayout.Parent = wrapper
	do
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.Padding = UDim.new(.0625, 0)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	end
	close.Parent = frame
	do
		close.Size = UDim2.new(.0625, 0, .0625, 0)
		close.AnchorPoint = Vector2.new(1, 0)
		close.Position = UDim2.new(.965, 0, .025, 0)
		close.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		close.Text = ""

		circleCorner:Clone().Parent = close
		squareConstraint:Clone().Parent = close

		close.MouseButton1Click:Connect(function()
			self:Close()
		end)
	end



	self.main = frame
	self.wrapper = wrapper
	return setmetatable(self, window)
end

function window:Close()
	self.main:Destroy()

	if #screenGui:GetChildren() == 0 then
		screenGui:Destroy()
	end
end

-- AddToggle(<string> text, <boolean> initialState, <function> callback)
-- Callback Params -> <boolean> enabled
function window:AddToggle(text, initialState, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(.85, 0, .125, 0)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(.75, 0, 1, 0)
	label.TextScaled = true
	label.Text = text
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Parent = frame

	local enabled = initialState

	local button = Instance.new("TextButton")
	button.Parent = frame
	button.Size = UDim2.new(.125,0,.25,0)
	button.AnchorPoint = Vector2.new(.5, .5)
	button.Position = UDim2.new(.875, 0, .5, 0)
	button.BackgroundColor3 = toggle_colors[initialState]
	button.Text = ""

	squareConstraint:Clone().Parent = button
	roundedCorner:Clone().Parent = button

	button.MouseButton1Click:Connect(function()
		enabled = not enabled

		local success, err = pcall(callback, enabled)
		if not success then
			print("Error running callback for " .. text .. " toggle button.", err)
			return
		end

		button.BackgroundColor3 = toggle_colors[enabled]
	end)

	frame.Parent = self.wrapper
	return frame
end

-- AddSelection(<table> options, <function> callback)
-- Callback Params -> <string> option
function window:AddSelection(options, callback)
	local rows = math.ceil(#options / 3) + 1

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(.85, 0, rows * .125, 0)
	frame.BackgroundTransparency = 1

	local grid = Instance.new("UIGridLayout")
	grid.CellPadding = UDim2.new(.075, 0, .075, 0)
	grid.CellSize = UDim2.new(.25, 0, frame.Size.Y.Scale / (rows - .075), 0)
	grid.SortOrder = Enum.SortOrder.LayoutOrder
	grid.FillDirectionMaxCells = 3
	grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	grid.Parent = frame

	squareConstraint:Clone().Parent = grid

	local selectedButton

	for _, option in pairs(options) do
		local text = option.Text or "?"

		local button = Instance.new("TextButton")
		button.Text = text
		button.TextScaled = true
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Font = Enum.Font.FredokaOne
		button.BackgroundColor3 = Color3.fromRGB(0,0,0)
		button.BorderSizePixel = 0
		button.BackgroundTransparency = .5

		roundedCorner:Clone().Parent = button

		button.MouseButton1Click:Connect(function()
			local success, err = pcall(callback, text)
			if not success then
				print("Error running callback for " .. text .. " toggle button.", err)
				return
			end

			if selectedButton then
				selectedButton.BackgroundTransparency = .5
			end

			selectedButton = button
			button.BackgroundTransparency = .75
		end)

		button.Parent = frame
	end

	frame.Parent = self.wrapper
	return frame
end

-- AddLabel(<string> text)
-- Callback Params -> <string> option
function window:AddLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.85, 0, 0.0625, 0)
	label.BackgroundTransparency = 1

	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = text



	label.Parent = self.wrapper
	return label
end


function window:AddTextBox(labelText: string, callback)
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.85, 0, .125, 0)
	textBox.BackgroundTransparency = .5
	textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textBox.ClearTextOnFocus = false
	textBox.PlaceholderText = ""
	
	textBox.TextScaled = true
	textBox.TextColor3 = Color3.fromRGB(255,255,255)
	textBox.Font = Enum.Font.FredokaOne
	textBox.Text = ""
	
	roundedCorner:Clone().Parent = textBox

	local label = Instance.new("TextLabel")
	label.Text = labelText
	label.BackgroundTransparency = 1

	label.Size = UDim2.new(.5, 0, .5, 0)
    label.Position = UDim2.new(0, 0, .75, 0)
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.FredokaOne

	roundedCorner:Clone().Parent = label
	
	
	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local success, err = pcall(callback, textBox.Text)
			if not success then
				print("Error running callback for " .. labelText .. " text box.", err)
				return
			end
		end
	end)
	label.Parent = textBox
	textBox.Parent = self.wrapper

	return textBox
end

function library:NewWindow(windowTitle, initialPosition)
	local _window = window.new(windowTitle, initialPosition)

	if (syn ~= nil) then
		syn.protect_gui(screenGui)
	end
	screenGui.Parent = CoreGui
	return _window
end

return library
