local ADDON_NAME, ns = ...

local default = {
    ["Edge of Reality"] = GetLFGDungeonInfo(907),
}

local localization = {}

do
    local function defaultFunc(L, key) return key end
    for locale, tbl in pairs(localization) do
        locale = setmetatable(tbl, {__index = defaultFunc})
    end
end

ns.L = localization[GetLocale()] or default
