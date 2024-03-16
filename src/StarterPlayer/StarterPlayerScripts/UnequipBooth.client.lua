game.ReplicatedStorage.RemoteEvents.UnequipBooth.OnClientEvent:Connect(function()
	for _, v in ipairs(workspace.Booths:GetChildren()) do
		if v:IsA("Model") then
			v.PrimaryPart.Attachment.ProximityPrompt.Enabled = true
			v.PrimaryPart.Attachment.ProximityPrompt.ActionText = "Equip"
		end
	end
end)
