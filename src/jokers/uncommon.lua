-- Uncommon Jokers

-- Shareholder Joker
SMODS.Atlas {
    key = "shareholder_joker",
    path = "shareholder_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'shareholder_joker',
    atlas = 'shareholder_joker',
    unlocked = false,
    loc_txt = {
        name = 'Shareholder Joker',
        text = {
            "Earn {C:money}$#1#{} ({C:money}$#2#{} on {C:attention}Big Blind{}, {C:money}$#3#{} on {C:attention}Boss Blind{})",
            "when defeating the Blind in only {C:attention}1 hand{}"
        },
        unlock = {
            "Have at least",
            "{C:money}$100{} at once"
        }
    },
    config = { extra = { small = 5, big = 6, boss = 8 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.small, card.ability.extra.big, card.ability.extra.boss } }
    end,
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.dollars and G.GAME.dollars >= 100 then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.current_round and G.GAME.current_round.hands_played == 1 then
                local reward = card.ability.extra.small
                if G.GAME.blind then
                    if G.GAME.blind.boss then
                        reward = card.ability.extra.boss
                    elseif G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' then
                        reward = card.ability.extra.big
                    end
                end
                return {
                    dollars = reward,
                    message = '+$' .. reward,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-- Builder Joker
SMODS.Atlas {
    key = "builder_joker",
    path = "builder_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'builder_joker',
    atlas = 'builder_joker',
    unlocked = false,
    loc_txt = {
        name = 'Builder Joker',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult if played hand contains",
            "a {C:attention}Three of a Kind{}, {C:attention}Four of a Kind{},",
            "or {C:attention}Five of a Kind{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        },
        unlock = {
            "Play a {C:attention}Three of a Kind{},",
            "{C:attention}Four of a Kind{}, and {C:attention}Five of a Kind{}",
            "consecutively in one run"
        }
    },
    config = { extra = { xmult = 1.0, xmult_gain = 0.1 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    check_for_unlock = function(self, args)
        if (args.type == 'hand' or args.type == 'play_hand') and args.handname then
            G.GAME.builder_streak = G.GAME.builder_streak or 0
            if args.handname == 'Three of a Kind' then
                G.GAME.builder_streak = 1
            elseif args.handname == 'Four of a Kind' and G.GAME.builder_streak == 1 then
                G.GAME.builder_streak = 2
            elseif (args.handname == 'Five of a Kind' or args.handname == 'Flush Five') and G.GAME.builder_streak == 2 then
                G.GAME.builder_streak = 3
                return true
            else
                G.GAME.builder_streak = (args.handname == 'Three of a Kind' and 1 or 0)
            end
        end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local is_valid_hand = (context.poker_hands['Three of a Kind'] and next(context.poker_hands['Three of a Kind'])) or
                                  (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                  (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if is_valid_hand then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Built!',
                    colour = G.C.MULT
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

-- Banquet
SMODS.Atlas {
    key = "banquet_joker",
    path = "banquet_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'banquet_joker',
    atlas = 'banquet_joker',
    loc_txt = {
        name = 'Banquet',
        text = {
            "When {C:attention}sold{}, creates an {C:attention}Ice Cream{},",
            "{C:attention}Popcorn{}, and {C:attention}Ramen{}",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = {} },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local food_jokers = { 'j_ice_cream', 'j_popcorn', 'j_ramen' }
                    for _, food_key in ipairs(food_jokers) do
                        if #G.jokers.cards < G.jokers.config.card_limit then
                            local new_food = create_card('Joker', G.jokers, nil, nil, nil, nil, food_key, nil)
                            new_food:add_to_deck()
                            G.jokers:emplace(new_food)
                        end
                    end
                    return true
                end
            }))
        end
    end
}

-- Appraiser
SMODS.Atlas {
    key = "appraiser_joker",
    path = "appraiser_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'appraiser_joker',
    atlas = 'appraiser_joker',
    loc_txt = {
        name = 'Appraiser',
        text = {
            "Earn {C:money}$#1#{} at end of round for each card",
            "with an {C:dark_edition}Edition{} in your {C:attention}full deck{}",
            "{C:inactive}(Foil, Holographic, or Polychrome){}"
        }
    },
    config = { extra = { dollars_per_edition = 1 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability and card.ability.extra and card.ability.extra.dollars_per_edition) or 1 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if pcard.edition and (pcard.edition.foil or pcard.edition.holo or pcard.edition.polychrome) then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                local total_money = count * card.ability.extra.dollars_per_edition
                return {
                    dollars = total_money,
                    message = '+$' .. total_money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-- Runway
SMODS.Atlas {
    key = "runway_joker",
    path = "runway_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'runway_joker',
    atlas = 'runway_joker',
    loc_txt = {
        name = 'Runway',
        text = {
            "{C:green}#1# in #2#{} chance for played {C:attention}Enhanced cards{}",
            "to permanently gain a random {C:dark_edition}Edition{}",
            "{C:inactive}(Foil, Holographic, or Polychrome){}"
        }
    },
    config = { extra = { odds = 10 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.scoring_hand then
            for _, pcard in ipairs(context.scoring_hand) do
                local has_enhancement = (pcard.config and pcard.config.center and pcard.config.center ~= G.P_CENTERS.c_base) or (pcard.ability and pcard.ability.effect and pcard.ability.effect ~= 'Base')
                if has_enhancement and not pcard.edition then
                    if pseudorandom('runway') < (G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                        local editions = { 'e_foil', 'e_holo', 'e_polychrome' }
                        local chosen_edition = pseudorandom_element(editions, 'runway_choice')
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                pcard:set_edition(chosen_edition, true)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end
}

-- Slot Machine
SMODS.Atlas {
    key = "slot_machine_joker",
    path = "slot_machine_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'slot_machine_joker',
    atlas = 'slot_machine_joker',
    unlocked = false,
    loc_txt = {
        name = 'Slot Machine',
        text = {
            "Each scored card has a chance to win:",
            "{C:green}#1# in 8{}: {C:money}$3{} | {C:green}#1# in 15{}: {C:money}$5{} | {C:green}#1# in 25{}: {C:money}$15{} | {C:green}#1# in 35{}: {C:money}$30{}",
            "{C:green}#1# in 40{}: {C:attention}Uncommon Joker{} | {C:green}#1# in 65{}: {C:red}Rare Joker{}",
            "{C:green}#1# in 125{}: {C:dark_edition}Negative{} {C:red}Rare Joker{}",
            "{C:green}#1# in 200{}: {C:dark_edition}Negative{} {C:eternal}Eternal{} {C:attention}Blueprint{}",
            "{C:green}#1# in 777{}: {C:dark_edition}Negative{} {C:spectral}The Soul{}"
        },
        unlock = {
            "Trigger both {C:mult}+20 Mult{} and",
            "{C:money}$20{} from a single",
            "{C:attention}Lucky Card{}"
        }
    },
    config = { extra = { odds_base = 1 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'lucky_both' or (G.GAME and G.GAME.lucky_hit_both) then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local prob = (G.GAME and G.GAME.probabilities.normal or 1)
            local hit = false
            local ret = {}

            -- $3 (1 in 8)
            if pseudorandom('slot_3') < prob / 8 then
                ease_dollars(3)
                ret.dollars = (ret.dollars or 0) + 3
                hit = true
            end

            -- $5 (1 in 15)
            if pseudorandom('slot_5') < prob / 15 then
                ease_dollars(5)
                ret.dollars = (ret.dollars or 0) + 5
                hit = true
            end

            -- $15 (1 in 25)
            if pseudorandom('slot_15') < prob / 25 then
                ease_dollars(15)
                ret.dollars = (ret.dollars or 0) + 15
                hit = true
            end

            -- $30 (1 in 35)
            if pseudorandom('slot_30') < prob / 35 then
                ease_dollars(30)
                ret.dollars = (ret.dollars or 0) + 30
                hit = true
            end

            -- Uncommon Joker (1 in 40)
            if pseudorandom('slot_uncommon') < prob / 40 then
                if #G.jokers.cards < G.jokers.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_joker = create_card('Joker', G.jokers, nil, 0.8, nil, nil, nil, 'slot_uncommon')
                            new_joker:add_to_deck()
                            G.jokers:emplace(new_joker)
                            return true
                        end
                    }))
                    hit = true
                end
            end

            -- Rare Joker (1 in 65)
            if pseudorandom('slot_rare') < prob / 65 then
                if #G.jokers.cards < G.jokers.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_joker = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'slot_rare')
                            new_joker:add_to_deck()
                            G.jokers:emplace(new_joker)
                            return true
                        end
                    }))
                    hit = true
                end
            end

            -- Negative Rare Joker (1 in 125)
            if pseudorandom('slot_neg_rare') < prob / 125 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_joker = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'slot_neg_rare')
                        new_joker:set_edition({negative = true}, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        return true
                    end
                }))
                hit = true
                ret.message = 'NEGATIVE RARE!'
                ret.colour = G.C.DARK_EDITION
            end

            -- Negative Eternal Blueprint (1 in 200)
            if pseudorandom('slot_blueprint') < prob / 200 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local blueprint = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_blueprint', 'slot_blueprint')
                        blueprint:set_edition({negative = true}, true)
                        blueprint.eternal = true
                        if blueprint.ability then
                            blueprint.ability.eternal = true
                        end
                        blueprint:add_to_deck()
                        G.jokers:emplace(blueprint)
                        return true
                    end
                }))
                hit = true
                ret.message = 'BLUEPRINT!'
                ret.colour = G.C.BLUE
            end

            -- Negative Soul (1 in 777)
            if pseudorandom('slot_soul') < prob / 777 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local soul_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_soul', 'slot_soul')
                        soul_card:set_edition({negative = true}, true)
                        soul_card:add_to_deck()
                        G.consumeables:emplace(soul_card)
                        return true
                    end
                }))
                hit = true
                ret.message = 'JACKPOT!'
                ret.colour = G.C.DARK_EDITION
            end

            if hit then
                ret.card = card
                return ret
            end
        end
    end
}

-- Duel of Value
SMODS.Atlas {
    key = "duel_of_value_joker",
    path = "duel_of_value_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'duel_of_value_joker',
    atlas = 'duel_of_value_joker',
    unlocked = false,
    loc_txt = {
        name = 'Duel of Value',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand is a {C:attention}Two Pair{}",
            "scored with exactly {C:attention}2 even{} and {C:attention}2 odd{} cards",
            "{C:inactive}(Art by kars_on_mars){}"
        },
        unlock = {
            "Reach {C:attention}Ante 8{} holding both",
            "{C:attention}Odd Todd{} and {C:attention}Even Steven{}"
        }
    },
    config = { extra = { xmult = 3.0 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 8 then
            local has_odd = false
            local has_even = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    local k = (j.config and j.config.center and j.config.center.key) or j.config.center_key or (j.ability and j.ability.name)
                    if k == 'j_odd_todd' or k == 'odd_todd' then has_odd = true end
                    if k == 'j_even_steven' or k == 'even_steven' then has_even = true end
                end
            end
            if has_odd and has_even then
                return true
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and context.poker_hands['Two Pair'] and next(context.poker_hands['Two Pair']) then
            local evens = 0
            local odds = 0
            if context.scoring_hand then
                for _, scard in ipairs(context.scoring_hand) do
                    local id = scard:get_id()
                    if id and id > 0 then
                        if id % 2 == 0 then
                            evens = evens + 1
                        else
                            odds = odds + 1
                        end
                    end
                end
            end
            if evens == 2 and odds == 2 then
                return {
                    Xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

-- Falta de Lectura
SMODS.Atlas {
    key = "falta_de_lectura_joker",
    path = "falta_de_lectura_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'falta_de_lectura_joker',
    atlas = 'falta_de_lectura_joker',
    unlocked = false,
    loc_txt = {
        name = 'Falta de Lectura',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand",
            "activates {C:attention}no other Jokers{}"
        },
        unlock = {
            "Play a scoring hand that",
            "activates {C:attention}no Jokers{}"
        }
    },
    config = { extra = { xmult = 5.0 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'no_jokers_activated' or (G.GAME and G.GAME.no_jokers_activated_hand) then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.before then
            G.GAME.falta_de_lectura_other_activated = false
        end

        if context.joker_main then
            if G.GAME.falta_de_lectura_other_activated then
                return nil
            end

            local other_will_activate = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    local jkey = (j.config and j.config.center and j.config.center.key) or j.config.center_key or (j.ability and j.ability.name)
                    local is_self = (jkey == 'j_Crackedlatro_falta_de_lectura_joker' or jkey == 'falta_de_lectura_joker' or jkey == 'j_falta_de_lectura_joker' or jkey == 'falta_de_lectura')
                    if not is_self and not j.debuff and j.calculate_joker then
                        local check_ctx = {}
                        for k, v in pairs(context) do check_ctx[k] = v end
                        check_ctx.falta_de_lectura_check = true
                        local res = j:calculate_joker(check_ctx)
                        if res and type(res) == 'table' and next(res) then
                            if res.mult or res.chips or res.Xmult or res.x_mult or res.dollars or res.x_chips or res.p_dollars or res.message or res.swap then
                                other_will_activate = true
                                break
                            end
                        end
                    end
                end
            end

            if not other_will_activate then
                check_for_unlock({ type = 'no_jokers_activated' })
                return {
                    Xmult = card.ability.extra.xmult,
                    message = 'Lee porfavor',
                    colour = G.C.XMULT
                }
            end
        end
    end
}

-- Chameleon Joker
SMODS.Atlas {
    key = "chameleon_joker",
    path = "chameleon_joker.png",
    px = 71,
    py = 95
}

local function get_available_deck_ranks()
    local ranks = {}
    local seen = {}
    if G.playing_cards then
        for _, pcard in ipairs(G.playing_cards) do
            local val = pcard.base and pcard.base.value
            if val and not seen[val] then
                seen[val] = true
                table.insert(ranks, val)
            end
        end
    end
    return ranks
end

local function ensure_chameleon_rank(card)
    card.ability = card.ability or {}
    card.ability.extra = card.ability.extra or {}
    local ranks = get_available_deck_ranks()
    if #ranks > 0 then
        local current = card.ability.extra.required_rank
        local found = false
        if current then
            for _, r in ipairs(ranks) do
                if r == current then found = true; break end
            end
        end
        if not found or not current then
            card.ability.extra.required_rank = pseudorandom_element(ranks, 'chameleon_rank')
        end
    else
        card.ability.extra.required_rank = card.ability.extra.required_rank or 'Ace'
    end
end

SMODS.Joker {
    key = 'chameleon_joker',
    atlas = 'chameleon_joker',
    loc_txt = {
        name = 'Chameleon',
        text = {
            "Copies ability of the {C:attention}Joker to the left{}",
            "if played hand contains at least one {C:attention}#1#{}",
            "{C:inactive}(Rank changes every round from full deck){}"
        }
    },
    config = { extra = { required_rank = 'Ace' } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        ensure_chameleon_rank(card)
        return { vars = { card.ability.extra.required_rank or 'Ace' } }
    end,
    calculate = function(self, card, context)
        ensure_chameleon_rank(card)

        if context.setting_blind and not context.blueprint then
            local ranks = get_available_deck_ranks()
            if #ranks > 0 then
                card.ability.extra.required_rank = pseudorandom_element(ranks, 'chameleon_rank_round')
            end
        end

        local rank_played = false
        local target_rank = card.ability.extra.required_rank
        local cards_to_check = context.full_hand or context.scoring_hand or (G.play and G.play.cards)

        if cards_to_check then
            for _, c in ipairs(cards_to_check) do
                if c.base and c.base.value == target_rank then
                    rank_played = true
                    break
                end
            end
        end

        if rank_played and G.jokers and G.jokers.cards then
            local my_idx = nil
            for idx, j in ipairs(G.jokers.cards) do
                if j == card then my_idx = idx; break end
            end

            if my_idx and my_idx > 1 then
                local left_joker = G.jokers.cards[my_idx - 1]
                if left_joker and left_joker ~= card then
                    context.blueprint = (context.blueprint or 0) + 1
                    context.blueprint_card = card
                    local ret = left_joker:calculate_joker(context)
                    if ret then
                        ret.card = card
                        return ret
                    end
                end
            end
        end
    end
}
