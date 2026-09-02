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
            "When another compatible {C:attention}Joker{} is {C:red}destroyed{},",
            "{C:attention}Doctor Jo. self-destructs{} to create an exact",
            "copy of it without debuffs or negative stickers",
            "{C:inactive}(e.g. Perishable, Rental, Debuffed){}"
        }
    },
    config = { extra = {} },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = false
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
            "{X:mult,C:white}X#1#{} Mult if played hand is a",
            "{C:attention}Four of a Kind{} or {C:attention}Five of a Kind{}",
            "where all scoring cards share the {C:attention}same suit{}"
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
            "Creates {C:spectral}#2# Spectral cards{} if played hand",
            "is a {C:attention}Four of a Kind{} with exactly {C:attention}#1# scoring cards{}",
            "of the {C:attention}same suit{} {C:inactive}(Must have room){}"
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
            "In shop: {C:attention}+1{} Card slot, {C:attention}+1{} Voucher, {C:attention}+1{} Booster Pack,",
            "{C:money}25% discount{} on all items, and {C:red}higher Rare Joker rate{}",
            "Lose {C:money}$#1#{} when leaving the shop"
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
            "Scored {C:hearts}Hearts{} give {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to create a {C:dark_edition}Negative{}",
            "{C:tarot}The Lovers{} Tarot card {C:inactive}(Must have room){}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { chips = 50, mult = 25, odds = 4 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') then
                if pseudorandom('lover_joker') < (G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local lovers_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_lovers')
                            lovers_card:set_edition({negative = true}, true)
                            lovers_card:add_to_deck()
                            G.consumeables:emplace(lovers_card)
                            return true
                        end
                    }))
                end
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
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
            "This Joker gains {X:mult,C:white}X#2#{} Mult for each",
            "scored {C:spades}Spade{} card played",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { xmult = 1.0, xmult_gain = 0.05 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit('Spades') then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
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
            "Scored {C:clubs}Clubs{} give {C:money}$#1#{} and {C:mult}+#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to create a random",
            "{C:attention}Common{} or {C:attention}Uncommon Joker{} {C:inactive}(Must have room){}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { dollars = 1, mult = 5, odds = 4 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.mult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Clubs') then
                if pseudorandom('lucky_one_joker') < (G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                    if #G.jokers.cards < G.jokers.config.card_limit then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local rarities = { 0, 0.8 }
                                local chosen_rarity = pseudorandom_element(rarities, 'lucky_one_rarity')
                                local new_joker = create_card('Joker', G.jokers, nil, chosen_rarity, nil, nil, nil, 'lucky_one')
                                new_joker:add_to_deck()
                                G.jokers:emplace(new_joker)
                                return true
                            end
                        }))
                    end
                end
                return {
                    dollars = card.ability.extra.dollars,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
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
            "Scored {C:diamonds}Diamonds{} give {X:mult,C:white}X#1#{} Mult and {C:chips}+#2#{} Chips.",
            "{C:green}#3# in #4#{} chance at end of round to collapse and",
            "transform into a {C:attention}Rough Gem{}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { xmult = 1.5, chips = 10, odds = 7 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.chips, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') then
                return {
                    x_mult = card.ability.extra.xmult,
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if pseudorandom('miner_cavein') < (G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve()
                        local gem = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_rough_gem')
                        gem:add_to_deck()
                        G.jokers:emplace(gem)
                        return true
                    end
                }))
                return {
                    message = 'CAVE-IN!',
                    colour = G.C.RED
                }
            else
                return {
                    message = 'Mining!',
                    colour = G.C.GOLD
                }
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
            "When defeating a {C:attention}Big Blind{}",
            "or {C:attention}Boss Blind{}, apply {C:dark_edition}Polychrome{}",
            "to a random {C:attention}Joker{} {C:inactive}(Except itself){}",
            "{C:inactive}({C:green}#1# in #2#{} chance for {C:dark_edition}Negative{}{C:inactive}){}"
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
            "When another {C:attention}Joker{} is sold,",
            "creates an {C:attention}Invisible Joker{}",
            "{C:inactive}(Once per round, #1#){}",
            "{C:inactive}(Must have room){}"
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
            "Click {C:attention}Use{} to feed it {C:money}$1{}.",
            "Gains {X:mult,C:white}+X#3#{} Mult for every",
            "{C:money}$#4#{} fed to it {C:inactive}(#2#/#4# fed){}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { xmult = 1.0, dollars_drained = 0, threshold = 20, xmult_gain = 2.0 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or 1.0
        local drained = (card and card.ability and card.ability.extra and card.ability.extra.dollars_drained) or 0
        local current_fed = drained % 20
        local gain = (card and card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 2.0
        local threshold = (card and card.ability and card.ability.extra and card.ability.extra.threshold) or 20
        return { vars = { xmult, current_fed, gain, threshold } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
        if card.ability then card.ability.eternal = true end
    end,
    can_use = function(self, card)
        return G.GAME and G.GAME.dollars and G.GAME.dollars >= 1
    end,
    use = function(self, card, area, copier)
        ease_dollars(-1)
        card.ability.extra.dollars_drained = (card.ability.extra.dollars_drained or 0) + 1
        local current_progress = card.ability.extra.dollars_drained % card.ability.extra.threshold
        play_sound('tarot1')
        card:juice_up(0.4, 0.4)

        if current_progress == 0 then
            card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + card.ability.extra.xmult_gain
            play_sound('foil1')
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+' .. card.ability.extra.xmult_gain .. ' XMult!', colour = G.C.XMULT })
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = '-$1 (' .. current_progress .. '/' .. card.ability.extra.threshold .. ')', colour = G.C.MONEY })
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
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
            "Each scored card randomly gains a missing",
            "{C:attention}Enhancement{}, {C:attention}Seal{}, or {C:dark_edition}Edition{}.",
            "If a card cannot receive any more improvements,",
            "it earns {C:money}+$10{} instead"
        }
    },
    config = {},
    rarity = 3,
    pos = { x = 0, y = 0 },
    cost = 8,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local pcard = context.other_card
            local has_enh = (pcard.config and pcard.config.center and pcard.config.center ~= G.P_CENTERS.c_base) or (pcard.ability and pcard.ability.effect and pcard.ability.effect ~= 'Base')
            local has_seal = (pcard.seal ~= nil)
            local has_edition = (pcard.edition ~= nil)

            if has_enh and has_seal and has_edition then
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
}

