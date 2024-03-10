game.ReplicatedFirst:RemoveDefaultLoadingScreen()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local LoadingScreenGui = Instance.new("ScreenGui")
LoadingScreenGui.Name = "Loading"
LoadingScreenGui.IgnoreGuiInset = true
LoadingScreenGui.DisplayOrder = math.huge
LoadingScreenGui.ResetOnSpawn = false
LoadingScreenGui.Parent = PlayerGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.fromScale(1, 1)
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Text = "Loading"
TextLabel.TextSize = 32
TextLabel.FontFace = Font.fromEnum(Enum.Font.FredokaOne)
TextLabel.Parent = LoadingScreenGui

task.wait(3)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

LoadingScreenGui:Destroy()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
