-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- RemoteEvent
local GiveSwordEvent = ReplicatedStorage:WaitForChild("GiveSwordEvent")

-- Function to create and give the sword
local function giveKillSword(player)
    local killPartTool = Instance.new("Tool")
    killPartTool.Name = "Kill Sword"
    killPartTool.Grip = CFrame.new(0, -1, 0)
    killPartTool.RequiresHandle = true

    -- Create the sword handle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 3, 0.5)
    handle.BrickColor = BrickColor.new("Dark stone grey")
    handle.Transparency = 0
    handle.CanCollide = false
    handle.Massless = true

    -- Create the blade
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.5, 4, 0.5)
    blade.Position = Vector3.new(0, 3.5, 0)
    blade.BrickColor = BrickColor.new("Light steel blue")
    blade.Material = Enum.Material.Metal
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = handle

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.Parent = handle

    handle.Parent = killPartTool

    -- Kill part functionality
    local debounce = false
    killPartTool.Activated:Connect(function()
        if not killPartTool.Parent or not killPartTool.Parent:IsA("Model") or debounce then return end
        debounce = true
        
        local character = killPartTool.Parent
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local killPart = Instance.new("Part")
        killPart.CanCollide = false
        killPart.Anchored = false
        killPart.Size = Vector3.new(5, 5, 5)
        killPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
        killPart.Parent = workspace
        killPart.Material = Enum.Material.Neon
        killPart.Color = Color3.fromRGB(255, 0, 0)
        killPart.Transparency = 0.5
        killPart.Massless = true
        
        Debris:AddItem(killPart, 0.2)

        local hitConnection
        hitConnection = killPart.Touched:Connect(function(hit)
            if not hit or not hit.Parent then return end
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Parent ~= character then
                humanoid.Health = 0
            end
        end)

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
        TweenService:Create(killPart, tweenInfo, {Transparency = 1}):Play()
        
        task.delay(0.2, function()
            if hitConnection then
                hitConnection:Disconnect()
            end
        end)

        task.wait(0.5)
        debounce = false
    end)
    
    killPartTool.Parent = player.Backpack
end

-- Listen for the RemoteEvent and give the sword
GiveSwordEvent.OnServerEvent:Connect(function(player)
    -- Check if the player already has the sword to prevent spamming
    if not player.Backpack:FindFirstChild("Kill Sword") and not player.Character:FindFirstChild("Kill Sword") then
        giveKillSword(player)
    end
end)
