local DybooUI = {}

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

function DybooUI:CreateWindow(config)

    if CoreGui:FindFirstChild("DybooUI") then
        CoreGui.DybooUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DybooUI"
    ScreenGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0,420,0,260)
    Main.Position = UDim2.new(0.5,-210,0.5,-130)
    Main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Main.BorderSizePixel = 0

    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,8)

    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1,0,0,30)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Dyboo UI"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    local Tabs = Instance.new("Frame")
    Tabs.Parent = Main
    Tabs.Size = UDim2.new(0,120,1,-30)
    Tabs.Position = UDim2.new(0,0,0,30)
    Tabs.BackgroundColor3 = Color3.fromRGB(15,15,15)

    local Pages = Instance.new("Frame")
    Pages.Parent = Main
    Pages.Size = UDim2.new(1,-120,1,-30)
    Pages.Position = UDim2.new(0,120,0,30)
    Pages.BackgroundTransparency = 1

    -- Drag UI
    local dragging = false
    local dragStart
    local startPos

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local Window = {}

    function Window:Tab(info)

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Tabs
        TabButton.Size = UDim2.new(1,0,0,35)
        TabButton.Text = info.Title
        TabButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
        TabButton.TextColor3 = Color3.new(1,1,1)

        local Page = Instance.new("Frame")
        Page.Parent = Pages
        Page.Size = UDim2.new(1,0,1,0)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Page
        Layout.Padding = UDim.new(0,5)

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        local Tab = {}

        function Tab:Button(data)

            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1,-10,0,35)
            Btn.Text = data.Title
            Btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Btn.TextColor3 = Color3.new(1,1,1)

            Btn.MouseButton1Click:Connect(function()
                if data.Callback then
                    data.Callback()
                end
            end)

        end

        function Tab:Toggle(data)

            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Page
            Toggle.Size = UDim2.new(1,-10,0,35)
            Toggle.Text = data.Title .. " : OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Toggle.TextColor3 = Color3.new(1,1,1)

            local state = false

            Toggle.MouseButton1Click:Connect(function()

                state = not state

                if state then
                    Toggle.Text = data.Title .. " : ON"
                else
                    Toggle.Text = data.Title .. " : OFF"
                end

                if data.Callback then
                    data.Callback(state)
                end

            end)

        end

        function Tab:Textbox(data)

            local Box = Instance.new("TextBox")
            Box.Parent = Page
            Box.Size = UDim2.new(1,-10,0,35)
            Box.PlaceholderText = data.Title
            Box.Text = ""
            Box.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Box.TextColor3 = Color3.new(1,1,1)

            Box.FocusLost:Connect(function()
                if data.Callback then
                    data.Callback(Box.Text)
                end
            end)

        end

        function Tab:Slider(data)

            local Slider = Instance.new("TextButton")
            Slider.Parent = Page
            Slider.Size = UDim2.new(1,-10,0,35)
            Slider.Text = data.Title .. " : " .. data.Default
            Slider.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Slider.TextColor3 = Color3.new(1,1,1)

            local value = data.Default

            Slider.MouseButton1Click:Connect(function()

                value = value + 1

                if value > data.Max then
                    value = data.Min
                end

                Slider.Text = data.Title .. " : " .. value

                if data.Callback then
                    data.Callback(value)
                end

            end)

        end

        return Tab
    end

    return Window
end

return DybooUI