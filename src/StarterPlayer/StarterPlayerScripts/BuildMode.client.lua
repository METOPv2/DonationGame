local Mouse = game.Players.LocalPlayer:GetMouse()
local CurrentColor = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BuildMode").Colors.CurrentColor
local CurrentMaterial =
	game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BuildMode").Materials.CurrentMaterial

type PartData = {
	Material: string,
	Color: Color3,
	Owner: number,
	CFrame: CFrame,
}

local function CreatePart(data: PartData)
	if data then
		local player = game.Players:GetPlayerByUserId(data.Owner)
		if not player then
			return
		end
		if not player:GetAttribute("EquippedPlot") then
			return
		end
		local plot = workspace.Plots:FindFirstChild(player:GetAttribute("EquippedPlot"))
		local blocks = workspace.Blocks:FindFirstChild(player.UserId)
		if not blocks then
			blocks = Instance.new("Model")
			blocks.Name = player.UserId
			blocks.Parent = workspace.Blocks
		end
		local Part = Instance.new("Part")
		Part.Color = Color3.new(data.Color.R, data.Color.G, data.Color.B)
		Part.Material = Enum.Material[data.Material]
		Part.Anchored = true
		Part.CanCollide = true
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = true
		Part.Transparency = 0
		Part.TopSurface = Enum.SurfaceType.Smooth
		Part.BottomSurface = Enum.SurfaceType.Smooth
		Part:SetAttribute("Plot", player:GetAttribute("EquippedPlot"))
		Part.Size = Vector3.one * 2
		Part.CFrame = CFrame.new(
			Vector3.new(unpack(data.CFrame.Position)),
			Vector3.new(unpack(data.CFrame.Position)) + Vector3.new(unpack(data.CFrame.LookVector))
		)
		Part.Parent = blocks
		local checkPart = Instance.new("Part")
		checkPart.Size = Vector3.new(plot:GetExtentsSize().X - 0.1, 100, plot:GetExtentsSize().Z - 0.1)
		checkPart.CFrame = plot:GetPivot() * CFrame.new(0, checkPart.Size.Y / 2 + plot:GetExtentsSize().Y / 2, 0)
		checkPart.Transparency = 1
		checkPart.CanCollide = false
		checkPart.Anchored = true
		checkPart.Parent = workspace
		local parts = workspace:GetPartsInPart(checkPart)
		for _, part in ipairs(blocks:GetChildren()) do
			if not table.find(parts, part) then
				part:Destroy()
			end
		end
		checkPart:Destroy()
	else
		if not game.Players.LocalPlayer:GetAttribute("EquippedPlot") then
			return
		end
		local plot = workspace.Plots:FindFirstChild(game.Players.LocalPlayer:GetAttribute("EquippedPlot"))
		local blocks = workspace.Blocks:FindFirstChild(game.Players.LocalPlayer.UserId)
		if not blocks then
			blocks = Instance.new("Model")
			blocks.Name = game.Players.LocalPlayer.UserId
			blocks.Parent = workspace.Blocks
		end
		local Part = Instance.new("Part")
		Part.Color = CurrentColor.Value
		Part.Material = Enum.Material[CurrentMaterial.Value]
		Part.Anchored = true
		Part.CanCollide = true
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = true
		Part.Transparency = 0
		Part.TopSurface = Enum.SurfaceType.Smooth
		Part.BottomSurface = Enum.SurfaceType.Smooth
		Part:SetAttribute("Plot", game.Players.LocalPlayer:GetAttribute("EquippedPlot"))
		Part.Size = Vector3.one * 2
		Part.Parent = blocks
		if Mouse.TargetSurface == Enum.NormalId.Top then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(0, Part.Size.Y / 2 + Mouse.Target.Size.Y / 2, 0)
		elseif Mouse.TargetSurface == Enum.NormalId.Bottom then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(0, -Part.Size.Y / 2 - Mouse.Target.Size.Y / 2, 0)
		elseif Mouse.TargetSurface == Enum.NormalId.Right then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(Part.Size.X / 2 + Mouse.Target.Size.X / 2, 0, 0)
		elseif Mouse.TargetSurface == Enum.NormalId.Left then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(-Part.Size.X / 2 - Mouse.Target.Size.X / 2, 0, 0)
		elseif Mouse.TargetSurface == Enum.NormalId.Front then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(0, 0, -Part.Size.Z / 2 - Mouse.Target.Size.Z / 2)
		elseif Mouse.TargetSurface == Enum.NormalId.Back then
			Part.CFrame = Mouse.Target.CFrame * CFrame.new(0, 0, Part.Size.Z / 2 + Mouse.Target.Size.Z / 2)
		end
		local checkPart = Instance.new("Part")
		checkPart.Size = Vector3.new(plot:GetExtentsSize().X - 0.1, 100, plot:GetExtentsSize().Z - 0.1)
		checkPart.CFrame = plot:GetPivot() * CFrame.new(0, checkPart.Size.Y / 2 + plot:GetExtentsSize().Y / 2, 0)
		checkPart.Transparency = 1
		checkPart.CanCollide = false
		checkPart.Anchored = true
		checkPart.Parent = workspace
		local parts = workspace:GetPartsInPart(checkPart)
		for _, part in ipairs(blocks:GetChildren()) do
			if not table.find(parts, part) then
				part:Destroy()
			end
		end
		checkPart:Destroy()
		game.ReplicatedStorage.RemoteEvents.PlaceBlock:FireServer({
			Material = CurrentMaterial.Value,
			Color = { R = CurrentColor.Value.R, G = CurrentColor.Value.G, B = CurrentColor.Value.B },
			CFrame = {
				Position = { Part.CFrame.Position.X, Part.CFrame.Position.Y, Part.CFrame.Position.Z },
				LookVector = { Part.CFrame.LookVector.X, Part.CFrame.LookVector.Y, Part.CFrame.LookVector.Z },
			},
		})
	end
end

game.ReplicatedStorage.RemoteEvents.PlaceBlock.OnClientEvent:Connect(function(data)
	CreatePart(data)
end)

local function DeletePart()
	if Mouse.Target and Mouse.Target:GetAttribute("Plot") then
		Mouse.Target:Destroy()
	end
end

local function PaintPart()
	if Mouse.Target and Mouse.Target:GetAttribute("Plot") then
		Mouse.Target.Color = CurrentColor.Value
		Mouse.Target.Material = Enum.Material[CurrentMaterial.Value]
	end
end

local function CopyColor()
	if Mouse.Target and Mouse.Target:GetAttribute("Plot") then
		CurrentColor.Value = Mouse.Target.Color
		CurrentMaterial.Value = Mouse.Target.Material.Name
	end
end

local function MouseClicked()
	if game.Players.LocalPlayer:GetAttribute("BuildModeEnabled") then
		CreatePart()
	elseif game.Players.LocalPlayer:GetAttribute("BuildModeDeleteEnabled") then
		DeletePart()
	elseif game.Players.LocalPlayer:GetAttribute("BuildModeCloneEnabled") then
		CopyColor()
	elseif game.Players.LocalPlayer:GetAttribute("BuildModePaintEnabled") then
		PaintPart()
	end
end

local selection
local function ChangeSelection()
	if selection then
		selection:Destroy()
	end
	if game.Players.LocalPlayer:GetAttribute("BuildModeEnabled") then
		selection = Instance.new("SurfaceSelection")
		selection.Adornee = Mouse.Target
		selection.TargetSurface = Mouse.TargetSurface
		selection.Color3 = Color3.fromRGB(39, 219, 4)
		selection.Parent = Mouse.Target
	elseif game.Players.LocalPlayer:GetAttribute("BuildModeDeleteEnabled") then
		selection = Instance.new("SelectionBox")
		selection.Color3 = Color3.fromRGB(199, 17, 17)
		selection.Adornee = Mouse.Target
		selection.Parent = Mouse.Target
	elseif game.Players.LocalPlayer:GetAttribute("BuildModeCloneEnabled") then
		selection = Instance.new("SelectionBox")
		selection.Color3 = Color3.fromRGB(4, 115, 218)
		selection.Adornee = Mouse.Target
		selection.Parent = Mouse.Target
	elseif game.Players.LocalPlayer:GetAttribute("BuildModePaintEnabled") then
		selection = Instance.new("SelectionBox")
		selection.Color3 = Color3.fromRGB(240, 135, 30)
		selection.Adornee = Mouse.Target
		selection.Parent = Mouse.Target
	end
end

local function MouseMoved()
	if
		game.Players.LocalPlayer:GetAttribute("EquippedPlot")
		and (game.Players.LocalPlayer:GetAttribute("BuildModeEnabled") or game.Players.LocalPlayer:GetAttribute(
			"BuildModeDeleteEnabled"
		) or game.Players.LocalPlayer:GetAttribute("BuildModePaintEnabled") or game.Players.LocalPlayer:GetAttribute(
			"BuildModeCloneEnabled"
		))
		and Mouse.Target
		and (Mouse.Target:FindFirstAncestor("Blocks") or Mouse.Target:FindFirstAncestor("Plots"))
		and (
			Mouse.Target.Parent.Name == game.Players.LocalPlayer:GetAttribute("EquippedPlot")
			or Mouse.Target:GetAttribute("Plot") == game.Players.LocalPlayer:GetAttribute("EquippedPlot")
		)
	then
		ChangeSelection()
	else
		if selection then
			selection:Destroy()
			selection = nil
		end
	end
end

Mouse.Move:Connect(MouseMoved)
Mouse.Button1Down:Connect(MouseClicked)

game.Players.LocalPlayer.AttributeChanged:Connect(function(attribute)
	if attribute == "BuildModeEnabled" then
		if game.Players.LocalPlayer:GetAttribute(attribute) == false and selection then
			selection:Destroy()
			selection = nil
		end
	end
end)

game.ReplicatedStorage.RemoteEvents.UnequipBooth.OnClientEvent:Connect(function(uneqippedOwnerId)
	if workspace.Blocks[uneqippedOwnerId] then
		workspace.Blocks[uneqippedOwnerId]:Destroy()
	end
end)
