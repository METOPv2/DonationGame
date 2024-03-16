local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")
local PlayerDataMetatable = require(script.Parent.PlayerDataMetatable)
local PlayerDataService = {
	PlayerDataBase = {},
	PlayerDataTemplate = {
		Donated = 0,
		Raised = 0,
		Likes = 0,
		Visits = 0,
		PlayTime = 0,
	},
}

function PlayerDataService:GetPlayerDataFromDataStore(userId)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	return PlayerDataStore:GetAsync(userId)
end

function PlayerDataService:GetPlayerDataFromServer(userId)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	return PlayerDataService.PlayerDataBase[userId]
end

function PlayerDataService:ReconcilePlayerData(playerData)
	assert(type(playerData) == "table", "Player data must be a table.")
	for key, value in pairs(PlayerDataService.PlayerDataTemplate) do
		if playerData[key] == nil then
			playerData[key] = value
		end
	end
	return playerData
end

function PlayerDataService:InitLeaderstatsByPlayerData(playerData)
	assert(type(playerData) == "table", "Player data must be a table.")
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"

	local Donated = Instance.new("IntValue")
	Donated.Name = "Donated"
	Donated.Value = playerData.Donated
	Donated.Parent = Leaderstats

	local Raised = Instance.new("IntValue")
	Raised.Name = "Raised"
	Raised.Value = playerData.Raised
	Raised.Parent = Leaderstats

	local Likes = Instance.new("IntValue")
	Likes.Name = "Likes"
	Likes.Value = playerData.Likes
	Likes.Parent = Leaderstats

	return Leaderstats
end

function PlayerDataService:ConnectMetatableToPlayerData(playerData)
	assert(type(playerData) == "table", "Player data must be a table.")
	return setmetatable(playerData, PlayerDataMetatable)
end

function PlayerDataService:InitPlayerData(playerData)
	if playerData == nil then
		playerData = PlayerDataService.PlayerDataTemplate
	else
		playerData = PlayerDataService:ReconcilePlayerData(playerData)
	end
	playerData = PlayerDataService:ConnectMetatableToPlayerData(playerData)
	return playerData
end

function PlayerDataService:LoadPlayerDataToServer(userId, playerData)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	assert(type(playerData) == "table", "Player data must be a table.")
	PlayerDataService.PlayerDataBase[userId] = playerData
end

function PlayerDataService:IsPlayerDataLoadedInServer(userId)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	return PlayerDataService.PlayerDataBase[userId] ~= nil
end

function PlayerDataService:UnloadPlayerDataFromServer(userId)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	PlayerDataService.PlayerDataBase[userId] = nil
end

function PlayerDataService:SavePlayerDataToDataStore(userId, playerData)
	assert(userId, "User id is required.")
	assert(type(userId) == "number", "User id must be a number.")
	assert(type(playerData) == "table", "Player data must be a table.")
	PlayerDataStore:SetAsync(userId, playerData)
end

return PlayerDataService
