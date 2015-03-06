local ADDON_NAME, ns = ...

local localization = {
    ["enUS"] = {
        ["Edge of Reality"] = "Edge of Reality",
    },
}

do
    for locale, tbl in pairs(localization) do
        locale = setmetatable(tbl, {__index = default})
    end
end

ns.L = localization[GetLocale()] or default
