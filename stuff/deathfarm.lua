-- some of this is forked from nullfire's death farm, go check them out https://github.com/TeamNullFire/NullFire

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

local q = queue_on_teleport or queueonteleport
local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/doram44/cheesy/refs/heads/main/stuff/deathfarm.lua"))()


local smith = game:GetService("Players")
local smith2 = game:GetService("ReplicatedStorage")
local smith3 = smith.LocalPlayer
local smith4 = smith2:WaitForChild("RemotesFolder")

local function SendCaption(Text)
    if firesignal then
        firesignal(smith4.Caption.OnClientEvent, Text)
    else
        if smith4:FindFirstChild("CaptionClient") then
            smith4.CaptionClient:Fire(Text)
        end
    end
end

local function GetFloor()
    if workspace:FindFirstChild("Lobby") then
        return "Lobby"
    end
    local gd = smith2:FindFirstChild("GameData")
    if not gd then
        return "Lobby"
    end
    local fv = gd:FindFirstChild("Floor")
    if not fv then
        return "Lobby"
    end
    local val = tostring(fv.Value)
    if val == "" then
        return "Lobby"
    end
    if val == "Hotel" and smith2:FindFirstChild("Bricks") then
        return "OldHotel"
    end
    return val
end

if GetFloor() ~= "Hotel" then
    SendCaption("Use this script in the hotel floor for it to work")
    return
end

local smith5 = workspace:WaitForChild("CurrentRooms", 9e9):WaitForChild("0", 9e9)
local smith6 = smith3.PlayerGui:WaitForChild("MainUI", 9e9):WaitForChild("ItemShop", 10)
local smith7 = smith5:WaitForChild("Door", 9e9)
local smith8 = smith7:WaitForChild("Hidden", 9e9)
local smith9 = smith7:WaitForChild("Lock", 9e9):WaitForChild("UnlockPrompt", 9e9)
local smith10 = smith2.GameData.LatestRoom

-- Fixed: Checked visibility directly without hanging the thread
if not smith6 or not smith6.Visible then 
    smith4.PlayAgain:FireServer()
    q(script)
    return 
end

smith6.Visible = false

local key = smith5:WaitForChild("Assets", 9e9):WaitForChild("KeyObtain", 9e9)
local hitbox = key:WaitForChild("Hitbox", 9e9)

smith3.Character:PivotTo(hitbox:GetPivot())
repeat 
    task.wait()
    smith3.Character:PivotTo(hitbox:GetPivot())
until smith3.Character:FindFirstChild("Key")

repeat
    smith3.Character:PivotTo(smith8:GetPivot())
    smith9.HoldDuration = 0
    fireproximityprompt(smith9)
    task.wait()
until smith10.Value ~= 0

if replicatesignal then
    replicatesignal(smith3.Kill)
else
    smith4.Underwater:FireServer(true)
end

smith3:GetAttributeChangedSignal("Alive"):Wait()

smith4.PlayAgain:FireServer()
q(script)
