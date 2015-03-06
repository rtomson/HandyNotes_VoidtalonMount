local ADDON_NAME, ns = ...
local ADDON_ICON = "Interface\\ICONS\\inv_enchant_essencecosmicgreater"
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")

local L = ns.L
local PLUGIN_NAME = L["Edge of Reality"]

local points = {
    ["FrostfireRidge"] = {
        [53791727] = 0,
        [51021983] = 0,
        [52371814] = 0,
        [48022741] = 0,
    },
    ["Gorgrond"] = {
        [43223418] = 0,
        [56014063] = 0,
        [53994580] = 0,
        [51583865] = 0,
    },
    ["NagrandDraenor"] = {
        [44043079] = 0,
        [40554760] = 0,
        [57302653] = 0,
    },
    ["ShadowmoonValleyDR"] = {
        [43597136] = 0,
        [50327152] = 0,
        [48797016] = 0,
        [41897567] = 0,
        [51687487] = 0,
        [46647021] = 0,
    },
    ["SpiresOfArak"] = {
        [60911122] = 0,
        [46862017] = 0,
        [36401831] = 0,
        [50470631] = 0,
    },
    ["Talador"] = {
        [39865561] = 0,
        [46265258] = 0,
        [52272585] = 0,
        [50943245] = 0,
        [52164110] = 0,
        [47244892] = 0,
        [52643437] = 0,
    },
}

local waypoints = {}
------------------------------------------------------------------------
local pluginHandler = {}

function pluginHandler:OnEnter(mapFile, coord)
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
    if self:GetCenter() > UIParent:GetCenter() then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
    tooltip:SetText(L["Edge of Reality"])
    tooltip:Show()
end

function pluginHandler:OnLeave()
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
    tooltip:Hide()
end

do
    local function setWaypoint(mapFile, coord)
        if waypoints[coord] and TomTom:IsValidWaypoint(waypoints[coord]) then
            return
        end
        local mapID = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        waypoints[coord] = TomTom:AddMFWaypoint(mapID, nil, x, y, {
            title = L["Edge of Reality"],
            persistent = nil,
            minimap = true,
            world = true,
            arrivaldistance = 15,
            cleardistance = 20,
        })
    end

    function pluginHandler:OnClick(button, down, mapFile, coord)
        if button ~= "RightButton" or down ~= true or not TomTom then
            return
        end
        if IsControlKeyDown() then
            for coord in pairs(points[mapFile]) do
                setWaypoint(mapFile, coord)
            end
            local data = waypoints[coord]
            TomTom:SetCrazyArrow(data, TomTom.profile.arrow.arrival, data.title)
        else
            setWaypoint(mapFile, coord)
        end
    end
end

do
    local function iterator(t, last)
        if not t then return end
        local k = next(t, last)
        while k do
            if k then
                return k, nil, ADDON_ICON, 1, 1
            end
            k = next(t, k)
        end
    end

    function pluginHandler:GetNodes(mapFile)
        return iterator, points[mapFile]
    end
end

------------------------------------------------------------------------

local Addon = CreateFrame("Frame")
Addon:RegisterEvent("PLAYER_LOGIN")
Addon:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)

function Addon:PLAYER_LOGIN()
    HandyNotes:RegisterPluginDB(PLUGIN_NAME, pluginHandler)
end
