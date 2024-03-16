local httpService = game:GetService("HttpService")
local function getGamesIds(userId, cursor, gamesIds)
	cursor = cursor or ""
	gamesIds = gamesIds or {}
	local success, result = pcall(
		httpService.GetAsync,
		httpService,
		`https://games.roproxy.com/v2/users/{userId}/games?limit=50&cursor={cursor}`
	)
	if success and result then
		local data = httpService:JSONDecode(result)
		for _, _game in data.data do
			table.insert(gamesIds, _game.id)
		end
		if data.nextPageCursor then
			getGamesIds(userId, data.nextPageCursor, gamesIds)
		end
	else
		warn(result)
		getGamesIds(userId, cursor, gamesIds)
	end
	return gamesIds
end
local function getGamePasses(userId, cursor, gamePasses, universeIds)
	cursor = cursor or ""
	gamePasses = gamePasses or {}
	universeIds = universeIds or getGamesIds(userId)
	for i, universeId in universeIds do
		local success, result = pcall(
			httpService.GetAsync,
			httpService,
			`https://games.roproxy.com/v1/games/{universeId}/game-passes?limit=100&cursor={cursor}`
		)
		if success and result then
			table.remove(universeIds, i)
			local data = httpService:JSONDecode(result)
			for _, gamePass in data.data do
				if gamePass.price then
					table.insert(gamePasses, {
						Name = gamePass.name,
						Price = gamePass.price,
						Id = gamePass.id,
						ItemType = Enum.InfoType.GamePass,
					})
				end
			end
			if data.nextPageCursor then
				getGamePasses(userId, data.nextPageCursor, gamePasses, universeIds)
			end
		else
			warn(result)
			getGamePasses(userId, cursor, gamePasses, universeIds)
		end
	end
	return gamePasses
end
local function getCatalogAssets(userId, cursor, assets)
	cursor = cursor or ""
	assets = assets or {}
	local success, result = pcall(
		httpService.GetAsync,
		httpService,
		`https://catalog.roproxy.com/v1/search/items/details?Category=1&Sort=4&Limit=30&CreatorName={game.Players:GetNameFromUserIdAsync(
			userId
		)}&cursor={cursor}`
	)
	if success and result then
		local data = httpService:JSONDecode(result)
		for _, asset in data.data do
			if asset.price then
				table.insert(assets, {
					Name = asset.name,
					Description = asset.description,
					Price = asset.price,
					Id = asset.id,
					ItemType = Enum.InfoType[asset.itemType],
				})
			end
		end
		if data.nextPageCursor then
			getCatalogAssets(userId, data.nextPageCursor, assets)
		end
	else
		warn(result)
		getCatalogAssets(userId, cursor, assets)
	end
	return assets
end
return {
	GetGamePasses = function(userId)
		local gamePasses = getGamePasses(userId)
		table.sort(gamePasses, function(t1, t2)
			return t1.Price < t2.Price
		end)
		return gamePasses
	end,
	GetCatalogAssets = function(userId)
		local assets = getCatalogAssets(userId)
		table.sort(assets, function(t1, t2)
			return t1.Price < t2.Price
		end)
		return assets
	end,
}
