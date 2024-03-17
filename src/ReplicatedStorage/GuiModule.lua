local TweenService = game:GetService("TweenService")
local Shop = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Shop")
local WindowInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local BuildModeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local BuildMode = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BuildMode")
local Codes = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Codes")
local Profile = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Profile")
local ButtonColorTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ButtonSizeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

game.Players.LocalPlayer:SetAttribute("BuildModeEnabled", false)

local module = {
	IsShopEnabled = false,
	IsBuildModeEnabled = false,
}

function module.ShopLogic()
	if module.IsShopEnabled then
		module.CloseShop()
		module.CurrentGui = nil
	else
		module.CloseCurrentGui()
		module.OpenShop()
		module.CurrentGui = module.CloseShop
	end
end

function module.CloseShop()
	module.IsShopEnabled = false
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 1.5 }):Play()
	TweenService:Create(Shop.Frame.UIScale, WindowInfo, { Scale = 0 }):Play()
	TweenService:Create(Shop.Frame, WindowInfo, { Rotation = 90 }):Play()
end

function module.OpenShop()
	Shop.Frame.Rotation = -90
	module.IsShopEnabled = true
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 20 }):Play()
	TweenService:Create(Shop.Frame.UIScale, WindowInfo, { Scale = 1 }):Play()
	TweenService:Create(Shop.Frame, WindowInfo, { Rotation = 0 }):Play()
end

function module.BuildModeLogic()
	if module.IsBuildModeEnabled then
		module.CloseBuildMode()
		module.CurrentGui = nil
	else
		module.CloseCurrentGui()
		module.OpenBuildMode()
		module.CurrentGui = module.CloseBuildMode
	end
end

function module.CloseBuildMode()
	game.Players.LocalPlayer:SetAttribute("BuildModeEnabled", false)
	module.IsBuildModeEnabled = false
	TweenService:Create(BuildMode.Frame, BuildModeTweenInfo, { Position = UDim2.new(0.5, 0, 2, 0) }):Play()
	TweenService:Create(BuildMode.Materials, BuildModeTweenInfo, { Position = UDim2.new(1, 365, 1, -220) }):Play()
	TweenService:Create(BuildMode.Colors, BuildModeTweenInfo, { Position = UDim2.new(1, 365, 1, -10) }):Play()
end

function module.OpenBuildMode()
	module.IsBuildModeEnabled = true
	TweenService:Create(BuildMode.Frame, BuildModeTweenInfo, { Position = UDim2.new(0.5, 0, 1, -10) }):Play()
	task.wait(0.2)
	TweenService:Create(BuildMode.Colors, BuildModeTweenInfo, { Position = UDim2.new(1, -10, 1, -10) }):Play()
	task.wait(0.1)
	TweenService:Create(BuildMode.Materials, BuildModeTweenInfo, { Position = UDim2.new(1, -10, 1, -220) }):Play()
end

function module.CodesLogic()
	if module.IsCodesEnabled then
		module.CloseCodes()
		module.CurrentGui = nil
	else
		module.CloseCurrentGui()
		module.OpenCodes()
		module.CurrentGui = module.CloseCodes
	end
end

function module.CloseCodes()
	module.IsCodesEnabled = false
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 1.5 }):Play()
	TweenService:Create(Codes.Frame.UIScale, WindowInfo, { Scale = 0 }):Play()
	TweenService:Create(Codes.Frame, WindowInfo, { Rotation = 90 }):Play()
end

function module.OpenCodes()
	Codes.Frame.Rotation = -90
	module.IsCodesEnabled = true
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 20 }):Play()
	TweenService:Create(Codes.Frame.UIScale, WindowInfo, { Scale = 1 }):Play()
	TweenService:Create(Codes.Frame, WindowInfo, { Rotation = 0 }):Play()
end

function module.ProfileLogic()
	if module.IsProfileEnabled then
		module.CloseProfile()
		module.CurrentGui = nil
	else
		module.CloseCurrentGui()
		module.OpenProfile()
		module.CurrentGui = module.CloseProfile
	end
end

function module.CloseProfile()
	module.IsProfileEnabled = false
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 1.5 }):Play()
	TweenService:Create(Profile.Frame.UIScale, WindowInfo, { Scale = 0 }):Play()
	TweenService:Create(Profile.Frame, WindowInfo, { Rotation = 90 }):Play()
end

function module.OpenProfile()
	Profile.Frame.Rotation = -90
	module.IsProfileEnabled = true
	TweenService:Create(game.Lighting.Blur, WindowInfo, { Size = 20 }):Play()
	TweenService:Create(Profile.Frame.UIScale, WindowInfo, { Scale = 1 }):Play()
	TweenService:Create(Profile.Frame, WindowInfo, { Rotation = 0 }):Play()
end

function module.CloseCurrentGui()
	if module.CurrentGui then
		module.CurrentGui()
	end
end

function module.MouseEnter(Frame)
	TweenService:Create(Frame.ImageLabel, ButtonColorTweenInfo, { ImageColor3 = Color3.fromRGB(225, 225, 225) }):Play()
	TweenService:Create(Frame.TextLabel, ButtonColorTweenInfo, { TextColor3 = Color3.fromRGB(225, 225, 225) }):Play()
end

function module.MouseButtonDown(Frame)
	TweenService:Create(Frame.UIScale, ButtonSizeTweenInfo, { Scale = 0.9 }):Play()
end

function module.MouseButtonUp(Frame)
	TweenService:Create(Frame.UIScale, ButtonSizeTweenInfo, { Scale = 1 }):Play()
end

function module.MouseLeave(Frame)
	TweenService:Create(Frame.ImageLabel, ButtonColorTweenInfo, { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
	TweenService:Create(Frame.TextLabel, ButtonColorTweenInfo, { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end

return module
