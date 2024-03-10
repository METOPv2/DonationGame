local PlayerDataMetatable = {}
PlayerDataMetatable.__index = PlayerDataMetatable

function PlayerDataMetatable:set(key, value)
	self[key] = value
end

function PlayerDataMetatable:remove(key)
	self[key] = nil
end

function PlayerDataMetatable:get(key)
	return self[key]
end

function PlayerDataMetatable:increment(key, amount)
	self[key] += amount
end

return PlayerDataMetatable
