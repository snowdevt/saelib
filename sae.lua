local SimpleKavo = {}

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Temas pré-definidos
local Themes = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    DefaultTheme = {
        SchemeColor = Color3.fromRGB(74, 99, 135),
        Background = Color3.fromRGB(36, 37, 43),
        Header = Color3.fromRGB(28, 29, 34),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(32, 32, 38)
    }
}

-- Função para criar tweens
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Função para habilitar arrastar
function SimpleKavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    local function startDrag(input)
        dragging = true
        mousePos = input.Position
        framePos = parent.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input == dragInput and dragging) and 
           (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X,
                framePos.Y.Scale, 
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Função principal para criar a Window
function SimpleKavo.CreateLib(title, themeName)
    local theme = Themes[themeName] or Themes.DefaultTheme
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "SimpleKavo_"..tostring(math.random(1, 10000))
    ScreenGui.ResetOnSpawn = false
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = theme.Background
    Main.Position = UDim2.new(0.3, 0, 0.3, 0)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = Main
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = theme.Header
    Header.Size = UDim2.new(1, 0, 0, 30)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = title
    Title.TextColor3 = theme.TextColor
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Close = Instance.new("ImageButton")
    Close.Parent = Header
    Close.BackgroundTransparency = 1
    Close.AnchorPoint = Vector2.new(1, 0)
    Close.Position = UDim2.new(1, -5, 0.15, 0)
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Image = "rbxassetid://3926305904"
    Close.ImageRectOffset = Vector2.new(284, 4)
    Close.ImageRectSize = Vector2.new(24, 24)
    Close.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0)})
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    local Minimize = Instance.new("ImageButton")
    Minimize.Parent = ScreenGui
    Minimize.Name = "MinimizeButton"
    Minimize.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Minimize.BackgroundTransparency = 0.5
    Minimize.Size = UDim2.new(0, 40, 0, 40)
    Minimize.Position = UDim2.new(0.3, -45, 0.3, -50)
    Minimize.Image = "rbxassetid://128334668980442" -- Ícone do Sae
    Minimize.ImageColor3 = theme.TextColor

    local MinimizeStroke = Instance.new("UIStroke")
    MinimizeStroke.Color = Color3.fromRGB(0, 0, 0)
    MinimizeStroke.Parent = Minimize
    MinimizeStroke.Thickness = 1.5
    MinimizeStroke.Transparency = 0
    MinimizeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = Minimize

    SimpleKavo:DraggingEnabled(Minimize)

    local Minimized = false
    Minimize.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(Main, {Size = UDim2.new(0, 0, 0, 0)})
        else
            Tween(Main, {Size = UDim2.new(0, 500, 0, 350)})
        end
    end)
    
    SimpleKavo:DraggingEnabled(Header, Main)
    
    local TabsScroll = Instance.new("ScrollingFrame")
    TabsScroll.Name = "TabsScroll"
    TabsScroll.Parent = Main
    TabsScroll.BackgroundTransparency = 1
    TabsScroll.Position = UDim2.new(0, 20, 0, 30)
    TabsScroll.Size = UDim2.new(0, 140, 1, -30)
    TabsScroll.ScrollBarThickness = 5
    TabsScroll.ScrollBarImageColor3 = theme.SchemeColor
    TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    TabsScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    local TabsHolder = Instance.new("Frame")
    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = TabsScroll
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Size = UDim2.new(1, 0, 0, 0)
    TabsHolder.AutomaticSize = Enum.AutomaticSize.Y

    local TabsList = Instance.new("UIListLayout")
    TabsList.Parent = TabsHolder
    TabsList.Padding = UDim.new(0, 5)
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsHolder.Size = UDim2.new(1, 0, 0, TabsList.AbsoluteContentSize.Y)
        if #TabsHolder:GetChildren() > 5 then
            TabsScroll.CanvasSize = UDim2.new(0, 0, 0, TabsList.AbsoluteContentSize.Y)
        else
            TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        end
    end)
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 150, 0, 30)
    Content.Size = UDim2.new(1, -150, 1, -30)
    
    -- Variável para controlar a ordem das tabs
    local tabsOrder = {}
    local currentTab = nil
    
    function SimpleKavo:NewTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = TabsHolder
        TabButton.BackgroundColor3 = theme.ElementColor
        TabButton.Size = UDim2.new(0.9, 0, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = theme.TextColor
        TabButton.TextSize = 14
        TabButton.AnchorPoint = Vector2.new(0.5, 0)
        TabButton.Position = UDim2.new(0.35, -10, 0, 0)
        TabButton.LayoutOrder = #tabsOrder + 1
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."_Content"
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = theme.SchemeColor
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.Parent = TabContent
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Adiciona a tab à lista de ordem
        table.insert(tabsOrder, {
            button = TabButton,
            content = TabContent
        })
        
        TabButton.MouseButton1Click:Connect(function()
            -- Esconde todas as tabs
            for _, tab in ipairs(tabsOrder) do
                tab.content.Visible = false
                Tween(tab.button, {BackgroundColor3 = theme.ElementColor}, 0.2)
            end
            
            -- Mostra apenas a tab clicada
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = theme.SchemeColor}, 0.2)
            currentTab = TabContent
        end)
        
        -- Ativa a primeira tab criada
        if #tabsOrder == 1 then
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = theme.SchemeColor}, 0.2)
            currentTab = TabContent
        end
        
        local TabFunctions = {}
        
        function TabFunctions:NewSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name.."_Section"
            SectionFrame.Parent = TabContent
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(0.9, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Parent = SectionFrame
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 30)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = "Label"
            SectionLabel.Parent = SectionHeader
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Font = Enum.Font.GothamSemibold
            SectionLabel.Text = name
            SectionLabel.TextColor3 = theme.TextColor
            SectionLabel.TextSize = 14
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Name = "Line"
            SectionLine.Parent = SectionHeader
            SectionLine.BackgroundColor3 = theme.SchemeColor
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 0, 1, -2)
            SectionLine.Size = UDim2.new(1, 0, 0, 1)
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 35)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Parent = SectionContent
            SectionList.Padding = UDim.new(0, 5)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            
            local SectionFunctions = {}
            
            function SectionFunctions:NewButton(name, description, callback)
                local elementOrder = #SectionContent:GetChildren()
                
                local Button = Instance.new("TextButton")
                Button.Name = name
                Button.BackgroundColor3 = theme.ElementColor
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.Font = Enum.Font.Gotham
                Button.Text = name
                Button.TextColor3 = theme.TextColor
                Button.TextSize = 14
                Button.AutoButtonColor = false
                Button.LayoutOrder = elementOrder
                
                if description then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Name = "Description"
                    DescLabel.Parent = Button
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Position = UDim2.new(0, 10, 1, -15)
                    DescLabel.Size = UDim2.new(1, -20, 0, 12)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = description
                    DescLabel.TextColor3 = theme.TextColor
                    DescLabel.TextSize = 10
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                end
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {
                        BackgroundColor3 = Color3.fromRGB(
                            math.floor(theme.ElementColor.R * 255 + 20),
                            math.floor(theme.ElementColor.G * 255 + 20),
                            math.floor(theme.ElementColor.B * 255 + 20)
                        )
                    }, 0.1)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {
                        BackgroundColor3 = theme.ElementColor
                    }, 0.1)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                Button.Parent = SectionContent
                return Button
            end
            
            function SectionFunctions:NewToggle(name, default, callback)
                local elementOrder = #SectionContent:GetChildren()
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name.."_Toggle"
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.LayoutOrder = elementOrder
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundColor3 = theme.ElementColor
                ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
                ToggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.Text = ""
                ToggleButton.TextColor3 = theme.TextColor
                ToggleButton.TextSize = 14
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.Parent = ToggleButton
                
                local ToggleText = Instance.new("TextLabel")
                ToggleText.Name = "Text"
                ToggleText.Parent = ToggleFrame
                ToggleText.BackgroundTransparency = 1
                ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleText.Font = Enum.Font.Gotham
                ToggleText.Text = name
                ToggleText.TextColor3 = theme.TextColor
                ToggleText.TextSize = 14
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                
                local State = default or false
                
                local function UpdateToggle()
                    if State then
                        Tween(ToggleButton, {
                            BackgroundColor3 = theme.SchemeColor
                        }, 0.2)
                    else
                        Tween(ToggleButton, {
                            BackgroundColor3 = theme.ElementColor
                        }, 0.2)
                    end
                end
                
                UpdateToggle()
                
                ToggleButton.MouseButton1Click:Connect(function()
                    State = not State
                    UpdateToggle()
                    if callback then callback(State) end
                end)
                
                ToggleFrame.Parent = SectionContent
                return ToggleFrame
            end
            
            function SectionFunctions:NewDropdown(name, options, defaultOption, callback)
                local elementOrder = #SectionContent:GetChildren()
                
                -- Estado do dropdown
                local isOpen = false
                local selectedOption = defaultOption or (options and options[1]) or "Selecione"
                
                -- Frame principal do dropdown
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = name.."_Dropdown"
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.LayoutOrder = elementOrder
                
                -- Botão principal
                local MainButton = Instance.new("TextButton")
                MainButton.Name = "MainButton"
                MainButton.Parent = DropdownFrame
                MainButton.BackgroundColor3 = theme.ElementColor
                MainButton.Size = UDim2.new(1, 0, 0, 35)
                MainButton.Font = Enum.Font.Gotham
                MainButton.Text = name..": "..tostring(selectedOption)
                MainButton.TextColor3 = theme.TextColor
                MainButton.TextSize = 14
                MainButton.TextXAlignment = Enum.TextXAlignment.Left
                MainButton.AutoButtonColor = false
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = MainButton
                
                -- Seta indicadora
                local Arrow = Instance.new("TextLabel")
                Arrow.Name = "Arrow"
                Arrow.Parent = MainButton
                Arrow.BackgroundTransparency = 1
                Arrow.Size = UDim2.new(0, 20, 0, 20)
                Arrow.Position = UDim2.new(1, -25, 0, 7)
                Arrow.Text = "▼"
                Arrow.TextColor3 = theme.TextColor
                Arrow.Font = Enum.Font.Gotham
                Arrow.TextSize = 14
                
                -- Frame das opções
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Name = "OptionsFrame"
                OptionsFrame.Parent = DropdownFrame
                OptionsFrame.BackgroundColor3 = theme.ElementColor
                OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.Visible = false
                OptionsFrame.ClipsDescendants = true
                
                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 4)
                OptionsCorner.Parent = OptionsFrame
                
                local OptionsList = Instance.new("UIListLayout")
                OptionsList.Parent = OptionsFrame
                OptionsList.Padding = UDim.new(0, 5)
                OptionsList.HorizontalAlignment = Enum.HorizontalAlignment.Left
                
                -- Função para criar as opções
                local function createOptions()
                    for _, child in ipairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    if not options or #options == 0 then
                        local NoOptions = Instance.new("TextLabel")
                        NoOptions.Parent = OptionsFrame
                        NoOptions.BackgroundTransparency = 1
                        NoOptions.Size = UDim2.new(1, 0, 0, 30)
                        NoOptions.Text = "Sem opções"
                        NoOptions.TextColor3 = theme.TextColor
                        NoOptions.Font = Enum.Font.Gotham
                        NoOptions.TextSize = 12
                        return
                    end
                    
                    for i, option in ipairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = tostring(option)
                        OptionButton.Parent = OptionsFrame
                        OptionButton.BackgroundColor3 = theme.ElementColor
                        OptionButton.Size = UDim2.new(1, -10, 0, 30)
                        OptionButton.Position = UDim2.new(0, 5, 0, 0)
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Text = tostring(option)
                        OptionButton.TextColor3 = theme.TextColor
                        OptionButton.TextSize = 14
                        OptionButton.AutoButtonColor = false
                        
                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 4)
                        OptionCorner.Parent = OptionButton
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            MainButton.Text = name..": "..tostring(selectedOption)
                            isOpen = false
                            OptionsFrame.Visible = false
                            Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                            Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                            Tween(Arrow, {Rotation = 0}, 0.2)
                            if callback then callback(option) end
                        end)
                        
                        OptionButton.MouseEnter:Connect(function()
                            Tween(OptionButton, {
                                BackgroundColor3 = Color3.fromRGB(
                                    math.floor(theme.ElementColor.R * 255 + 20),
                                    math.floor(theme.ElementColor.G * 255 + 20),
                                    math.floor(theme.ElementColor.B * 255 + 20)
                                )
                            }, 0.1)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = theme.ElementColor}, 0.1)
                        end)
                    end
                end
                
                createOptions()
                
                -- Função para abrir/fechar o dropdown
                local function toggleDropdown()
                    isOpen = not isOpen
                    Tween(Arrow, {Rotation = isOpen and 180 or 0}, 0.2)
                    
                    if isOpen then
                        local optionCount = #options > 0 and #options or 1
                        local totalHeight = optionCount * 35 + (optionCount-1)*5 -- Altura total com padding
                        OptionsFrame.Visible = true
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35 + totalHeight + 5)}, 0.2)
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.2)
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        wait(0.2)
                        OptionsFrame.Visible = false
                    end
                end
                
                MainButton.MouseButton1Click:Connect(toggleDropdown)
                
                -- Fechar ao clicar fora
                local dropdownConnection
                dropdownConnection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                        local pos = input.Position
                        local framePos = DropdownFrame.AbsolutePosition
                        local frameSize = DropdownFrame.AbsoluteSize
                        
                        if not (pos.X >= framePos.X and pos.X <= framePos.X + frameSize.X and
                               pos.Y >= framePos.Y and pos.Y <= framePos.Y + frameSize.Y) then
                            toggleDropdown()
                        end
                    end
                end)
                
                DropdownFrame.Destroying:Connect(function()
                    dropdownConnection:Disconnect()
                end)
                
                -- Funções de controle
                local dropdownMethods = {}
                
                function dropdownMethods:Set(newOption)
                    if table.find(options, newOption) then
                        selectedOption = newOption
                        MainButton.Text = name..": "..tostring(selectedOption)
                    end
                end
                
                function dropdownMethods:Get()
                    return selectedOption
                end
                
                function dropdownMethods:Update(newOptions, newDefault)
                    options = newOptions or options
                    selectedOption = newDefault or selectedOption or (options and options[1]) or "Selecione"
                    MainButton.Text = name..": "..tostring(selectedOption)
                    createOptions()
                    if isOpen then
                        toggleDropdown()
                    end
                end
                
                DropdownFrame.Parent = SectionContent
                
                -- Adiciona métodos ao frame de retorno
                for name, func in pairs(dropdownMethods) do
                    DropdownFrame[name] = func
                end
                
                return DropdownFrame
            end
            
            function SectionFunctions:NewSlider(name, min, max, default, callback)
                local elementOrder = #SectionContent:GetChildren()
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name.."_Slider"
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.LayoutOrder = elementOrder
                
                local SliderText = Instance.new("TextLabel")
                SliderText.Name = "Text"
                SliderText.Parent = SliderFrame
                SliderText.BackgroundTransparency = 1
                SliderText.Size = UDim2.new(1, 0, 0.4, 0)
                SliderText.Font = Enum.Font.Gotham
                SliderText.Text = name..": "..default
                SliderText.TextColor3 = theme.TextColor
                SliderText.TextSize = 14
                SliderText.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = theme.ElementColor
                SliderBar.Size = UDim2.new(1, 0, 0.2, 0)
                SliderBar.Position = UDim2.new(0, 0, 0.6, 0)
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = theme.SchemeColor
                SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.Parent = SliderFill
                
                local dragging = false
                
                local function UpdateSlider(value)
                    local percent = math.clamp((value - min)/(max - min), 0, 1)
                    Tween(SliderFill, {
                        Size = UDim2.new(percent, 0, 1, 0)
                    }, 0.1)
                    SliderText.Text = name..": "..math.floor(value)
                    if callback then callback(value) end
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position.X - SliderBar.AbsolutePosition.X
                        local percent = math.clamp(pos/SliderBar.AbsoluteSize.X, 0, 1)
                        local value = min + (max - min) * percent
                        UpdateSlider(value)
                    end
                end)
                
                SliderFrame.Parent = SectionContent
                return SliderFrame
            end
            
            return SectionFunctions
        end
        
        return TabFunctions
    end
    
    return {
        NewTab = SimpleKavo.NewTab,
        ToggleUI = function()
            ScreenGui.Enabled = not ScreenGui.Enabled
        end,
        Destroy = function()
            ScreenGui:Destroy()
        end,
        Minimize = function()
            Minimized = not Minimized
            if Minimized then
                Tween(Main, {Size = UDim2.new(0, 0, 0, 0)})
            else
                Tween(Main, {Size = UDim2.new(0, 500, 0, 350)})
            end
        end
    }
end

return SimpleKavo
