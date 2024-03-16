game.ReplicatedStorage.RemoteEvents.EquipBooth.OnClientEvent:Connect(function(boothName)
	for _, v in ipairs(workspace.Booths:GetChildren()) do
		if v:IsA("Model") then
			v.PrimaryPart.Attachment.ProximityPrompt.Enabled = false
		end
	end

	local booth = workspace.Booths:FindFirstChild(boothName)
	booth.PrimaryPart.Attachment.ProximityPrompt.Enabled = true
	booth.PrimaryPart.Attachment.ProximityPrompt.ActionText = "Uneqip"
end)
