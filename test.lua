local DybooUI = {}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

function DybooUI:CreateWindow(title)

    if CoreGui:FindFirstChild("DybooHub") then
        CoreGui.DybooHub:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DybooHub"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,220,0,140)
    MainFrame.Position = UDim2.new(0.5,-110,0.5,-70)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,10)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(80,80,80)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,30)
    Title.BackgroundTransparency = 1
    Title.Text = title or "Dyboo Hub"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,25,0,25)
    MinBtn.Position = UDim2.new(1,-30,0,3)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.Parent = MainFrame

    Instance.new("UICorner",MinBtn).CornerRadius = UDim.new(0,6)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1,0,1,-30)
    Container.Position = UDim2.new(0,0,0,30)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,6)
    Layout.Parent = Container

    -- minimize
    local minimized = false

    MinBtn.MouseButton1Click:Connect(function()
        if minimized then
            MainFrame.Size = UDim2.new(0,220,0,140)
            Container.Visible = true
            MinBtn.Text = "-"
        else
            MainFrame.Size = UDim2.new(0,220,0,35)
            Container.Visible = false
            MinBtn.Text = "+"
        end
        minimized = not minimized
    end)

    -- drag
    local dragging = false
    local dragStart
    local startPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local Window = {}

    -- BUTTON
    function Window:Button(text,callback)

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.9,0,0,28)
        Btn.Position = UDim2.new(0.05,0,0,0)
        Btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
        Btn.Text = text
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 13
        Btn.Parent = Container

        Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,6)

        Btn.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)

    end

    -- TOGGLE
    function Window:Toggle(text,callback)

        local state = false

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0.9,0,0,28)
        Toggle.Position = UDim2.new(0.05,0,0,0)
        Toggle.BackgroundColor3 = Color3.fromRGB(15,15,15)
        Toggle.Text = text.." : OFF"
        Toggle.TextColor3 = Color3.new(1,1,1)
        Toggle.Font = Enum.Font.GothamSemibold
        Toggle.TextSize = 13
        Toggle.Parent = Container

        Instance.new("UICorner",Toggle).CornerRadius = UDim.new(0,6)

        Toggle.MouseButton1Click:Connect(function()

            state = not state

            if state then
                Toggle.Text = text.." : ON"
            else
                Toggle.Text = text.." : OFF"
            end

            if callback then
                callback(state)
            end

        end)

    end

    -- TEXTBOX
    function Window:Textbox(text,callback)

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(0.9,0,0,28)
        Box.Position = UDim2.new(0.05,0,0,0)
        Box.BackgroundColor3 = Color3.fromRGB(15,15,15)
        Box.PlaceholderText = text
        Box.Text = ""
        Box.TextColor3 = Color3.new(1,1,1)
        Box.Font = Enum.Font.Gotham
        Box.TextSize = 13
        Box.Parent = Container

        Instance.new("UICorner",Box).CornerRadius = UDim.new(0,6)

        Box.FocusLost:Connect(function()
            if callback then
                callback(Box.Text)
            end
        end)

    end

    -- SLIDER
    function Window:Slider(text,min,max,default,callback)

        local value = default

        local Slider = Instance.new("TextButton")
        Slider.Size = UDim2.new(0.9,0,0,28)
        Slider.Position = UDim2.new(0.05,0,0,0)
        Slider.BackgroundColor3 = Color3.fromRGB(15,15,15)
        Slider.Text = text.." : "..value
        Slider.TextColor3 = Color3.new(1,1,1)
        Slider.Font = Enum.Font.GothamSemibold
        Slider.TextSize = 13
        Slider.Parent = Container

        Instance.new("UICorner",Slider).CornerRadius = UDim.new(0,6)

        Slider.MouseButton1Click:Connect(function()

            value = value + 1
            if value > max then
                value = min
            end

            Slider.Text = text.." : "..value

            if callback then
                callback(value)
            end

        end)

    end

    -- DROPDOWN
    function Window:Dropdown(text,options,callback)

        local index = 1

        local Drop = Instance.new("TextButton")
        Drop.Size = UDim2.new(0.9,0,0,28)
        Drop.Position = UDim2.new(0.05,0,0,0)
        Drop.BackgroundColor3 = Color3.fromRGB(15,15,15)
        Drop.Text = text.." : "..options[index]
        Drop.TextColor3 = Color3.new(1,1,1)
        Drop.Font = Enum.Font.GothamSemibold
        Drop.TextSize = 13
        Drop.Parent = Container

        Instance.new("UICorner",Drop).CornerRadius = UDim.new(0,6)

        Drop.MouseButton1Click:Connect(function()

            index = index + 1
            if index > #options then
                index = 1
            end

            Drop.Text = text.." : "..options[index]

            if callback then
                callback(options[index])
            end

        end)

    end

    return Window
end

return DybooUI