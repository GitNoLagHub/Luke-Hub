--// DARK MOBILE HUB - LUMBER TYCOON 2
--// Versão mobile: calculadora + Fly GUI separado + FPS/Ping no topo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

--==================================================
-- CONFIGURAÇÃO DO PERSONAGEM
--==================================================

local character
local humanoid
local root

local function setupCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)

--==================================================
-- GUI PRINCIPAL
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "DarkMobileHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(48,48)
reopen.Position = UDim2.new(0,15,0.5,-24)
reopen.BackgroundColor3 = Color3.fromRGB(25,25,25)
reopen.Text = "☰"
reopen.TextColor3 = Color3.new(1,1,1)
reopen.TextSize = 22
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner",reopen).CornerRadius = UDim.new(0,12)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330,420)
main.Position = UDim2.new(0.5,-165,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner",main).CornerRadius = UDim.new(0,15)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55,55,55)
stroke.Thickness = 1
stroke.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,48)
titleBar.BackgroundColor3 = Color3.fromRGB(24,24,24)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.fromOffset(15,0)
title.BackgroundTransparency = 1
title.Text = "DARK HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(42,42)
close.Position = UDim2.new(1,-46,0,3)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextColor3 = Color3.fromRGB(230,230,230)
close.TextSize = 28
close.Font = Enum.Font.GothamBold
close.Parent = titleBar

--==================================================
-- ARRASTAR HUB
--==================================================

local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and
       (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- REDIMENSIONAR HUB
--==================================================

local resize = Instance.new("TextButton")
resize.Size = UDim2.fromOffset(25,25)
resize.Position = UDim2.new(1,-25,1,-25)
resize.BackgroundTransparency = 1
resize.Text = "↘"
resize.TextColor3 = Color3.fromRGB(130,130,130)
resize.TextSize = 17
resize.Parent = main

local resizing = false
local resizeStart
local originalSize

resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        resizing = true
        resizeStart = input.Position
        originalSize = main.Size

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and
       (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - resizeStart

        local newX = math.clamp(
            originalSize.X.Offset + delta.X,
            260,
            500
        )

        local newY = math.clamp(
            originalSize.Y.Offset + delta.Y,
            330,
            650
        )

        main.Size = UDim2.fromOffset(newX,newY)
    end
end)

--==================================================
-- SCROLL
--==================================================

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1,-20,1,-60)
content.Position = UDim2.fromOffset(10,52)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0,0,0,0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0,5)
padding.PaddingBottom = UDim.new(0,10)
padding.Parent = content

local function makeButton(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,45)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    b.Font = Enum.Font.GothamMedium
    b.Text = text
    b.AutoButtonColor = true
    b.Parent = content

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,9)

    return b
end

--==================================================
-- FLY GUI SEPARADO
-- O HUB SOMENTE ABRE/FECHA A JANELA DO FLY.
--==================================================

local flyEnabled = false
local flySpeed = 2
local flyConnection
local flyWindowVisible = false

local flyOpenButton = makeButton("✈️  ABRIR FLY GUI")

local flyWindow = Instance.new("Frame")
flyWindow.Size = UDim2.fromOffset(250,195)
flyWindow.Position = UDim2.new(0.5,-125,0.5,-97)
flyWindow.BackgroundColor3 = Color3.fromRGB(14,14,14)
flyWindow.BorderSizePixel = 0
flyWindow.Visible = false
flyWindow.ZIndex = 30
flyWindow.Parent = gui
Instance.new("UICorner",flyWindow).CornerRadius = UDim.new(0,16)

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(65,65,65)
flyStroke.Thickness = 1
flyStroke.Parent = flyWindow

local flyHeader = Instance.new("Frame")
flyHeader.Size = UDim2.new(1,0,0,45)
flyHeader.BackgroundColor3 = Color3.fromRGB(24,24,24)
flyHeader.BorderSizePixel = 0
flyHeader.ZIndex = 31
flyHeader.Parent = flyWindow

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(1,-55,1,0)
flyTitle.Position = UDim2.fromOffset(14,0)
flyTitle.BackgroundTransparency = 1
flyTitle.Text = "✈️  FLY GUI"
flyTitle.TextColor3 = Color3.new(1,1,1)
flyTitle.TextSize = 15
flyTitle.Font = Enum.Font.GothamBold
flyTitle.TextXAlignment = Enum.TextXAlignment.Left
flyTitle.ZIndex = 32
flyTitle.Parent = flyHeader

local flyClose = Instance.new("TextButton")
flyClose.Size = UDim2.fromOffset(40,40)
flyClose.Position = UDim2.new(1,-43,0,2)
flyClose.BackgroundTransparency = 1
flyClose.Text = "×"
flyClose.TextColor3 = Color3.new(1,1,1)
flyClose.TextSize = 26
flyClose.Font = Enum.Font.GothamBold
flyClose.ZIndex = 32
flyClose.Parent = flyHeader

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1,-24,0,48)
flyToggle.Position = UDim2.fromOffset(12,57)
flyToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
flyToggle.Text = "✈️  FLY: OFF"
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.TextSize = 15
flyToggle.Font = Enum.Font.GothamBold
flyToggle.ZIndex = 31
flyToggle.Parent = flyWindow
Instance.new("UICorner",flyToggle).CornerRadius = UDim.new(0,11)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,-24,0,22)
speedLabel.Position = UDim2.fromOffset(12,112)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "VELOCIDADE"
speedLabel.TextColor3 = Color3.fromRGB(170,170,170)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 31
speedLabel.Parent = flyWindow

local speedMinus = Instance.new("TextButton")
speedMinus.Size = UDim2.fromOffset(45,36)
speedMinus.Position = UDim2.fromOffset(12,139)
speedMinus.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedMinus.Text = "−"
speedMinus.TextColor3 = Color3.new(1,1,1)
speedMinus.TextSize = 21
speedMinus.Font = Enum.Font.GothamBold
speedMinus.ZIndex = 31
speedMinus.Parent = flyWindow
Instance.new("UICorner",speedMinus).CornerRadius = UDim.new(0,9)

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.fromOffset(112,36)
speedValue.Position = UDim2.fromOffset(61,139)
speedValue.BackgroundColor3 = Color3.fromRGB(24,24,24)
speedValue.Text = "2"
speedValue.TextColor3 = Color3.new(1,1,1)
speedValue.TextSize = 15
speedValue.Font = Enum.Font.GothamBold
speedValue.ZIndex = 31
speedValue.Parent = flyWindow
Instance.new("UICorner",speedValue).CornerRadius = UDim.new(0,9)

local speedPlus = Instance.new("TextButton")
speedPlus.Size = UDim2.fromOffset(45,36)
speedPlus.Position = UDim2.new(1,-57,0,139)
speedPlus.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedPlus.Text = "+"
speedPlus.TextColor3 = Color3.new(1,1,1)
speedPlus.TextSize = 21
speedPlus.Font = Enum.Font.GothamBold
speedPlus.ZIndex = 31
speedPlus.Parent = flyWindow
Instance.new("UICorner",speedPlus).CornerRadius = UDim.new(0,9)

local function stopFly()
    flyEnabled = false
    flyToggle.Text = "✈️  FLY: OFF"

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if humanoid then
        humanoid.PlatformStand = false
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
end

local function startFly()
    if not root or not humanoid then
        return
    end

    if flyConnection then
        flyConnection:Disconnect()
    end

    flyEnabled = true
    flyToggle.Text = "✈️  FLY: ON"
    humanoid.PlatformStand = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not root or not root.Parent or not humanoid then
            return
        end

        local camera = workspace.CurrentCamera
        local move = humanoid.MoveDirection
        local velocity = Vector3.zero

        if move.Magnitude > 0 then
            velocity = move.Unit * (35 * flySpeed)

            local lookY = camera.CFrame.LookVector.Y

            if math.abs(lookY) > 0.15 then
                velocity = velocity + Vector3.new(
                    0,
                    lookY * (30 * flySpeed),
                    0
                )
            end
        end

        root.AssemblyLinearVelocity = velocity
        root.CFrame = CFrame.lookAt(
            root.Position,
            root.Position + camera.CFrame.LookVector
        )
    end)
end

flyToggle.MouseButton1Click:Connect(function()
    if flyEnabled then
        stopFly()
    else
        startFly()
    end
end)

speedMinus.MouseButton1Click:Connect(function()
    flySpeed = math.max(1,flySpeed - 1)
    speedValue.Text = tostring(flySpeed)
end)

speedPlus.MouseButton1Click:Connect(function()
    flySpeed = math.min(10,flySpeed + 1)
    speedValue.Text = tostring(flySpeed)
end)

flyOpenButton.MouseButton1Click:Connect(function()
    flyWindowVisible = not flyWindowVisible
    flyWindow.Visible = flyWindowVisible

    if flyWindowVisible then
        flyOpenButton.Text = "✈️  FECHAR FLY GUI"
    else
        flyOpenButton.Text = "✈️  ABRIR FLY GUI"
    end
end)

flyClose.MouseButton1Click:Connect(function()
    flyWindowVisible = false
    flyWindow.Visible = false
    flyOpenButton.Text = "✈️  ABRIR FLY GUI"
end)

-- Arrastar Fly GUI
local flyDragging = false
local flyDragStart
local flyStartPos

flyHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        flyDragging = true
        flyDragStart = input.Position
        flyStartPos = flyWindow.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                flyDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flyDragging and
       (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - flyDragStart

        flyWindow.Position = UDim2.new(
            flyStartPos.X.Scale,
            flyStartPos.X.Offset + delta.X,
            flyStartPos.Y.Scale,
            flyStartPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- FPS / PING NO TOPO DA TELA
--==================================================

local statsVisible = false
local statsButton = makeButton("📊  MOSTRAR FPS / PING")

local statsOverlay = Instance.new("Frame")
statsOverlay.Size = UDim2.fromOffset(195,42)
statsOverlay.Position = UDim2.new(0.5,-97,0,12)
statsOverlay.BackgroundColor3 = Color3.fromRGB(15,15,15)
statsOverlay.BackgroundTransparency = 0.08
statsOverlay.BorderSizePixel = 0
statsOverlay.Visible = false
statsOverlay.ZIndex = 50
statsOverlay.Parent = gui
Instance.new("UICorner",statsOverlay).CornerRadius = UDim.new(0,12)

local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Color3.fromRGB(65,65,65)
statsStroke.Parent = statsOverlay

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1,-12,1,0)
statsLabel.Position = UDim2.fromOffset(6,0)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "FPS: --  |  PING: -- ms"
statsLabel.TextColor3 = Color3.new(1,1,1)
statsLabel.TextSize = 13
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextXAlignment = Enum.TextXAlignment.Center
statsLabel.ZIndex = 51
statsLabel.Parent = statsOverlay

statsButton.MouseButton1Click:Connect(function()
    statsVisible = not statsVisible
    statsOverlay.Visible = statsVisible

    if statsVisible then
        statsButton.Text = "📊  OCULTAR FPS / PING"
    else
        statsButton.Text = "📊  MOSTRAR FPS / PING"
    end
end)

local frames = 0
local lastFPSUpdate = tick()

RunService.RenderStepped:Connect(function()
    frames = frames + 1

    local now = tick()

    if now - lastFPSUpdate >= 0.5 then
        local fps = math.floor(frames / (now - lastFPSUpdate))

        frames = 0
        lastFPSUpdate = now

        local ping = 0

        pcall(function()
            ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )
        end)

        statsLabel.Text =
            "FPS: " .. fps .. "  |  PING: " .. ping .. " ms"
    end
end)

--==================================================
-- CALCULADORA
--==================================================

local calcButton = makeButton("🧮  ABRIR CALCULADORA")

local calculator = Instance.new("Frame")
calculator.Size = UDim2.fromOffset(335,475)
calculator.Position = UDim2.new(0.5,-167,0.5,-237)
calculator.BackgroundColor3 = Color3.fromRGB(14,14,14)
calculator.BorderSizePixel = 0
calculator.Visible = false
calculator.ZIndex = 20
calculator.Parent = gui
Instance.new("UICorner",calculator).CornerRadius = UDim.new(0,18)

local calcStroke = Instance.new("UIStroke")
calcStroke.Color = Color3.fromRGB(65,65,65)
calcStroke.Thickness = 1
calcStroke.Parent = calculator

local calcTitleBar = Instance.new("Frame")
calcTitleBar.Size = UDim2.new(1,0,0,48)
calcTitleBar.BackgroundColor3 = Color3.fromRGB(23,23,23)
calcTitleBar.BorderSizePixel = 0
calcTitleBar.ZIndex = 21
calcTitleBar.Parent = calculator

local calcTitle = Instance.new("TextLabel")
calcTitle.Size = UDim2.new(1,-55,1,0)
calcTitle.Position = UDim2.fromOffset(15,0)
calcTitle.BackgroundTransparency = 1
calcTitle.Text = "🧮  Calculadora"
calcTitle.TextColor3 = Color3.new(1,1,1)
calcTitle.TextSize = 16
calcTitle.Font = Enum.Font.GothamBold
calcTitle.TextXAlignment = Enum.TextXAlignment.Left
calcTitle.ZIndex = 22
calcTitle.Parent = calcTitleBar

local calcClose = Instance.new("TextButton")
calcClose.Size = UDim2.fromOffset(42,42)
calcClose.Position = UDim2.new(1,-46,0,3)
calcClose.BackgroundTransparency = 1
calcClose.Text = "×"
calcClose.TextColor3 = Color3.new(1,1,1)
calcClose.TextSize = 27
calcClose.Font = Enum.Font.GothamBold
calcClose.ZIndex = 22
calcClose.Parent = calcTitleBar

-- Linha da expressão
local expressionLabel = Instance.new("TextLabel")
expressionLabel.Size = UDim2.new(1,-28,0,28)
expressionLabel.Position = UDim2.fromOffset(14,60)
expressionLabel.BackgroundTransparency = 1
expressionLabel.Text = ""
expressionLabel.TextColor3 = Color3.fromRGB(150,150,150)
expressionLabel.TextSize = 13
expressionLabel.Font = Enum.Font.Gotham
expressionLabel.TextXAlignment = Enum.TextXAlignment.Right
expressionLabel.TextTruncate = Enum.TextTruncate.AtEnd
expressionLabel.ZIndex = 21
expressionLabel.Parent = calculator

-- Display principal
local display = Instance.new("TextLabel")
display.Size = UDim2.new(1,-28,0,58)
display.Position = UDim2.fromOffset(14,86)
display.BackgroundColor3 = Color3.fromRGB(24,24,24)
display.TextColor3 = Color3.new(1,1,1)
display.Text = "0"
display.TextSize = 27
display.Font = Enum.Font.GothamBold
display.TextXAlignment = Enum.TextXAlignment.Right
display.TextTruncate = Enum.TextTruncate.AtEnd
display.ZIndex = 21
display.Parent = calculator
Instance.new("UICorner",display).CornerRadius = UDim.new(0,11)

-- Resultado PREVIEW
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1,-28,0,25)
resultLabel.Position = UDim2.fromOffset(14,148)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Resultado: 0"
resultLabel.TextColor3 = Color3.fromRGB(110,190,130)
resultLabel.TextSize = 14
resultLabel.Font = Enum.Font.GothamMedium
resultLabel.TextXAlignment = Enum.TextXAlignment.Right
resultLabel.TextTruncate = Enum.TextTruncate.AtEnd
resultLabel.ZIndex = 21
resultLabel.Parent = calculator

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1,-28,1,-190)
buttonsFrame.Position = UDim2.fromOffset(14,180)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.ZIndex = 21
buttonsFrame.Parent = calculator

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.23,0,0,49)
grid.CellPadding = UDim2.new(0.025,0,0,8)
grid.Parent = buttonsFrame

local expression = ""

local function calculate(exp)
    if exp == "" then
        return "0"
    end

    -- Aceita somente números e operadores matemáticos.
    if not exp:match("^[%d%+%-%*/%.%(%)%s]+$") then
        return "Erro"
    end

    local ok,result = pcall(function()
        return loadstring("return " .. exp)()
    end)

    if ok and type(result) == "number" and result == result then
        return tostring(result)
    end

    return "Erro"
end

-- Mantém × e ÷ bonitos na tela.
local function displayExpression(exp)
    return exp
        :gsub("%*", "×")
        :gsub("/", "÷")
        :gsub("%-", "−")
end

local function refreshCalculator()
    if expression == "" then
        expressionLabel.Text = ""
         display.Text = "0"
        resultLabel.Text = "Resultado: 0"
        return
    end

    expressionLabel.Text = displayExpression(expression)
    display.Text = displayExpression(expression)

    -- Resultado aparece enquanto digita.
    local preview = calculate(expression)

    if preview ~= "Erro" then
        resultLabel.Text = "Resultado: " .. preview
    else
        resultLabel.Text = "Resultado: —"
    end
end

local calcKeys = {
    "7","8","9","÷",
    "4","5","6","×",
    "1","2","3","−",
    "0",".","(",")",
    "C","⌫","=","+"
}

for _,key in ipairs(calcKeys) do
    local b = Instance.new("TextButton")

    if key == "=" then
        b.BackgroundColor3 = Color3.fromRGB(48,48,48)
    elseif key == "C" or key == "⌫" then
        b.BackgroundColor3 = Color3.fromRGB(38,38,38)
    else
        b.BackgroundColor3 = Color3.fromRGB(29,29,29)
    end

    b.TextColor3 = Color3.new(1,1,1)
    b.Text = key
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.ZIndex = 22
    b.Parent = buttonsFrame

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)

    b.MouseButton1Click:Connect(function()
        if key == "C" then
            expression = ""
            refreshCalculator()

        elseif key == "⌫" then
            expression = expression:sub(1,-2)
            refreshCalculator()

        elseif key == "=" then
            local result = calculate(expression)

            if result ~= "Erro" then
                expression = result
                expressionLabel.Text = ""
                display.Text = result
                resultLabel.Text = "Resultado: " .. result
            else
                resultLabel.Text = "Resultado: Erro"
            end

        else
            local converted = key

            if key == "×" then
                converted = "*"
            elseif key == "÷" then
                converted = "/"
            elseif key == "−" then
                converted = "-"
            end

            expression = expression .. converted
            refreshCalculator()
        end
    end)
end

--==================================================
-- ARRASTAR CALCULADORA
--==================================================

local calcDragging = false
local calcDragStart
local calcStartPos

calcTitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        calcDragging = true
        calcDragStart = input.Position
        calcStartPos = calculator.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                calcDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if calcDragging and
       (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - calcDragStart

        calculator.Position = UDim2.new(
            calcStartPos.X.Scale,
            calcStartPos.X.Offset + delta.X,
            calcStartPos.Y.Scale,
            calcStartPos.Y.Offset + delta.Y
        )
    end
end)

calcButton.MouseButton1Click:Connect(function()
    calculator.Visible = true
end)

calcClose.MouseButton1Click:Connect(function()
    calculator.Visible = false
end)

--==================================================
-- FECHAR / REABRIR HUB
--==================================================

close.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

--==================================================
-- ATUALIZA CANVAS
--==================================================

local function updateCanvas()
    content.CanvasSize = UDim2.fromOffset(
        0,
        layout.AbsoluteContentSize.Y + 15
    )
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateCanvas()
