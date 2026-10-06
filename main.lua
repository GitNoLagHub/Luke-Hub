--// DARK MOBILE HUB - LUMBER TYCOON 2
--// Feito para uso no seu próprio jogo
--// Compatível com execução Lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- CONFIG
--==================================================

local flyEnabled = false
local flySpeed = 1
local flyConnection
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

player.CharacterAdded:Connect(setupCharacter)

--==================================================
-- GUI
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

Instance.new("UICorner", reopen).CornerRadius = UDim.new(0,12)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330,390)
main.Position = UDim2.new(0.5,-165,0.5,-195)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

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
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart

    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

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
        updateDrag(input)
    end
end)

--==================================================
-- RESIZE
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
            300,
            600
        )

        main.Size = UDim2.fromOffset(newX,newY)
    end
end)

--==================================================
-- SCROLLING
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

--==================================================
-- FUNÇÃO BOTÃO
--==================================================

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
-- FLY
--==================================================

local flyButton = makeButton("✈️  FLY: OFF")
local speedButton = makeButton("⚡ VELOCIDADE: 1")

local function stopFly()
    flyEnabled = false
    flyButton.Text = "✈️  FLY: OFF"

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function startFly()
    if not root or not humanoid then
        return
    end

    flyEnabled = true
    flyButton.Text = "✈️  FLY: ON"

    humanoid.PlatformStand = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not root or not root.Parent then
            return
        end

        local move = humanoid.MoveDirection

        if move.Magnitude > 0 then
            root.AssemblyLinearVelocity = move * (45 * flySpeed)
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end

        root.CFrame = CFrame.new(
            root.Position,
            root.Position + camera.CFrame.LookVector
        )
    end)
end

flyButton.MouseButton1Click:Connect(function()
    if flyEnabled then
        stopFly()
    else
        startFly()
    end
end)

speedButton.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 1
    speedButton.Text = "⚡ VELOCIDADE: " .. tostring(flySpeed)
end)

--==================================================
-- FPS / PING
--==================================================

local statsButton = makeButton("📊 FPS: --  |  PING: -- ms")

local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frames = frames + 1

    local now = tick()

    if now - lastTime >= 1 then
        local fps = frames
        frames = 0
        lastTime = now

        local ping = 0

        pcall(function()
            ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )
        end)

        statsButton.Text =
            "📊 FPS: " .. fps .. "  |  PING: " .. ping .. " ms"
    end
end)

--==================================================
-- CALCULADORA
--==================================================

local calcButton = makeButton("🧮 ABRIR CALCULADORA")

local calculator = Instance.new("Frame")
calculator.Size = UDim2.fromOffset(300,390)
calculator.Position = UDim2.new(0.5,-150,0.5,-195)
calculator.BackgroundColor3 = Color3.fromRGB(16,16,16)
calculator.BorderSizePixel = 0
calculator.Visible = false
calculator.ZIndex = 20
calculator.Parent = gui

Instance.new("UICorner",calculator).CornerRadius = UDim.new(0,14)

local calcStroke = Instance.new("UIStroke")
calcStroke.Color = Color3.fromRGB(60,60,60)
calcStroke.Parent = calculator

local calcTitle = Instance.new("TextLabel")
calcTitle.Size = UDim2.new(1,-45,0,42)
calcTitle.Position = UDim2.fromOffset(12,0)
calcTitle.BackgroundTransparency = 1
calcTitle.Text = "🧮 Calculadora"
calcTitle.TextColor3 = Color3.new(1,1,1)
calcTitle.TextSize = 16
calcTitle.Font = Enum.Font.GothamBold
calcTitle.TextXAlignment = Enum.TextXAlignment.Left
calcTitle.ZIndex = 21
calcTitle.Parent = calculator

local calcClose = Instance.new("TextButton")
calcClose.Size = UDim2.fromOffset(40,40)
calcClose.Position = UDim2.new(1,-43,0,2)
calcClose.BackgroundTransparency = 1
calcClose.Text = "×"
calcClose.TextColor3 = Color3.new(1,1,1)
calcClose.TextSize = 25
calcClose.ZIndex = 21
calcClose.Parent = calculator

local display = Instance.new("TextLabel")
display.Size = UDim2.new(1,-20,0,55)
display.Position = UDim2.fromOffset(10,48)
display.BackgroundColor3 = Color3.fromRGB(25,25,25)
display.TextColor3 = Color3.new(1,1,1)
display.Text = "0"
display.TextSize = 24
display.Font = Enum.Font.Gotham
display.TextXAlignment = Enum.TextXAlignment.Right
display.ZIndex = 21
display.Parent = calculator

Instance.new("UICorner",display).CornerRadius = UDim.new(0,8)

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1,-20,1,-115)
buttonsFrame.Position = UDim2.fromOffset(10,110)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.ZIndex = 21
buttonsFrame.Parent = calculator

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.23,0,0.18,0)
grid.CellPadding = UDim2.new(0.025,0,0.025,0)
grid.Parent = buttonsFrame

local expression = ""

local function calculate(exp)
    if exp == "" then
        return "0"
    end

    if not exp:match("^[%d%+%-%*/%.%(%)%s]+$") then
        return "Erro"
    end

    local ok,result = pcall(function()
        return loadstring("return " .. exp)()
    end)

    if ok and type(result) == "number" then
        return tostring(result)
    end

    return "Erro"
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
    b.BackgroundColor3 = Color3.fromRGB(32,32,32)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = key
    b.TextSize = 18
    b.Font = Enum.Font.GothamMedium
    b.ZIndex = 22
    b.Parent = buttonsFrame

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

    b.MouseButton1Click:Connect(function()
        if key == "C" then
            expression = ""
            display.Text = "0"

        elseif key == "⌫" then
            expression = expression:sub(1,-2)

            if expression == "" then
                display.Text = "0"
            else
                display.Text = expression
            end

        elseif key == "=" then
            local result = calculate(expression)
            display.Text = result

            if result ~= "Erro" then
                expression = result
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
            display.Text = expression
        end
    end)
end

--==================================================
-- DRAG DA CALCULADORA
--==================================================

local calcDragging = false
local calcDragStart
local calcStartPos

calcTitle.InputBegan:Connect(function(input)
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

--==================================================
-- ABRIR / FECHAR CALCULADORA
--==================================================

calcButton.MouseButton1Click:Connect(function()
    calculator.Visible = true
end)

calcClose.MouseButton1Click:Connect(function()
    calculator.Visible = false
end)

--==================================================
-- MENU FECHAR / REABRIR
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

]])
