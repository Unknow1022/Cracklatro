-- Boss Blinds

-- 1. The Pole
SMODS.Atlas {
    key = "b_pole",
    path = "b_pole.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'pole',
    atlas = 'b_pole',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('7f8c8d'),
    loc_txt = {
        name = 'The Pole',
        text = {
            "Cards with Editions (Foil, Holo, Poly)",
            "lose $10 when scored"
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and context.other_card.edition then
            ease_dollars(-10)
            return {
                message = '-$10',
                colour = G.C.MONEY
            }
        end
    end
}

-- 2. The Rod
SMODS.Atlas {
    key = "b_stick",
    path = "b_stick.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'stick',
    atlas = 'b_stick',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('145a32'),
    loc_txt = {
        name = 'The Rod',
        text = {
            "If score triples target,",
            "next round target is X1.5"
        }
    },
    defeat = function(self)
        if G.GAME.chips and G.GAME.blind and G.GAME.chips >= G.GAME.blind.chips * 3 then
            G.GAME.stick_penalty = 1.5
        end
    end
}

-- 3. The Magician
SMODS.Atlas {
    key = "b_wizard",
    path = "b_wizard.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'wizard',
    atlas = 'b_wizard',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('8e44ad'),
    loc_txt = {
        name = 'The Magician',
        text = {
            "At final scoring, halves final Chips",
            "and reduces final Mult to 1/3"
        }
    },
    calculate = function(self, card, context)
        if context.before then
            G.GAME.wizard_triggered = nil
        end
        if context.final_scoring_step and not G.GAME.wizard_triggered then
            G.GAME.wizard_triggered = true
            return {
                x_chips = 0.5,
                Xmult = 1 / 3,
                message = '/2 Chips, /3 Mult!',
                colour = HEX('8e44ad')
            }
        end
    end
}

-- 4. The Mountain
SMODS.Atlas {
    key = "b_mountain",
    path = "b_mountain.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'mountain',
    atlas = 'b_mountain',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('0e6655'),
    loc_txt = {
        name = 'The Mountain',
        text = {
            "Using consumables disables",
            "scoring on the next hand"
        }
    }
}

-- 5. The Door
SMODS.Atlas {
    key = "b_door",
    path = "b_door.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'door',
    atlas = 'b_door',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('e84393'),
    loc_txt = {
        name = 'The Door',
        text = {
            "Hands with odd number",
            "of cards do not score"
        }
    },
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local odd_hand_names = {
            ['High Card'] = true,
            ['Three of a Kind'] = true,
            ['Full House'] = true,
            ['Five of a Kind'] = true,
            ['Straight'] = true,
            ['Flush'] = true,
            ['Straight Flush'] = true,
            ['Flush House'] = true,
            ['Flush Five'] = true
        }
        if #cards % 2 ~= 0 or odd_hand_names[text] then
            return 0, 0, true
        end
        return mult, hand_chips, false
    end
}

-- 6. The Triangle
SMODS.Atlas {
    key = "b_triangle",
    path = "b_triangle.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'triangle',
    atlas = 'b_triangle',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('1b4f72'),
    loc_txt = {
        name = 'The Triangle',
        text = {
            "Hands with even number",
            "of cards do not score"
        }
    },
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local even_hand_names = {
            ['Pair'] = true,
            ['Two Pair'] = true,
            ['Four of a Kind'] = true
        }
        if #cards % 2 == 0 or even_hand_names[text] then
            return 0, 0, true
        end
        return mult, hand_chips, false
    end
}

-- 7. The Cube
SMODS.Atlas {
    key = "b_cube",
    path = "b_cube.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'cube',
    atlas = 'b_cube',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX('3498db'),
    loc_txt = {
        name = 'The Cube',
        text = {
            "Halves final Chips and Mult",
            "if the number is even in final scoring"
        }
    },
    calculate = function(self, card, context)
        if context.before then
            G.GAME.cube_triggered = nil
        end
        if context.final_scoring_step and not G.GAME.cube_triggered then
            G.GAME.cube_triggered = true
            local cur_chips = (hand_chips and hand_chips > 0 and hand_chips) or (context.chips and context.chips > 0 and context.chips) or 0
            local cur_mult = (mult and mult > 0 and mult) or (context.mult and context.mult > 0 and context.mult) or 0
            local mod_chips = (cur_chips > 0 and cur_chips % 2 == 0) and 0.5 or 1
            local mod_mult = (cur_mult > 0 and cur_mult % 2 == 0) and 0.5 or 1
            if mod_chips < 1 or mod_mult < 1 then
                return {
                    x_chips = mod_chips,
                    Xmult = mod_mult,
                    message = 'Cube Halved!',
                    colour = HEX('3498db')
                }
            end
        end
    end
}

-- 8. The Void (Showdown)
SMODS.Atlas {
    key = "b_void",
    path = "b_void.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'void',
    atlas = 'b_void',
    pos = { x = 0, y = 0 },
    dollars = 8,
    mult = 2,
    boss = { min = 8, max = 10, showdown = true },
    showdown = true,
    boss_colour = HEX('1a052e'),
    loc_txt = {
        name = 'The Void',
        text = {
            "Increases chip requirement by",
            "{C:attention}X1.25{} after each played hand",
            "that does not defeat the blind"
        }
    },
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME and G.GAME.blind and G.GAME.chips < G.GAME.blind.chips then
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.25)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    message = 'X1.25 Target!',
                    colour = HEX('8e44ad')
                }
            end
        end
    end
}

local function sync_blind_atlases()
    local blind_atlases = {'b_pole', 'b_stick', 'b_wizard', 'b_mountain', 'b_door', 'b_triangle', 'b_cube', 'b_void'}
    for _, key in ipairs(blind_atlases) do
        local atlas_obj = (SMODS and SMODS.Atlases and SMODS.Atlases[key]) or (G.ASSET_ATLAS and G.ASSET_ATLAS[key]) or (G.ANIMATION_ATLAS and G.ANIMATION_ATLAS[key])
        if atlas_obj then
            if G.ASSET_ATLAS and not G.ASSET_ATLAS[key] then G.ASSET_ATLAS[key] = atlas_obj end
            if G.ANIMATION_ATLAS and not G.ANIMATION_ATLAS[key] then G.ANIMATION_ATLAS[key] = atlas_obj end
        end
    end
end

sync_blind_atlases()
G.E_MANAGER:add_event(Event({
    func = function()
        sync_blind_atlases()
        return true
    end
}))
