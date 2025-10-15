local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Protect GUI if executor supports it
local guiParent = (syn and syn.protect_gui and syn.protect_gui(CoreGui)) or CoreGui

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KuromiX"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Build a Boat For Treasure Script"
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 0, 0)

-- Rainbow text animation
local function RainbowText(obj)
	task.spawn(function()
		while obj and obj.Parent do
			for hue = 0, 1, 0.005 do
				obj.TextColor3 = Color3.fromHSV(hue, 1, 1)
				task.wait(0.05)
			end
		end
	end)
end
RainbowText(Title)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = MainFrame
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.new(1, 0, 0)
RainbowText(CloseButton)

-- Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Parent = MainFrame
MinButton.Size = UDim2.new(0, 40, 0, 40)
MinButton.Position = UDim2.new(1, -90, 0, 0)
MinButton.Text = "_"
MinButton.BackgroundTransparency = 1
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 22
MinButton.TextColor3 = Color3.new(1, 0, 0)
RainbowText(MinButton)

-- Button Container
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = MainFrame
ButtonFrame.Position = UDim2.new(0, 10, 0, 50)
ButtonFrame.Size = UDim2.new(1, -20, 1, -60)
ButtonFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ButtonFrame)
UIListLayout.Padding = UDim.new(0, 8)

local function CreateButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = text
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 0, 0)
	btn.Parent = ButtonFrame
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)
	RainbowText(btn)
	btn.MouseButton1Click:Connect(callback)
end

-- Teleport function
local function tpTo(x, y, z)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(Vector3.new(x, y, z))
	end
end

-- Multi-checkpoint setup
local checkpoints = {
	Vector3.new(-57.13, 67.09, 616.45),    -- Start
	Vector3.new(-47.10, 53.47, 8674.01),   -- Checkpoint 2
	Vector3.new(-49.31, -270.43, 8793.45), -- Checkpoint 3
	Vector3.new(-60.29, -355.07, 9489.90)  -- End
}

local tweening = false
local currentTween = nil
local currentIndex = 2 -- next checkpoint index

-- Function to tween to a single checkpoint
local function tweenToCheckpoint(index)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local root = LocalPlayer.Character.HumanoidRootPart
	if index > #checkpoints then
		tweening = false
		currentIndex = 2
		return
	end
	local goal = {CFrame = CFrame.new(checkpoints[index])}
	currentTween = TweenService:Create(root, TweenInfo.new(25, Enum.EasingStyle.Linear), goal)
	currentTween:Play()
	currentTween.Completed:Connect(function()
		if tweening then
			currentIndex = currentIndex + 1
			tweenToCheckpoint(currentIndex)
		end
	end)
end

-- Toggle function
local function toggleTween()
	if tweening then
		-- Stop tween
		tweening = false
		if currentTween then
			currentTween:Cancel()
		end
	else
		-- Start tweening
		tweening = true
		currentIndex = 2
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(checkpoints[1])
			tweenToCheckpoint(currentIndex)
		end
	end
end

-- Buttons
CreateButton("TP to White Spawn", function() tpTo(-48.89, -8.06, -611.44) end)
CreateButton("TP to Cool Spot", function() tpTo(-740.48, 73.30, 265.03) end)
CreateButton("Autofarm Toggle", toggleTween)
CreateButton("Copy Nucax Github", function()
	if setclipboard then
		setclipboard("https://github.com/nucax")
	end
end)

-- Minimize / Close behavior
local minimized = false
MinButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	ButtonFrame.Visible = not minimized
end)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
