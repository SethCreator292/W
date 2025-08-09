local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Create RemoteEvent if missing
local giveSwordEvent = ReplicatedStorage:FindFirstChild("GiveSwordEvent") 
    or Instance.new("RemoteEvent", ReplicatedStorage)
giveSwordEvent.Name = "GiveSwordEvent"

-- Create LocalScript in StarterPlayerScripts for GUI creation
local starterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")
if starterPlayerScripts and not starterPlayerScripts:FindFirstChild("SwordGuiCreator") then
    local guiLocalScript = Instance.new("LocalScript")
    guiLocalScript.Name = "SwordGuiCreator"
    guiLocalScript.Source = [[
        local player = game.Players.LocalPlayer

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SwordGiverGui"

        local button = Instance.new("TextButton")
        button.Name = "GetSwordButton"
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0.5, -100, 0.7, 0)
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.SourceSansBold
        button.Text = "Get Sword"
        button.Parent = screenGui

        screenGui.Parent = player:WaitForChild("PlayerGui")

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local giveSwordEvent = ReplicatedStorage:WaitForChild("GiveSwordEvent")

        button.MouseButton1Click:Connect(function()
            giveSwordEvent:FireServer()
        end)
    ]]
    guiLocalScript.Parent = starterPlayerScripts
end

-- Create ServerScript handling GiveSword
if not ServerScriptService:FindFirstChild("KillSwordServer") then
    local serverScript = Instance.new("Script")
    serverScript.Name = "KillSwordServer"
    serverScript.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Debris = game:GetService("Debris")
        local TweenService = game:GetService("TweenService")

        local GiveSwordEvent = ReplicatedStorage:WaitForChild("GiveSwordEvent")

        local function giveKillSword(player)
            local killPartTool = Instance.new("Tool")
            killPartTool.Name = "Kill Sword"
            killPartTool.Grip = CFrame.new(0, -1, 0)
            killPartTool.RequiresHandle = true

            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(0.5, 3, 0.5)
            handle.BrickColor = BrickColor.new("Dark stone grey")
            handle.CanCollide = false
            handle.Massless = true

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

        GiveSwordEvent.OnServerEvent:Connect(function(player)
            if not player.Backpack:FindFirstChild("Kill Sword") and not player.Character:FindFirstChild("Kill Sword") then
                giveKillSword(player)
            end
        end)
    ]]
    serverScript.Parent = ServerScriptService
end

print("✅ Installer ran: GUI will appear instantly for players; sword giving logic set up.")
