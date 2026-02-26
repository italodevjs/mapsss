local CatalogModule = {}
local AvatarEditorService = game:GetService("AvatarEditorService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local BRUNO_EMOTE_ID = 78395047278790
CatalogModule.CurrentPage = nil
CatalogModule.CurrentSearch = ""

function CatalogModule.Search(isNext, keyword)
	local results = {}
	keyword = keyword or CatalogModule.CurrentSearch

	if keyword ~= CatalogModule.CurrentSearch then
		CatalogModule.CurrentSearch = keyword
		CatalogModule.CurrentPage = nil
	end

	if not isNext and (keyword == "" or string.find(string.upper("BRUNO BEST PRIME"), string.upper(keyword))) then
		table.insert(results, {
			Name = "BRUNO BEST PRIME",
			Id = BRUNO_EMOTE_ID,
			Price = 50,
			IsSpecial = true,
		})
	end

	local success, page = pcall(function()
		if isNext and CatalogModule.CurrentPage then
			CatalogModule.CurrentPage:AdvanceToNextPageAsync()
			return CatalogModule.CurrentPage
		else
			local params = CatalogSearchParams.new()
			params.AssetTypes = {Enum.AvatarAssetType.EmoteAnimation}
			if keyword and keyword ~= "" then
				params.SearchKeyword = keyword
			end
			return AvatarEditorService:SearchCatalog(params)
		end
	end)

	if success and page then
		CatalogModule.CurrentPage = page
		for _, item in ipairs(page:GetCurrentPage()) do
			if item.Id ~= BRUNO_EMOTE_ID then
				table.insert(results, {
					Name = item.Name,
					Id = item.Id,
					Price = item.Price or 0,
					IsSpecial = false,
				})
			end
		end
	end

	return results
end

function CatalogModule.CreateCard(data, parent)
	-- Altura do card: especial é maior para caber badge + botões
	local cardH = data.IsSpecial and 260 or 220

	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(0, 150, 0, cardH)
	card.BackgroundColor3 = data.IsSpecial and Color3.fromRGB(22, 17, 4) or Color3.fromRGB(20, 20, 28)
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke", card)
	stroke.Thickness = data.IsSpecial and 2 or 1
	stroke.Color = data.IsSpecial and Color3.fromRGB(255, 190, 0) or Color3.fromRGB(50, 50, 65)

	if data.IsSpecial then
		-- Pulso dourado
		task.spawn(function()
			while card and card.Parent do
				TweenService:Create(stroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0.65}):Play()
				task.wait(0.9)
				TweenService:Create(stroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0}):Play()
				task.wait(0.9)
			end
		end)

		-- Badge ⭐ ESPECIAL
		local badge = Instance.new("Frame", card)
		badge.Size = UDim2.new(0, 76, 0, 18)
		badge.Position = UDim2.new(0, 8, 0, 8)
		badge.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
		badge.ZIndex = 5
		badge.BorderSizePixel = 0
		Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
		local badgeText = Instance.new("TextLabel", badge)
		badgeText.Size = UDim2.new(1, 0, 1, 0)
		badgeText.Text = "⭐ ESPECIAL"
		badgeText.Font = Enum.Font.GothamBlack
		badgeText.TextColor3 = Color3.fromRGB(30, 15, 0)
		badgeText.TextSize = 8
		badgeText.BackgroundTransparency = 1
		badgeText.ZIndex = 6
	end

	-- Imagem
	local imgTop = data.IsSpecial and 32 or 8
	local img = Instance.new("ImageLabel", card)
	img.Size = UDim2.new(1, -16, 0, 110)
	img.Position = UDim2.new(0, 8, 0, imgTop)
	img.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	img.Image = "rbxthumb://type=Asset&id=" .. data.Id .. "&w=420&h=420"
	img.ScaleType = Enum.ScaleType.Fit
	img.BorderSizePixel = 0
	Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)

	-- Nome
	local nameTop = data.IsSpecial and 148 or 124
	local nameLabel = Instance.new("TextLabel", card)
	nameLabel.Size = UDim2.new(1, -16, 0, 30)
	nameLabel.Position = UDim2.new(0, 8, 0, nameTop)
	nameLabel.Text = data.Name:upper()
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.TextColor3 = data.IsSpecial and Color3.fromRGB(255, 205, 50) or Color3.fromRGB(235, 235, 255)
	nameLabel.TextSize = 9
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextWrapped = true

	-- Preço
	local priceTop = data.IsSpecial and 178 or 154
	local priceFrame = Instance.new("Frame", card)
	priceFrame.Size = UDim2.new(1, -16, 0, 16)
	priceFrame.Position = UDim2.new(0, 8, 0, priceTop)
	priceFrame.BackgroundTransparency = 1
	local pl = Instance.new("UIListLayout", priceFrame)
	pl.FillDirection = Enum.FillDirection.Horizontal
	pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
	pl.VerticalAlignment = Enum.VerticalAlignment.Center
	pl.Padding = UDim.new(0, 3)

	local robuxIcon = Instance.new("ImageLabel", priceFrame)
	robuxIcon.Size = UDim2.new(0, 12, 0, 12)
	robuxIcon.BackgroundTransparency = 1
	robuxIcon.Image = "rbxassetid://12143004832"

	local priceLabel = Instance.new("TextLabel", priceFrame)
	priceLabel.Size = UDim2.new(0, 0, 1, 0)
	priceLabel.AutomaticSize = Enum.AutomaticSize.X
	priceLabel.Text = data.Price == 0 and "GRÁTIS" or tostring(data.Price)
	priceLabel.Font = Enum.Font.GothamBlack
	priceLabel.TextColor3 = data.Price == 0 and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(255, 255, 255)
	priceLabel.TextSize = 10
	priceLabel.BackgroundTransparency = 1

	-- Botões — posição calculada para sempre caber dentro do card
	local btnTop = data.IsSpecial and 198 or 174

	local btnFrame = Instance.new("Frame", card)
	btnFrame.Size = UDim2.new(1, -16, 0, 52)
	btnFrame.Position = UDim2.new(0, 8, 0, btnTop)
	btnFrame.BackgroundTransparency = 1
	local bl = Instance.new("UIListLayout", btnFrame)
	bl.Padding = UDim.new(0, 5)

	local function makeBtn(txt, bg)
		local b = Instance.new("TextButton", btnFrame)
		b.Size = UDim2.new(1, 0, 0, 21)
		b.BackgroundColor3 = bg
		b.Text = txt
		b.Font = Enum.Font.GothamBlack
		b.TextColor3 = Color3.new(1, 1, 1)
		b.TextSize = 9
		b.BorderSizePixel = 0
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseEnter:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = bg:Lerp(Color3.new(1,1,1), 0.18)}):Play()
		end)
		b.MouseLeave:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = bg}):Play()
		end)
		return b
	end

	local tryColor = data.IsSpecial and Color3.fromRGB(170, 120, 0) or Color3.fromRGB(55, 55, 70)
	local tryBtn = makeBtn("▶ TESTAR", tryColor)
	local buyBtn = makeBtn("🛒 COMPRAR", Color3.fromRGB(0, 130, 220))

	tryBtn.MouseButton1Click:Connect(function()
		local player = game.Players.LocalPlayer
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			local desc = hum:FindFirstChildOfClass("HumanoidDescription")
			if desc then
				local emotes = desc:GetEmotes()
				local emoteName = "TestEmote_" .. data.Id
				emotes[emoteName] = {data.Id}
				desc:SetEmotes(emotes)
				task.spawn(function()
					pcall(function() hum:PlayEmote(emoteName) end)
				end)
			end
		end
	end)

	buyBtn.MouseButton1Click:Connect(function()
		MarketplaceService:PromptPurchase(game.Players.LocalPlayer, data.Id)
	end)

	return card
end

return CatalogModule
