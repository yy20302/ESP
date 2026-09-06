local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- 加载 Obsidian UI 库
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- ESP 设置
local S = {
    Box = true, Health = true, Fill = false, Dist = true, Name = true,
    HealthMode = "左",
    BT = 0.25, TS = 13, HW = 3,
    BC = Color3.new(1,0,0), FC = Color3.new(.5,.5,.5),
    NC = Color3.new(.7,.7,.7),
    RT = false, RF = false, RB = false, RH = false,
    RS = .3, CG = false, CC = {},
    CornerOnly = false,
    Rounding = 0,
    MultiFill = false,
    MultiFillColor1 = Color3.new(1,0,0),
    MultiFillColor2 = Color3.new(0,0,1),
    BoxGradient = false,
    BoxGradientColor1 = Color3.new(1,0,0),
    BoxGradientColor2 = Color3.new(0,0,1),
    FillGradient = true,
    FillGradientColor1 = Color3.new(1,0,0),
    FillGradientColor2 = Color3.new(0,0,1),
    HealthGradient = true,
    HealthGradientColor1 = Color3.new(0,1,0),
    HealthGradientColor2 = Color3.new(1,0,0),
    BreathEffect = true,
    MaxDistance = 200,
    FadeOutOnDist = true,
}

-- 存储每个玩家的ESP元素表
local playerESP = {}

-- 创建窗口
local Window = Library:CreateWindow({
    Title = "luo_ye",
    Footer = "by luo_ye",
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Home = Window:AddTab("主页", "user"),
    ESP = Window:AddTab("ESP设置", "settings"),
    Color = Window:AddTab("彩色设置", "palette"),
    Color2 = Window:AddTab("彩色设置2", "palette"),
    About = Window:AddTab("关于", "info"),
}

-- 主页玩家信息
pcall(function()
    local HomeInfo = Tabs.Home:AddLeftGroupbox("玩家信息", "user")
    HomeInfo:AddLabel("玩家: " .. LocalPlayer.Name)
    HomeInfo:AddLabel("设备码: " .. game:GetService("RbxAnalyticsService"):GetClientId())
end)

-- 主页 ESP 开关
pcall(function()
    local HomeFunc = Tabs.Home:AddRightGroupbox("ESP功能", "box")
    HomeFunc:AddToggle("ESPBox", { Text = "ESP框架", Default = true, Callback = function(v) S.Box = v end })
    HomeFunc:AddToggle("ESPHealth", { Text = "血量", Default = true, Callback = function(v) S.Health = v end })
    HomeFunc:AddDropdown("ESPHealthMode", {
        Text = "血量模式",
        Values = {"上","下","左","右","圆圈"},
        Default = "左",
        Callback = function(v) S.HealthMode = v end
    })
    HomeFunc:AddToggle("ESPFill", { Text = "填充", Default = false, Callback = function(v) S.Fill = v end })
    HomeFunc:AddToggle("ESPDist", { Text = "距离", Default = true, Callback = function(v) S.Dist = v end })
    HomeFunc:AddToggle("ESPName", { Text = "名字显示", Default = true, Callback = function(v) S.Name = v end })
    HomeFunc:AddDropdown("ESPCorner", {
        Text = "框架绘制方式",
        Values = {"全部绘制","只绘制4个角"},
        Default = "全部绘制",
        Callback = function(v) S.CornerOnly = (v == "只绘制4个角") end
    })
end)

-- ESP 设置标签页
pcall(function()
    local ESPGroup = Tabs.ESP:AddLeftGroupbox("设置", "settings")
    ESPGroup:AddSlider("ESPBT", { Text = "框透明度", Default = 0.25, Min = 0, Max = 1, Rounding = 2, Callback = function(v) S.BT = v end })
    ESPGroup:AddSlider("ESPRounding", { Text = "框圆润度", Default = 0, Min = 0, Max = 30, Rounding = 0, Callback = function(v) S.Rounding = v end })
    ESPGroup:AddSlider("ESPTS", { Text = "字体大小", Default = 13, Min = 10, Max = 20, Rounding = 0, Callback = function(v) S.TS = v end })
    ESPGroup:AddSlider("ESPHW", { Text = "血量宽", Default = 3, Min = 1, Max = 10, Rounding = 0, Callback = function(v) S.HW = v end })
    ESPGroup:AddColorPicker("ESPBC", { Text = "框颜色", Default = S.BC, Callback = function(v) S.BC = v end })
    ESPGroup:AddColorPicker("ESPFC", { Text = "填充颜色", Default = S.FC, Callback = function(v) S.FC = v end })
    ESPGroup:AddColorPicker("ESPNC", { Text = "字体颜色", Default = S.NC, Callback = function(v) S.NC = v end })
end)

-- 彩色设置标签页
pcall(function()
    local ColorGroup = Tabs.Color:AddLeftGroupbox("彩色", "palette")
    ColorGroup:AddToggle("ColorCG", { Text = "自定义渐变", Default = false, Callback = function(v) S.CG = v end })
    ColorGroup:AddToggle("ColorRT", { Text = "彩色名字", Default = false, Callback = function(v) S.RT = v end })
    ColorGroup:AddToggle("ColorRF", { Text = "彩色填充", Default = false, Callback = function(v) S.RF = v end })
    ColorGroup:AddToggle("ColorRB", { Text = "彩色方框", Default = false, Callback = function(v) S.RB = v end })
    ColorGroup:AddToggle("ColorRH", { Text = "彩色血量", Default = false, Callback = function(v) S.RH = v end })
    ColorGroup:AddSlider("ColorRS", { Text = "渐变速度", Default = 0.3, Min = 0.05, Max = 2, Rounding = 2, Callback = function(v) S.RS = v end })
    for i = 1, 5 do
        S.CC[i] = Color3.new(1,1,1)
        ColorGroup:AddColorPicker("ColorCC"..i, { Text = "颜色"..i, Default = S.CC[i], Callback = function(v) S.CC[i] = v end })
    end
end)

-- 彩色设置2标签页
pcall(function()
    local Color2Group = Tabs.Color2:AddLeftGroupbox("渐变设置", "palette")
    Color2Group:AddToggle("BoxGradient", { Text = "框边框渐变", Default = false, Callback = function(v) S.BoxGradient = v end })
    Color2Group:AddColorPicker("BoxGradientColor1", { Text = "边框渐变起始色", Default = S.BoxGradientColor1, Callback = function(v) S.BoxGradientColor1 = v end })
    Color2Group:AddColorPicker("BoxGradientColor2", { Text = "边框渐变结束色", Default = S.BoxGradientColor2, Callback = function(v) S.BoxGradientColor2 = v end })
    Color2Group:AddToggle("FillGradient", { Text = "填充渐变", Default = true, Callback = function(v) S.FillGradient = v end })
    Color2Group:AddColorPicker("FillGradientColor1", { Text = "填充渐变起始色", Default = S.FillGradientColor1, Callback = function(v) S.FillGradientColor1 = v end })
    Color2Group:AddColorPicker("FillGradientColor2", { Text = "填充渐变结束色", Default = S.FillGradientColor2, Callback = function(v) S.FillGradientColor2 = v end })
    Color2Group:AddToggle("HealthGradient", { Text = "血量条渐变", Default = true, Callback = function(v) S.HealthGradient = v end })
    Color2Group:AddColorPicker("HealthGradientColor1", { Text = "血量渐变起始色", Default = S.HealthGradientColor1, Callback = function(v) S.HealthGradientColor1 = v end })
    Color2Group:AddColorPicker("HealthGradientColor2", { Text = "血量渐变结束色", Default = S.HealthGradientColor2, Callback = function(v) S.HealthGradientColor2 = v end })
    Color2Group:AddToggle("BreathEffect", { Text = "呼吸效果", Default = true, Callback = function(v) S.BreathEffect = v end })
end)

-- 关于标签页
pcall(function()
    Tabs.About:AddLeftGroupbox("关于", "info"):AddLabel("作者: luo_ye")
end)

-- 默认渐变色板
local DefaultGradient = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(255,128,0), Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,128,255), Color3.fromRGB(128,0,255),
    Color3.fromRGB(255,0,255)
}

-- 获取平滑渐变颜色（可加入呼吸效果）
local function getGradientColor(offset)
    offset = offset or 0
    local colors
    if S.CG then
        colors = {}
        for _, v in pairs(S.CC) do table.insert(colors, v) end
        if #colors == 0 then colors = DefaultGradient end
    else
        colors = DefaultGradient
    end
    local count = #colors
    if count == 0 then return Color3.new(1,1,1) end
    if count == 1 then return colors[1] end
    local t = (tick() * S.RS + offset) % count
    local idx = math.floor(t) + 1
    local nextIdx = idx + 1
    if nextIdx > count then nextIdx = 1 end
    local alpha = t - math.floor(t)
    local color = colors[idx]:Lerp(colors[nextIdx], alpha)
    if S.BreathEffect then
        local breathe = math.atan(math.sin(tick() * 2)) * 2 / math.pi
        color = color:Lerp(Color3.new(1,1,1), breathe * 0.15)
    end
    return color
end

-- 血量颜色
local function getHealthColor(hp)
    if hp > 0.5 then
        return Color3.new(0,1,0):Lerp(Color3.new(1,1,0),(1-hp)*2)
    else
        return Color3.new(1,1,0):Lerp(Color3.new(1,0,0),(0.5-hp)*2)
    end
end

-- 世界坐标转屏幕坐标
local function worldToScreen(pos)
    local rel = Camera.CFrame:PointToObjectSpace(pos)
    if rel.Z > 0 then return nil end
    local fov = math.rad(Camera.FieldOfView)
    local vs = Camera.ViewportSize
    local h = 2 * -rel.Z * math.tan(fov / 2)
    local w = h * (vs.X / vs.Y)
    return Vector2.new((rel.X / w) * vs.X + vs.X / 2, -(rel.Y / h) * vs.Y + vs.Y / 2)
end

-- 删除 Roblox 自带名字
local function removeNameTag(char)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                    child:Destroy()
                end
            end
        end
    end
end

-- 为玩家创建ESP GUI元素
local function createESP(player)
    local holder = Instance.new("ScreenGui")
    holder.Name = player.Name
    holder.Parent = CoreGui
    holder.IgnoreGuiInset = true

    local elements = {
        Holder = holder,
        Box = nil,
        BoxStroke = nil,
        Fill = nil,
        FillGradient = nil,
        Healthbar = nil,
        HealthbarGradient = nil,
        HealthbarBG = nil,
        HealthText = nil,
        Name = nil,
        Distance = nil,
        Corners = {},
    }

    -- 框
    elements.Box = Instance.new("Frame")
    elements.Box.BackgroundTransparency = 1
    elements.Box.BorderSizePixel = 0
    elements.Box.Parent = holder
    elements.BoxStroke = Instance.new("UIStroke")
    elements.BoxStroke.Parent = elements.Box
    elements.BoxStroke.Thickness = 2

    -- 填充
    elements.Fill = Instance.new("Frame")
    elements.Fill.BackgroundTransparency = S.BT
    elements.Fill.BackgroundColor3 = S.FC
    elements.Fill.BorderSizePixel = 0
    elements.Fill.Parent = elements.Box
    elements.FillGradient = Instance.new("UIGradient")
    elements.FillGradient.Parent = elements.Fill

    -- 血量条
    elements.HealthbarBG = Instance.new("Frame")
    elements.HealthbarBG.BackgroundTransparency = 0.5
    elements.HealthbarBG.BackgroundColor3 = Color3.new(0,0,0)
    elements.HealthbarBG.BorderSizePixel = 0
    elements.HealthbarBG.Parent = holder
    elements.Healthbar = Instance.new("Frame")
    elements.Healthbar.BackgroundTransparency = 0
    elements.Healthbar.BorderSizePixel = 0
    elements.Healthbar.Parent = elements.HealthbarBG
    elements.HealthbarGradient = Instance.new("UIGradient")
    elements.HealthbarGradient.Rotation = -90
    elements.HealthbarGradient.Parent = elements.Healthbar

    -- 血量文字
    elements.HealthText = Instance.new("TextLabel")
    elements.HealthText.BackgroundTransparency = 1
    elements.HealthText.TextColor3 = S.NC
    elements.HealthText.Font = Enum.Font.SourceSans
    elements.HealthText.TextSize = S.TS
    elements.HealthText.Parent = holder

    -- 名字
    elements.Name = Instance.new("TextLabel")
    elements.Name.BackgroundTransparency = 1
    elements.Name.TextColor3 = S.NC
    elements.Name.Font = Enum.Font.SourceSans
    elements.Name.TextSize = S.TS
    elements.Name.Parent = holder

    -- 距离
    elements.Distance = Instance.new("TextLabel")
    elements.Distance.BackgroundTransparency = 1
    elements.Distance.TextColor3 = S.NC
    elements.Distance.Font = Enum.Font.SourceSans
    elements.Distance.TextSize = S.TS
    elements.Distance.Parent = holder

    -- 四角框（8个Frame作为线条）
    for i = 1, 8 do
        local corner = Instance.new("Frame")
        corner.BorderSizePixel = 0
        corner.Parent = holder
        table.insert(elements.Corners, corner)
    end

    playerESP[player] = elements
end

-- 更新ESP
local function updateESP(player)
    local e = playerESP[player]
    if not e then return end
    local char = player.Character
    if not char then
        e.Holder.Enabled = false
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not head or not hum then
        e.Holder.Enabled = false
        return
    end

    if S.Name then removeNameTag(char) end

    local top = worldToScreen(Vector3.new(root.Position.X, head.Position.Y + 2.5, root.Position.Z))
    local bottom = worldToScreen(Vector3.new(root.Position.X, root.Position.Y - 4, root.Position.Z))
    if not top or not bottom then
        e.Holder.Enabled = false
        return
    end

    local dist = (Camera.CFrame.Position - root.Position).Magnitude
    if dist > S.MaxDistance then
        e.Holder.Enabled = false
        return
    end

    local screenHeight = math.abs(bottom.Y - top.Y)
    local screenWidth = screenHeight * 0.65
    local posX = top.X - screenWidth / 2
    local posY = top.Y

    -- 距离淡出
    local fade = 1
    if S.FadeOutOnDist then
        fade = math.clamp(1 - (dist / S.MaxDistance), 0.1, 1)
    end
    local overallTransparency = 1 - fade

    -- 设置Holder可见
    e.Holder.Enabled = true

    -- 框
    if S.Box then
        e.Box.Visible = true
        e.Box.Position = UDim2.new(0, posX, 0, posY)
        e.Box.Size = UDim2.new(0, screenWidth, 0, screenHeight)
        e.Box.BackgroundTransparency = 1  -- 框本身透明，只用边框
        e.BoxStroke.Enabled = true
        e.BoxStroke.Transparency = overallTransparency

        if S.BoxGradient then
            e.BoxStroke.Color = S.BoxGradientColor1
            -- 边框渐变需要额外UIGradient，但UIStroke不支持直接加UIGradient，我们创建渐变到Box本身
            local gradient = e.Box:FindFirstChildOfClass("UIGradient")
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Parent = e.Box
            end
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, S.BoxGradientColor1),
                ColorSequenceKeypoint.new(1, S.BoxGradientColor2)
            }
            e.BoxStroke.Color = Color3.new(1,1,1)
        else
            local gradient = e.Box:FindFirstChildOfClass("UIGradient")
            if gradient then gradient:Destroy() end
            if S.RB then
                e.BoxStroke.Color = getGradientColor(0)
            else
                e.BoxStroke.Color = S.BC
            end
        end
    else
        e.Box.Visible = false
    end

    -- 四角框
    if S.CornerOnly and S.Box then
        e.Box.Visible = false  -- 隐藏完整框
        local cornerLength = screenWidth * 0.25
        local cornerThickness = 2
        local cornerColor
        if S.RB then
            cornerColor = getGradientColor(0)
        else
            cornerColor = S.BC
        end
        -- 8个角线段
        local positions = {
            {Vector2.new(posX, posY + screenHeight*0.15), Vector2.new(posX, posY)},
            {Vector2.new(posX, posY), Vector2.new(posX + cornerLength, posY)},
            {Vector2.new(posX + screenWidth - cornerLength, posY), Vector2.new(posX + screenWidth, posY)},
            {Vector2.new(posX + screenWidth, posY), Vector2.new(posX + screenWidth, posY + screenHeight*0.15)},
            {Vector2.new(posX, posY + screenHeight - screenHeight*0.15), Vector2.new(posX, posY + screenHeight)},
            {Vector2.new(posX, posY + screenHeight), Vector2.new(posX + cornerLength, posY + screenHeight)},
            {Vector2.new(posX + screenWidth - cornerLength, posY + screenHeight), Vector2.new(posX + screenWidth, posY + screenHeight)},
            {Vector2.new(posX + screenWidth, posY + screenHeight), Vector2.new(posX + screenWidth, posY + screenHeight - screenHeight*0.15)},
        }
        for i = 1, 8 do
            local corner = e.Corners[i]
            corner.BackgroundColor3 = cornerColor
            corner.BackgroundTransparency = overallTransparency
            corner.Position = UDim2.new(0, positions[i][1].X, 0, positions[i][1].Y)
            local sizeX = math.abs(positions[i][2].X - positions[i][1].X)
            local sizeY = math.abs(positions[i][2].Y - positions[i][1].Y)
            if sizeX < 1 then sizeX = cornerThickness end
            if sizeY < 1 then sizeY = cornerThickness end
            corner.Size = UDim2.new(0, sizeX, 0, sizeY)
            corner.Visible = true
        end
    else
        for _, corner in pairs(e.Corners) do
            corner.Visible = false
        end
    end

    -- 填充
    if S.Fill and not S.CornerOnly then
        e.Fill.Visible = true
        e.Fill.Position = UDim2.new(0, posX, 0, posY)
        e.Fill.Size = UDim2.new(0, screenWidth, 0, screenHeight)
        e.Fill.BackgroundTransparency = S.BT + overallTransparency * 0.5
        if S.FillGradient or S.RF then
            e.FillGradient.Enabled = true
            if S.RF then
                -- 动态彩虹渐变
                local c1 = getGradientColor(0)
                local c2 = getGradientColor(0.5)
                e.FillGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, c1),
                    ColorSequenceKeypoint.new(1, c2)
                }
            else
                e.FillGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, S.FillGradientColor1),
                    ColorSequenceKeypoint.new(1, S.FillGradientColor2)
                }
            end
            e.Fill.BackgroundColor3 = Color3.new(1,1,1)
        else
            e.FillGradient.Enabled = false
            e.Fill.BackgroundColor3 = S.FC
        end
    else
        e.Fill.Visible = false
    end

    -- 血量
    local hp = hum.Health / hum.MaxHealth
    if S.Health then
        if S.HealthMode == "圆圈" then
            -- 保留Drawing圆圈（或使用ImageLabel，但这里简化隐藏条，用Drawing）
            -- 我们暂时禁用条并绘制圆圈（需要Drawing）
            e.HealthbarBG.Visible = false
            e.Healthbar.Visible = false
            e.HealthText.Visible = true
            -- 使用之前Drawing的圆圈逻辑
            -- 省略，用户可自行添加
        else
            e.HealthbarBG.Visible = true
            e.Healthbar.Visible = true
            e.HealthText.Visible = true
            local barWidth = S.HW
            local barHeight = screenHeight * hp
            local barX, barY
            if S.HealthMode == "左" then
                barX = posX - barWidth - 4
                barY = posY + screenHeight - barHeight
                e.HealthbarBG.Position = UDim2.new(0, barX, 0, posY)
                e.HealthbarBG.Size = UDim2.new(0, barWidth, 0, screenHeight)
                e.Healthbar.Position = UDim2.new(0, 0, 0, screenHeight - barHeight)
                e.Healthbar.Size = UDim2.new(1, 0, 0, barHeight)
            elseif S.HealthMode == "右" then
                barX = posX + screenWidth + 4
                barY = posY + screenHeight - barHeight
                e.HealthbarBG.Position = UDim2.new(0, barX, 0, posY)
                e.HealthbarBG.Size = UDim2.new(0, barWidth, 0, screenHeight)
                e.Healthbar.Position = UDim2.new(0, 0, 0, screenHeight - barHeight)
                e.Healthbar.Size = UDim2.new(1, 0, 0, barHeight)
            elseif S.HealthMode == "上" then
                barX = posX
                barY = posY - barWidth - 4
                e.HealthbarBG.Position = UDim2.new(0, barX, 0, barY)
                e.HealthbarBG.Size = UDim2.new(0, screenWidth, 0, barWidth)
                e.Healthbar.Position = UDim2.new(0, 0, 0, 0)
                e.Healthbar.Size = UDim2.new(0, screenWidth * hp, 1, 0)
            elseif S.HealthMode == "下" then
                barX = posX
                barY = posY + screenHeight + 4
                e.HealthbarBG.Position = UDim2.new(0, barX, 0, barY)
                e.HealthbarBG.Size = UDim2.new(0, screenWidth, 0, barWidth)
                e.Healthbar.Position = UDim2.new(0, 0, 0, 0)
                e.Healthbar.Size = UDim2.new(0, screenWidth * hp, 1, 0)
            end

            -- 血量渐变
            if S.HealthGradient or S.RH then
                e.HealthbarGradient.Enabled = true
                if S.RH then
                    local c1 = getGradientColor(0)
                    local c2 = getGradientColor(0.5)
                    e.HealthbarGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, c1),
                        ColorSequenceKeypoint.new(1, c2)
                    }
                else
                    e.HealthbarGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, S.HealthGradientColor1),
                        ColorSequenceKeypoint.new(1, S.HealthGradientColor2)
                    }
                end
                e.Healthbar.BackgroundColor3 = Color3.new(1,1,1)
            else
                e.HealthbarGradient.Enabled = false
                e.Healthbar.BackgroundColor3 = getHealthColor(hp)
            end

            -- 血量文字
            e.HealthText.Text = tostring(math.floor(hp * 100))
            e.HealthText.Position = UDim2.new(0, barX + barWidth/2, 0, barY - 15)
            e.HealthText.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    else
        e.HealthbarBG.Visible = false
        e.HealthText.Visible = false
    end

    -- 名字
    if S.Name then
        e.Name.Visible = true
        e.Name.Text = player.Name
        e.Name.Position = UDim2.new(0, posX + screenWidth/2, 0, posY - 20)
        e.Name.AnchorPoint = Vector2.new(0.5, 0.5)
        e.Name.TextTransparency = overallTransparency
        if S.RT then
            e.Name.TextColor3 = getGradientColor(0.8)
        else
            e.Name.TextColor3 = S.NC
        end
    else
        e.Name.Visible = false
    end

    -- 距离
    if S.Dist then
        e.Distance.Visible = true
        e.Distance.Text = string.format("%.0fm", dist)
        e.Distance.Position = UDim2.new(0, posX + screenWidth/2, 0, posY + screenHeight + 5)
        e.Distance.AnchorPoint = Vector2.new(0.5, 0)
        e.Distance.TextTransparency = overallTransparency
        e.Distance.TextColor3 = S.NC
    else
        e.Distance.Visible = false
    end
end

-- 初始化所有玩家
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
        updateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    local e = playerESP[player]
    if e then
        e.Holder:Destroy()
        playerESP[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, e in pairs(playerESP) do
        updateESP(player)
    end
end)
