-- ; Library
local UID = 14811417135
local HexNotifyUI = game:GetObjects("rbxassetid://"..UID)[1]
HexNotifyUI.Enabled = true

-- ; Variables
local CoreGui = game:GetService("CoreGui")
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

-- ; UI Variables
local Main = HexNotifyUI.Notifications
local NotifyLib = {}
Main.Template.Visible = false

-- ; Functions
function ParentObject(Gui)
	if get_hidden_gui or gethui then
		local hiddenUI = get_hidden_gui or gethui
		Gui.Parent = hiddenUI()
	elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		syn.protect_gui(Gui)
		Gui.Parent = CoreGui
	elseif CoreGui then
		Gui.Parent = CoreGui
	end
end
ParentObject(HexNotifyUI)

function NotifyLib:Notify(Title, Content, Value, Duration, Image)
    spawn(function()
		local Notification = Main.Template:Clone()
		Notification.Parent = Main
		Notification.Name = Title or "Untitled"
        Notification.Description.Text = Content
		Notification.Title.Text = Title or "Untitled"
		Notification.Visible = true

        local NotifyConfig = {
            Color3.fromRGB(240,240,240),
            Color3.fromRGB(240,223,33),
            Color3.fromRGB(240,30,33),
        }
        local StringColor = NotifyConfig[Value]

		if Image then
			Notification.Title.Icon.Image = "rbxassetid://"..tostring(Image) 
		else
			Notification.Title.Icon.Image = "rbxassetid://14810928256"
		end

        Notification.Title.Icon.ImageColor3 = StringColor
        Notification.Title.TextColor3 = StringColor
        for _, Text in next, Notification:GetChildren() do
            if Text.ClassName == "TextLabel" then
                Text.TextTransparency = 1
            end
        end
		Notification.BackgroundTransparency = 1
		TweenService:Create(Notification, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.2}):Play()
		Notification:TweenPosition(UDim2.new(0.5,0,0.915,0),'Out','Quint',0.6,true)
		wait(0.3)
		TweenService:Create(Notification.Title.Icon, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()
		TweenService:Create(Notification.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
		TweenService:Create(Notification.Description, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.2}):Play()
		wait(0.2)

		wait(Duration - 0.5)

		Notification:Destroy()
	end)
end

return NotifyLib
