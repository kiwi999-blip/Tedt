local OrionLibV2 = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local STYLE = {
    Colors = {
        Primary = Color3.fromRGB(40, 40, 40),
        Secondary = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 170, 0),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(80, 80, 80),
        Hover = Color3.fromRGB(60, 60, 60)
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        SubTitle = Enum.Font.Gotham,
        Body = Enum.Font.Gotham,
        Button = Enum.Font.Gotham
    },
    Sizes = {
        Title = 20,
        SubTitle = 14,
        Body = 14,
        Button = 14
    },
    CornerRadius = 6,
    StrokeThickness = 1.5,
    AnimationDuration = 0.2,
    AnimationEasing = Enum.EasingStyle.Quad
}

local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function applyTheme(instance, themeType)
    if themeType == "Window" then
        instance.BackgroundColor3 = STYLE.Colors.Secondary
        local stroke = createInstance("UIStroke", {
            Parent = instance,
            Thickness = STYLE.StrokeThickness,
            Color = STYLE.Colors.Border,
            Transparency = 0.4
        })
        local gradient = createInstance("UIGradient", {
            Parent = instance,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, STYLE.Colors.Primary),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
            },
            Rotation = 90
        })
        createInstance("UICorner", {
            Parent = instance,
            CornerRadius = UDim.new(0, STYLE.CornerRadius)
        })
    elseif themeType == "Button" then
        instance.BackgroundColor3 = STYLE.Colors.Primary
        instance.TextColor3 = STYLE.Colors.Text
        instance.Font = STYLE.Fonts.Button
        instance.TextSize = STYLE.Sizes.Button
        createInstance("UICorner", {
            Parent = instance,
            CornerRadius = UDim.new(0, STYLE.CornerRadius)
        })
    end
end

local function createTextLabel(parent, text, size, position, options)
    options = options or {}
    local label = createInstance("TextLabel", {
        Parent = parent,
        Text = text,
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        TextColor3 = options.Color or STYLE.Colors.Text,
        Font = options.Font or STYLE.Fonts.Body,
        TextSize = options.TextSize or STYLE.Sizes.Body,
        TextXAlignment = options.XAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.YAlignment or Enum.TextYAlignment.Center,
        TextWrapped = options.Wrapped or false,
        TextTransparency = options.Transparency or 0,
        ZIndex = options.ZIndex or 1
    })
    return label
end

local function createButton(parent, size, position, text, callback)
    local button = createInstance("TextButton", {
        Parent = parent,
        Size = size,
        Position = position,
        Text = text,
        AutoButtonColor = false,
        BackgroundColor3 = STYLE.Colors.Primary,
        TextColor3 = STYLE.Colors.Text,
        Font = STYLE.Fonts.Button,
        TextSize = STYLE.Sizes.Button
    })
    
    createInstance("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, STYLE.CornerRadius)
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(STYLE.AnimationDuration), {
            BackgroundColor3 = STYLE.Colors.Hover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(STYLE.AnimationDuration), {
            BackgroundColor3 = STYLE.Colors.Primary
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
    
    return button
end

function OrionLibV2:MakeWindow(info)
    info = info or {}
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return nil end
    
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
    if not PlayerGui then return nil end
    
    local ScreenGui = createInstance("ScreenGui", {
        Parent = PlayerGui,
        Name = "OrionLibV2UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local window = createInstance("Frame", {
        Parent = ScreenGui,
        Name = "MainWindow",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Active = true,
        Draggable = true
    })
    applyTheme(window, "Window")
    
    local title = createTextLabel(window, info.Title or "Orion", 
        UDim2.new(0, 300, 0, 30), UDim2.new(0, 10, 0, 5), {
            Font = STYLE.Fonts.Title,
            TextSize = STYLE.Sizes.Title,
            Color = STYLE.Colors.Text
        })
    
    local subtitle = createTextLabel(window, info.SubTitle or "Orion Subtitle", 
        UDim2.new(0, 300, 0, 20), UDim2.new(0, 10, 0, 35), {
            Font = STYLE.Fonts.SubTitle,
            TextSize = STYLE.Sizes.SubTitle,
            Color = STYLE.Colors.SubText
        })
    
    local separator = createInstance("Frame", {
        Parent = window,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundColor3 = STYLE.Colors.Border,
        BorderSizePixel = 0
    })
    
    local verticalLine = createInstance("Frame", {
        Parent = window,
        Size = UDim2.new(0, 1, 1, -80),
        Position = UDim2.new(0, 135, 0, 70),
        BackgroundColor3 = STYLE.Colors.Border,
        BorderSizePixel = 0
    })
    
    local tabScrollFrame = createInstance("ScrollingFrame", {
        Parent = window,
        Size = UDim2.new(0, 120, 1, -80),
        Position = UDim2.new(0, 10, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = STYLE.Colors.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    })
    
    local buttonY = 0
    local tabs = {}
    local tabList = {}
    
    function tabs:MakeTab(tabInfo)
        tabInfo = tabInfo or {}
        
        local button = createInstance("TextButton", {
            Parent = tabScrollFrame,
            Size = UDim2.new(0, 120, 0, 30),
            Position = UDim2.new(0, 0, 0, buttonY),
            BackgroundColor3 = STYLE.Colors.Primary,
            TextColor3 = STYLE.Colors.Text,
            Font = STYLE.Fonts.Body,
            TextSize = STYLE.Sizes.Body,
            AutoButtonColor = false,
            Text = tabInfo.Name or "Tab"
        })
        
        createInstance("UICorner", {
            Parent = button,
            CornerRadius = UDim.new(0, STYLE.CornerRadius)
        })
        
        local textSize = TextService:GetTextSize(
            button.Text, 
            STYLE.Sizes.Body, 
            STYLE.Fonts.Body, 
            Vector2.new(110, math.huge)
        )
        
        if textSize.Y > 30 then
            button.Size = UDim2.new(0, 120, 0, math.ceil(textSize.Y) + 10)
        end
        
        buttonY = buttonY + button.Size.Y.Offset + 5
        tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, buttonY)
        
        local tabContent = createInstance("ScrollingFrame", {
            Parent = window,
            Name = tabInfo.Name or "TabContent",
            Size = UDim2.new(1, -150, 1, -80),
            Position = UDim2.new(0, 140, 0, 70),
            BackgroundTransparency = 1,
            Visible = (#tabList == 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = STYLE.Colors.Border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        })
        
        table.insert(tabList, tabContent)
        
        button.MouseButton1Click:Connect(function()
            for _, frame in ipairs(tabList) do frame.Visible = false end
            tabContent.Visible = true
            
            for _, btn in ipairs(tabScrollFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(STYLE.AnimationDuration), {
                        BackgroundColor3 = STYLE.Colors.Primary
                    }):Play()
                end
            end
            
            TweenService:Create(button, TweenInfo.new(STYLE.AnimationDuration), {
                BackgroundColor3 = STYLE.Colors.Hover
            }):Play()
        end)
        
        local elementY = 0
        local tabFunctions = {}
        
        local function addElement(createFunction)
            local success, element = pcall(createFunction)
            if success and element then
                elementY = elementY + element.Size.Y.Offset + 10
                tabContent.CanvasSize = UDim2.new(0, 0, 0, elementY)
                return element
            end
            return nil
        end
        
        function tabFunctions:AddSection(sectionInfo)
            return addElement(function()
                sectionInfo = sectionInfo or {}
                local container = createInstance("Frame", {
                    Parent = tabContent,
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 10, 0, elementY + 20),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                })
                
                local nameLabel = createTextLabel(container, sectionInfo.Name or "Section", 
                    UDim2.new(1, -10, 0, 25), UDim2.new(0, 0, 0, 0), {
                        Font = STYLE.Fonts.Title,
                        TextSize = 16,
                        Color = STYLE.Colors.SubText
                    })
                
                return container
            end)
        end
        
        function tabFunctions:AddLabel(labelInfo)
            return addElement(function()
                labelInfo = labelInfo or {}
                local container = createInstance("Frame", {
                    Parent = tabContent,
                    Size = UDim2.new(1, -20, 0, 50),
                    Position = UDim2.new(0, 10, 0, elementY),
                    BackgroundColor3 = STYLE.Colors.Primary,
                    BackgroundTransparency = 0.8
                })
                
                createInstance("UICorner", {
                    Parent = container,
                    CornerRadius = UDim.new(0, STYLE.CornerRadius)
                })
                
                createInstance("UIStroke", {
                    Parent = container,
                    Color = STYLE.Colors.Border,
                    Thickness = STYLE.StrokeThickness
                })
                
                local nameLabel = createTextLabel(container, labelInfo.Name or "Label", 
                    UDim2.new(1, -10, 0.5, 0), UDim2.new(0, 10, 0, 0), {
                        Font = STYLE.Fonts.Body,
                        TextSize = STYLE.Sizes.Body,
                        Color = STYLE.Colors.Text
                    })
                
                if labelInfo.Description then
                    local descLabel = createTextLabel(container, labelInfo.Description, 
                        UDim2.new(1, -10, 0.5, 0), UDim2.new(0, 10, 0.5, 0), {
                            Font = STYLE.Fonts.Body,
                            TextSize = STYLE.Sizes.SubTitle,
                            Color = STYLE.Colors.SubText
                        })
                end
                
                return container
            end)
        end
        
        function tabFunctions:AddButton(buttonInfo)
            return addElement(function()
                buttonInfo = buttonInfo or {}
                local container = createInstance("Frame", {
                    Parent = tabContent,
                    Size = UDim2.new(1, -20, 0, 50),
                    Position = UDim2.new(0, 10, 0, elementY),
                    BackgroundColor3 = STYLE.Colors.Primary,
                    BackgroundTransparency = 0.8
                })
                
                createInstance("UICorner", {
                    Parent = container,
                    CornerRadius = UDim.new(0, STYLE.CornerRadius)
                })
                
                createInstance("UIStroke", {
                    Parent = container,
                    Color = STYLE.Colors.Border,
                    Thickness = STYLE.StrokeThickness
                })
                
                local button = createButton(container, 
                    UDim2.new(1, 0, 1, 0), 
                    UDim2.new(0, 0, 0, 0),
                    buttonInfo.Name or "Button",
                    buttonInfo.Callback)
                
                if buttonInfo.Description then
                    local descLabel = createTextLabel(container, buttonInfo.Description, 
                        UDim2.new(1, -10, 0.5, 0), UDim2.new(0, 10, 0.5, 0), {
                            Font = STYLE.Fonts.Body,
                            TextSize = STYLE.Sizes.SubTitle,
                            Color = STYLE.Colors.SubText
                        })
                end
                
                return container
            end)
        end
        
        function tabFunctions:AddToggle(toggleInfo)
            return addElement(function()
                toggleInfo = toggleInfo or {}
                local container = createInstance("Frame", {
                    Parent = tabContent,
                    Size = UDim2.new(1, -20, 0, 50),
                    Position = UDim2.new(0, 10, 0, elementY),
                    BackgroundColor3 = STYLE.Colors.Primary,
                    BackgroundTransparency = 0.8
                })
                
                createInstance("UICorner", {
                    Parent = container,
                    CornerRadius = UDim.new(0, STYLE.CornerRadius)
                })
                
                createInstance("UIStroke", {
                    Parent = container,
                    Color = STYLE.Colors.Border,
                    Thickness = STYLE.StrokeThickness
                })
                
                local nameLabel = createTextLabel(container, toggleInfo.Name or "Toggle", 
                    UDim2.new(1, -70, 0.5, 0), UDim2.new(0, 10, 0, 0), {
                        Font = STYLE.Fonts.Body,
                        TextSize = STYLE.Sizes.Body,
                        Color = STYLE.Colors.Text
                    })
                
                if toggleInfo.Description then
                    local descLabel = createTextLabel(container, toggleInfo.Description, 
                        UDim2.new(1, -70, 0.5, 0), UDim2.new(0, 10, 0.5, 0), {
                            Font = STYLE.Fonts.Body,
                            TextSize = STYLE.Sizes.SubTitle,
                            Color = STYLE.Colors.SubText
                        })
                end
                
                local toggleButton = createInstance("TextButton", {
                    Parent = container,
                    Size = UDim2.new(0, 50, 0, 24),
                    Position = UDim2.new(1, -60, 0.5, -12),
                    BackgroundColor3 = STYLE.Colors.Primary,
                    AutoButtonColor = false,
                    Text = ""
                })
                
                createInstance("UICorner", {
                    Parent = toggleButton,
                    CornerRadius = UDim.new(0, 12)
                })
                
                local toggleIndicator = createInstance("Frame", {
                    Parent = toggleButton,
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = STYLE.Colors.Text,
                    AnchorPoint = Vector2.new(0, 0.5)
                })
                
                createInstance("UICorner", {
                    Parent = toggleIndicator,
                    CornerRadius = UDim.new(0, 10)
                })
                
                local isOn = toggleInfo.Default or false
                
                local function updateToggle()
                    local targetPosition = isOn and UDim2.new(0, 28, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                    local targetColor = isOn and STYLE.Colors.Accent or STYLE.Colors.Primary
                    
                    TweenService:Create(toggleButton, TweenInfo.new(STYLE.AnimationDuration), {
                        BackgroundColor3 = targetColor
                    }):Play()
                    
                    TweenService:Create(toggleIndicator, TweenInfo.new(STYLE.AnimationDuration), {
                        Position = targetPosition
                    }):Play()
                    
                    if toggleInfo.Callback then pcall(toggleInfo.Callback, isOn) end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    isOn = not isOn
                    updateToggle()
                end)
                
                toggleButton.MouseEnter:Connect(function()
                    if not isOn then
                        TweenService:Create(toggleButton, TweenInfo.new(STYLE.AnimationDuration), {
                            BackgroundColor3 = STYLE.Colors.Hover
                        }):Play()
                    end
                end)
                
                toggleButton.MouseLeave:Connect(function()
                    if not isOn then
                        TweenService:Create(toggleButton, TweenInfo.new(STYLE.AnimationDuration), {
                            BackgroundColor3 = STYLE.Colors.Primary
                        }):Play()
                    end
                end)
                
                updateToggle()
                return container
            end)
        end
        
        return tabFunctions
    end
    
    return tabs
end

return OrionLibV2
