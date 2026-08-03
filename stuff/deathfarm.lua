-- some of this is forked from nullfire's death farm, go check them out https://github.com/TeamNullFire/NullFire

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

local q = queue_on_teleport or queueonteleport
local script = [=[
loadstring(game:HttpGet("https://raw.githubusercontent.com/doram44/cheesy/refs/heads/main/stuff/deathfarm.lua"))()
]=]

local smith = game:GetService("Players")
local smith2 = game:GetService("ReplicatedStorage")
local smith3 = smith.LocalPlayer
local smith4 = smith2:WaitForChild("RemotesFolder")
local smith5 = workspace:WaitForChild("CurrentRooms", 9e9)

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

local floor = GetFloor()
print("[deathfarm] current floor:", floor)
if floor ~= "Hotel" then
    SendCaption("Use this script in the hotel floor for it to work")
    print("[deathfarm] wrong floor, stopping")
    return
end

if #smith5:GetChildren() > 1 or smith3.Character then
    SendCaption("Run already started, joining a new run...")
    q(script)
    smith4.PlayAgain:FireServer()
    return
end

local function WaitWithCheck(obj, name, timeout)
    timeout = timeout or 15
    local child = obj:WaitForChild(name, timeout)
    if not child then
        print(string.format("[deathfarm] STALLED: '%s' missing on %s after %.1fs", tostring(name), tostring(obj:GetFullName()), timeout))
    end
    return child
end

local room0 = WaitWithCheck(smith5, "0")
if not room0 then return end
local smith6 = WaitWithCheck(smith3.PlayerGui, "MainUI")
if not smith6 then return end
smith6 = smith6:WaitForChild("ItemShop", 10)
if not smith6 then
    print("[deathfarm] STALLED: ItemShop missing in MainUI after 10s")
    return
end

repeat task.wait() until smith6.Visible
if not smith6 or not smith6.Visible then
    print("[deathfarm] ItemShop never became visible, restarting")
    smith4.PlayAgain:FireServer()
    q(script)
    return
end
if smith6 then smith6.Visible = false end

local key = WaitWithCheck(room0, "Assets")
if not key then return end
key = WaitWithCheck(key, "KeyObtain")
if not key then return end
local hitbox = WaitWithCheck(key, "Hitbox")
if not hitbox then return end

print("[deathfarm] moving to key hitbox")
smith3.Character:PivotTo(hitbox:GetPivot())
repeat
    task.wait()
    smith3.Character:PivotTo(hitbox:GetPivot())
until smith3.Character:FindFirstChild("Key")

local smith7 = WaitWithCheck(room0, "Door")
if not smith7 then return end
local smith8 = WaitWithCheck(smith7, "Hidden")
if not smith8 then return end
local lock = WaitWithCheck(smith7, "Lock")
if not lock then return end
local smith9 = WaitWithCheck(lock, "UnlockPrompt")
if not smith9 then return end
local smith10 = smith2.GameData and smith2.GameData:FindFirstChild("LatestRoom")
if not smith10 then
    print("[deathfarm] STALLED: no GameData.LatestRoom found")
    return
end

print("[deathfarm] using key on hidden door")
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
