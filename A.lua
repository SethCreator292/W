-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local GiveSwordEvent = ReplicatedStorage:WaitForChild("GiveSwordEvent")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwordGiverGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Name = "SwordGiverFrame"
Frame.Parent = ScreenGui
Frame.Active = true
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.061, 0, 0.093, 0)
Frame.Size = UDim2.new(0, 230, 0, 100)

local corner1 = Instance.new("UICorner", Frame)
corner1.CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = Frame
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🗡️ Sword Giver"
TitleLabel.TextSize = 16

local labelCorner = Instance.new("UICorner", TitleLabel)
labelCorner.CornerRadius = UDim.new(0, 8)

local GetSwordButton = Instance.new("TextButton")
GetSwordButton.Name = "GetSwordButton"
GetSwordButton.Parent = Frame
GetSwordButton.BorderSizePixel = 0
GetSwordButton.Position = UDim2.new(0.5, -75, 0.5, -10)
GetSwordButton.Size = UDim2.new(0, 150, 0, 40)
GetSwordButton.Font = Enum.Font.Gotham
GetSwordButton.Text = "Get Sword"
GetSwordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetSwordButton.TextSize = 18

local buttonCorner = Instance.new("UICorner", GetSwordButton)
buttonCorner.CornerRadius = UDim.new(0, 8)

local ThemeToggle = Instance.new("TextButton")
ThemeToggle.Name = "ThemeToggle"
ThemeToggle.Parent = Frame
ThemeToggle.BorderSizePixel = 0
ThemeToggle.Position = UDim2.new(1, -28, 0, 2)
ThemeToggle.Size = UDim2.new(0, 24, 0, 24)
ThemeToggle.Font = Enum.Font.Gotham
ThemeToggle.TextSize = 12

local toggleCorner = Instance.new("UICorner", ThemeToggle)
toggleCorner.CornerRadius = UDim.new(1, 0)

-- Variables
local isDarkMode = true

-- Functions
local function applyTheme()
	if isDarkMode then
		Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		GetSwordButton.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
		ThemeToggle.Text = "🌙"
		ThemeToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	else
		Frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		TitleLabel.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		TitleLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
		GetSwordButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		ThemeToggle.Text = "☀️"
		ThemeToggle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	end
end

-- Draggable functionality
local dragToggle, dragStart, startPos = false, Vector2.new(0, 0), UDim2.new(0, 0, 0, 0)
local dragSpeed = 0.1

local function updateInput(input)
	local delta = input.Position - dragStart
	local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(Frame, TweenInfo.new(dragSpeed), {Position = newPosition}):Play()
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
		dragToggle = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragToggle then
			updateInput(input)
		end
	end
end)

-- Connect events
ThemeToggle.MouseButton1Click:Connect(function()
	isDarkMode = not isDarkMode
	applyTheme()
end)

GetSwordButton.MouseButton1Click:Connect(function()
	-- Tell the server to give the sword
	if not Player.Backpack:FindFirstChild("Kill Sword") and not Player.Character:FindFirstChild("Kill Sword") then
		GiveSwordEvent:FireServer()
	end
end)

-- Initial setup
applyTheme()
