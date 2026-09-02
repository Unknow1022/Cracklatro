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
            "Stock price changes each round {C:inactive}(Current: {C:money}$#1#{C:inactive}){}.",
            "Gives {C:mult}+#2#{} Mult and pays {C:money}$#1#{} at round end.",
            "Defeating Blind in {C:attention}1 hand{} triggers Bull Market,",
            "using all hands triggers Bear Market"
        }
    },
    unlock = {
        "Have at least",
        "{C:money}$100{} at once"
    },
    config = { extra = { current_price = 8, min_price = 2, max_price = 15, market_trend = 'Normal' } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local price = ex.current_price or 8
        return { vars = { price, price * 2 } }
    end,
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.dollars and G.GAME.dollars >= 100 then
            return true
        end
    end,
    calculate = function(self, card, context)
        -- New blind stock price change
        if (context.setting_blind or context.first_hand_drawn) and not context.blueprint and not context.individual and not context.repetition then
            if not card.ability.extra.priced_this_round then
                card.ability.extra.priced_this_round = true
                if card.ability.extra.market_trend == 'Bull' then
                    card.ability.extra.current_price = pseudorandom('stock_price', 12, 18)
                    card.ability.extra.market_trend = 'Normal'
                elseif card.ability.extra.market_trend == 'Bear' then
                    card.ability.extra.current_price = pseudorandom('stock_price', 2, 5)
                    card.ability.extra.market_trend = 'Normal'
                else
                    card.ability.extra.current_price = pseudorandom('stock_price', 4, 14)
                end
            end
        end

        if context.joker_main then
            local p = card.ability.extra.current_price or 8
            return {
                mult = p * 2
            }
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.priced_this_round = nil
            local p = card.ability.extra.current_price or 8
            ease_dollars(p)

            local msg = 'Dividend +$' .. p
            local col = G.C.MONEY

            if G.GAME.current_round and G.GAME.current_round.hands_played == 1 then
                card.ability.extra.market_trend = 'Bull'
                msg = 'BULL MARKET! +$' .. p
                col = G.C.GREEN
            elseif G.GAME.current_round and G.GAME.current_round.hands_left == 0 then
                card.ability.extra.market_trend = 'Bear'
                msg = 'BEAR MARKET! +$' .. p
                col = G.C.RED
            end

            return {
                message = msg,
                colour = col
            }
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
            "If scoring cards are in {C:attention}ascending rank order{}:",
            "gives {X:mult,C:white}X#1#{} Mult per card scored.",
            "{C:attention}4+ cards{} in order adds permanent {C:chips}+#2#{} Chips to highest card"
        }
    },
    unlock = {
        "Play a {C:attention}Three of a Kind{},",
        "{C:attention}Four of a Kind{}, and {C:attention}Five of a Kind{}",
        "consecutively in one run"
    },
    config = { extra = { xmult_per_card = 0.5, bonus_chips = 20 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        return { vars = { 1 + (ex.xmult_per_card or 0.5), ex.bonus_chips or 20 } }
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
        if context.joker_main and context.scoring_hand and #context.scoring_hand >= 2 then
            local is_ascending = true
            for i = 1, #context.scoring_hand - 1 do
                local cur_id = context.scoring_hand[i]:get_id() or 0
                local next_id = context.scoring_hand[i + 1]:get_id() or 0
                if cur_id >= next_id then
                    is_ascending = false
                    break
                end
            end

            if is_ascending then
                local multiplier = 1 + (#context.scoring_hand * card.ability.extra.xmult_per_card)
                if #context.scoring_hand >= 4 and not context.blueprint then
                    local top_card = context.scoring_hand[#context.scoring_hand]
                    top_card.ability = top_card.ability or {}
                    top_card.ability.perma_bonus = (top_card.ability.perma_bonus or 0) + card.ability.extra.bonus_chips
                end
                return {
                    Xmult = multiplier,
                    message = 'Stable Pyramid! X' .. multiplier,
                    colour = G.C.MULT
                }
            else
                return {
                    chips = 10,
                    message = 'Unstable Structure',
                    colour = G.C.GREY
                }
            end
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
            "Cards held in hand gain permanent {C:chips}+#1#{} Chips each score.",
            "{X:mult,C:white}X#3#{} Mult if holding {C:attention}#2#+ cards{}.",
            "When sold, earn {C:money}$#4#{} and create a {C:dark_edition}Negative{} Food Joker"
        }
    },
    config = { extra = { perma_chips = 2, hand_threshold = 7, xmult = 2.5, sell_cash = 15 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        return { vars = { ex.perma_chips or 2, ex.hand_threshold or 7, ex.xmult or 2.5, ex.sell_cash or 15 } }
    end,
    calculate = function(self, card, context)
        -- Cards remaining in hand dine at the banquet
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
            context.other_card.ability = context.other_card.ability or {}
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.perma_chips
            return {
                chips = card.ability.extra.perma_chips,
                card = card
            }
        end

        -- Full banquet table bonus
        if context.joker_main then
            local held_count = (G.hand and G.hand.cards) and #G.hand.cards or 0
            if held_count >= (card.ability.extra.hand_threshold or 7) then
                return {
                    Xmult = card.ability.extra.xmult,
                    message = 'Full Feast! X' .. card.ability.extra.xmult,
                    colour = G.C.XMULT
                }
            end
        end

        -- Selling reward
        if context.selling_self and not context.blueprint then
            ease_dollars(card.ability.extra.sell_cash)
            G.E_MANAGER:add_event(Event({
                func = function()
                    local food_keys = { 'j_ice_cream', 'j_popcorn', 'j_ramen', 'j_turtle_bean', 'j_diet_cola', 'j_selzer' }
                    local chosen_food = pseudorandom_element(food_keys, 'banquet_food')
                    local new_food = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_food, nil)
                    new_food:set_edition({ negative = true }, true)
                    new_food:add_to_deck()
                    G.jokers:emplace(new_food)
                    new_food:juice_up(0.6, 0.6)
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
            "Earn {C:money}$#1#{} at end of round for each",
            "card with an {C:dark_edition}Edition{} in your deck"
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
    unlocked = false,
    loc_txt = {
        name = 'Runway',
        text = {
            "Center card of played hand gains {X:mult,C:white}+X#1#{} Mult",
            "for each unique trait on other played cards.",
            "Defeating Blind permanently transfers one trait to it"
        }
    },
    unlock = {
        "Have 5 cards with",
        "{C:attention}Editions{} in your deck"
    },
    config = { extra = { xmult_per_trait = 0.5 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        return { vars = { ex.xmult_per_trait or 0.5 } }
    end,
    check_for_unlock = function(self, args)
        if G.playing_cards then
            local ed_count = 0
            for _, c in ipairs(G.playing_cards) do
                if c.edition and (c.edition.foil or c.edition.holo or c.edition.polychrome) then
                    ed_count = ed_count + 1
                end
            end
            if ed_count >= 5 then
                return true
            end
        end
    end,
    calculate = function(self, card, context)
        if context.scoring_hand and #context.scoring_hand >= 1 then
            local center_idx = math.ceil(#context.scoring_hand / 2)
            local center_card = context.scoring_hand[center_idx]

            if context.individual and context.cardarea == G.play and context.other_card == center_card then
                local traits = {}
                for i, sc in ipairs(context.scoring_hand) do
                    if sc ~= center_card then
                        if sc.seal then traits['seal_' .. sc.seal] = sc.seal end
                        if sc.edition then
                            for ed_k, ed_v in pairs(sc.edition) do
                                if ed_v and ed_k ~= 'type' then traits['ed_' .. ed_k] = ed_k end
                            end
                        end
                        if sc.ability and sc.ability.set == 'Enhanced' then
                            traits['enh_' .. sc.ability.name] = sc.config.center
                        end
                    end
                end

                local trait_count = 0
                for _ in pairs(traits) do trait_count = trait_count + 1 end

                if trait_count > 0 then
                    local total_xmult = 1 + (trait_count * card.ability.extra.xmult_per_trait)
                    return {
                        x_mult = total_xmult,
                        message = 'TOP MODEL! X' .. total_xmult,
                        colour = G.C.DARK_EDITION,
                        card = card
                    }
                end
            end

            -- If hand defeats blind, bestow a permanent trait
            if context.after and not context.blueprint and G.GAME.chips >= G.GAME.blind.chips then
                if center_card and not center_card.runway_bestowed then
                    center_card.runway_bestowed = true
                    local pool = {}
                    for i, sc in ipairs(context.scoring_hand) do
                        if sc ~= center_card then
                            if sc.seal and not center_card.seal then table.insert(pool, { type = 'seal', val = sc.seal }) end
                            if sc.edition and not center_card.edition then
                                for ed_k, ed_v in pairs(sc.edition) do
                                    if ed_v and ed_k ~= 'type' then table.insert(pool, { type = 'edition', val = 'e_' .. ed_k }) end
                                end
                            end
                        end
                    end
                    if #pool > 0 then
                        local chosen = pseudorandom_element(pool, pseudoseed('runway_trait'))
                        if chosen.type == 'seal' then
                            center_card:set_seal(chosen.val, true)
                        elseif chosen.type == 'edition' then
                            center_card:set_edition(chosen.val, true)
                        end
                        center_card:juice_up(0.6, 0.6)
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
            "Spins 3 reels on each hand played.",
            "{C:attention}Pair match{}: {C:money}+$#1#{} and {C:mult}+#2#{} Mult.",
            "{C:attention}Three of a kind{}: {C:money}+$#3#{} and {X:mult,C:white}X#4#{} Mult.",
            "{C:attention}Triple 7 Jackpot{}: {C:money}+$#5#{}, {X:mult,C:white}X#6#{} Mult, and a Spectral card"
        }
    },
    unlock = {
        "Trigger both {C:mult}+20 Mult{} and",
        "{C:money}$20{} from a single",
        "{C:attention}Lucky Card{}"
    },
    config = { extra = { pair_cash = 3, pair_mult = 15, triple_cash = 12, triple_xmult = 2.5, jackpot_cash = 35, jackpot_xmult = 4.0 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        return { vars = { ex.pair_cash, ex.pair_mult, ex.triple_cash, ex.triple_xmult, ex.jackpot_cash, ex.jackpot_xmult } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'lucky_both' or (G.GAME and G.GAME.lucky_hit_both) then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.scoring_hand then
            local symbols = { 'Cherry', 'Lemon', 'Bell', '7' }
            local has_lucky = false
            for _, sc in ipairs(context.scoring_hand) do
                if sc.ability and (sc.ability.name == 'Lucky Card' or sc.ability.effect == 'Lucky Card') then
                    has_lucky = true
                    break
                end
            end

            local r1 = has_lucky and '7' or pseudorandom_element(symbols, 'slot_r1')
            local r2 = pseudorandom_element(symbols, 'slot_r2')
            local r3 = pseudorandom_element(symbols, 'slot_r3')
            card.ability.extra.last_spin = { r1, r2, r3 }

            return {
                message = '[ ' .. r1 .. ' | ' .. r2 .. ' | ' .. r3 .. ' ]',
                colour = G.C.GOLD
            }
        end

        if context.joker_main and card.ability.extra.last_spin then
            local r = card.ability.extra.last_spin
            local r1, r2, r3 = r[1], r[2], r[3]
            local ex = card.ability.extra

            if r1 == '7' and r2 == '7' and r3 == '7' then
                ease_dollars(ex.jackpot_cash)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local sc = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'slot_jackpot')
                        sc:add_to_deck()
                        G.consumeables:emplace(sc)
                        sc:juice_up(0.6, 0.6)
                        return true
                    end
                }))
                return {
                    Xmult = ex.jackpot_xmult,
                    dollars = ex.jackpot_cash,
                    message = '777 JACKPOT! +$' .. ex.jackpot_cash,
                    colour = G.C.GOLD
                }
            elseif r1 == r2 and r2 == r3 then
                ease_dollars(ex.triple_cash)
                return {
                    Xmult = ex.triple_xmult,
                    dollars = ex.triple_cash,
                    message = 'TRIPLE MATCH! +$' .. ex.triple_cash,
                    colour = G.C.MONEY
                }
            elseif r1 == r2 or r2 == r3 or r1 == r3 then
                ease_dollars(ex.pair_cash)
                return {
                    mult = ex.pair_mult,
                    dollars = ex.pair_cash,
                    message = 'PAIR MATCH! +$' .. ex.pair_cash,
                    colour = G.C.MULT
                }
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
            "{X:mult,C:white}X#1#{} Mult if played {C:attention}Two Pair{}",
            "contains exactly 2 even and 2 odd cards"
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
        name = 'Reading Deficiency',
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
                    message = 'Please Read!',
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

-- Motorized Joker (Joker Motorizado)
SMODS.Atlas {
    key = "motorizado_joker",
    path = "motorizado_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'motorizado_joker',
    atlas = 'motorizado_joker',
    loc_txt = {
        name = 'Motorized Joker',
        text = {
            "Gains {C:mult}+#2#{} Mult whenever",
            "a card is {C:attention}retriggered{}",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { mult = 20, mult_gain = 20 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local mult = (card and card.ability and card.ability.extra and card.ability.extra.mult) or 20
        local mult_gain = (card and card.ability and card.ability.extra and card.ability.extra.mult_gain) or 20
        return { vars = { mult, mult_gain } }
    end,
    calculate = function(self, card, context)
        if context.before then
            G.GAME.motorizado_scored_cards = {}
        end

        if context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.blueprint then
            local pcard = context.other_card
            G.GAME.motorizado_scored_cards = G.GAME.motorizado_scored_cards or {}
            if pcard then
                if G.GAME.motorizado_scored_cards[pcard] then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                    return {
                        message = '+' .. card.ability.extra.mult_gain .. ' Mult!',
                        colour = G.C.MULT,
                        card = card
                    }
                else
                    G.GAME.motorizado_scored_cards[pcard] = true
                end
            end
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.after or context.end_of_round then
            G.GAME.motorizado_scored_cards = nil
        end
    end
}

-- Hired Joker (Joker Contratado)
SMODS.Atlas {
    key = "contratado_joker",
    path = "contratado_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'contratado_joker',
    atlas = 'contratado_joker',
    loc_txt = {
        name = 'Hired Joker',
        text = {
            "{C:green}#1# in #2#{} chance per played hand",
            "to create a random {C:attention}Job Card{}",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = { odds = 3 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if pseudorandom('contratado') < (G.GAME and G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            play_sound('tarot1')
                            local job_keys = {
                                'c_Crackedlatro_minero_job', 'c_Crackedlatro_gardener_job', 'c_Crackedlatro_banker_job',
                                'c_Crackedlatro_surgeon_job', 'c_Crackedlatro_alchemist_job', 'c_Crackedlatro_butcher_job',
                                'c_Crackedlatro_detective_job', 'c_Crackedlatro_chef_job', 'c_Crackedlatro_archaeologist_job',
                                'c_Crackedlatro_jeweler_job'
                            }
                            local chosen_job = pseudorandom_element(job_keys, pseudoseed('contratado_spawn'))
                            local new_card = create_card('Job', G.consumeables, nil, nil, nil, nil, chosen_job, 'contratado')
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            new_card:juice_up(0.4, 0.4)
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Job Offered!', colour = HEX('5c1e11') })
                            return true
                        end
                    }))
                end
            end
        end
    end
}

-- Seal of Approval (Sello de Aprobación)
SMODS.Atlas {
    key = "sello_aprobacion_joker",
    path = "sello_aprobacion_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'sello_aprobacion_joker',
    atlas = 'sello_aprobacion_joker',
    loc_txt = {
        name = 'Seal of Approval',
        text = {
            "If played hand contains only {C:attention}1 card{},",
            "adds a random {C:attention}Seal{} to it"
        }
    },
    config = {},
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 7,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local play_count = (context.full_hand and #context.full_hand) or (context.scoring_hand and #context.scoring_hand) or (G.play and G.play.cards and #G.play.cards) or 0
            if play_count == 1 and context.scoring_hand and #context.scoring_hand == 1 then
                local target_card = context.scoring_hand[1]
                local seals = { 'Gold', 'Blue', 'Red', 'Purple', 'Crackedlatro_dark_green', 'Crackedlatro_silver', 'Crackedlatro_white' }
                local chosen_seal = pseudorandom_element(seals, pseudoseed('sello_aprobacion'))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        play_sound('gold_seal')
                        target_card:set_seal(chosen_seal, nil, true)
                        target_card:juice_up(0.5, 0.5)
                        card:juice_up(0.4, 0.5)
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Approved!', colour = G.C.GOLD })
                        return true
                    end
                }))
            end
        end
    end
}

-- Paint Puddle (Charco de Pintura)
SMODS.Atlas {
    key = "charco_pintura_joker",
    path = "charco_pintura_joker.png",
    px = 71,
    py = 95
}

local function ensure_charco_suit(card)
    card.ability = card.ability or {}
    card.ability.extra = card.ability.extra or {}
    if not card.ability.extra.suit then
        local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
        card.ability.extra.suit = pseudorandom_element(suits, 'charco_init_suit') or 'Hearts'
    end
end

SMODS.Joker {
    key = 'charco_pintura_joker',
    atlas = 'charco_pintura_joker',
    loc_txt = {
        name = 'Paint Puddle',
        text = {
            "Scored {C:attention}#1#{} give {C:mult}+#2#{} Mult.",
            "Scored {C:attention}Wild Cards{} give {C:mult}+#3#{} Mult instead.",
            "{C:inactive}(Suit changes each round){}"
        }
    },
    config = { extra = { mult_suit = 25, mult_wild = 50, suit = 'Hearts' } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        ensure_charco_suit(card)
        local suit = card.ability.extra.suit or 'Hearts'
        local mult_suit = card.ability.extra.mult_suit or 25
        local mult_wild = card.ability.extra.mult_wild or 50
        return { vars = { suit, mult_suit, mult_wild } }
    end,
    calculate = function(self, card, context)
        ensure_charco_suit(card)

        if context.setting_blind and not context.blueprint then
            local current_suit = card.ability.extra.suit
            local available_suits = {}
            local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
            for _, s in ipairs(suits) do
                if s ~= current_suit then
                    table.insert(available_suits, s)
                end
            end
            card.ability.extra.suit = pseudorandom_element(available_suits, pseudoseed('charco_round_suit'))
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = card.ability.extra.suit .. '!', colour = G.C.ATTENTION })
            card:juice_up(0.3, 0.3)
        end

        if context.individual and context.cardarea == G.play then
            if is_wild_card(context.other_card) then
                return {
                    mult = card.ability.extra.mult_wild,
                    card = card
                }
            elseif context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.mult_suit,
                    card = card
                }
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
            "{C:chips}+#1#{} Chips and {X:mult,C:white}X#2#{} Mult",
            "if played hand contains a {C:attention}Straight{}",
            "{C:green}#3# in #4#{} chance at the end of round",
            "to transform into another Joker"
        }
    },
    config = { extra = { chips = 125, xmult = 1.5, odds = 5 } },
    rarity = 2,
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips) or 125
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or 1.5
        local odds = (card and card.ability and card.ability.extra and card.ability.extra.odds) or 5
        local prob = (G.GAME and G.GAME.probabilities.normal) or 1
        return { vars = { chips, xmult, prob, odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands then
            local is_straight = (context.poker_hands['Straight'] and next(context.poker_hands['Straight'])) or
                                (context.poker_hands['Straight Flush'] and next(context.poker_hands['Straight Flush']))
            if is_straight then
                return {
                    chips = card.ability.extra.chips,
                    Xmult = card.ability.extra.xmult,
                    card = card
                }
            end
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local odds = (card.ability and card.ability.extra and card.ability.extra.odds) or 5
            local prob = (G.GAME and G.GAME.probabilities.normal) or 1
            if pseudorandom('injured_joker') < (prob / odds) then
                local motorized_key = (G.P_CENTERS and G.P_CENTERS['j_Crackedlatro_motorizado_joker']) and 'j_Crackedlatro_motorizado_joker' or 'j_motorizado_joker'
                local transform_options = {
                    { key = motorized_key, message = 'A rockear!', colour = G.C.ORANGE },
                    { key = 'j_stuntman', message = 'A rockear!', colour = G.C.ORANGE },
                    { key = 'j_invisible', message = 'Maldito!', colour = G.C.RED },
                    { key = 'j_mr_bones', message = 'Maldito!', colour = G.C.RED },
                    { key = 'j_vampire', message = 'Maldito!', colour = G.C.RED },
                    { key = 'j_stencil', message = '?', colour = G.C.PURPLE }
                }
                local chosen = pseudorandom_element(transform_options, pseudoseed('injured_transform'))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('tarot2')
                        local ed = card.edition
                        card:start_dissolve()
                        local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen.key, 'injured_morph')
                        if ed then
                            new_joker:set_edition(ed, true)
                        end
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:juice_up(0.6, 0.6)
                        card_eval_status_text(new_joker, 'extra', nil, nil, nil, { message = chosen.message, colour = chosen.colour })
                        return true
                    end
                }))
                return {
                    message = chosen.message,
                    colour = chosen.colour
                }
            end
        end
    end
}

