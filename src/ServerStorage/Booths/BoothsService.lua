local DonationModule = require(game.ReplicatedStorage.Source.DonationModule)
local BoothService = {
	ClaimedBooths = {},
	Debounce = {},
}

function BoothService.IsEquipped(Player)
	return BoothService.ClaimedBooths[Player.UserId] ~= nil
end

function BoothService.Equipbuttons(Player, Booth)
	local gamepasses = DonationModule.GetGamePasses(Player.UserId)
	for _, gamepass in ipairs(gamepasses) do
		local button = game.ReplicatedStorage.Template:Clone()
		button.Text = gamepass.Price
		button.Name = gamepass.Price
		button:SetAttribute("ID", gamepass.Id)
		button.Parent = Booth.PrimaryPart.SurfaceGui.ScrollingFrame
	end
end

function BoothService.EquipBooth(Player, Booth)
	if BoothService.Debounce[Player.UserId] then
		return
	end
	BoothService.Debounce[Player.UserId] = true
	Booth.PrimaryPart.Attachment.ProximityPrompt.Enabled = false
	BoothService.ClaimedBooths[Player.UserId] = Booth
	game.ReplicatedStorage.RemoteEvents.EquipBooth:FireClient(Player, Booth.Name)
	BoothService.Equipbuttons(Player, Booth)
	BoothService.Debounce[Player.UserId] = nil
end

function BoothService.UnequipBooth(Player)
	if BoothService.Debounce[Player.UserId] then
		return
	end
	BoothService.Debounce[Player.UserId] = true
	for _, button in
		ipairs(BoothService.ClaimedBooths[Player.UserId].PrimaryPart.SurfaceGui.ScrollingFrame:GetChildren())
	do
		if button:IsA("TextButton") then
			button:Destroy()
		end
	end
	BoothService.ClaimedBooths[Player.UserId].PrimaryPart.Attachment.ProximityPrompt.Enabled = true
	BoothService.ClaimedBooths[Player.UserId] = nil
	game.ReplicatedStorage.RemoteEvents.UnequipBooth:FireClient(Player)
	BoothService.Debounce[Player.UserId] = nil
end

return BoothService
