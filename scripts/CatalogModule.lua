local CatalogModule = {}
local AvatarEditorService = game:GetService("AvatarEditorService")
local MarketplaceService  = game:GetService("MarketplaceService")
local TweenService        = game:GetService("TweenService")

local BRUNO_EMOTE_ID = 78395047278790
CatalogModule.CurrentPage  = nil
CatalogModule.CurrentSearch = ""

-- ─────────────────────────────────────────────
--  BUSCA
-- ─────────────────────────────────────────────
function CatalogModule.Search(isNext, keyword)
	local results = {}
	keyword = keyword or CatalogModule.CurrentSearch

	if keyword ~= CatalogModule.CurrentSearch then
		CatalogModule.CurrentSearch = keyword
		CatalogModule.CurrentPage   = nil
	end

	-- Emote especial sempre no topo (só na primeira página)
	if not isNext and (keyword == "" or string.find(string.upper("BRUNO BEST PRIME"), string.upper(keyword))) then
		table.insert(results, {
			Name      = "BRUNO BEST PRIME",
			Id        = BRUNO_EMOTE_ID,
			Price     = 50,
			IsSpecial = true,
		})
	end

	local ok, page = pcall(function()
		if isNext and CatalogModule.CurrentPage then
			CatalogModule.CurrentPage:AdvanceToNextPageAsync()
			return CatalogModule.CurrentPage
		else
			local p = CatalogSearchParams.new()
			p.AssetTypes = {Enum.AvatarAssetType.EmoteAnimation}
			if keyword and keyword ~= "" then p.SearchKeyword = keyword end
			return AvatarEditorService:SearchCatalog(p)
		end
	end)

	if ok and page then
		CatalogModule.CurrentPage = page
		for _, item in ipairs(page:GetCurrentPage()) do
			if item.Id ~= BRUNO_EMOTE_ID then
				table.insert(results, {
					Name      = item.Name,
					Id        = item.Id,
					Price     = item.Price or 0,
					IsSpecial = false,
				})
			end
		end
	end

	return results
end

-- ─────────────────────────────────────────────
--  HELPER: cria botão
-- ─────────────────────────────────────────────
local function makeBtn(parent, txt, bg, h)
	local b = Instance.new("TextButton", parent)
	b.Size            = UDim2.new(1, 0, 0, h or 28)
	b.BackgroundColor3 = bg
	b.Text            = txt
	b.Font            = Enum.Font.GothamBlack
	b.TextColor3      = Color3.new(1, 1, 1)
	b.TextSize        = 11
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = bg:Lerp(Color3.new(1,1,1), 0.2)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = bg}):Play()
	end)
	return b
end

-- ─────────────────────────────────────────────
--  CARD ESPECIAL — ocupa largura total do scroll
-- ─────────────────────────────────────────────
function CatalogModule.CreateSpecialCard(data, parent, fullWidth)
	local card = Instance.new("Frame", parent)
	card.Size             = UDim2.new(1, -16, 0, 200)
	card.BackgroundColor3 = Color3.fromRGB(22, 17, 4)
	card.BorderSizePixel  = 0
	card.LayoutOrder      = 0
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

	local stroke = Instance.new("UIStroke", card)
	stroke.Thickness = 2
	stroke.Color     = Color3.fromRGB(255, 190, 0)

	-- Pulso dourado
	task.spawn(function()
		while card and card.Parent do
			TweenService:Create(stroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0.6}):Play()
			task.wait(0.9)
			TweenService:Create(stroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0}):Play()
			task.wait(0.9)
		end
	end)

	-- Layout horizontal: imagem à esquerda, info à direita
	local imgW = 130
	local img  = Instance.new("ImageLabel", card)
	img.Size             = UDim2.new(0, imgW, 1, -16)
	img.Position         = UDim2.new(0, 8, 0, 8)
	img.BackgroundColor3 = Color3.fromRGB(30, 28, 10)
	img.Image            = "rbxthumb://type=Asset&id=" .. data.Id .. "&w=420&h=420"
	img.ScaleType        = Enum.ScaleType.Fit
	img.BorderSizePixel  = 0
	Instance.new("UICorner", img).CornerRadius = UDim.new(0, 10)

	-- Badge
	local badge = Instance.new("Frame", card)
	badge.Size             = UDim2.new(0, 90, 0, 22)
	badge.Position         = UDim2.new(0, 8, 0, 8)
	badge.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
	badge.BorderSizePixel  = 0
	badge.ZIndex           = 5
	Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 7)
	local bt = Instance.new("TextLabel", badge)
	bt.Size               = UDim2.new(1, 0, 1, 0)
	bt.Text               = "⭐  ESPECIAL"
	bt.Font               = Enum.Font.GothamBlack
	bt.TextColor3         = Color3.fromRGB(30, 15, 0)
	bt.TextSize           = 9
	bt.BackgroundTransparency = 1
	bt.ZIndex             = 6

	-- Painel direito
	local right = Instance.new("Frame", card)
	right.Size             = UDim2.new(1, -(imgW + 20), 1, -16)
	right.Position         = UDim2.new(0, imgW + 14, 0, 8)
	right.BackgroundTransparency = 1

	local nameL = Instance.new("TextLabel", right)
	nameL.Size             = UDim2.new(1, 0, 0, 50)
	nameL.Position         = UDim2.new(0, 0, 0, 0)
	nameL.Text             = "BRUNO BEST PRIME"
	nameL.Font             = Enum.Font.GothamBlack
	nameL.TextColor3       = Color3.fromRGB(255, 210, 50)
	nameL.TextSize         = 14
	nameL.BackgroundTransparency = 1
	nameL.TextWrapped      = true
	nameL.TextXAlignment   = Enum.TextXAlignment.Left
	nameL.TextYAlignment   = Enum.TextYAlignment.Top

	local priceL = Instance.new("TextLabel", right)
	priceL.Size            = UDim2.new(1, 0, 0, 22)
	priceL.Position        = UDim2.new(0, 0, 0, 52)
	priceL.Text            = "🪙  " .. (data.Price == 0 and "GRÁTIS" or tostring(data.Price))
	priceL.Font            = Enum.Font.GothamBold
	priceL.TextColor3      = Color3.fromRGB(255, 255, 255)
	priceL.TextSize        = 12
	priceL.BackgroundTransparency = 1
	priceL.TextXAlignment  = Enum.TextXAlignment.Left

	local btnHolder = Instance.new("Frame", right)
	btnHolder.Size             = UDim2.new(1, 0, 0, 70)
	btnHolder.Position         = UDim2.new(0, 0, 1, -70)
	btnHolder.BackgroundTransparency = 1
	local bl = Instance.new("UIListLayout", btnHolder)
	bl.Padding = UDim.new(0, 7)

	local tryBtn = makeBtn(btnHolder, "▶  TESTAR",  Color3.fromRGB(160, 110, 0), 28)
	local buyBtn = makeBtn(btnHolder, "🛒  COMPRAR", Color3.fromRGB(0, 130, 220), 28)

	tryBtn.MouseButton1Click:Connect(function()
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			local desc = hum:FindFirstChildOfClass("HumanoidDescription")
			if desc then
				local emotes = desc:GetEmotes()
				local eName  = "TestEmote_" .. data.Id
				emotes[eName] = {data.Id}
				desc:SetEmotes(emotes)
				task.spawn(function() pcall(function() hum:PlayEmote(eName) end) end)
			end
		end
	end)

	buyBtn.MouseButton1Click:Connect(function()
		MarketplaceService:PromptPurchase(game.Players.LocalPlayer, data.Id)
	end)

	return card
end

-- ─────────────────────────────────────────────
--  CARD NORMAL
-- ─────────────────────────────────────────────
function CatalogModule.CreateCard(data, parent)
	if data.IsSpecial then
		return CatalogModule.CreateSpecialCard(data, parent)
	end

	local card = Instance.new("Frame", parent)
	card.Size             = UDim2.new(0, 150, 0, 250)
	card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	card.BorderSizePixel  = 0
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", card)
	stroke.Thickness = 1
	stroke.Color     = Color3.fromRGB(50, 50, 65)

	-- Imagem
	local img = Instance.new("ImageLabel", card)
	img.Size             = UDim2.new(1, -16, 0, 110)
	img.Position         = UDim2.new(0, 8, 0, 8)
	img.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	img.Image            = "rbxthumb://type=Asset&id=" .. data.Id .. "&w=420&h=420"
	img.ScaleType        = Enum.ScaleType.Fit
	img.BorderSizePixel  = 0
	Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)

	-- Nome
	local nameL = Instance.new("TextLabel", card)
	nameL.Size             = UDim2.new(1, -16, 0, 36)
	nameL.Position         = UDim2.new(0, 8, 0, 122)
	nameL.Text             = data.Name:upper()
	nameL.Font             = Enum.Font.GothamBlack
	nameL.TextColor3       = Color3.fromRGB(235, 235, 255)
	nameL.TextSize         = 9
	nameL.BackgroundTransparency = 1
	nameL.TextTruncate     = Enum.TextTruncate.AtEnd
	nameL.TextXAlignment   = Enum.TextXAlignment.Center
	nameL.TextWrapped      = true

	-- Preço
	local priceL = Instance.new("TextLabel", card)
	priceL.Size            = UDim2.new(1, -16, 0, 18)
	priceL.Position        = UDim2.new(0, 8, 0, 160)
	priceL.Text            = "🪙  " .. (data.Price == 0 and "GRÁTIS" or tostring(data.Price))
	priceL.Font            = Enum.Font.GothamBold
	priceL.TextColor3      = Color3.fromRGB(255, 255, 255)
	priceL.TextSize        = 11
	priceL.BackgroundTransparency = 1
	priceL.TextXAlignment  = Enum.TextXAlignment.Center

	-- Botões
	local btnFrame = Instance.new("Frame", card)
	btnFrame.Size             = UDim2.new(1, -16, 0, 62)
	btnFrame.Position         = UDim2.new(0, 8, 0, 182)
	btnFrame.BackgroundTransparency = 1
	local bl = Instance.new("UIListLayout", btnFrame)
	bl.Padding = UDim.new(0, 6)

	local tryBtn = makeBtn(btnFrame, "▶  TESTAR",  Color3.fromRGB(60, 60, 75), 26)
	local buyBtn = makeBtn(btnFrame, "🛒  COMPRAR", Color3.fromRGB(0, 130, 220), 26)

	tryBtn.MouseButton1Click:Connect(function()
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			local desc = hum:FindFirstChildOfClass("HumanoidDescription")
			if desc then
				local emotes = desc:GetEmotes()
				local eName  = "TestEmote_" .. data.Id
				emotes[eName] = {data.Id}
				desc:SetEmotes(emotes)
				task.spawn(function() pcall(function() hum:PlayEmote(eName) end) end)
			end
		end
	end)

	buyBtn.MouseButton1Click:Connect(function()
		MarketplaceService:PromptPurchase(game.Players.LocalPlayer, data.Id)
	end)

	return card
end

return CatalogModule
