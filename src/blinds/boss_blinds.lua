-- Boss Blinds

G.CRACKEDLATRO_BLIND_THEMES = {
    ['pole'] = {
        name = 'The Pole',
        boss_colour = HEX('868686'),
        new_colour = HEX('2b2b2b'),
        special_colour = HEX('a3a3a3'),
        tertiary_colour = HEX('1a1a1a'),
        contrast = 2
    },
    ['stick'] = {
        name = 'The Rod',
        boss_colour = HEX('439a4f'),
        new_colour = HEX('1a3e20'),
        special_colour = HEX('71b27a'),
        tertiary_colour = HEX('0e2312'),
        contrast = 2
    },
    ['wizard'] = {
        name = 'The Magician',
        boss_colour = HEX('8a52b4'),
        new_colour = HEX('3d165c'),
        special_colour = HEX('ad75d7'),
        tertiary_colour = HEX('200933'),
        contrast = 2.5
    },
    ['mountain'] = {
        name = 'The Mountain',
        boss_colour = HEX('5b94b3'),
        new_colour = HEX('1a3c4f'),
        special_colour = HEX('78b1d0'),
        tertiary_colour = HEX('0f222d'),
        contrast = 2
    },
    ['door'] = {
        name = 'The Door',
        boss_colour = HEX('ff1fdb'),
        new_colour = HEX('610052'),
        special_colour = HEX('ff55e4'),
        tertiary_colour = HEX('300028'),
        contrast = 2.5
    },
    ['triangle'] = {
        name = 'The Triangle',
        boss_colour = HEX('2e8a81'),
        new_colour = HEX('0d3d37'),
        special_colour = HEX('52aea5'),
        tertiary_colour = HEX('05211e'),
        contrast = 2
    },
    ['cube'] = {
        name = 'The Cube',
        boss_colour = HEX('5e8bd6'),
        new_colour = HEX('18386e'),
        special_colour = HEX('7ba8f3'),
        tertiary_colour = HEX('0b1c3b'),
        contrast = 2.5
    },
    ['void'] = {
        name = 'The Void',
        boss_colour = HEX('150426'),
        new_colour = HEX('090112'),
        special_colour = HEX('b067b1'),
        tertiary_colour = HEX('000000'),
        contrast = 3
    },
    ['guitar'] = {
        name = 'The Guitar',
        boss_colour = HEX('ce515a'),
        new_colour = HEX('541318'),
        special_colour = HEX('ef727b'),
        tertiary_colour = HEX('2b080b'),
        contrast = 2.5
    },
    ['phone'] = {
        name = 'The Phone',
        boss_colour = HEX('00b281'),
        new_colour = HEX('004230'),
        special_colour = HEX('00e3a5'),
        tertiary_colour = HEX('002118'),
        contrast = 2
    },
    ['pinza'] = {
        name = 'The Pincer',
        boss_colour = HEX('777777'),
        new_colour = HEX('2d3436'),
        special_colour = HEX('b2bec3'),
        tertiary_colour = HEX('181d1e'),
        contrast = 3
    },
    ['doppelganger'] = {
        name = 'The Doppelgänger',
        boss_colour = HEX('1c2833'),
        new_colour = HEX('0e141a'),
        special_colour = HEX('aeb6bf'),
        tertiary_colour = HEX('070a0d'),
        contrast = 2.5
    }
}

function ease_custom_blind_background(blind)
    if not blind then return end
    local key = (blind.config and blind.config.center and blind.config.center.key) or blind.config.center_key or blind.name or ''
    key = string.gsub(key, '^bl_Crackedlatro_', '')
    key = string.gsub(key, '^b_Crackedlatro_', '')
    key = string.gsub(key, '^bl_', '')
    key = string.gsub(key, '^b_', '')

    local theme = G.CRACKEDLATRO_BLIND_THEMES[key] or G.CRACKEDLATRO_BLIND_THEMES[blind.name]
    if not theme then
        for k, v in pairs(G.CRACKEDLATRO_BLIND_THEMES) do
            if string.find(key, k) or (blind.name and string.find(blind.name, v.name)) then
                theme = v
                break
            end
        end
    end

    if theme then
        G.GAME.blind_color = theme.special_colour or theme.boss_colour
        G.ARGS.blind_colour = G.GAME.blind_color
        if G.C and G.C.DYN_UI then
            G.C.DYN_UI.BOSS_MAIN = theme.boss_colour
            ease_colour(G.C.DYN_UI.MAIN, theme.special_colour)
            ease_colour(G.C.DYN_UI.DARK, theme.tertiary_colour)
        end
        ease_background_colour{
            new_colour = theme.new_colour,
            special_colour = theme.special_colour,
            tertiary_colour = theme.tertiary_colour,
            contrast = theme.contrast or 2
        }
    end
end

local function sync_cracklatro_blind_colours()
    if not G.C or not G.C.BLIND or not G.CRACKEDLATRO_BLIND_THEMES then return end
    for key, data in pairs(G.CRACKEDLATRO_BLIND_THEMES) do
        G.C.BLIND[key] = data.boss_colour
        G.C.BLIND['b_Crackedlatro_' .. key] = data.boss_colour
        G.C.BLIND['bl_Crackedlatro_' .. key] = data.boss_colour
        if data.name then
            G.C.BLIND[data.name] = data.boss_colour
        end
    end
end

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
    boss_colour = HEX('868686'),
    loc_txt = {
        name = 'The Pole',
        text = {
            "Cards with Editions (Foil, Holo, Poly)",
            "lose $10 when scored"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
    boss_colour = HEX('439a4f'),
    loc_txt = {
        name = 'The Rod',
        text = {
            "If score triples target,",
            "next round target is X1.5"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
    boss_colour = HEX('8a52b4'),
    loc_txt = {
        name = 'The Magician',
        text = {
            "At final scoring, halves final Chips",
            "and reduces final Mult to 1/3"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
                colour = HEX('8a52b4')
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
    boss_colour = HEX('5b94b3'),
    loc_txt = {
        name = 'The Mountain',
        text = {
            "Using consumables disables",
            "scoring on the next hand"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end
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
    boss_colour = HEX('ff1fdb'),
    loc_txt = {
        name = 'The Door',
        text = {
            "Hands with odd number",
            "of cards do not score"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
    boss_colour = HEX('2e8a81'),
    loc_txt = {
        name = 'The Triangle',
        text = {
            "Hands with even number",
            "of cards do not score"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
    boss_colour = HEX('5e8bd6'),
    loc_txt = {
        name = 'The Cube',
        text = {
            "Halves final Chips and Mult",
            "if the number is even in final scoring"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
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
                    colour = HEX('5e8bd6')
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
    boss_colour = HEX('150426'),
    loc_txt = {
        name = 'The Void',
        text = {
            "Increases chip requirement by",
            "{C:attention}X1.25{} after each played hand",
            "that does not defeat the blind"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME and G.GAME.blind and G.GAME.chips < G.GAME.blind.chips then
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.25)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    message = 'X1.25 Target!',
                    colour = HEX('b067b1')
                }
            end
        end
    end
}

-- 9. The Guitar (La Guitarra)
SMODS.Atlas {
    key = "b_guitar",
    path = "b_guitar.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'guitar',
    atlas = 'b_guitar',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('ce515a'),
    loc_txt = {
        name = 'The Guitar',
        text = {
            "Hands containing 5 cards",
            "do not score"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        if #cards == 5 then
            return 0, 0, true
        end
        return mult, hand_chips, false
    end,
    calculate = function(self, card, context)
        if context.before and context.full_hand and #context.full_hand == 5 then
            return {
                message = 'Guitar Muted!',
                colour = HEX('ce515a')
            }
        end
    end
}

-- 10. The Phone (El Teléfono)
SMODS.Atlas {
    key = "b_phone",
    path = "b_phone.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'phone',
    atlas = 'b_phone',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('00b281'),
    loc_txt = {
        name = 'The Phone',
        text = {
            "Only the 1st scoring card scores",
            "and triggers Jokers"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand and #context.scoring_hand > 1 then
            for i = 2, #context.scoring_hand do
                context.scoring_hand[i].debuff = true
                context.scoring_hand[i].debuffed_by_phone = true
            end
            return {
                message = '1st Card Only!',
                colour = HEX('00b281')
            }
        end
        if context.after and context.scoring_hand then
            for i = 2, #context.scoring_hand do
                if context.scoring_hand[i].debuffed_by_phone then
                    context.scoring_hand[i].debuff = false
                    context.scoring_hand[i].debuffed_by_phone = nil
                end
            end
        end
    end
}

-- 11. The Pincer (La Pinza - Showdown Boss)
SMODS.Atlas {
    key = "b_pinza",
    path = "b_pinza.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'pinza',
    atlas = 'b_pinza',
    pos = { x = 0, y = 0 },
    dollars = 8,
    mult = 2,
    boss = { min = 8, max = 10, showdown = true },
    showdown = true,
    boss_colour = HEX('777777'),
    loc_txt = {
        name = 'The Pincer',
        text = {
            "All Jokers are disabled until a playing",
            "card is destroyed (except card-destroying Jokers)"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
    set_blind = function(self, reset, silent)
        G.GAME.pinza_card_destroyed = nil
        ease_custom_blind_background(self)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                local key = (j.config and j.config.center and j.config.center.key) or j.config.center_key or (j.ability and j.ability.name) or ''
                local destroys_cards = {
                    ['j_trading'] = true,
                    ['j_sixth_sense'] = true,
                    ['j_Crackedlatro_paula'] = true,
                    ['paula'] = true,
                    ['j_paula'] = true,
                    ['c_Crackedlatro_butcher_job'] = true,
                    ['j_c_butcher'] = true
                }
                if not destroys_cards[key] then
                    j:set_debuff(true)
                end
            end
        end
    end,
    debuff_card = function(self, card, from_blind)
        if card.area == G.jokers and not G.GAME.pinza_card_destroyed then
            local key = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
            local destroys_cards = {
                ['j_trading'] = true,
                ['j_sixth_sense'] = true,
                ['j_Crackedlatro_paula'] = true,
                ['paula'] = true,
                ['j_paula'] = true,
                ['c_Crackedlatro_butcher_job'] = true,
                ['j_c_butcher'] = true
            }
            if destroys_cards[key] then return false end
            return true
        end
        return false
    end
}

-- 12. The Doppelgänger (El Doppelgänger - Showdown Boss)
SMODS.Atlas {
    key = "b_doppelganger",
    path = "b_doppelganger.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'doppelganger',
    atlas = 'b_doppelganger',
    pos = { x = 0, y = 0 },
    dollars = 8,
    mult = 2,
    boss = { min = 8, max = 10, showdown = true },
    showdown = true,
    boss_colour = HEX('1c2833'),
    loc_vars = function(self)
        local target_name = (G.GAME and G.GAME.doppelganger_target_name) or "Random Joker"
        return { vars = { target_name } }
    end,
    loc_txt = {
        name = 'The Doppelgänger',
        text = {
            "Reflects a random Joker inverted:",
            "{C:attention}#1#{}",
            "{C:red}Subtracts{} its Mult & Chips,",
            "{C:red}divides{} by its XMult each time it activates"
        }
    },
    ease_background_colour = function(self)
        ease_custom_blind_background(self)
    end,
    set_blind = function(self, reset, silent)
        ease_custom_blind_background(self)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                j.doppelganger_reflected = nil
            end
        end
        G.GAME.doppelganger_target = nil
        G.GAME.doppelganger_target_name = nil

        local eligible = {}
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if not j.debuff then
                    table.insert(eligible, j)
                end
            end
            if #eligible == 0 then
                for _, j in ipairs(G.jokers.cards) do
                    table.insert(eligible, j)
                end
            end
        end

        if #eligible > 0 then
            local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 1
            local r_num = (G.GAME.round) or 1
            local pick_idx = pseudorandom('doppel_pick_' .. ante .. '_' .. r_num, 1, #eligible)
            local chosen = eligible[pick_idx]
            G.GAME.doppelganger_target = chosen
            chosen.doppelganger_reflected = true
            local jname = (chosen.ability and chosen.ability.name) or (chosen.config and chosen.config.center and chosen.config.center.name) or 'Joker'
            G.GAME.doppelganger_target_name = jname

            self.loc_debuff_text = "Reflecting: " .. jname .. " (Inverted)"
            if G.GAME.blind then
                G.GAME.blind.loc_debuff_text = self.loc_debuff_text
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    if chosen and not chosen.removed then
                        chosen:juice_up(0.8, 0.8)
                        attention_text({
                            text = 'Doppelgänger: ' .. tostring(jname) .. '!',
                            scale = 0.7,
                            hold = 2.5,
                            colour = HEX('aeb6bf'),
                            align = 'cm',
                            offset = { x = 0, y = -1.2 }
                        })
                    end
                    return true
                end
            }))
        else
            self.loc_debuff_text = "No Jokers to reflect"
            if G.GAME.blind then
                G.GAME.blind.loc_debuff_text = self.loc_debuff_text
            end
        end
    end,
    calculate = function(self, card, context)
        local context = context or card
        if not context then return end

        if context.before then
            if not G.GAME.doppelganger_target or G.GAME.doppelganger_target.removed or (G.GAME.doppelganger_target.area and G.GAME.doppelganger_target.area ~= G.jokers) then
                if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 1
                    local r_num = (G.GAME.round) or 1
                    local pick_idx = pseudorandom('doppel_repick_' .. ante .. '_' .. r_num, 1, #G.jokers.cards)
                    local chosen = G.jokers.cards[pick_idx]
                    G.GAME.doppelganger_target = chosen
                    if chosen then
                        chosen.doppelganger_reflected = true
                        local jname = (chosen.ability and chosen.ability.name) or (chosen.config and chosen.config.center and chosen.config.center.name) or 'Joker'
                        G.GAME.doppelganger_target_name = jname
                        self.loc_debuff_text = "Reflecting: " .. jname .. " (Inverted)"
                        if G.GAME.blind then
                            G.GAME.blind.loc_debuff_text = self.loc_debuff_text
                        end
                    end
                else
                    G.GAME.doppelganger_target = nil
                    G.GAME.doppelganger_target_name = "None"
                end
            end
        end
    end,
    defeat = function(self)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                j.doppelganger_reflected = nil
            end
        end
        G.GAME.doppelganger_target = nil
        G.GAME.doppelganger_target_name = nil
        reset_cracklatro_boss_ui()
    end,
    disable = function(self)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                j.doppelganger_reflected = nil
            end
        end
        G.GAME.doppelganger_target = nil
        G.GAME.doppelganger_target_name = nil
        reset_cracklatro_boss_ui()
    end
}

local function sync_blind_atlases()
    local blind_atlases = {'b_pole', 'b_stick', 'b_wizard', 'b_mountain', 'b_door', 'b_triangle', 'b_cube', 'b_void', 'b_guitar', 'b_phone', 'b_pinza', 'b_doppelganger'}
    for _, key in ipairs(blind_atlases) do
        local atlas_obj = (SMODS and SMODS.Atlases and SMODS.Atlases[key]) or (G.ASSET_ATLAS and G.ASSET_ATLAS[key]) or (G.ANIMATION_ATLAS and G.ANIMATION_ATLAS[key])
        if atlas_obj then
            if G.ASSET_ATLAS and not G.ASSET_ATLAS[key] then G.ASSET_ATLAS[key] = atlas_obj end
            if G.ANIMATION_ATLAS and not G.ANIMATION_ATLAS[key] then G.ANIMATION_ATLAS[key] = atlas_obj end
        end
    end
    sync_cracklatro_blind_colours()
end

sync_blind_atlases()
G.E_MANAGER:add_event(Event({
    func = function()
        sync_blind_atlases()
        return true
    end
}))


