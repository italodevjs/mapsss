-- LocalScript — dentro de StarterGui (ScreenGui)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local CatalogModule = require(ReplicatedStorage:WaitForChild("CatalogModule", 10))

local open    = false
local loading = false
local currentSearch = ""

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("EmoteCatalogGUI") then
	playerGui.EmoteCatalogGUI:Destroy()
end

-- ═══════════════════════════════════════
--  SCREENGUI
-- ═══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "EmoteCatalogGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- ═══════════════════════════════════════
--  BOTÃO DE ABRIR — canto esquerdo
-- ═══════════════════════════════════════
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 36)
OpenBtn.Position = UDim2.new(0, 12, 0.5, -18)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
OpenBtn.Text = "EMOTES"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.TextSize = 13
OpenBtn.ZIndex = 20
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)

-- Pulso suave no botão
task.spawn(function()
	while OpenBtn and OpenBtn.Parent do
		TweenService:Create(OpenBtn, TweenInfo.new(1, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(0, 100, 210)}):Play()
		task.wait(1)
		TweenService:Create(OpenBtn, TweenInfo.new(1, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(0, 130, 255)}):Play()
		task.wait(1)
	end
end)

-- ═══════════════════════════════════════
--  PAINEL PRINCIPAL
-- ═══════════════════════════════════════
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 780, 0, 560)
Main.Position = UDim2.new(1, 20, 0.5, -280)  -- fora da tela inicialmente
Main.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
Main.BorderSizePixel = 0
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(45, 45, 65)
mainStroke.Thickness = 1.5

-- ═══════════════════════════════════════
--  HEADER
-- ═══════════════════════════════════════
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 56)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

-- Linha separadora no header
local headerLine = Instance.new("Frame", Header)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
headerLine.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.Text = "🕺  EMOTES"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 18
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- ═══════════════════════════════════════
--  BARRA DE PESQUISA
-- ═══════════════════════════════════════
local SearchFrame = Instance.new("Frame", Main)
SearchFrame.Size = UDim2.new(1, -32, 0, 36)
SearchFrame.Position = UDim2.new(0, 16, 0, 64)
SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SearchFrame.BorderSizePixel = 0
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)
local searchStroke = Instance.new("UIStroke", SearchFrame)
searchStroke.Color = Color3.fromRGB(45, 45, 65)
searchStroke.Thickness = 1

local SearchIcon = Instance.new("TextLabel", SearchFrame)
SearchIcon.Size = UDim2.new(0, 34, 1, 0)
SearchIcon.Text = "🔍"
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 13
SearchIcon.BackgroundTransparency = 1
SearchIcon.TextColor3 = Color3.fromRGB(100, 100, 130)

local SearchBar = Instance.new("TextBox", SearchFrame)
SearchBar.Size = UDim2.new(1, -40, 1, 0)
SearchBar.Position = UDim2.new(0, 34, 0, 0)
SearchBar.BackgroundTransparency = 1
SearchBar.Text = ""
SearchBar.PlaceholderText = "Pesquisar emote..."
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextColor3 = Color3.fromRGB(230, 230, 255)
SearchBar.PlaceholderColor3 = Color3.fromRGB(90, 90, 115)
SearchBar.TextSize = 13
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
--  ÁREA DE SCROLL COM GRID
-- ═══════════════════════════════════════
local ScrollArea = Instance.new("ScrollingFrame", Main)
ScrollArea.Size = UDim2.new(1, -32, 1, -116)
ScrollArea.Position = UDim2.new(0, 16, 0, 108)
ScrollArea.BackgroundTransparency = 1
ScrollArea.ScrollBarThickness = 3
ScrollArea.ScrollBarImageColor3 = Color3.fromRGB(0, 130, 255)
ScrollArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollArea.BorderSizePixel = 0

local Grid = Instance.new("UIGridLayout", ScrollArea)
Grid.CellSize = UDim2.new(0, 150, 0, 245)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
Grid.SortOrder = Enum.SortOrder.LayoutOrder

local GridPad = Instance.new("UIPadding", ScrollArea)
GridPad.PaddingTop = UDim.new(0, 6)
GridPad.PaddingBottom = UDim.new(0, 6)
GridPad.PaddingLeft = UDim.new(0, 2)

-- Loading
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
	local target = open
		and UDim2.new(0.5, -390, 0.5, -280)
		or  UDim2.new(1, 20, 0.5, -280)
	TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = target}):Play()
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

-- Carrega ao iniciar
load(false, "")
