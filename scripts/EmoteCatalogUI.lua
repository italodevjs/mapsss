-- LocalScript — dentro de StarterGui (ScreenGui)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CatalogModule = require(ReplicatedStorage:WaitForChild("CatalogModule", 10))

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local open    = false
local loading = false
local currentSearch = ""

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("EmoteCatalogGUI") then
	playerGui.EmoteCatalogGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "EmoteCatalogGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- ═══════════════════════════════════════
--  BOTÃO DE ABRIR — canto direito
-- ═══════════════════════════════════════
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.ZIndex = 20
OpenBtn.Text = "EMOTES"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.BorderSizePixel = 0
OpenBtn.TextSize = 13
OpenBtn.AnchorPoint = Vector2.new(1, 0.5)
OpenBtn.Size = UDim2.new(0, isMobile and 100 or 84, 0, 38)
OpenBtn.Position = UDim2.new(1, isMobile and -16 or -14, 0.5, 0)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)

-- Sombra suave no botão
local openStroke = Instance.new("UIStroke", OpenBtn)
openStroke.Color = Color3.fromRGB(60, 60, 60)
openStroke.Thickness = 1.5
openStroke.Transparency = 0.5

-- ═══════════════════════════════════════
--  PAINEL PRINCIPAL — centralizado com AnchorPoint
-- ═══════════════════════════════════════
local panelW = isMobile and UDim2.new(0.88, 0, 0.62, 0) or UDim2.new(0, 780, 0, 560)
local panelOpen  = UDim2.new(0.5, 0, 0.5, 0)   -- centro da tela
local panelClose = isMobile
	and UDim2.new(0.5, 0, 1.5, 0)   -- sai por baixo
	or  UDim2.new(1.5, 0, 0.5, 0)   -- sai pela direita

local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = panelW
Main.Position = panelClose
Main.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
Main.BorderSizePixel = 0
Main.ZIndex = 10
-- Bloqueia o input da câmera ao tocar no painel
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(45, 45, 65)
mainStroke.Thickness = 1.5

-- ═══════════════════════════════════════
--  HEADER
-- ═══════════════════════════════════════
local headerH = isMobile and 46 or 56

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, headerH)
Header.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local headerLine = Instance.new("Frame", Header)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
headerLine.BorderSizePixel = 0

if isMobile then
	local handle = Instance.new("Frame", Header)
	handle.Size = UDim2.new(0, 36, 0, 4)
	handle.Position = UDim2.new(0.5, -18, 0, 6)
	handle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	handle.BorderSizePixel = 0
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
end

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.Text = "🕺  EMOTES"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = isMobile and 14 or 18
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

-- ═══════════════════════════════════════
--  BARRA DE PESQUISA
-- ═══════════════════════════════════════
local searchTop = headerH + 7
local searchH   = 34

local SearchFrame = Instance.new("Frame", Main)
SearchFrame.Size = UDim2.new(1, -24, 0, searchH)
SearchFrame.Position = UDim2.new(0, 12, 0, searchTop)
SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SearchFrame.BorderSizePixel = 0
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)
local searchStroke = Instance.new("UIStroke", SearchFrame)
searchStroke.Color = Color3.fromRGB(45, 45, 65)
searchStroke.Thickness = 1

local SearchIcon = Instance.new("TextLabel", SearchFrame)
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Text = "🔍"
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 12
SearchIcon.BackgroundTransparency = 1
SearchIcon.TextColor3 = Color3.fromRGB(100, 100, 130)

local SearchBar = Instance.new("TextBox", SearchFrame)
SearchBar.Size = UDim2.new(1, -36, 1, 0)
SearchBar.Position = UDim2.new(0, 30, 0, 0)
SearchBar.BackgroundTransparency = 1
SearchBar.Text = ""
SearchBar.PlaceholderText = "Pesquisar emote..."
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextColor3 = Color3.fromRGB(230, 230, 255)
SearchBar.PlaceholderColor3 = Color3.fromRGB(90, 90, 115)
SearchBar.TextSize = isMobile and 11 or 13
SearchBar.ClearTextOnFocus = false
SearchBar.BorderSizePixel = 0

SearchBar.Focused:Connect(function()
	TweenService:Create(searchStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 130, 255)}):Play()
end)
SearchBar.FocusLost:Connect(function(enter)
	TweenService:Create(searchStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 65)}):Play()
	if enter then
		currentSearch = SearchBar.Text
		load(false, currentSearch)
	end
end)

-- ═══════════════════════════════════════
--  GRID DE CARDS
-- ═══════════════════════════════════════
local scrollTop = searchTop + searchH + 6
local cellW   = isMobile and 130 or 150
local cellH   = isMobile and 250 or 250
local cellPad = isMobile and 8   or 10

local ScrollArea = Instance.new("ScrollingFrame", Main)
ScrollArea.Size = UDim2.new(1, -24, 1, -(scrollTop + 8))
ScrollArea.Position = UDim2.new(0, 12, 0, scrollTop)
ScrollArea.BackgroundTransparency = 1
ScrollArea.ScrollBarThickness = isMobile and 0 or 3
ScrollArea.ScrollBarImageColor3 = Color3.fromRGB(0, 130, 255)
ScrollArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollArea.BorderSizePixel = 0
ScrollArea.ElasticBehavior = Enum.ElasticBehavior.Always

local Grid = Instance.new("UIGridLayout", ScrollArea)
Grid.CellSize = UDim2.new(0, cellW, 0, cellH)
Grid.CellPadding = UDim2.new(0, cellPad, 0, cellPad)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.SortOrder = Enum.SortOrder.LayoutOrder

local GridPad = Instance.new("UIPadding", ScrollArea)
GridPad.PaddingTop = UDim.new(0, 6)
GridPad.PaddingBottom = UDim.new(0, 6)

local LoadingLabel = Instance.new("TextLabel", Main)
LoadingLabel.Size = UDim2.new(1, 0, 0, 40)
LoadingLabel.Position = UDim2.new(0, 0, 0.5, -20)
LoadingLabel.Text = "Carregando..."
LoadingLabel.Font = Enum.Font.GothamBold
LoadingLabel.TextColor3 = Color3.fromRGB(100, 100, 130)
LoadingLabel.TextSize = 14
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Visible = false

-- ═══════════════════════════════════════
--  FUNÇÕES
-- ═══════════════════════════════════════
function load(isNext, keyword)
	if loading then return end
	loading = true
	LoadingLabel.Visible = not isNext
	if not isNext then
		for _, c in ipairs(ScrollArea:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
	end
	local items = CatalogModule.Search(isNext, keyword)
	for _, item in ipairs(items) do
		CatalogModule.CreateCard(item, ScrollArea)
	end
	LoadingLabel.Visible = false
	loading = false
end

local function toggleOpen(state)
	open = state
	local target = open and panelOpen or panelClose
	TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = target}):Play()
	if isMobile then
		OpenBtn.Visible = not open
	end
end

-- ═══════════════════════════════════════
--  EVENTOS
-- ═══════════════════════════════════════
OpenBtn.MouseButton1Click:Connect(function()
	toggleOpen(not open)
	if open and #ScrollArea:GetChildren() <= 1 then
		load(false, "")
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	toggleOpen(false)
end)

ScrollArea:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local atBottom = ScrollArea.CanvasPosition.Y >= (ScrollArea.AbsoluteCanvasSize.Y - ScrollArea.AbsoluteSize.Y) - 200
	if atBottom then
		load(true, currentSearch)
	end
end)

-- Swipe para baixo fecha no mobile
if isMobile then
	local swipeStartY = 0
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			swipeStartY = input.Position.Y
		end
	end)
	Main.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position.Y - swipeStartY
			if delta > 70 and ScrollArea.CanvasPosition.Y <= 0 then
				toggleOpen(false)
			end
		end
	end)
end

load(false, "")
