-- Rare Jokers

-- Doctor Jo.
SMODS.Atlas {
    key = "doctor_jo_joker",
    path = "doctor_jo_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'doctor_jo_joker',
    atlas = 'doctor_jo_joker',
    loc_txt = {
        name = 'Doctor Jo.',
        text = {
            "Reimburses {C:money}Rental{} fees and stops {C:attention}Perishable{} loss.",
            "On final hand, if short on chips: grants",
            "{C:blue}+1 Hand{} with {X:mult,C:white}X3{} Mult and removes all debuffs {C:inactive}(1 per Blind){}"
        }
    },
    config = { extra = { defibrillator_used = false } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = false,
    calculate = function(self, card, context)
        -- Start of shop or round: heal debuffs and reset defib
        if (context.starting_shop or context.setting_blind) and not context.blueprint then
            card.ability.extra.defibrillator_used = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.debuff then
                        j.debuff = false
                        j.debuffed_by_blind = nil
                        if j.set_debuff then j:set_debuff(false) end
                    end
                end
            end
        end

        -- Medical Insurance: Reimburse rental fees and preserve perishable
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.defibrillator_used = false
            local rental_reimburse = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.ability and j.ability.rental then
                        rental_reimburse = rental_reimburse + 3
                    end
                    if j.ability and j.ability.perishable then
                        j.ability.perish_tally = (j.ability.perish_tally or 5) + 1
                    end
                end
            end
            if rental_reimburse > 0 then
                ease_dollars(rental_reimburse)
                return {
                    message = 'Medical Insurance! +$' .. rental_reimburse,
                    colour = G.C.MONEY
                }
            end
        end

        -- Emergency Defibrillator
        if context.after and not context.blueprint and G.GAME.chips < G.GAME.blind.chips then
            if G.GAME.current_round and G.GAME.current_round.hands_left == 0 and not card.ability.extra.defibrillator_used then
                card.ability.extra.defibrillator_used = true
                ease_hands_played(1)
                play_sound('tarot1')
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        if j.debuff then
                            j.debuff = false
                            if j.set_debuff then j:set_debuff(false) end
                        end
                    end
                end
                return {
                    message = 'CLEAR! +1 Hand (X3)',
                    colour = G.C.RED
                }
            end
        end

        -- Emergency Hand X3 Mult boost
        if context.joker_main and card.ability.extra.defibrillator_used then
            return {
                Xmult = 3.0
            }
        end
    end
}

-- Symmetrical Joker
SMODS.Atlas {
    key = "symmetrical_joker",
    path = "symmetrical_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'symmetrical_joker',
    atlas = 'symmetrical_joker',
    loc_txt = {
        name = 'Symmetrical Joker',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played {C:attention}Four or Five of a Kind{}",
            "shares the same suit across all scoring cards"
        }
    },
    config = { extra = { xmult = 4.0 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand and context.poker_hands then
            local is_poker = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                             (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind'])) or
                             (context.poker_hands['Flush Five'] and next(context.poker_hands['Flush Five']))
            if is_poker then
                local first_suit = context.scoring_hand[1] and context.scoring_hand[1].base and context.scoring_hand[1].base.suit
                local same_suit = true
                for _, pcard in ipairs(context.scoring_hand) do
                    if not pcard.base or pcard.base.suit ~= first_suit then
                        same_suit = false
                        break
                    end
                end
                if same_suit then
                    return {
                        Xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
}

-- Balance
SMODS.Atlas {
    key = "balance_joker",
    path = "balance_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'balance_joker',
    atlas = 'balance_joker',
    loc_txt = {
        name = 'Balance',
        text = {
            "Creates {C:spectral}#2# Spectral cards{} if played",
            "{C:attention}Four of a Kind{} has all cards of the same suit",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = { cards_needed = 4, spectral_count = 2 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_needed, card.ability.extra.spectral_count } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind']) then
            if context.scoring_hand and #context.scoring_hand == 4 then
                local same_suit = false
                local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                for _, suit in ipairs(suits) do
                    local matches_all = true
                    for _, pcard in ipairs(context.scoring_hand) do
                        if not pcard:is_suit(suit) then
                            matches_all = false
                            break
                        end
                    end
                    if matches_all then
                        same_suit = true
                        break
                    end
                end

                if same_suit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for i = 1, card.ability.extra.spectral_count do
                                if #G.consumeables.cards < G.consumeables.config.card_limit then
                                    local spectral_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'balance')
                                    spectral_card:add_to_deck()
                                    G.consumeables:emplace(spectral_card)
                                end
                            end
                            return true
                        end
                    }))
                    return {
                        message = 'Balance!',
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
            end
        end
    end
}

-- Merchant
SMODS.Atlas {
    key = "merchant_joker",
    path = "merchant_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'merchant_joker',
    atlas = 'merchant_joker',
    unlocked = false,
    loc_txt = {
        name = 'Merchant',
        text = {
            "+1 card slot, +1 voucher, +1 pack, and 25% discount in shop.",
            "Lose {C:money}$#1#{} upon leaving shop"
        },
        unlock = {
            "Enter a shop with at least {C:money}$50{}",
            "and leave with {C:money}$10{} or less"
        }
    },
    config = { extra = { cost_per_shop = 5 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost_per_shop } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'leave_shop' or args.type == 'ending_shop' then
            if G.GAME and G.GAME.entered_shop_dollars and G.GAME.entered_shop_dollars >= 50 and (G.GAME.dollars or 0) <= 10 then
                return true
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
        G.GAME.modifiers.extra_vouchers = (G.GAME.modifiers.extra_vouchers or 0) + 1
        G.GAME.modifiers.extra_packs = (G.GAME.modifiers.extra_packs or 0) + 1
        G.GAME.discount_percent = (G.GAME.discount_percent or 0) + 25
        G.GAME.merchant_rare_boost = (G.GAME.merchant_rare_boost or 0) + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = math.max(1, (G.GAME.shop.joker_max or 3) - 1)
        G.GAME.modifiers.extra_vouchers = math.max(0, (G.GAME.modifiers.extra_vouchers or 0) - 1)
        G.GAME.modifiers.extra_packs = math.max(0, (G.GAME.modifiers.extra_packs or 0) - 1)
        G.GAME.discount_percent = math.max(0, (G.GAME.discount_percent or 0) - 25)
        G.GAME.merchant_rare_boost = math.max(0, (G.GAME.merchant_rare_boost or 0) - 1)
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            ease_dollars(-card.ability.extra.cost_per_shop)
            return {
                message = '-$' .. card.ability.extra.cost_per_shop,
                colour = G.C.MONEY
            }
        end
    end
}

-- Lover
SMODS.Atlas {
    key = "lover_joker",
    path = "lover_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'lover_joker',
    atlas = 'lover_joker',
    unlocked = false,
    loc_txt = {
        name = 'Lover',
        text = {
            "Bonds 2 cards as {C:attention}Soulmates{}: drawing one draws partner.",
            "Scoring both gives {X:mult,C:white}X#1#{} Mult, {C:money}+$#2#{}, and permanent {C:chips}+#3#{} Chips.",
            "Scored {C:hearts}Hearts{} give {C:mult}+#4#{} Mult",
            "{C:inactive}(Soulmates: #5# and #6#){}"
        }
    },
    unlock = {
        "Play a {C:attention}Flush{} of all 4 suits",
        "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
        "in a single run"
    },
    config = { extra = { xmult = 3.0, dollars = 6, perma_chips = 10, heart_mult = 10 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local sm1, sm2 = get_or_pick_soulmates()
        local sm1_str = format_soulmate_card_name(sm1)
        local sm2_str = format_soulmate_card_name(sm2)
        return { vars = { ex.xmult, ex.dollars, ex.perma_chips, ex.heart_mult, sm1_str, sm2_str } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    add_to_deck = function(self, card, from_debuff)
        get_or_pick_soulmates()
    end,
    calculate = function(self, card, context)
        -- Ensure soulmates exist
        if (context.setting_blind or context.first_hand_drawn) and not context.blueprint then
            get_or_pick_soulmates()
        end

        -- Soulmate summon: If 1 in hand and 1 in deck, draw missing partner
        if (context.first_hand_drawn or context.before) and not context.blueprint then
            local in_hand = {}
            local in_deck = {}
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    if c.ability and c.ability.is_soulmate then table.insert(in_hand, c) end
                end
            end
            if #in_hand == 1 and G.deck and G.deck.cards then
                for _, c in ipairs(G.deck.cards) do
                    if c.ability and c.ability.is_soulmate then table.insert(in_deck, c) end
                end
                if #in_deck >= 1 then
                    local partner = in_deck[1]
                    draw_card(G.deck, G.hand, 1, 'up', nil, partner)
                    return {
                        message = 'Soulmates Reunited!',
                        colour = G.C.HEARTS
                    }
                end
            end
        end

        -- Individual Hearts mult
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') then
                return {
                    mult = card.ability.extra.heart_mult,
                    card = card
                }
            end
        end

        -- Both soulmates score in the same hand!
        if context.joker_main and context.scoring_hand then
            local soulmates_scored = {}
            for _, sc in ipairs(context.scoring_hand) do
                if sc.ability and sc.ability.is_soulmate then
                    table.insert(soulmates_scored, sc)
                end
            end
            if #soulmates_scored >= 2 then
                ease_dollars(card.ability.extra.dollars)
                if not context.blueprint then
                    for _, sm in ipairs(soulmates_scored) do
                        sm.ability = sm.ability or {}
                        sm.ability.perma_bonus = (sm.ability.perma_bonus or 0) + card.ability.extra.perma_chips
                    end
                end
                return {
                    Xmult = card.ability.extra.xmult,
                    dollars = card.ability.extra.dollars,
                    message = 'TRUE LOVE! X' .. card.ability.extra.xmult,
                    colour = G.C.HEARTS
                }
            end
        end
    end
}

-- Blacksmith
SMODS.Atlas {
    key = "blacksmith_joker",
    path = "blacksmith_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'blacksmith_joker',
    atlas = 'blacksmith_joker',
    unlocked = false,
    loc_txt = {
        name = 'Blacksmith',
        text = {
            "Played cards add {C:attention}+#1#{} Heat to the forge.",
            "At {C:attention}#2# Heat{}, strikes the anvil: {C:green}1 in 2{} chance",
            "to apply a {C:attention}Silver Seal{} or {C:attention}Steel Card{} enhancement",
            "to the highest scored card and cools to 0 {C:inactive}(Current: #3#/#2# Heat){}"
        }
    },
    unlock = {
        "Play a {C:attention}Flush{} of all 4 suits",
        "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
        "in a single run"
    },
    config = { extra = { temp = 0, heat_per_card = 5, max_temp = 300 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        if info_queue then
            local silver_seal = (G.P_SEALS and (G.P_SEALS['Crackedlatro_silver'] or G.P_SEALS['silver'])) or { set = 'Seal', key = 'silver' }
            info_queue[#info_queue + 1] = silver_seal
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        end
        local current_temp = ex.temp or 0
        local max_temp = ex.max_temp or 300
        local heat_per_card = ex.heat_per_card or 5
        return { vars = { heat_per_card, max_temp, current_temp } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.scoring_hand and #context.scoring_hand > 0 then
            local heat_gain = (card.ability and card.ability.extra and card.ability.extra.heat_per_card) or 5
            local total_gain = #context.scoring_hand * heat_gain
            card.ability.extra.temp = (card.ability.extra.temp or 0) + total_gain
            return {
                message = '+' .. total_gain .. ' Heat!',
                colour = G.C.ORANGE,
                card = card
            }
        end

        if context.joker_main and not context.blueprint then
            local current_temp = (card.ability and card.ability.extra and card.ability.extra.temp) or 0
            local max_temp = (card.ability and card.ability.extra and card.ability.extra.max_temp) or 300

            if current_temp >= max_temp and context.scoring_hand and #context.scoring_hand >= 1 then
                local highest_card = context.scoring_hand[1]
                local highest_rank = -1
                for _, sc in ipairs(context.scoring_hand) do
                    local r = sc:get_id() or 0
                    if r > highest_rank then
                        highest_rank = r
                        highest_card = sc
                    end
                end

                if highest_card then
                    play_sound('gold_seal')
                    card.ability.extra.temp = 0
                    local is_seal = pseudorandom('blacksmith_reward') < 0.5
                    if is_seal then
                        highest_card:set_seal('silver', nil, true)
                        highest_card:juice_up(0.8, 0.8)
                        return {
                            message = 'Silver Seal Forged!',
                            colour = HEX('bdc3c7')
                        }
                    else
                        highest_card:set_ability(G.P_CENTERS.m_steel)
                        highest_card:juice_up(0.8, 0.8)
                        return {
                            message = 'Steel Card Forged!',
                            colour = G.C.GREY
                        }
                    end
                end
            end
        end
    end
}

-- Lucky One
SMODS.Atlas {
    key = "lucky_one_joker",
    path = "lucky_one_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'lucky_one_joker',
    atlas = 'lucky_one_joker',
    unlocked = false,
    loc_txt = {
        name = 'Lucky One',
        text = {
            "Scored {C:clubs}Clubs{} gather a Petal {C:inactive}(#1#/4){}.",
            "At 4 Petals, gives {X:mult,C:white}X#2#{} Mult and",
            "guarantees success on next probability roll"
        }
    },
    unlock = {
        "Play a {C:attention}Flush{} of all 4 suits",
        "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
        "in a single run"
    },
    config = { extra = { petals = 0, leaves_needed = 4, has_four_leaf = false, xmult = 2.0 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local p = ex.has_four_leaf and "READY!" or tostring(ex.petals or 0)
        return { vars = { p, ex.xmult or 2.0 } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit('Clubs') then
                if not card.ability.extra.has_four_leaf then
                    card.ability.extra.petals = (card.ability.extra.petals or 0) + 1
                    if card.ability.extra.petals >= (card.ability.extra.leaves_needed or 4) then
                        card.ability.extra.has_four_leaf = true
                        card.ability.extra.petals = 0
                        return {
                            message = '4-Leaf Clover Assembled!',
                            colour = G.C.GREEN,
                            card = card
                        }
                    else
                        return {
                            message = 'Petal ' .. card.ability.extra.petals .. '/4',
                            colour = G.C.CLUBS,
                            card = card
                        }
                    end
                end
            end
        end

        if context.joker_main and card.ability.extra.has_four_leaf then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-- Miner
SMODS.Atlas {
    key = "miner_joker",
    path = "miner_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'miner_joker',
    atlas = 'miner_joker',
    unlocked = false,
    loc_txt = {
        name = 'Miner',
        text = {
            "Scored {C:diamonds}Diamonds{} dig deeper {C:inactive}(Current: #2#m){}:",
            "0-50m: {C:chips}+25{} Chips | 50-120m: {C:money}+$2{} | 120-300m: {X:mult,C:white}X1.35{} Mult",
            "300m+: {X:mult,C:white}X1.5{} Mult, retriggers, and extracts a Spectral card"
        }
    },
    unlock = {
        "Play a {C:attention}Flush{} of all 4 suits",
        "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
        "in a single run"
    },
    config = { extra = { depth = 0, depth_per_card = 5 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local d = ex.depth or 0
        return { vars = { ex.depth_per_card or 5, d } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        -- Depth retrigger in Magma Core
        if context.repetition and context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') and (card.ability.extra.depth or 0) >= 300 then
                return {
                    repetitions = 1,
                    card = card
                }
            end
        end

        -- Individual stratum bonuses
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') then
                if not context.blueprint and not context.repetition then
                    card.ability.extra.depth = (card.ability.extra.depth or 0) + (card.ability.extra.depth_per_card or 5)
                end
                local d = card.ability.extra.depth or 0
                if d < 50 then
                    return {
                        chips = 25,
                        card = card
                    }
                elseif d < 120 then
                    return {
                        dollars = 2,
                        card = card
                    }
                elseif d < 300 then
                    return {
                        x_mult = 1.35,
                        card = card
                    }
                else
                    return {
                        x_mult = 1.5,
                        card = card
                    }
                end
            end
        end

        -- Round end core extraction
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if (card.ability.extra.depth or 0) >= 300 then
                if #G.consumeables.cards < G.consumeables.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            local sc = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'miner_core')
                            sc:add_to_deck()
                            G.consumeables:emplace(sc)
                            sc:juice_up(0.6, 0.6)
                            return true
                        end
                    }))
                    return {
                        message = 'Core Gem Extracted!',
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
            end
        end
    end
}

-- Joke Joker?
SMODS.Atlas {
    key = "joke_joker",
    path = "joke_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'joke_joker',
    atlas = 'joke_joker',
    unlocked = false,
    loc_txt = {
        name = 'Joke Joker?',
        text = {
            "Does nothing... or does it?"
        },
        unlock = {
            "Redeem the {C:attention}Blank Voucher{}",
            "a total of {C:attention}2 times{}"
        }
    },
    config = { extra = {} },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    check_for_unlock = function(self, args)
        local count = (G.PROFILES and G.SETTINGS and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought) or 0
        if count >= 2 then
            return true
        end
    end,
    calculate = function(self, card, context)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_blank'] then
            G.GAME.used_vouchers['v_blank'] = nil
            G.GAME.used_vouchers['v_antimatter'] = true
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            return {
                message = 'Antimatter!',
                colour = G.C.SECONDARY_SET.Voucher
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_blank'] then
            G.GAME.used_vouchers['v_blank'] = nil
            G.GAME.used_vouchers['v_antimatter'] = true
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    end
}

-- Perfectionism
SMODS.Atlas {
    key = "perfectionism_joker",
    path = "perfectionism_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'perfectionism_joker',
    atlas = 'perfectionism_joker',
    unlocked = false,
    loc_txt = {
        name = 'Perfectionism',
        text = {
            "Defeating Big or Boss Blind adds {C:dark_edition}Polychrome{}",
            "to a random Joker {C:inactive}(#1# in #2# chance for Negative){}"
        },
        unlock = {
            "Have {C:attention}5 Jokers{} with an",
            "{C:dark_edition}Edition{} at the same time"
        }
    },
    config = { extra = { odds = 5 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = function(self, args)
        if G.jokers and G.jokers.cards then
            local count = 0
            for _, j in ipairs(G.jokers.cards) do
                if j.edition then
                    count = count + 1
                end
            end
            if count >= 5 then
                return true
            end
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.individual and not context.repetition then
            local is_big_or_boss = false
            if G.GAME and G.GAME.blind then
                if G.GAME.blind.boss or G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' or (G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Big') then
                    is_big_or_boss = true
                end
            end

            if is_big_or_boss then
                local candidates = {}
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        local is_self = (j == card) or (context.blueprint_card and j == context.blueprint_card)
                        if not is_self and not (j.edition and j.edition.negative) then
                            table.insert(candidates, j)
                        end
                    end
                end

                if #candidates > 0 then
                    local uneditioned = {}
                    for _, j in ipairs(candidates) do
                        if not j.edition then
                            table.insert(uneditioned, j)
                        end
                    end

                    local target = nil
                    if #uneditioned > 0 then
                        target = pseudorandom_element(uneditioned, 'perfectionism_target')
                    else
                        target = pseudorandom_element(candidates, 'perfectionism_target')
                    end

                    if target then
                        local chosen_edition = 'e_polychrome'
                        local is_neg = pseudorandom('perfectionism_neg') < ((G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds)
                        if is_neg then
                            chosen_edition = 'e_negative'
                        end

                        G.E_MANAGER:add_event(Event({
                            func = function()
                                target:set_edition(chosen_edition, true)
                                target:juice_up(0.5, 0.5)
                                return true
                            end
                        }))

                        local chosen_msg = is_neg and "Negative!" or pseudorandom_element({"Perfected!", "Refined!"}, 'perfectionism_msg')

                        return {
                            message = chosen_msg,
                            colour = G.C.DARK_EDITION
                        }
                    end
                end
            end
        end
    end
}

-- Reaper Joker (Joker Parca)
SMODS.Atlas {
    key = "parca_joker",
    path = "parca_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'parca_joker',
    atlas = 'parca_joker',
    loc_txt = {
        name = 'Reaper Joker',
        text = {
            "Selling another Joker creates an {C:attention}Invisible Joker{}",
            "{C:inactive}(Once per round, #1#){}"
        }
    },
    config = { extra = { used = false } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local used = (card and card.ability and card.ability.extra and card.ability.extra.used) or false
        local status_text = used and "Used this round" or "Available"
        return { vars = { status_text } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card and context.card.ability and context.card.ability.set == 'Joker' and context.card ~= card and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            if not card.ability.extra.used then
                if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                    card.ability.extra.used = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            play_sound('tarot2')
                            local invisible = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_invisible', 'parca')
                            invisible:add_to_deck()
                            G.jokers:emplace(invisible)
                            invisible:juice_up(0.6, 0.6)
                            card:juice_up(0.4, 0.5)
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Spirited Away!', colour = G.C.PURPLE })
                            return true
                        end
                    }))
                end
            end
        end

        if (context.end_of_round or context.setting_blind) and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.used = false
        end
    end
}

-- Infostealer Joker (Always Eternal)
SMODS.Atlas {
    key = "infostealer_joker",
    path = "infostealer_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'infostealer_joker',
    atlas = 'infostealer_joker',
    loc_txt = {
        name = 'Infostealer Joker',
        text = {
            "{C:eternal}Always Eternal{}.",
            "Losing {C:money}$#2#{} upon leaving shop grants {X:mult,C:white}+X#3#{} Mult.",
            "If unable to pay, loses {X:mult,C:white}-X#3#{} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { xmult = 1.0, cost = 10, xmult_change = 0.5 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or 1.0
        local cost = (card and card.ability and card.ability.extra and card.ability.extra.cost) or 10
        local change = (card and card.ability and card.ability.extra and card.ability.extra.xmult_change) or 0.5
        return { vars = { xmult, cost, change } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
        if card.ability then card.ability.eternal = true end
    end,
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            local cost = card.ability.extra.cost or 10
            local change = card.ability.extra.xmult_change or 0.5
            local current_dollars = (G.GAME and G.GAME.dollars) or 0

            if current_dollars >= cost then
                ease_dollars(-cost)
                card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + change
                return {
                    message = '+X' .. change .. ' Mult',
                    colour = G.C.XMULT
                }
            else
                card.ability.extra.xmult = math.max(1.0, (card.ability.extra.xmult or 1.0) - change)
                return {
                    message = '-X' .. change .. ' Mult',
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main and card.ability.extra and card.ability.extra.xmult and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-- Supersaturated Joker (Joker Sobresaturado)
SMODS.Atlas {
    key = "sobresaturado_joker",
    path = "sobresaturado_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'sobresaturado_joker',
    atlas = 'sobresaturado_joker',
    loc_txt = {
        name = 'Supersaturated Joker',
        text = {
            "First scored card gains a missing Enhancement, Seal, or Edition.",
            "If already fully improved, gives {C:money}+$10{} instead",
            "{C:inactive}(Once per round, #1#){}"
        }
    },
    config = { extra = { used = false } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        local used = (card and card.ability and card.ability.extra and card.ability.extra.used) or false
        local status_text = used and "Used this round" or "Available"
        return { vars = { status_text } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            if not card.ability.extra.used then
                local pcard = context.other_card
                local has_enh = (pcard.config and pcard.config.center and pcard.config.center ~= G.P_CENTERS.c_base) or (pcard.ability and pcard.ability.effect and pcard.ability.effect ~= 'Base')
                local has_seal = (pcard.seal ~= nil)
                local has_edition = (pcard.edition ~= nil)

                if has_enh and has_seal and has_edition then
                    card.ability.extra.used = true
                    ease_dollars(10)
                    return {
                        dollars = 10,
                        message = '+$10 Saturated!',
                        colour = G.C.MONEY,
                        card = card
                    }
                else
                    local missing = {}
                    if not has_enh then table.insert(missing, 'enhancement') end
                    if not has_seal then table.insert(missing, 'seal') end
                    if not has_edition then table.insert(missing, 'edition') end

                    if #missing > 0 then
                        card.ability.extra.used = true
                        local chosen_type = pseudorandom_element(missing, pseudoseed('sobresaturado_type'))
                        if chosen_type == 'enhancement' then
                            local enhs = { G.P_CENTERS.m_bonus, G.P_CENTERS.m_mult, G.P_CENTERS.m_wild, G.P_CENTERS.m_glass, G.P_CENTERS.m_steel, G.P_CENTERS.m_stone, G.P_CENTERS.m_gold, G.P_CENTERS.m_lucky }
                            local chosen_enh = pseudorandom_element(enhs, pseudoseed('sobresaturado_enh'))
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.2,
                                func = function()
                                    play_sound('tarot1')
                                    pcard:set_ability(chosen_enh)
                                    pcard:juice_up(0.4, 0.4)
                                    card_eval_status_text(pcard, 'extra', nil, nil, nil, { message = 'Enhanced!', colour = G.C.SECONDARY_SET.Enhanced })
                                    return true
                                end
                            }))
                        elseif chosen_type == 'seal' then
                            local seals = { 'Gold', 'Blue', 'Red', 'Purple', 'Crackedlatro_dark_green', 'Crackedlatro_silver', 'Crackedlatro_white' }
                            local chosen_seal = pseudorandom_element(seals, pseudoseed('sobresaturado_seal'))
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.2,
                                func = function()
                                    play_sound('gold_seal')
                                    pcard:set_seal(chosen_seal, nil, true)
                                    pcard:juice_up(0.4, 0.4)
                                    card_eval_status_text(pcard, 'extra', nil, nil, nil, { message = 'Sealed!', colour = G.C.GOLD })
                                    return true
                                end
                            }))
                        elseif chosen_type == 'edition' then
                            local eds = { 'e_foil', 'e_holo', 'e_polychrome' }
                            local chosen_ed = pseudorandom_element(eds, pseudoseed('sobresaturado_ed'))
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.2,
                                func = function()
                                    play_sound('polychrome1')
                                    pcard:set_edition(chosen_ed, true)
                                    pcard:juice_up(0.4, 0.4)
                                    card_eval_status_text(pcard, 'extra', nil, nil, nil, { message = 'Polished!', colour = G.C.DARK_EDITION })
                                    return true
                                end
                            }))
                        end
                    end
                end
            end
        end

        if (context.end_of_round or context.setting_blind) and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.used = false
        end
    end
}

