-- LocalScript: Put this inside your "Get Sword" TextButton in StarterGui

local button = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local giveSwordEvent = ReplicatedStorage:WaitForChild("GiveSwordEvent")

button.MouseButton1Click:Connect(function()
    giveSwordEvent:FireServer() -- Sends request to server
end)
