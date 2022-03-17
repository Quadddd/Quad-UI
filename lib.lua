local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local screenGui = CoreGui:FindFirstChild("loglizzy-UILib-edit") or Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)

local roundedCorner = Instance.new("UICorner")
roundedCorner.CornerRadius = UDim.new(.125, 0)

local squareConstraint = Instance.new("UIAspectRatioConstraint")
squareConstraint.AspectRatio = 1

local syn = nil
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
		frame.Position = intialPosition
		
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
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.FredokaOne
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	
	scroll.Parent = frame
	do
		scroll.Size = UDim2.new(.95, 0, .875, 0)
		scroll.Position = UDim2.new(.025, 0, .125, 0)
		scroll.BackgroundTransparency = 1
	end
	
	wrapper.Parent = scroll
	do
		wrapper.Size = UDim2.new(1, 0, 1, 0)
		wrapper.SizeConstraint = Enum.SizeConstraint.RelativeXX
		wrapper.BackgroundTransparency = 1
	end
	
	close.Parent = frame
	do
		close.Size = UDim2.new(.0625, 0, .0625, 0)
		close.AnchorPoint = Vector2.new(1, 0)
		close.Position = UDim2.new(1, 0, 0, 0)
		close.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		
		circleCorner:Clone().Parent = close
	end
	
	self.main = frame
	self.wrapper = wrapper
	return setmetatable(self, window)
end

-- AddToggle(<string> title, <boolean> initialState, <function> callback)
-- Callback Params -> <boolean> enabled
function window:AddToggle(title, initialState, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, .25, 0)
	frame.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(.75, 0, 1, 0)
	label.Text = title
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Parent = frame
	
	local enabled = initialState
	
	local button = Instance.new("TextButton")
	button.Parent = frame
	button.Size = UDim2.new()
	button.AnchorPoint = Vector2.new(.5, .5)
	button.Position = UDim2.new(.875, 0, .5, 0)
	button.BackgroundColor3 = toggle_colors[initialState]
	
	squareConstraint:Clone().Parent = button
	roundedCorner:Clone().Parent = button
	
	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		
		local success, err = pcall(callback, enabled)
		if not success then
			print("Error running callback for " .. title .. " toggle button.", err)'
			return
		end
		
		button.BackgroundColor3 = toggle_colors[initialState]
	end)
	
	frame.Parent = self.wrapper
	return frame
end

-- AddSelection(<table> options, <function> callback)
-- Callback Params -> <string> option
function window:AddSelection(options, callback)
	
end




function library:NewWindow(title)
	
	local _window = window.new()

	if (syn ~= nil) then
		print("syn::protect_gui > window")
		syn.protect_gui(screenGui) -- Synapse function makes the ui object undetectable for any non synapse script
	end
	screenGui.Parent = CoreGui
	return _window
end

return library
