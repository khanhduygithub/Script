-- ================================================================
--                      МОДУЛЬ GUI (GUI.lua) - MOBILE VERSION
-- ================================================================

local GUI = {}
GUI.__index = GUI

function GUI:Initialize(core, utils)
    local self = setmetatable({}, GUI)
    self.Core = core
    self.Utils = utils
    
    self:LoadLibrary()
    self:CreateInterface()
    self:SetupEventHandlers()
    
    print("✅ GUI Mobile инициализирован")
    return self
end

function GUI:LoadLibrary()
    -- Загрузка LinoriaLib
    local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
    self.Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
    self.ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
    self.SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
    
    -- Создание главного окна với kích thước nhỏ hơn
    self.Window = self.Library:CreateWindow({
        Title = 'Mobile AimBot',
        Center = true,
        AutoShow = true,
        TabPadding = 4, -- Giảm padding
        MenuFadeTime = 0.1
    })
    
    self.MainTab = self.Window:AddTab('Main')
end

function GUI:CreateInterface()
    -- === COMPACT AIM GROUP ===
    local AimGroup = self.MainTab:AddLeftGroupbox('Aim Bot')
    
    AimGroup:AddToggle('AimBotEnabled', {
        Text = 'Enable',
        Default = self.Core.Config.AimBot.Enabled,
        Tooltip = 'Toggle silent aim'
    }):AddColorPicker('AimBotColor', {
        Default = Color3.new(1, 0, 0),
        Title = 'AimBot Color'
    })
    
    AimGroup:AddDropdown('AimBotMethod', {
        Values = {'Ray', 'FireServer'},
        Default = self.Core.Config.AimBot.Method,
        Multi = false,
        Text = 'Method',
        Tooltip = 'Aim bot method'
    })
    
    AimGroup:AddToggle('ShowFOV', {
        Text = 'Show FOV',
        Default = self.Core.Config.AimBot.ShowFOV,
        Tooltip = 'Display FOV circle'
    })
    
    AimGroup:AddSlider('FOVRadius', {
        Text = 'FOV Size',
        Default = self.Core.Config.AimBot.FOVRadius,
        Min = 50,
        Max = 500, -- Giảm max FOV cho mobile
        Rounding = 0,
        Tooltip = 'FOV circle radius'
    })
    
    -- === COMPACT ESP GROUP ===
    local ESPGroup = self.MainTab:AddLeftGroupbox('ESP')
    
    ESPGroup:AddToggle('ESPEnabled', {
        Text = 'Enable ESP',
        Default = self.Core.Config.ESP.Enabled,
        Tooltip = 'Toggle ESP'
    }):AddColorPicker('ESPColor', {
        Default = Color3.new(0, 1, 0),
        Title = 'ESP Color'
    })
    
    ESPGroup:AddToggle('ShowNames', {
        Text = 'Names',
        Default = self.Core.Config.ESP.ShowName,
        Tooltip = 'Show names'
    })
    
    ESPGroup:AddToggle('ShowDistance', {
        Text = 'Distance',
        Default = self.Core.Config.ESP.ShowDistance,
        Tooltip = 'Show distance'
    })
    
    -- === MOBILE SETTINGS GROUP ===
    local SettingsGroup = self.MainTab:AddRightGroupbox('Settings')
    
    SettingsGroup:AddToggle('AimAtCursor', {
        Text = 'Aim at Cursor',
        Default = self.Core.Config.AimBot.AimAtCursor,
        Tooltip = 'Target near cursor'
    })
    
    SettingsGroup:AddToggle('CheckNPC', {
        Text = 'Target NPCs',
        Default = self.Core.Config.AimBot.CheckNPC,
        Tooltip = 'Include NPCs'
    })
    
    SettingsGroup:AddToggle('Gun', {
        Text = 'Gun Aimbot',
        Default = self.Core.Config.AimBot.Gun,
        Tooltip = 'Gun aimbot'
    })
    
    SettingsGroup:AddSlider('MaxDistance', {
        Text = 'Max Distance',
        Default = self.Core.Config.AimBot.Filtering.MaxDistance,
        Min = 500,
        Max = 5000, -- Giảm khoảng cách tối đa cho mobile
        Rounding = 0,
        Suffix = ' studs',
        Tooltip = 'Max target distance'
    })
    
    -- === MOBILE TOOLS GROUP ===
    local ToolsGroup = self.MainTab:AddRightGroupbox('Tools')
    
    ToolsGroup:AddButton({
        Text = 'Copy Job ID',
        Func = function()
            if setclipboard then
                setclipboard(game.JobId)
                self.Library:Notify('Job ID copied!', 2)
            end
        end,
        DoubleClick = true, -- Yêu cầu double click để tránh accidental click
        Tooltip = 'Copy server Job ID'
    })
    
    ToolsGroup:AddButton({
        Text = 'Rejoin Server',
        Func = function()
            pcall(function()
                self.Core.Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, self.Core.LocalPlayer)
            end)
        end,
        DoubleClick = true,
        Tooltip = 'Rejoin current server'
    })
    
    ToolsGroup:AddButton({
        Text = 'Hide GUI',
        Func = function()
            self.Window:Hide()
        end,
        Tooltip = 'Hide GUI (reopen with hotkey)'
    })
    
    -- Thêm hotkey để mở/đóng GUI (phím M cho mobile)
    self.Library:SetHotkey('Enum.KeyCode.M', function()
        if self.Window then
            if self.Window.Visible then
                self.Window:Hide()
            else
                self.Window:Show()
            end
        end
    end)
end

function GUI:SetupEventHandlers()
    -- AimBot event handlers
    self.Library.Toggles.AimBotEnabled:OnChanged(function() 
        self.Core.Config.AimBot.Enabled = self.Library.Toggles.AimBotEnabled.Value 
    end)
    
    self.Library.Options.AimBotMethod:OnChanged(function() 
        self.Core.Config.AimBot.Method = self.Library.Options.AimBotMethod.Value 
    end)
    
    self.Library.Toggles.ShowFOV:OnChanged(function() 
        self.Core.Config.AimBot.ShowFOV = self.Library.Toggles.ShowFOV.Value 
    end)
    
    self.Library.Toggles.CheckNPC:OnChanged(function() 
        self.Core.Config.AimBot.CheckNPC = self.Library.Toggles.CheckNPC.Value 
    end)
    
    self.Library.Toggles.Gun:OnChanged(function() 
        self.Core.Config.AimBot.Gun = self.Library.Toggles.Gun.Value 
    end)
    
    -- ESP event handlers
    self.Library.Toggles.ESPEnabled:OnChanged(function() 
        self.Core.Config.ESP.Enabled = self.Library.Toggles.ESPEnabled.Value 
    end)
    
    self.Library.Toggles.ShowNames:OnChanged(function() 
        self.Core.Config.ESP.ShowName = self.Library.Toggles.ShowNames.Value 
    end)
    
    self.Library.Toggles.ShowDistance:OnChanged(function() 
        self.Core.Config.ESP.ShowDistance = self.Library.Toggles.ShowDistance.Value 
    end)
    
    -- Settings event handlers
    self.Library.Toggles.AimAtCursor:OnChanged(function() 
        self.Core.Config.AimBot.AimAtCursor = self.Library.Toggles.AimAtCursor.Value 
    end)
    
    self.Library.Options.MaxDistance:OnChanged(function() 
        self.Core.Config.AimBot.Filtering.MaxDistance = self.Library.Options.MaxDistance.Value 
    end)
    
    self.Library.Options.FOVRadius:OnChanged(function() 
        self.Core.Config.AimBot.FOVRadius = self.Library.Options.FOVRadius.Value 
    end)
    
    -- Color pickers
    self.Library.Options.AimBotColor:OnChanged(function()
        self.Core.Config.AimBot.FOVColor = self.Library.Options.AimBotColor.Value
    end)
    
    self.Library.Options.ESPColor:OnChanged(function()
        self.Core.Config.ESP.BoxColor = self.Library.Options.ESPColor.Value
    end)
end

-- Phương thức để điều chỉnh kích thước GUI động cho mobile
function GUI:AdjustForMobile()
    if self.Window then
        -- Giảm kích thước font chữ
        for _, element in pairs(self.Library.Elements) do
            if element.TextLabel then
                element.TextLabel.TextSize = 12
            end
        end
        
        -- Tăng kích thước touch areas cho mobile
        for _, toggle in pairs(self.Library.Toggles) do
            if toggle.Button then
                toggle.Button.Size = UDim2.new(0, 120, 0, 25) -- Kích thước lớn hơn cho touch
            end
        end
        
        for _, button in pairs(self.Library.Buttons) do
            if button.Button then
                button.Button.Size = UDim2.new(0, 120, 0, 28) -- Kích thước lớn hơn cho touch
            end
        end
    end
end

function GUI:GetToggleValue(name)
    return self.Library.Toggles[name] and self.Library.Toggles[name].Value or false
end

function GUI:GetOptionValue(name)
    return self.Library.Options[name] and self.Library.Options[name].Value or nil
end

-- Phương thức để ẩn/hiện GUI
function GUI:Toggle()
    if self.Window then
        if self.Window.Visible then
            self.Window:Hide()
        else
            self.Window:Show()
        end
    end
end

return GUI