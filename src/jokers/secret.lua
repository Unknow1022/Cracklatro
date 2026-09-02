-- Secret Jokers (Secret Rarity)

-- Esteban
SMODS.Atlas {
    key = "esteban_joker",
    path = "esteban_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'esteban',
    atlas = 'esteban_joker',
    loc_txt = {
        name = 'Esteban',
        text = {
            "Scored {C:spades}Spades{} and {C:clubs}Clubs{}",
            "cards give {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(\"*Ignores the kid*\")"
        }
    },
    config = { extra = { xmult = 2.5 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 2.5
        return { vars = { xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') then
                return {
                    x_mult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 2.5,
                    card = card
                }
            end
        end
    end
}

-- Thiago
SMODS.Atlas {
    key = "thiago_joker",
    path = "thiago_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'thiago',
    atlas = 'thiago_joker',
    loc_txt = {
        name = 'Thiago',
        text = {
            "Gives {X:mult,C:white}X1{} Mult for every",
            "{C:chips}#1# Chips{} in final hand chips",
            "{C:inactive}(\"Son, Brochacho 😭\")"
        }
    },
    config = { extra = { chips_per_xmult = 20 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local chips_req = (card and card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or (self.config and self.config.extra and self.config.extra.chips_per_xmult) or 20
        return { vars = { chips_req } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_chips = (hand_chips and hand_chips > 0 and hand_chips) or (context.chips and context.chips > 0 and context.chips) or 0
            local chips_req = (card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or 20
            local xmult = math.floor(current_chips / chips_req)
            if xmult > 1 then
                return {
                    Xmult = xmult,
                    card = card
                }
            end
        end
    end
}

-- Paula
SMODS.Atlas {
    key = "paula_joker",
    path = "paula_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'paula',
    atlas = 'paula_joker',
    loc_txt = {
        name = 'Paula',
        text = {
            "At start of round, {C:red}destroys{} adjacent",
            "Jokers and gains {X:mult,C:white}+X1{} Mult",
            "for each Joker destroyed",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}",
            "{C:inactive}(\"*Nom Nom Nom* NO MOM WAIT I'M NOT EATING\")"
        }
    },
    config = { extra = { xmult = 1.0 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 1.0
        return { vars = { xmult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        my_pos = i
                        break
                    end
                end
            end
            if my_pos then
                local jokers_to_destroy = {}
                if my_pos > 1 then
                    local left_j = G.jokers.cards[my_pos - 1]
                    if left_j and not (left_j.ability and left_j.ability.eternal) and not left_j.getting_sliced then
                        table.insert(jokers_to_destroy, left_j)
                    end
                end
                if my_pos < #G.jokers.cards then
                    local right_j = G.jokers.cards[my_pos + 1]
                    if right_j and not (right_j.ability and right_j.ability.eternal) and not right_j.getting_sliced then
                        table.insert(jokers_to_destroy, right_j)
                    end
                end

                if #jokers_to_destroy > 0 then
                    for _, j in ipairs(jokers_to_destroy) do
                        j.getting_sliced = true
                    end
                    local count = #jokers_to_destroy
                    card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + count
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for _, j in ipairs(jokers_to_destroy) do
                                j:start_dissolve()
                            end
                            return true
                        end
                    }))
                    return {
                        message = '*Nom Nom Nom*',
                        colour = G.C.XMULT
                    }
                end
            end
        end

        if context.joker_main and card.ability.extra.xmult and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-- Black Hole
SMODS.Atlas {
    key = "black_hole_joker",
    path = "black_hole_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'black_hole_joker',
    atlas = 'black_hole_joker',
    loc_txt = {
        name = 'Black Hole',
        text = {
            "Elevates final {C:chips}Chips{} to the power of {C:chips}^#1#{}",
            "and final {C:mult}Mult{} to the power of {C:mult}^#1#{}"
        }
    },
    config = { extra = { pow = 1.5 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local pow = (card and card.ability and card.ability.extra and card.ability.extra.pow) or (self.config and self.config.extra and self.config.extra.pow) or 1.5
        return { vars = { pow } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local pow = (card.ability and card.ability.extra and card.ability.extra.pow) or 1.5

            if hand_chips and hand_chips > 1 then
                hand_chips = math.floor(hand_chips ^ pow)
            end
            if mult and mult > 1 then
                mult = math.floor(mult ^ pow)
            end

            update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })

            return {
                message = '^' .. tostring(pow) .. '!',
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end
}

-- Squele
SMODS.Atlas {
    key = "squele_joker",
    path = "squele_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'squele',
    atlas = 'squele_joker',
    loc_txt = {
        name = 'Squele',
        text = {
            "Scored {C:hearts}Hearts{} cards give {C:mult}+#1#{} Mult",
            "and {X:mult,C:white}X#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to {C:attention}Project{} and create",
            "a {C:dark_edition}Negative{} {C:attention}Bloodstone{}",
            "{C:inactive}(\"I project myself\")"
        }
    },
    config = { extra = { mult = 10, xmult = 1.5, odds = 10 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local mult = (card and card.ability and card.ability.extra and card.ability.extra.mult) or (self.config and self.config.extra and self.config.extra.mult) or 10
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 1.5
        local odds = (card and card.ability and card.ability.extra and card.ability.extra.odds) or (self.config and self.config.extra and self.config.extra.odds) or 10
        return { vars = { mult, xmult, (G.GAME and G.GAME.probabilities.normal or 1), odds } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit('Hearts') then
            local norm = (G.GAME and G.GAME.probabilities.normal or 1)
            local odds = (card.ability and card.ability.extra and card.ability.extra.odds) or 10
            local does_project = pseudorandom('squele_project') < (norm / odds)

            if does_project and G.jokers then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_j = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_bloodstone', 'squele')
                        new_j:set_edition({ negative = true }, true)
                        new_j:add_to_deck()
                        G.jokers:emplace(new_j)
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Negative Bloodstone!', colour = G.C.DARK_EDITION })
                        return true
                    end
                }))
                return {
                    mult = card.ability.extra.mult,
                    x_mult = card.ability.extra.xmult,
                    card = card
                }
            else
                return {
                    mult = card.ability.extra.mult,
                    x_mult = card.ability.extra.xmult,
                    card = card
                }
            end
        end
    end
}

-- Bluxdir
SMODS.Atlas {
    key = "bluxdir_joker",
    path = "bluxdir_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'bluxdir',
    atlas = 'bluxdir_joker',
    loc_txt = {
        name = 'Bluxdir',
        text = {
            "When a hand is {C:attention}discarded{},",
            "levels up the discarded {C:attention}poker hand{}",
            "{C:inactive}(\"*Starts farming aura*\")"
        }
    },
    config = {},
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.hook and context.full_hand and #context.full_hand > 0 then
            local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
            if text and text ~= 'NULL' and G.GAME and G.GAME.hands and G.GAME.hands[text] then
                level_up_hand(card, text, false, 1)
            end
        end
    end
}

-- Charles & Mochi Synergy Helpers
local function is_charles_card(card)
    if not card then return false end
    local k = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    k = string.lower(tostring(k))
    return string.find(k, 'charles') ~= nil
end

local function is_mochi_card(card)
    if not card then return false end
    local k = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    k = string.lower(tostring(k))
    return string.find(k, 'mochi') ~= nil
end

local function has_charles_and_mochi()
    if not (G.jokers and G.jokers.cards) then return false end
    local has_charles = false
    local has_mochi = false
    for _, j in ipairs(G.jokers.cards) do
        if is_charles_card(j) then has_charles = true end
        if is_mochi_card(j) then has_mochi = true end
    end
    return has_charles and has_mochi
end

-- Charles
SMODS.Atlas {
    key = "charles_joker",
    path = "charles_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'charles',
    atlas = 'charles_joker',
    loc_txt = {
        name = 'Charles',
        text = {
            "Scored {C:spades}Spades{} and {C:hearts}Hearts{} cards",
            "give {X:mult,C:white}X#1#{} Mult.",
            "Earn {C:money}$#2#{} for {C:attention}each scored card{}.",
            "{C:inactive}(\"Homie\")"
        }
    },
    config = { extra = { xmult = 2, dollars = 5 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 2
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 5
        return { vars = { xmult, dollars } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if has_charles_and_mochi() then
                return {
                    repetitions = 1,
                    card = card
                }
            end
        end

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if has_charles_and_mochi() then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Best Friends!', colour = HEX('ff69b4') })
                        card:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end
        end

        if context.individual and context.cardarea == G.play then
            local dollars = (card.ability and card.ability.extra and card.ability.extra.dollars) or 5
            local gives_xmult = context.other_card:is_suit('Spades') or context.other_card:is_suit('Hearts')
            local xmult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 2

            ease_dollars(dollars)
            if gives_xmult then
                return {
                    x_mult = xmult,
                    dollars = dollars,
                    card = card
                }
            else
                return {
                    dollars = dollars,
                    card = card
                }
            end
        end
    end
}

-- Mochi
SMODS.Atlas {
    key = "mochi_joker",
    path = "mochi_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'mochi',
    atlas = 'mochi_joker',
    loc_txt = {
        name = 'Mochi',
        text = {
            "Scored cards become {C:attention}Wild Cards{}.",
            "Gives {X:mult,C:white}+X#1#{} Mult for each",
            "{C:attention}Wild Card{} in your full deck",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            "{C:inactive}(\"A drawing for you! :3\")"
        }
    },
    config = { extra = { xmult_gain = 0.25 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult_gain = (card and card.ability and card.ability.extra and card.ability.extra.xmult_gain) or (self.config and self.config.extra and self.config.extra.xmult_gain) or 0.25
        local wild_count = 0
        if G.playing_cards then
            for _, pcard in ipairs(G.playing_cards) do
                if is_wild_card(pcard) then
                    wild_count = wild_count + 1
                end
            end
        end
        local current_xmult = 1.0 + (wild_count * xmult_gain)
        return { vars = { xmult_gain, current_xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config and context.other_card.config.center ~= G.P_CENTERS.m_wild then
                context.other_card:set_ability(G.P_CENTERS.m_wild)
                context.other_card:juice_up()
            end
        end

        if context.joker_main then
            local wild_count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if is_wild_card(pcard) then
                        wild_count = wild_count + 1
                    end
                end
            end
            local xmult_gain = (card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 0.25
            local total_xmult = 1.0 + (wild_count * xmult_gain)
            if total_xmult > 1 then
                return {
                    Xmult = total_xmult
                }
            end
        end
    end
}

-- Helin
SMODS.Atlas {
    key = "helin_joker",
    path = "helin_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'helin',
    atlas = 'helin_joker',
    loc_txt = {
        name = 'Helin',
        text = {
            "On {C:attention}first hand{} of round,",
            "elevates final {C:mult}Mult{} to the power of {X:mult,C:white}^#1#{}",
            "{C:inactive}(\"What is the chat sending?\")"
        }
    },
    config = { extra = { power = 2 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local power = (card and card.ability and card.ability.extra and card.ability.extra.power) or (self.config and self.config.extra and self.config.extra.power) or 2
        return { vars = { power } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0 then
            local pow = (card.ability and card.ability.extra and card.ability.extra.power) or 2

            if mult and mult > 1 then
                mult = math.floor(mult ^ pow)
            end

            update_hand_text({ sound = 'multhit2', modded = true }, { mult = mult })

            return {
                message = '^' .. tostring(pow) .. ' Mult!',
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end
}

-- RayTracing
SMODS.Atlas {
    key = "raytracing_joker",
    path = "raytracing_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'raytracing',
    atlas = 'raytracing_joker',
    loc_txt = {
        name = 'RayTracing',
        text = {
            "Creates {C:attention}2{} random {C:dark_edition}Negative{}",
            "{C:spectral}Spectral{} cards at end of round",
            "{C:inactive}(Except La Muchachada){}",
            "{C:inactive}(\"Depradosini Negrini\")"
        }
    },
    config = {},
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local spectral_cards = {}
                    if G.P_CENTER_POOLS and G.P_CENTER_POOLS['Spectral'] then
                        for _, center in ipairs(G.P_CENTER_POOLS['Spectral']) do
                            if center.key ~= 'c_Crackedlatro_la_muchachada' and center.key ~= 'c_la_muchachada' and center.key ~= 'la_muchachada' then
                                table.insert(spectral_cards, center.key)
                            end
                        end
                    end
                    for i = 1, 2 do
                        local chosen_spectral = (#spectral_cards > 0) and pseudorandom_element(spectral_cards, 'raytracing_spectral') or 'c_ankh'
                        local new_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, chosen_spectral, 'raytracing')
                        new_card:set_edition({ negative = true }, true)
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                    end
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+2 Negative Spectrals!', colour = G.C.DARK_EDITION })
                    card:juice_up(0.6, 0.6)
                    return true
                end
            }))
        end
    end
}

-- Paco
SMODS.Atlas {
    key = "paco_joker",
    path = "paco_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'paco',
    atlas = 'paco_joker',
    loc_txt = {
        name = 'Paco',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult for each",
            "remaining {C:attention}discard{} you currently have",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            "{C:inactive}(\"No need to discard, every card is useful\")"
        }
    },
    config = { extra = { xmult_per_discard = 2 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
        local xmult_per_discard = (card and card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or (self.config and self.config.extra and self.config.extra.xmult_per_discard) or 2
        local total_xmult = math.max(1, discards * xmult_per_discard)
        return { vars = { xmult_per_discard, total_xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
            local xmult_per_discard = (card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or 2
            local total_xmult = discards * xmult_per_discard
            if total_xmult > 1 then
                return {
                    Xmult = total_xmult
                }
            end
        end
    end
}

-- Gabi
SMODS.Atlas {
    key = "gabi_joker",
    path = "gabi_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'gabi',
    atlas = 'gabi_joker',
    loc_txt = {
        name = 'Gabi',
        text = {
            "Scored cards give {X:mult,C:white}X#1#{} Mult,",
            "but {C:attention}subtracts 3/4{} of final {C:chips}Chips{}",
            "at the end of scoring",
            "{C:inactive}(\"Everything has a price...\")"
        }
    },
    config = { extra = { xmult = 4 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 4
        return { vars = { xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                x_mult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 4,
                card = card
            }
        end

        if context.joker_main then
            if hand_chips and hand_chips > 1 then
                hand_chips = math.max(1, math.floor(hand_chips * 0.25))
                update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips })
            end
            return {
                message = '-3/4 Chips',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}

-- Yairo
SMODS.Atlas {
    key = "yairo_joker",
    path = "yairo_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'yairo',
    atlas = 'yairo_joker',
    loc_txt = {
        name = 'Yairo',
        text = {
            "67!!!!"
        }
    },
    config = { extra = { xmult = 3, xchips = 1.5, secret_xmult = 4, secret_xchips = 2 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secret', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local id = (context.other_card.get_id and context.other_card:get_id()) or (context.other_card.base and context.other_card.base.id)
            local val = context.other_card.base and context.other_card.base.value
            if id == 6 or id == 7 or val == '6' or val == '7' then
                return {
                    x_mult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 3,
                    x_chips = (card.ability and card.ability.extra and card.ability.extra.xchips) or 1.5,
                    card = card
                }
            end
        end

        if context.joker_main then
            local has_six = false
            local has_ace = false
            local check_cards = context.scoring_hand or context.full_hand
            if check_cards then
                for _, c in ipairs(check_cards) do
                    local id = (c.get_id and c:get_id()) or (c.base and c.base.id)
                    local val = c.base and c.base.value
                    if id == 6 or val == '6' then has_six = true end
                    if id == 14 or id == 1 or val == 'Ace' or val == '1' then has_ace = true end
                end
            end

            if has_six and has_ace then
                return {
                    Xmult = (card.ability and card.ability.extra and card.ability.extra.secret_xmult) or 4,
                    x_chips = (card.ability and card.ability.extra and card.ability.extra.secret_xchips) or 2,
                    message = 'Secret 6 & Ace!',
                    colour = G.C.DARK_EDITION,
                    card = card
                }
            end
        end
    end
}

