--[[
    The Cracked Balatro (Cracklatro)
    Author: Unknow102
    Framework: Steamodded (SMODS)
--]]

local files = {
    -- Core & Engine Hooks
    "src/core/utils.lua",

    -- Jokers
    "src/jokers/common.lua",
    "src/jokers/uncommon.lua",
    "src/jokers/rare.lua",
    "src/jokers/secret.lua",

    -- Consumables, Enhancements & Seals
    "src/consumables/spectrals.lua",
    "src/consumables/enhancements.lua",
    "src/consumables/jobs.lua",

    -- Blinds, Decks, Vouchers & Tags
    "src/blinds/boss_blinds.lua",
    "src/decks/decks.lua",
    "src/vouchers/vouchers.lua",
    "src/tags/tags.lua",

    -- Mod Compatibility
    "src/compat/jokerdisplay.lua"
}

for _, file in ipairs(files) do
    assert(SMODS.load_file(file))()
end
