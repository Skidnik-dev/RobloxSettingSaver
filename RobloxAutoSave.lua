local gameSettings = UserSettings().GameSettings;
local httpService = game:GetService("HttpService");
local savesettings = {
    ControlMode = true,
    ComputerCameraMovementMode = true,
    ComputerMovementMode = true,
    MouseSensitivity = true,
    MasterVolume = true,
    SavedQualityLevel = true,
    CameraYInverted = true,
    OnScreenProfilerEnabled = true,
    PerformanceStatsVisible = true
};
local savedsettings = {};
local function specialDecode(json)
    local decoded = {};
    local tab = httpService:JSONDecode(json);
    for i, v in next, tab do
        if string.match(v, "Enum") then
            local _, enumSection, enumItem = unpack(string.split(v, "."));
            decoded[i] = Enum[enumSection][enumItem];
        elseif v == "true" then
            decoded[i] = true;
        elseif v == "false" then
            decoded[i] = false;
        else
            decoded[i] = v;
        end
    end
    return decoded;
end
if not isfile("RobloxSettings.json") then
    for i, v in next, savesettings do
        if savedsettings[i] then
            savedsettings[i] = tostring(gameSettings[i]);
        end
    end
    writefile("RobloxSettings.json", httpService:JSONEncode(savedsettings));
else
    local data = readfile("RobloxSettings.json");
    local decoded = specialDecode(data);
    for i, v in next, decoded do
        if gameSettings[i] ~= v then gameSettings[i] = v; end
        savedsettings[i] = tostring(v);
    end
end

local function settingChanged(name)
    if savesettings[name] then
        savedsettings[name] = tostring(gameSettings[name]);
        writefile("RobloxSettings.json", httpService:JSONEncode(savedsettings));
    end
end

gameSettings.Changed:Connect(settingChanged);
gameSettings.PerformanceStatsVisibleChanged:Connect(function(bool)
    if savesettings["PerformanceStatsVisible"] then
        savedsettings["PerformanceStatsVisible"] = tostring(bool);
        writefile("RobloxSettings.json", httpService:JSONEncode(savedsettings));
    end
end);
