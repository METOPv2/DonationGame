local PlayerDataService = require(game.ServerStorage.Source.PlayerData.PlayerDataService)
local buildings = require(game.ServerStorage.Source.Buildings.Buildings)

game.ReplicatedStorage.RemoteEvents.PlaceBlock.OnServerEvent:Connect(function(player, data)
	buildings[player.UserId] = buildings[player.UserId] or {}
	data.Owner = player.UserId
	table.insert(buildings[player.UserId], data)
	local playerData = PlayerDataService:GetPlayerDataFromServer(player.UserId)
	playerData.Buildings = buildings[player.UserId]
	for _, anotherPlayer in ipairs(game.Players:GetPlayers()) do
		if anotherPlayer ~= player then
			game.ReplicatedStorage.RemoteEvents.PlaceBlock:FireClient(anotherPlayer, data)
		end
	end
end)
