local ContextActionService = game:GetService("ContextActionService")
local StarterPlayer = game:GetService("StarterPlayer")
local Humanoid = script.Parent.Parent.Humanoid

local function ShiftToRun(name, state)
	if name == "ShiftToRun" then
		if state == Enum.UserInputState.Begin then
			Humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
		else
			Humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
		end
	end
end

ContextActionService:BindAction("ShiftToRun", ShiftToRun, true, Enum.KeyCode.LeftShift)
ContextActionService:SetTitle("ShiftToRun", "Run")
ContextActionService:SetPosition("ShiftToRun", UDim2.new(1, -100, 1, -150))
