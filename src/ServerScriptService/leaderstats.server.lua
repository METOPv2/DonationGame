game.Players.PlayerAdded:Connect(function(player)
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"
	Leaderstats.Parent = player

	local Donated = Instance.new("IntValue")
	Donated.Name = "Donated"
	Donated.Value = 0
	Donated.Parent = Leaderstats

	local Raised = Instance.new("IntValue")
	Raised.Name = "Raised"
	Raised.Value = 0
	Raised.Parent = Leaderstats

	local Likes = Instance.new("IntValue")
	Likes.Name = "Likes"
	Likes.Value = 0
	Likes.Parent = Leaderstats
end)
