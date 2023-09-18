# Hex UI - Version [1.2]

## Code Example
```lua
local HexLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/oficialbadware/LuaU/main/Interfaces/Hex/BadWare/UI.lua", true))()
local Window = HexLibrary:CreateWindow({
    Name = "BADWARE",
    Game = "Shit Test BETA",
    Discord = false,
    DiscordConfig = {
        Invite = "noserverinvite",
    },
})

local Tab = Window:CreateTab("Test Tab")
local Container = Tab:CreateContainer("Tab TWO")
local SectionOne = Container:AddSection("Farm")
local SectionThree = Container:AddSection("hello world moretto")

-- ; Toggle
SectionOne:CreateToggle({
    Name = "Nigga Toggle",
	CurrentValue = false,
    Callback = function(Bool)
		print(Bool)
    end
})

-- ; Button
SectionOne:CreateButton("Button Untitled", function()
	print("This is a Button")
end)

SectionOne:CreateButton("Nigga button2", function()
	print("Nigga Button2")
end)

-- ; Slider
SectionOne:CreateSlider({
	Name = "Slider Untitled",
	Range = {0, 10},
	Increment = 1,
	CurrentValue = 2,
	Callback = function(Value)
		print(Value)
	end,
})

-- ; Textbox
SectionThree:CreateTextBox({
	Name = "Textbox Untitled",
	RemoveText = false,
	Placeholder = "Placeholder",
	Callback = function(Value)
		print(Value)
	end,
})

-- ; Dropdown
SectionThree:CreateDropdown({
	Name = "Dropdown Untitled",
	Options = {"Option 1","Option 2"},
	CurrentOption = {"Option 1"},
	MultipleOptions = true,
	Callback = function(Options)
		print(Options[1])
	end,
})

-- ; Label
SectionThree:CreateLabel("Text Label Content")

-- ; Notify
HexLibrary:Notify("Title", "Content", 1, 1)
```
