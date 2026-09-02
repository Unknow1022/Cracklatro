-- Common Jokers

-- Masterful Joker
SMODS.Atlas {
    key = "masterful_joker",
    path = "masterful_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'masterful_joker',
    atlas = 'masterful_joker',
    loc_txt = {
        name = 'Masterful Joker',
        text = {
            "{C:mult}+#1#{} Mult if played hand contains",
            "a {C:attention}Four of a Kind{} or {C:attention}Five of a Kind{}"
        }
    },
    config = { extra = { mult = 25 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands then
            local has_poker_or_five = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                      (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if has_poker_or_five then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

-- Outstanding Joker
SMODS.Atlas {
    key = "outstanding_joker",
    path = "outstanding_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'outstanding_joker',
    atlas = 'outstanding_joker',
    unlocked = false,
    loc_txt = {
        name = 'Outstanding Joker',
        text = {
            "{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult, and {C:money}$#3#{}",
            "if played hand contains a {C:attention}Four of a Kind{}",
            "or {C:attention}Five of a Kind{}"
        },
        unlock = {
            "Play a",
            "{C:attention}Five of a Kind{}"
        }
    },
    config = { extra = { chips = 250, mult = 50, dollars = 5 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars } }
    end,
    check_for_unlock = function(self, args)
        if (args.type == 'hand' or args.type == 'play_hand') and (args.handname == 'Five of a Kind' or args.handname == 'Flush Five') then
            return true
        end
        if G.GAME and G.GAME.hands and G.GAME.hands['Five of a Kind'] and (G.GAME.hands['Five of a Kind'].played or 0) > 0 then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands then
            local has_poker_or_five = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                      (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if has_poker_or_five then
                ease_dollars(card.ability.extra.dollars)
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}

-- Blueberry
SMODS.Atlas {
    key = "blueberry_joker",
    path = "blueberry_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'blueberry_joker',
    atlas = 'blueberry_joker',
    loc_txt = {
        name = 'Blueberry',
        text = {
            "{C:blue}+1{} Hand when {C:attention}Blind{} is selected.",
            "Self-destructs after {C:attention}#1#{} round#2#{}",
            "{C:inactive}(Art by kars_on_mars){}"
        }
    },
    config = { extra = { hands = 1, rounds_left = 3 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local r = (card and card.ability and card.ability.extra and card.ability.extra.rounds_left) or 3
        return { vars = { r, (r == 1 and '' or 's') } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            ease_hands_played(card.ability.extra.hands)
            return {
                message = '+1 Hand!',
                colour = G.C.BLUE
            }
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
            if card.ability.extra.rounds_left <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Expired!',
                    colour = G.C.RED
                }
            else
                return {
                    message = card.ability.extra.rounds_left .. ' left!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

-- DJ Joker
SMODS.Atlas {
    key = "dj_joker",
    path = "dj_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'dj_joker',
    atlas = 'dj_joker',
    loc_txt = {
        name = 'DJ Joker',
        text = {
            "If played hand contains only {C:attention}1 card{},",
            "converts it into a random {C:attention}Lucky{},",
            "{C:attention}Steel{}, {C:attention}Gold{}, or {C:attention}Glass{} card"
        }
    },
    config = {},
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local play_count = (context.full_hand and #context.full_hand) or (context.scoring_hand and #context.scoring_hand) or (G.play and G.play.cards and #G.play.cards) or 0
            if play_count == 1 and context.scoring_hand and #context.scoring_hand == 1 then
                local target_card = context.scoring_hand[1]
                local enhancements = { G.P_CENTERS.m_lucky, G.P_CENTERS.m_steel, G.P_CENTERS.m_gold, G.P_CENTERS.m_glass }
                local chosen_enh = pseudorandom_element(enhancements, pseudoseed('dj_joker'))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        play_sound('tarot1')
                        target_card:set_ability(chosen_enh)
                        target_card:juice_up(0.5, 0.5)
                        card:juice_up(0.3, 0.5)
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Remixed!', colour = G.C.SECONDARY_SET.Enhanced })
                        return true
                    end
                }))
            end
        end
    end
}

-- Injured Joker (Joker Lesionado)
SMODS.Atlas {
    key = "lesionado_joker",
    path = "lesionado_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'lesionado_joker',
    atlas = 'lesionado_joker',
    loc_txt = {
        name = 'Injured Joker',
        text = {
            "After playing {C:attention}#1#{} Straight#2#{},",
            "self-destructs and creates {C:attention}Mr. Bones{}",
            "{C:inactive}(#3# left){}"
        }
    },
    config = { extra = { straights_left = 3 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local left = (card and card.ability and card.ability.extra and card.ability.extra.straights_left) or 3
        return { vars = { 3, (left == 1 and '' or 's'), left } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.poker_hands then
            local is_straight = (context.poker_hands['Straight'] and next(context.poker_hands['Straight'])) or
                                (context.poker_hands['Straight Flush'] and next(context.poker_hands['Straight Flush']))
            if is_straight then
                card.ability.extra.straights_left = math.max(0, card.ability.extra.straights_left - 1)
                if card.ability.extra.straights_left <= 0 then
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'My Leg!', colour = G.C.RED })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            play_sound('tarot2')
                            card:start_dissolve()
                            local bones = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mr_bones', 'lesionado')
                            bones:add_to_deck()
                            G.jokers:emplace(bones)
                            bones:juice_up(0.6, 0.6)
                            return true
                        end
                    }))
                    return {
                        message = 'My Leg!',
                        colour = G.C.RED
                    }
                else
                    return {
                        message = card.ability.extra.straights_left .. ' Straights left!',
                        colour = G.C.ATTENTION
                    }
                end
            end
        end
    end
}

-- Designer Joker (Joker Diseñador)
SMODS.Atlas {
    key = "disenador_joker",
    path = "disenador_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'disenador_joker',
    atlas = 'disenador_joker',
    loc_txt = {
        name = 'Designer Joker',
        text = {
            "Scored {C:attention}Wild Cards{} give {C:money}$#1#{}",
            "when scored"
        }
    },
    config = { extra = { dollars = 1 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability and card.ability.extra and card.ability.extra.dollars) or 1 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if is_wild_card(context.other_card) then
                local d = (card.ability and card.ability.extra and card.ability.extra.dollars) or 1
                ease_dollars(d)
                return {
                    dollars = d,
                    card = card
                }
            end
        end
    end
}

-- TTS Joker
SMODS.Atlas {
    key = "tts_joker",
    path = "tts_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'tts_joker',
    atlas = 'tts_joker',
    loc_txt = {
        name = 'TTS',
        text = {
            "Scored {C:attention}Aces{} give {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips.",
            "{C:attention}Aces{} held in hand give {C:money}$#3#{} at end of round"
        }
    },
    config = { extra = { mult = 20, chips = 10, dollars = 2 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local mult = (card and card.ability and card.ability.extra and card.ability.extra.mult) or 20
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips) or 10
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or 2
        return { vars = { mult, chips, dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local id = context.other_card:get_id()
            if id == 14 then
                return {
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local ace_count = 0
            if G.hand and G.hand.cards then
                for _, hc in ipairs(G.hand.cards) do
                    if hc:get_id() == 14 then
                        ace_count = ace_count + 1
                    end
                end
            end
            if ace_count > 0 then
                local total_money = ace_count * card.ability.extra.dollars
                ease_dollars(total_money)
                return {
                    dollars = total_money,
                    message = '+$' .. total_money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}
