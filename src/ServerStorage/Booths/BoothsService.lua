local DonationModule = require(game.ReplicatedStorage.Source.DonationModule)
local PlayerDataService = require(game.ServerStorage.Source.PlayerData.PlayerDataService)
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
	Player:SetAttribute("EquippedPlot", Booth.Name)
	BoothService.Debounce[Player.UserId] = true
	Booth.PrimaryPart.Attachment.ProximityPrompt.Enabled = false
	BoothService.ClaimedBooths[Player.UserId] = Booth
	game.ReplicatedStorage.RemoteEvents.EquipBooth:FireClient(Player, Booth.Name)
	local playerData = PlayerDataService:GetPlayerDataFromServer(Player.UserId)
	for i, building in ipairs(playerData.Buildings) do
		if i % 2 == 0 then
			task.wait()
		end
		game.ReplicatedStorage.RemoteEvents.PlaceBlock:FireAllClients(building)
	end
	BoothService.Equipbuttons(Player, Booth)

	BoothService.Debounce[Player.UserId] = nil
end

function BoothService.UnequipBooth(Player)
	if BoothService.Debounce[Player.UserId] then
		return
	end
	Player:SetAttribute("EquippedPlot", nil)
	local plot = workspace:FindFirstChild("Plot_" .. BoothService.ClaimedBooths[Player.UserId].Name)
	if plot then
		plot:Destroy()
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
	game.ReplicatedStorage.RemoteEvents.UnequipBooth:FireAllClients(Player.UserId)
	BoothService.Debounce[Player.UserId] = nil
end

return BoothService
