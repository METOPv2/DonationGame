local RunService = game:GetService("RunService")
local PlayerDataService = require(game.ServerStorage.Source.PlayerData.PlayerDataService)
local buildings = require(game.ServerStorage.Source.Buildings.Buildings)

game.Players.PlayerAdded:Connect(function(player)
	local playerData = PlayerDataService:GetPlayerDataFromDataStore(player.UserId)
	playerData = PlayerDataService:InitPlayerData(playerData)
	PlayerDataService:LoadPlayerDataToServer(player.UserId, playerData)
	buildings[player.UserId] = playerData:get("Buildings")

	local Leaderstats = PlayerDataService:InitLeaderstatsByPlayerData(playerData)
	Leaderstats.Parent = player

	if not RunService:IsStudio() then
		playerData:increment("Visits", 1)
	end

	player:SetAttribute("PlayTime", workspace:GetServerTimeNow() - playerData.PlayTime)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local playerData = PlayerDataService:GetPlayerDataFromServer(player.UserId)
	playerData:set("PlayTime", workspace:GetServerTimeNow() - player:GetAttribute("PlayTime"))
	playerData:set("Buildings", buildings[player.UserId] or {})
	PlayerDataService:SavePlayerDataToDataStore(player.UserId, playerData)
	PlayerDataService:UnloadPlayerDataFromServer(player.UserId)
end)
