-- ; Services 
local CoreGui = game:GetService("CoreGui")
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

-- ; Functions

-- ; Init
local ID = 14735987773
local HexUI = game:GetObjects("rbxassetid://"..ID)[1]
HexUI.Enabled = false

-- ; UI Variables
local Main = HexUI.Main
local Top = Main.Top
local Elements = Main.Elements
local Templates = Main.Templates
local Tabs = Main.Tabs

-- ; Variables
local Request = (syn and syn.request) or (http and http.request) or http_request

-- ; UI Functions

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
ParentObject(HexUI)

local function DraggingUI(DraggPoint)

	local Dragging, DraggInput, DraggStart, StartPos = false

	DraggPoint.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DraggStart = Input.Position
			StartPos = DraggPoint.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	DraggPoint.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DraggInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DraggInput and Dragging then
			local Delta = Input.Position - DraggStart
			DraggPoint.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)

end

local HexLibrary = {}
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/oficialbadware/LuaU/main/Interfaces/Notification/Library.lua", true))()

function HexLibrary:Notify(Title, Content, Type, Duration, Image)
	local Image = Image or nil
	NotifyLib:Notify(Title or "Untitled", Content or "No content", Type or 1, Duration or 4, Image)
end

function HexLibrary:Visible(Bool)
	HexUI.Enabled = Bool
end

function HexLibrary:CreateWindow(Settings)

    local Window = {}

	HexUI.Enabled = false
	Main.Title.Text = Settings.Name
	Main.Game.Text = Settings.Game

	DraggingUI(Main)

	if Settings.Discord then
		if Request then
			Request({
				Url = 'http://127.0.0.1:6463/rpc?v=1',
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 'https://discord.com'
				},
				Body = HttpService:JSONEncode({
					cmd = 'INVITE_BROWSER',
					nonce = HttpService:GenerateGUID(false),
					args = {code = Settings.DiscordConfig.Invite}
				})
			})
		end
	end

	HexUI.Enabled = true
	
	-- ; Tab
	local FirstTab = false

	function Window:CreateTab(Name)

		local Tab = {}

		-- ; Tab Button
		local NewTab = Templates["Tab Disabled"]:Clone()
		NewTab.Title.Text = Name
		NewTab.Name = Name
		NewTab.Parent = Tabs.List

		-- ; Tab Page
		local NewPage = Templates["Tab"]:Clone()
		NewPage.Name = Name
		NewPage.Visible = false
		NewPage.Parent = Elements

		Top.Container.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
			for _, Item in pairs(Elements:GetDescendants()) do
				if Item.Parent.Parent.Name == "C_Elements" and Item:IsA("Frame") and Item:FindFirstChild("Title") then
					if string.match(Item.Title.Text:lower(), Top.Container.TextBox.Text:lower()) then 
						Item.Visible = true
					else
						Item.Visible = false
					end
				end
			end
		end)

		local function ChangeColor(Bool, Path)
			if Bool then
				TweenService:Create(Path.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(45,45,45)}):Play()
				TweenService:Create(Path.Title, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {TextTransparency = 0.2}):Play()
				TweenService:Create(Path, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
			else
				TweenService:Create(Path.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(35,35,35)}):Play()
				TweenService:Create(Path.Title, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {TextTransparency = 0.4}):Play()
				TweenService:Create(Path, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play()
			end
		end

		if not FirstTab then
			FirstTab = Name
			NewPage.Visible = true
			ChangeColor(true, NewTab)
		end

		NewTab.Interact.MouseButton1Click:Connect(function()
			ChangeColor(true, NewTab)

			for _, OtherTabButtons in ipairs(Tabs.List:GetChildren()) do
				if OtherTabButtons.ClassName == "Frame" and OtherTabButtons ~= NewTab then
					ChangeColor(false, OtherTabButtons)
				end
			end

			for _, OtherPages in ipairs(Elements:GetChildren()) do
				if OtherPages.ClassName == "ScrollingFrame" and OtherPages ~= NewPage then
					OtherPages.Visible = false
				end
			end

			NewPage.Visible = true
		end)

		function Tab:CreateContainer(ContainerName)
            ContainerName = ContainerName or ''
			local Container = {}

			-- ; Container
			local NewContainer = Templates["Section"]:Clone()
			NewContainer.Name = ContainerName
			NewContainer.Parent = NewPage

			local SectionPages = {}
			SectionPages[ContainerName] = {}

			function Container:AddSection(SectionName)
				
				local Section = {}

				-- ; Section
				local NewSection = Templates["Disabled Section"]:Clone()
				NewSection.Name = SectionName
				NewSection.Parent = NewContainer["A_List"]
				NewSection.Title.Text = SectionName

				-- ; Section Page 
				local NewSecPage = Templates["Sub Section"]:Clone()
				NewSecPage.Name = SectionName
				NewSecPage.Parent = NewContainer["C_Elements"]
				NewSecPage.Visible = false

				local function ChangeSecColor(Bool, Path)
					if Bool then
						Path.Fixer.Visible = true
						TweenService:Create(Path.Title, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {TextTransparency = 0.2}):Play()
						TweenService:Create(Path, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
					else
						Path.Fixer.Visible = false
						TweenService:Create(Path.Title, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {TextTransparency = 0.4}):Play()
						TweenService:Create(Path, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
					end
				end

				NewSection.Title.Size = UDim2.new(0, NewSection.Title.TextBounds.X + 15, 0, 25)
				NewSection.Size = UDim2.new(0, NewSection.Title.TextBounds.X + 15, 0, 25)

				if not SectionPages[ContainerName][1] then
					table.insert(SectionPages[ContainerName], NewSection)
					ChangeSecColor(true, NewSection)
					NewSecPage.Visible = true
				else
					ChangeSecColor(false, NewSection)
					NewSecPage.Visible = false
				end

				NewSection.Interact.MouseButton1Click:Connect(function()
					ChangeSecColor(true, NewSection)

					for _, OtherSecButtons in ipairs(NewContainer["A_List"]:GetChildren()) do
						if OtherSecButtons.ClassName == "Frame" and OtherSecButtons ~= NewSection then
							ChangeSecColor(false, OtherSecButtons)
						end
					end

					for _, OtherSubSections in ipairs(NewContainer["C_Elements"]:GetChildren()) do
						if OtherSubSections.ClassName == "Frame" and OtherSubSections ~= NewSecPage then
							OtherSubSections.Visible = false
						end
					end

					NewSecPage.Visible = true
				end)

				function Section:CreateButton(Name, Callback)

					local ButtonValue = {}

					local NewButton = Templates["Button"]:Clone()
					NewButton.Name = Name
					NewButton.Title.Text = Name
                    NewButton.Title.RichText = true
					NewButton.Parent = NewSecPage
                    
                    NewButton.Interact.MouseButton1Click:Connect(function()
                        local Success, Response = pcall(Callback)
                        if Success then
							TweenService:Create(NewButton.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(74, 143, 255)}):Play()
                            TweenService:Create(NewButton.UICorner, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CornerRadius = UDim.new(0, 8)}):Play()
                            wait(0.2)
							TweenService:Create(NewButton.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(40, 40, 40)}):Play()
                            TweenService:Create(NewButton.UICorner, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CornerRadius = UDim.new(0, 4)}):Play()
                        end
                    end)

					function ButtonValue:Hide(Value)
						NewButton.Visible = false 
					end
					function ButtonValue:Show(Value)
						NewButton.Visible = true 
					end
					function ButtonValue:Click()
						Callback(true)
					end
					

					return ButtonValue
				end

				function Section:CreateToggle(ToggleSettings)

					local ToggleValue = {}

					-- ; Toggle
					local NewToggle = Templates["Toggle Disabled"]:Clone()
					NewToggle.Name = ToggleSettings.Name
					NewToggle.Title.Text = ToggleSettings.Name
                    NewToggle.Title.RichText = true
					NewToggle.Parent = NewSecPage

					local function ToggleSet(Bool, Path)
						if Bool then
							TweenService:Create(NewToggle.Out, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(74, 143, 255)}):Play()
                            TweenService:Create(NewToggle.Out.UICorner, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CornerRadius = UDim.new(0, 4)}):Play()
							TweenService:Create(NewToggle.Out.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Thickness = 0}):Play()
							TweenService:Create(NewToggle.Out.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {ImageTransparency = 0}):Play()
						else
							TweenService:Create(NewToggle.Out, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
                            TweenService:Create(NewToggle.Out.UICorner, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CornerRadius = UDim.new(0, 8)}):Play()
							TweenService:Create(NewToggle.Out.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Thickness = 1}):Play()
							TweenService:Create(NewToggle.Out.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {ImageTransparency = 1}):Play()
						end
					end

					if ToggleSettings.CurrentValue then
						ToggleSet(true, NewToggle)
						ToggleSettings.CurrentValue = true
						local Success, Response = pcall(ToggleSettings.Callback(ToggleSettings.CurrentValue))
					end

					NewToggle.Interact.MouseButton1Click:Connect(function()
						if ToggleSettings.CurrentValue then
							ToggleSet(false, NewToggle)
							ToggleSettings.CurrentValue = false
						else
							ToggleSet(true, NewToggle)
							ToggleSettings.CurrentValue = true
						end
						local Success, Response = pcall(function() ToggleSettings.Callback(ToggleSettings.CurrentValue) end)
					end)

					function ToggleValue:Change(Bool)
						ToggleSettings.CurrentValue = Bool
						ToggleSet(Bool, NewToggle)
					end

					function ToggleValue:Value()
						return ToggleSettings.CurrentValue
					end

					function ToggleValue:Hide()
						NewToggle.Visible = false 
					end

					function ToggleValue:Show()
						NewToggle.Visible = true
					end

					return ToggleValue
				end

				function Section:CreateLabel(ContentText)

					local LabelValue = {}

					-- ; Label
					local NewLabel = Templates["Label"]:Clone()
					for _, Content in pairs(NewLabel:GetChildren()) do 
						Content.Text = ContentText
                        Content.RichText = true
					end
					NewLabel.Parent = NewSecPage
					NewLabel.Name = ContentText

					function LabelValue:Refresh(Value)
						NewLabel.Content.Text = Value
					end

					function LabelValue:Hide()
						NewLabel.Visible = false 
					end
					
					function LabelValue:Show()
						NewLabel.Visible = true
					end

					return LabelValue
				end

				function Section:CreateSlider(SliderSettings)
					local SliderValue = {}
					local Dragging = false

					-- ; Slider
					local NewSlider = Templates["Slider"]:Clone()
					NewSlider.Name = SliderSettings.Name
					NewSlider.Title.Text = SliderSettings.Name
					NewSlider.Parent = NewSecPage
					NewSlider.TextBox.Text = tostring(SliderSettings.CurrentValue)

					NewSlider.Out.Inner.Position = UDim2.new(0, 0,0, 0)
					NewSlider.Out.Inner.AnchorPoint = Vector2.new(0, 0)
					NewSlider.Out.Inner.Size = UDim2.new(0, NewSlider.Out.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and NewSlider.Out.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)

					NewSlider.MouseEnter:Connect(function()
						TweenService:Create(NewSlider.Out.Inner, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(74, 143, 255)}):Play()
						TweenService:Create(NewSlider.Out.Inner.Circle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(74, 143, 255)}):Play()
					end)
		
					NewSlider.MouseLeave:Connect(function()
						TweenService:Create(NewSlider.Out.Inner, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
						TweenService:Create(NewSlider.Out.Inner.Circle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(55, 55, 55)}):Play()
					end)

					NewSlider.Interact.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
							Dragging = true 
						end 
					end)

					NewSlider.Interact.InputEnded:Connect(function(Input) 
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
							Dragging = false 
						end 
					end)

					NewSlider.Interact.MouseButton1Down:Connect(function(X)
						local Current = NewSlider.Out.Inner.AbsolutePosition.X + NewSlider.Out.Inner.AbsoluteSize.X
						local Start = Current
						local Location = X
						local Loop; Loop = RunService.Stepped:Connect(function()
							if Dragging then
								Location = UserInputService:GetMouseLocation().X
								Current = Current + 0.025 * (Location - Start)
		
								if Location < NewSlider.Out.AbsolutePosition.X then
									Location = NewSlider.Out.AbsolutePosition.X
								elseif Location > NewSlider.Out.AbsolutePosition.X + NewSlider.Out.AbsoluteSize.X then
									Location = NewSlider.Out.AbsolutePosition.X + NewSlider.Out.AbsoluteSize.X
								end
		
								if Current < NewSlider.Out.AbsolutePosition.X + 5 then
									Current = NewSlider.Out.AbsolutePosition.X + 5
								elseif Current > NewSlider.Out.AbsolutePosition.X + NewSlider.Out.AbsoluteSize.X then
									Current = NewSlider.Out.AbsolutePosition.X + NewSlider.Out.AbsoluteSize.X
								end
		
								if Current <= Location and (Location - Start) < 0 then
									Start = Location
								elseif Current >= Location and (Location - Start) > 0 then
									Start = Location
								end

								NewSlider.Out.Inner.Size = UDim2.new(0, Current - NewSlider.Out.AbsolutePosition.X, 1, 0)

								local NewValue = SliderSettings.Range[1] + (Location - NewSlider.Out.AbsolutePosition.X) / NewSlider.Out.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])
								NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000
								NewSlider.TextBox.Text = tostring(NewValue)

								if SliderSettings.CurrentValue ~= NewValue then
									local Success, Response = pcall(function()
										SliderSettings.Callback(NewValue)
									end)
									SliderSettings.CurrentValue = NewValue
								end
							else
								NewSlider.Out.Inner.Size = UDim2.new(0, Location - NewSlider.Out.AbsolutePosition.X > 5 and Location - NewSlider.Out.AbsolutePosition.X or 5, 1, 0)
								Loop:Disconnect()
							end
						end)
					end)

					NewSlider.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
						NewSlider.TextBox.Text = NewSlider.TextBox.Text:gsub('%D+', '')
						if Dragging then return end
						if NewSlider.TextBox.Text == '' then return end
						if tonumber(NewSlider.TextBox.Text) > SliderSettings.Range[2] then NewSlider.TextBox.Text = SliderSettings.Range[2] end
						if tonumber(NewSlider.TextBox.Text) < SliderSettings.Range[1] then NewSlider.TextBox.Text = SliderSettings.Range[1] end
						SliderSettings.CurrentValue = tonumber(NewSlider.TextBox.Text)
						local ChangeSize = UDim2.new(0, NewSlider.Out.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and NewSlider.Out.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)
						TweenService:Create(NewSlider.Out.Inner, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = ChangeSize}):Play()
						local Success, Response = pcall(function()
							SliderSettings.Callback(SliderSettings.CurrentValue)
						end)
					end)		

					function SliderValue:Hide()
						NewSlider.Visible = false 
					end
					function SliderValue:Show()
						NewSlider.Visible = true
					end

					return SliderValue
				end

				function Section:CreateTextBox(TextBoxSettings)

					local TextBoxValue = {}

					-- ; TextBox
					local NewTextBox = Templates["Textbox"]:Clone()
					NewTextBox.Name = TextBoxSettings.Name
					NewTextBox.Title.Text = TextBoxSettings.Name
					NewTextBox.Parent = NewSecPage
					NewTextBox.Out.TextBox.Position = UDim2.new(0.5, 0,0.5, 0)
					NewTextBox.Out.Position = UDim2.new(0.999, 0,0.48, 0)
					NewTextBox.Out.AnchorPoint = Vector2.new(1, 0.5)
					NewTextBox.Out.TextBox.AnchorPoint = Vector2.new(0.5, 0.5)

					NewTextBox.Out.TextBox.Text = ""
					NewTextBox.Out.TextBox.PlaceholderText = TextBoxSettings.Placeholder
					NewTextBox.Out.Size = UDim2.new(0, NewTextBox.Out.TextBox.TextBounds.X + 20, 0, 20)
		
					NewTextBox.Out.TextBox.FocusLost:Connect(function()
						local Success, Response = pcall(function()
							TextBoxSettings.Callback(NewTextBox.Out.TextBox.Text)
						end)
		
						if TextBoxSettings.RemoveText then
							NewTextBox.Out.TextBox.Text = ""
						end
					end)
		
					NewTextBox.Out.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
						TweenService:Create(NewTextBox.Out, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, NewTextBox.Out.TextBox.TextBounds.X + 15, 0, 20)}):Play()
					end)
					function TextBoxValue:Hide()
						NewTextBox.Visible = false
					end
					function TextBoxValue:Show()
						NewTextBox.Visible = true
					end
					return TextBoxValue
				end

				function Section:CreateDropdown(DropdownSettings)

					local DropdownValue = {}
					
					-- ; TextBox
					local NewDropdown = Templates["Dropdown"]:Clone()
					NewDropdown.Name = DropdownSettings.Name
					NewDropdown.Title.Text = DropdownSettings.Name
					NewDropdown.Parent = NewSecPage
					NewDropdown.List.Visible = false

					if typeof(DropdownSettings.CurrentOption) == "string" then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
					end
		
					if not DropdownSettings.MultipleOptions then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
					end

					local DropVisualSettings = {
						-- ; Title Settings
						CloseTitlePos = UDim2.new(0.395, 0,0.487, 0),
						OpenTitlePos = UDim2.new(0.395, 0,0.127, 0),
						-- ; Dropdown Container Settings
						OpenDropSize = UDim2.new(0, 315,0, 110),
						CloseDropSize = UDim2.new(0, 315,0, 25),
						-- ; Dropdown Toggle Settings
						CloseTogglePos = UDim2.new(0.946, 0,0.487, 0),
						OpenTogglePos = UDim2.new(0.946, 0,0.127, 0),
					}
					
					NewDropdown.Size = DropVisualSettings.CloseDropSize
					NewDropdown.Logo.Position = DropVisualSettings.CloseTogglePos
					NewDropdown.Title.Position = DropVisualSettings.CloseTitlePos

					for _, ununusedoption in ipairs(NewDropdown.List:GetChildren()) do
						if ununusedoption.ClassName == "Frame" then
							ununusedoption:Destroy()
						end
					end

					NewDropdown.Logo.Rotation = 180
					local Debounce = false

					NewDropdown.Interact.MouseButton1Click:Connect(function()
						if Debounce then return end
						if NewDropdown.List.Visible then
							Debounce = true
							TweenService:Create(NewDropdown, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = DropVisualSettings.CloseDropSize}):Play()
							NewDropdown.Title.Position = DropVisualSettings.CloseTitlePos
							NewDropdown.Logo.Position = DropVisualSettings.CloseTogglePos
							for _, DropdownOpt in ipairs(NewDropdown.List:GetChildren()) do
								if DropdownOpt.ClassName == "Frame" then
									TweenService:Create(DropdownOpt, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
									TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
								end
							end
							TweenService:Create(NewDropdown.Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Rotation = 180}):Play()	
							wait(0.35)
							NewDropdown.List.Visible = false
							Debounce = false
						else
							Debounce = true
							TweenService:Create(NewDropdown, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = DropVisualSettings.OpenDropSize}):Play()
							NewDropdown.Title.Position = DropVisualSettings.OpenTitlePos
							NewDropdown.Logo.Position = DropVisualSettings.OpenTogglePos
							NewDropdown.List.Visible = true
							TweenService:Create(NewDropdown.Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Rotation = 0}):Play()	
							for _, DropdownOpt in ipairs(NewDropdown.List:GetChildren()) do
								if DropdownOpt.ClassName == "Frame" then
									TweenService:Create(DropdownOpt, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
									TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
								end
							end
							wait(0.35)
							Debounce = false
						end
					end)

					for _, Option in ipairs(DropdownSettings.Options) do
						local DropdownOption = Templates["Dropdown"].List.Template:Clone()
						DropdownOption.Name = Option
						DropdownOption.Title.Text = Option
						DropdownOption.Parent = NewDropdown.List
						DropdownOption.Visible = true
		
						if DropdownSettings.CurrentOption == Option then
							DropdownOption.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
						end
		
						DropdownOption.Interact.ZIndex = 50
						DropdownOption.Interact.MouseButton1Click:Connect(function()
							if not DropdownSettings.MultipleOptions and table.find(DropdownSettings.CurrentOption, Option) then 
								return
							end
		
							if table.find(DropdownSettings.CurrentOption, Option) then
								table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, Option))
							else
								if not DropdownSettings.MultipleOptions then
									table.clear(DropdownSettings.CurrentOption)
								end
								table.insert(DropdownSettings.CurrentOption, Option)
								TweenService:Create(DropdownOption, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(75,75,75)}):Play()
							end
		
		
							local Success, Response = pcall(function()
								DropdownSettings.Callback(DropdownSettings.CurrentOption)
							end)
	
		
							for _, droption in ipairs(NewDropdown.List:GetChildren()) do
								if droption.ClassName == "Frame" and not table.find(DropdownSettings.CurrentOption, droption.Name) then
									TweenService:Create(droption, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(55,55,55)}):Play()
								end
							end
							if not DropdownSettings.MultipleOptions then
								wait(0.1)
								TweenService:Create(NewDropdown, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = DropVisualSettings.CloseDropSize}):Play()
								NewDropdown.Title.Position = DropVisualSettings.CloseTitlePos
								NewDropdown.Logo.Position = DropVisualSettings.CloseTogglePos
								for _, DropdownOpt in ipairs(NewDropdown.List:GetChildren()) do
									if DropdownOpt.ClassName == "Frame" then
										TweenService:Create(DropdownOpt, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
										TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
									end
								end
								TweenService:Create(NewDropdown.Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Rotation = 180}):Play()	
								wait(0.35)
								NewDropdown.List.Visible = false
							end
							Debounce = false
						end)
					end

					for _, droption in ipairs(NewDropdown.List:GetChildren()) do
						if droption.ClassName == "Frame" then
							if not table.find(DropdownSettings.CurrentOption, droption.Name) then
								droption.BackgroundColor3 = Color3.fromRGB(55,55,55)
							else
								droption.BackgroundColor3 = Color3.fromRGB(75,75,75)
							end
						end
					end

					return DropdownValue
				end

				return Section
			end
			return Container
		end
		return Tab
	end

	return Window

end

return HexLibrary
