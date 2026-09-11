--[[
    JokerDisplay Integration for Cracklatro
    Full Native Display Suite for all 44 Jokers
    Author: Unknow102 & Antigravity
    Compatible with JokerDisplay >= 1.8.0 & SMODS
--]]

if not JokerDisplay then return end

local jd_def = JokerDisplay.Definitions

-- Helpers for compact card and suit formatting
local function format_short_card(c)
    if not c or not c.base then return "?" end
    local val = c.base.value or '?'
    local short_val = (val == '10' and '10') or string.sub(tostring(val), 1, 1)
    local suit_sym = (c.base.suit == 'Hearts' and 'H') or
                     (c.base.suit == 'Diamonds' and 'D') or
                     (c.base.suit == 'Spades' and 'S') or
                     (c.base.suit == 'Clubs' and 'C') or ''
    return short_val .. suit_sym
end

local function has_charles_and_mochi_jd()
    return (type(has_charles_and_mochi) == 'function' and has_charles_and_mochi()) or false
end

-- =========================================================================
-- COMMON JOKERS (6)
-- =========================================================================

-- 1. Masterful Joker
jd_def["j_Crackedlatro_masterful_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "mastered_text" },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        if card.ability and card.ability.extra and card.ability.extra.mastered_ranks then
            for _ in pairs(card.ability.extra.mastered_ranks) do count = count + 1 end
        end
        local mult_per = (card.ability and card.ability.extra and card.ability.extra.mult_per_rank) or 10
        card.joker_display_values.mult = count * mult_per

        local will_master = nil
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and poker_hands then
            local has_poker = (poker_hands['Four of a Kind'] and next(poker_hands['Four of a Kind'])) or
                              (poker_hands['Five of a Kind'] and next(poker_hands['Five of a Kind'])) or
                              (poker_hands['Flush Five'] and next(poker_hands['Flush Five']))
            if has_poker and scoring_hand then
                local counts = {}
                for _, c in ipairs(scoring_hand) do
                    local v = c.base and c.base.value
                    if v then
                        counts[v] = (counts[v] or 0) + 1
                        if counts[v] >= 4 and not (card.ability.extra.mastered_ranks and card.ability.extra.mastered_ranks[v]) then
                            will_master = v
                        end
                    end
                end
            end
        end

        if will_master then
            card.joker_display_values.mastered_text = "+" .. will_master
            card.joker_display_values.active_master = true
        else
            card.joker_display_values.mastered_text = count > 0 and (count .. " M") or "-"
            card.joker_display_values.active_master = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active_master and G.C.PURPLE or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 2. Outstanding Joker
jd_def["j_Crackedlatro_outstanding_joker"] = {
    text = {
        {
            ref_table = "card.joker_display_values",
            ref_value = "retrigger_str"
        }
    },
    reminder_text = {
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "card_str"
        },
        { text = ")" }
    },
    calc_function = function(card)
        local triggers = JokerDisplay.calculate_joker_triggers(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand and #scoring_hand > 0 then
            local highest_rank = -1
            local highest_card = nil
            for _, c in ipairs(scoring_hand) do
                local r = (c.get_id and c:get_id()) or (c.base and c.base.id) or 0
                if r > highest_rank then
                    highest_rank = r
                    highest_card = c
                end
            end

            if highest_card then
                card.joker_display_values.retrigger_str = (1 * triggers) .. "x"
                card.joker_display_values.card_str = format_short_card(highest_card)
                card.joker_display_values.active = true
            else
                card.joker_display_values.retrigger_str = "0x"
                card.joker_display_values.card_str = "-"
                card.joker_display_values.active = false
            end
        else
            card.joker_display_values.retrigger_str = (1 * triggers) .. "x"
            card.joker_display_values.card_str = "-"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.ORANGE or G.C.UI.TEXT_INACTIVE
        end
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand or not scoring_hand or #scoring_hand == 0 then return 0 end
        if not JokerDisplay.in_scoring(playing_card, scoring_hand) then return 0 end
        local highest_rank = -1
        local highest_card = nil
        for _, c in ipairs(scoring_hand) do
            local r = (c.get_id and c:get_id()) or (c.base and c.base.id) or 0
            if r > highest_rank then
                highest_rank = r
                highest_card = c
            end
        end
        if playing_card == highest_card then
            return 1 * JokerDisplay.calculate_joker_triggers(joker_card)
        end
        return 0
    end
}

-- 3. Blueberry
jd_def["j_Crackedlatro_blueberry_joker"] = {
    text = {
        { text = "+1 Hand", colour = G.C.BLUE }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rounds_left" },
        { text = ")" }
    },
    calc_function = function(card)
        local r = (card.ability and card.ability.extra and card.ability.extra.rounds_left) or 3
        card.joker_display_values.rounds_left = r .. (r == 1 and " rnd" or " rnds")
        card.joker_display_values.is_last = (r <= 1)
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.is_last and G.C.RED or G.C.FILTER
        end
    end
}

-- 4. DJ Joker
jd_def["j_Crackedlatro_dj_joker"] = {
    text = {
        { text = "Remix", colour = G.C.SECONDARY_SET.Enhanced }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        if used then
            card.joker_display_values.rem = "Used"
            card.joker_display_values.active = false
        else
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' and scoring_hand and #scoring_hand == 1 then
                card.joker_display_values.rem = format_short_card(scoring_hand[1])
                card.joker_display_values.active = true
            else
                card.joker_display_values.rem = "1 Card"
                card.joker_display_values.active = false
            end
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Enhanced or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 5. Designer Joker
jd_def["j_Crackedlatro_disenador_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local dollars = 0
        local wild_count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                if is_wild_card(c) then
                    local triggers = JokerDisplay.calculate_card_triggers(c, scoring_hand)
                    dollars = dollars + (card.ability.extra.dollars or 1) * triggers
                    wild_count = wild_count + 1
                end
            end
        end
        card.joker_display_values.dollars = dollars
        card.joker_display_values.rem = wild_count > 0 and (wild_count .. " Wild") or "Wild"
        card.joker_display_values.active = (dollars > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.MONEY or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 6. TTS Joker
jd_def["j_Crackedlatro_tts_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
        { text = " +" },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT, retrigger_type = "mult" }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "letters" },
        { text = ")" }
    },
    calc_function = function(card)
        local letter_counts = {
            ['2'] = 3, ['3'] = 5, ['4'] = 4, ['5'] = 4, ['6'] = 3,
            ['7'] = 5, ['8'] = 5, ['9'] = 4, ['10'] = 3,
            ['Jack'] = 4, ['Queen'] = 5, ['King'] = 4, ['Ace'] = 3
        }
        local total_letters = 0
        local total_chips = 0
        local total_mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                local val = c.base and c.base.value
                local l = letter_counts[val] or 4
                local triggers = JokerDisplay.calculate_card_triggers(c, scoring_hand)
                total_letters = total_letters + l
                total_chips = total_chips + (l * (card.ability.extra.chips_per_letter or 4)) * triggers
                total_mult = total_mult + (l * (card.ability.extra.mult_per_letter or 1)) * triggers
            end
        end
        card.joker_display_values.chips = total_chips
        card.joker_display_values.mult = total_mult
        local prog = (card.ability and card.ability.extra and card.ability.extra.letters_progress) or 0
        card.joker_display_values.letters = prog .. "/50"
    end
}

-- =========================================================================
-- UNCOMMON JOKERS (14)
-- =========================================================================

-- 7. Shareholder Joker
jd_def["j_Crackedlatro_shareholder_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(Pays +$" },
        { ref_table = "card.ability.extra", ref_value = "current_price" },
        { text = " at end)" }
    },
    reminder_text_config = { colour = G.C.MONEY },
    extra = {
        {
            { text = "Market Trend: " },
            { ref_table = "card.joker_display_values", ref_value = "trend_str" }
        }
    },
    calc_function = function(card)
        local price = (card.ability and card.ability.extra and card.ability.extra.current_price) or 8
        card.joker_display_values.mult = price * 2
        local trend = (card.ability and card.ability.extra and card.ability.extra.market_trend) or 'Normal'
        card.joker_display_values.trend_str = trend
    end,
    style_function = function(card, text, reminder_text, extra)
        if extra and extra.children and extra.children[1] and extra.children[1].children and extra.children[1].children[2] then
            local trend = card.joker_display_values.trend_str
            extra.children[1].children[2].config.colour = trend == 'Bull' and G.C.GREEN or (trend == 'Bear' and G.C.RED or G.C.UI.TEXT_LIGHT)
        end
    end
}

-- 8. Builder Joker
jd_def["j_Crackedlatro_builder_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "4+ cards: +20 Perma Chips to highest", colour = G.C.CHIPS }
        }
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand and #scoring_hand >= 2 then
            local is_ascending = true
            for i = 1, #scoring_hand - 1 do
                local cur_id = scoring_hand[i]:get_id() or 0
                local next_id = scoring_hand[i + 1]:get_id() or 0
                if cur_id >= next_id then
                    is_ascending = false
                    break
                end
            end
            if is_ascending then
                card.joker_display_values.x_mult = 1 + (#scoring_hand * (card.ability.extra.xmult_per_card or 0.5))
                card.joker_display_values.rem = "Ascending (" .. #scoring_hand .. " cards)"
                card.joker_display_values.active = true
            else
                card.joker_display_values.x_mult = 1
                card.joker_display_values.rem = "Unstable (+10 Chips)"
                card.joker_display_values.active = false
            end
        else
            card.joker_display_values.x_mult = 1
            card.joker_display_values.rem = "Ascending Order (+X0.5/c)"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 9. Banquet
jd_def["j_Crackedlatro_banquet_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "held_count" },
        { text = "/7 Held)" }
    },
    extra = {
        {
            { text = "+2 Perma Chips per held card", colour = G.C.CHIPS }
        },
        {
            { text = "Sell: +$15 & Negative Food", colour = G.C.SECONDARY_SET.Enhanced }
        }
    },
    calc_function = function(card)
        local in_hand = (G.hand and G.hand.cards and #G.hand.cards) or 0
        local highlighted = (G.hand and G.hand.highlighted and #G.hand.highlighted) or 0
        local held = math.max(0, in_hand - highlighted)
        local thresh = (card.ability and card.ability.extra and card.ability.extra.hand_threshold) or 7
        card.joker_display_values.held_count = held
        if held >= thresh then
            card.joker_display_values.x_mult = card.ability.extra.xmult or 2.5
            card.joker_display_values.active = true
        else
            card.joker_display_values.x_mult = 1
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 10. Appraiser
jd_def["j_Crackedlatro_appraiser_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count" },
        { text = " Editions in deck)" }
    },
    calc_function = function(card)
        local count = 0
        if G.playing_cards then
            for _, pcard in ipairs(G.playing_cards) do
                if pcard.edition and (pcard.edition.foil or pcard.edition.holo or pcard.edition.polychrome) then
                    count = count + 1
                end
            end
        end
        local per = (card.ability and card.ability.extra and card.ability.extra.dollars_per_edition) or 1
        card.joker_display_values.count = count
        card.joker_display_values.dollars = count * per
    end
}

-- 11. Runway
jd_def["j_Crackedlatro_runway_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Defeating Blind transfers 1 trait to center", colour = G.C.DARK_EDITION }
        }
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand and #scoring_hand >= 1 then
            local center_idx = math.ceil(#scoring_hand / 2)
            local center_card = scoring_hand[center_idx]
            local traits = {}
            for _, sc in ipairs(scoring_hand) do
                if sc ~= center_card then
                    if sc.seal then traits['seal_' .. sc.seal] = true end
                    if sc.edition then
                        for ed_k, ed_v in pairs(sc.edition) do
                            if ed_v and ed_k ~= 'type' then traits['ed_' .. ed_k] = true end
                        end
                    end
                    if sc.ability and sc.ability.set == 'Enhanced' then
                        traits['enh_' .. (sc.ability.name or '')] = true
                    end
                end
            end
            local trait_count = 0
            for _ in pairs(traits) do trait_count = trait_count + 1 end
            local per = (card.ability and card.ability.extra and card.ability.extra.xmult_per_trait) or 0.5
            card.joker_display_values.x_mult = 1 + (trait_count * per)
            card.joker_display_values.rem = trait_count .. " Unique Traits (" .. format_short_card(center_card) .. ")"
            card.joker_display_values.active = (trait_count > 0)
        else
            card.joker_display_values.x_mult = 1
            card.joker_display_values.rem = "Center Card Model"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 12. Slot Machine
jd_def["j_Crackedlatro_slot_machine_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "reels_preview" }
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Pair: +$3, +15 Mult", colour = G.C.MULT }
        },
        {
            { text = "Triple: +$12, X2.5 Mult", colour = G.C.XMULT }
        },
        {
            { text = "Jackpot 777: +$35, X4 Mult, Spectral", colour = G.C.GOLD }
        }
    },
    calc_function = function(card)
        local has_lucky = false
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, sc in ipairs(scoring_hand) do
                if sc.ability and (sc.ability.name == 'Lucky Card' or sc.ability.effect == 'Lucky Card') then
                    has_lucky = true
                    break
                end
            end
        end
        if has_lucky then
            card.joker_display_values.reels_preview = "[ 7 | ? | ? ]"
            card.joker_display_values.rem = "Lucky Card: Reel 1 = 7"
            card.joker_display_values.active = true
        else
            card.joker_display_values.reels_preview = "[ ? | ? | ? ]"
            card.joker_display_values.rem = "Spin on Play"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GOLD or G.C.UI.TEXT_LIGHT
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 13. Duel of Value
jd_def["j_Crackedlatro_duel_of_value_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Two Pair with exactly 2 Even, 2 Odd", colour = G.C.UI.TEXT_INACTIVE }
        }
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        local is_two_pair = (poker_hands and poker_hands['Two Pair'] and next(poker_hands['Two Pair']))
        if text ~= 'Unknown' and is_two_pair and scoring_hand and #scoring_hand == 4 then
            local evens, odds = 0, 0
            for _, c in ipairs(scoring_hand) do
                local id = c:get_id() or 0
                if id > 0 then
                    if id % 2 == 0 then evens = evens + 1 else odds = odds + 1 end
                end
            end
            if evens == 2 and odds == 2 then
                card.joker_display_values.x_mult = card.ability.extra.xmult or 3.0
                card.joker_display_values.rem = "Duel Active!"
                card.joker_display_values.active = true
                return
            end
        end
        card.joker_display_values.x_mult = 1.0
        card.joker_display_values.rem = "Two Pair (2 Even, 2 Odd)"
        card.joker_display_values.active = false
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 14. Reading Deficiency (Falta de Lectura)
jd_def["j_Crackedlatro_falta_de_lectura_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local other_jokers = false
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and not j.debuff and (not j.ability or j.ability.name ~= 'Reading Deficiency') then
                    other_jokers = true
                    break
                end
            end
        end
        if not other_jokers then
            card.joker_display_values.x_mult = card.ability.extra.xmult or 5.0
            card.joker_display_values.rem = "Active (Alone)"
            card.joker_display_values.active = true
        else
            card.joker_display_values.x_mult = card.ability.extra.xmult or 5.0
            card.joker_display_values.rem = "No other Jokers may trigger"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 15. Chameleon Joker
jd_def["j_Crackedlatro_chameleon_joker"] = {
    text = {
        { text = "Needs " },
        { ref_table = "card.ability.extra", ref_value = "required_rank", colour = G.C.ATTENTION }
    },
    reminder_text = {
        { text = "(Copy Left: " },
        { ref_table = "card.ability.extra", ref_value = "required_rank" },
        { text = ")" }
    },
    calc_function = function(card)
        local req = card.ability and card.ability.extra and card.ability.extra.required_rank or 'Ace'
        local has_rank = false
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local pool = (text ~= 'Unknown' and scoring_hand) or (G.hand and G.hand.highlighted) or {}
        for _, c in ipairs(pool) do
            local val = c.base and c.base.value
            if val == req or tostring(c:get_id()) == tostring(req) then
                has_rank = true
                break
            end
        end

        if has_rank then
            local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
            JokerDisplay.copy_display(card, copied_joker, copied_debuff)
        else
            JokerDisplay.copy_display(card, nil)
        end
    end,
    get_blueprint_joker = function(card)
        if not G.jokers or not G.jokers.cards then return nil end
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                return G.jokers.cards[i - 1]
            end
        end
        return nil
    end
}

-- 16. Motorized Joker
jd_def["j_Crackedlatro_motorizado_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(+2 on each Retrigger)" }
    }
}

-- 17. Hired Joker (Joker Contratado)
jd_def["j_Crackedlatro_contratado_joker"] = {
    text = {
        { text = "Job Card", colour = HEX('5c1e11') }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Minero, Alquimista, Detective, Joyero...", colour = G.C.UI.TEXT_INACTIVE }
        }
    },
    calc_function = function(card)
        local is_full = G.consumeables and #G.consumeables.cards >= G.consumeables.config.card_limit
        if is_full then
            card.joker_display_values.rem = "Slots Full!"
            card.joker_display_values.active = false
        else
            card.joker_display_values.rem = "1 in 3 Chance"
            card.joker_display_values.active = true
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.RED
        end
    end
}

-- 18. Seal of Approval (Sello de Aprobación)
jd_def["j_Crackedlatro_sello_aprobacion_joker"] = {
    text = {
        { text = "+Seal", colour = G.C.GOLD }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand and #scoring_hand == 1 then
            card.joker_display_values.rem = "Approves " .. format_short_card(scoring_hand[1])
            card.joker_display_values.active = true
        else
            card.joker_display_values.rem = "Play exactly 1 Card"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GOLD or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 19. Paint Puddle (Charco de Pintura)
jd_def["j_Crackedlatro_charco_pintura_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "suit" },
        { text = " / Wild)" }
    },
    extra = {
        {
            { text = "Suit: +25 Mult | Wild: +50 Mult", colour = G.C.UI.TEXT_INACTIVE }
        }
    },
    calc_function = function(card)
        local suit = (card.ability and card.ability.extra and card.ability.extra.suit) or 'Hearts'
        local total_mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                local triggers = JokerDisplay.calculate_card_triggers(c, scoring_hand)
                if is_wild_card(c) then
                    total_mult = total_mult + (card.ability.extra.mult_wild or 50) * triggers
                elseif c:is_suit(suit) then
                    total_mult = total_mult + (card.ability.extra.mult_suit or 25) * triggers
                end
            end
        end
        card.joker_display_values.mult = total_mult
        card.joker_display_values.suit_name = suit
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            local suit = card.joker_display_values.suit_name or 'Hearts'
            if G.C.SUITS and G.C.SUITS[suit] then
                reminder_text.children[2].config.colour = lighten(G.C.SUITS[suit], 0.35)
            end
        end
    end
}

-- 20. Injured Joker (Joker Lesionado)
jd_def["j_Crackedlatro_lesionado_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
        { text = " " },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "1 in 5 chance to morph at end of round", colour = G.C.ORANGE }
        }
    },
    calc_function = function(card)
        local text, poker_hands = JokerDisplay.evaluate_hand()
        local is_straight = (poker_hands and (poker_hands['Straight'] and next(poker_hands['Straight']) or
                                              poker_hands['Straight Flush'] and next(poker_hands['Straight Flush'])))
        if text ~= 'Unknown' and is_straight then
            card.joker_display_values.chips = card.ability.extra.chips or 125
            card.joker_display_values.x_mult = card.ability.extra.xmult or 1.5
            card.joker_display_values.rem = "Straight Active!"
            card.joker_display_values.active = true
        else
            card.joker_display_values.chips = 0
            card.joker_display_values.x_mult = 1.0
            card.joker_display_values.rem = "Requires Straight"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[4] then
            text.children[4].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- =========================================================================
-- RARE JOKERS (13)
-- =========================================================================

-- 21. Doctor Jo.
jd_def["j_Crackedlatro_doctor_jo_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status" }
    },
    text_config = { colour = G.C.GREEN },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Stops Perishable & Reimburses $3/Rental", colour = G.C.MONEY }
        },
        {
            { text = "Final hand: +1 Hand (X3) if short on chips", colour = G.C.RED }
        }
    },
    calc_function = function(card)
        local hands_left = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left) or 0
        local used = card.ability and card.ability.extra and card.ability.extra.defibrillator_used
        if used then
            card.joker_display_values.status = "Medical Insurance"
            card.joker_display_values.rem = "Defibrillator Used"
            card.joker_display_values.is_defib = false
        elseif hands_left <= 1 then
            card.joker_display_values.status = "CLEAR! +1 Hand (X3)"
            card.joker_display_values.rem = "Defibrillator Armed"
            card.joker_display_values.is_defib = true
        else
            card.joker_display_values.status = "Medical Insurance"
            card.joker_display_values.rem = "Defibrillator Standby"
            card.joker_display_values.is_defib = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.is_defib and G.C.RED or G.C.GREEN
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.is_defib and G.C.RED or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 22. Symmetrical Joker
jd_def["j_Crackedlatro_symmetrical_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        local is_poker = poker_hands and ((poker_hands['Four of a Kind'] and next(poker_hands['Four of a Kind'])) or
                                          (poker_hands['Five of a Kind'] and next(poker_hands['Five of a Kind'])) or
                                          (poker_hands['Flush Five'] and next(poker_hands['Flush Five'])))
        if text ~= 'Unknown' and is_poker and scoring_hand and #scoring_hand >= 4 then
            local first_suit = scoring_hand[1] and scoring_hand[1].base and scoring_hand[1].base.suit
            local same = true
            for _, c in ipairs(scoring_hand) do
                if not c.base or c.base.suit ~= first_suit then
                    same = false
                    break
                end
            end
            if same then
                card.joker_display_values.x_mult = card.ability.extra.xmult or 4.0
                card.joker_display_values.rem = "Symmetrical Active!"
                card.joker_display_values.active = true
                return
            end
        end
        card.joker_display_values.x_mult = 1.0
        card.joker_display_values.rem = "4+ of Kind, Same Suit"
        card.joker_display_values.active = false
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 23. Balance
jd_def["j_Crackedlatro_balance_joker"] = {
    text = {
        { text = "+2 Spectrals", colour = G.C.SECONDARY_SET.Spectral }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        local is_four = poker_hands and poker_hands['Four of a Kind'] and next(poker_hands['Four of a Kind'])
        if text ~= 'Unknown' and is_four and scoring_hand and #scoring_hand == 4 then
            local first_suit = scoring_hand[1] and scoring_hand[1].base and scoring_hand[1].base.suit
            local same = true
            for _, c in ipairs(scoring_hand) do
                if not c.base or c.base.suit ~= first_suit then
                    same = false
                    break
                end
            end
            if same then
                card.joker_display_values.rem = "Flush Four Active!"
                card.joker_display_values.active = true
                return
            end
        end
        card.joker_display_values.rem = "Flush Four (1 Suit)"
        card.joker_display_values.active = false
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Spectral or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 24. Merchant
jd_def["j_Crackedlatro_merchant_joker"] = {
    text = {
        { text = "-$" },
        { ref_table = "card.ability.extra", ref_value = "cost_per_shop" }
    },
    text_config = { colour = G.C.RED },
    reminder_text = {
        { text = "(On Shop Exit)" }
    },
    extra = {
        {
            { text = "+1 Slot, +1 Pack, +1 Voucher, -25%", colour = G.C.GREEN }
        }
    }
}

-- 25. Lover (Soulmates)
jd_def["j_Crackedlatro_lover_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "main_text" }
    },
    text_config = { colour = G.C.HEARTS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Both Soulmates: X3, +$6, +20 Perma Chips", colour = G.C.GOLD }
        },
        {
            { text = "Scored Hearts: +10 Mult each", colour = G.C.MULT }
        }
    },
    calc_function = function(card)
        local sm1, sm2 = (type(get_or_pick_soulmates) == 'function' and get_or_pick_soulmates()) or nil, nil
        local s1 = format_short_card(sm1)
        local s2 = format_short_card(sm2)
        local has_sm1, has_sm2 = false, false
        local heart_count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                if c == sm1 then has_sm1 = true end
                if c == sm2 then has_sm2 = true end
                if c:is_suit('Hearts') then
                    heart_count = heart_count + JokerDisplay.calculate_card_triggers(c, scoring_hand)
                end
            end
        end

        if has_sm1 and has_sm2 then
            card.joker_display_values.main_text = "X3 Mult +$6"
            card.joker_display_values.rem = "Soulmates Active!"
            card.joker_display_values.active = true
        elseif heart_count > 0 then
            card.joker_display_values.main_text = "+" .. (heart_count * 10) .. " Mult"
            card.joker_display_values.rem = s1 .. " & " .. s2
            card.joker_display_values.active = true
        else
            card.joker_display_values.main_text = "X3 +$6"
            card.joker_display_values.rem = s1 .. " & " .. s2
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 26. Blacksmith
jd_def["j_Crackedlatro_blacksmith_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "heat_status" }
    },
    text_config = { colour = G.C.ORANGE },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "At 300 Heat: 50% Silver Seal, 50% Steel", colour = HEX('bdc3c7') }
        }
    },
    calc_function = function(card)
        local cur = (card.ability and card.ability.extra and card.ability.extra.temp) or 0
        local projected = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            projected = #scoring_hand * (card.ability.extra.heat_per_card or 5)
        end
        local total = cur + projected
        if total >= 300 then
            card.joker_display_values.heat_status = "FORGE READY!"
            card.joker_display_values.rem = "Strikes on Score"
            card.joker_display_values.active = true
        else
            card.joker_display_values.heat_status = cur .. "/300 Heat"
            card.joker_display_values.rem = projected > 0 and ("+" .. projected .. " Heat this hand") or "+5 Heat/card"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GOLD or G.C.ORANGE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 27. Lucky One
jd_def["j_Crackedlatro_lucky_one_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "4 Petals = Guaranteed Win on Next Roll", colour = G.C.GREEN }
        }
    },
    calc_function = function(card)
        local is_ready = card.ability and card.ability.extra and card.ability.extra.has_four_leaf
        local petals = (card.ability and card.ability.extra and card.ability.extra.petals) or 0
        if is_ready then
            card.joker_display_values.x_mult = card.ability.extra.xmult or 2.0
            card.joker_display_values.rem = "100% Luck Ready!"
            card.joker_display_values.active = true
        else
            card.joker_display_values.x_mult = 1.0
            card.joker_display_values.rem = petals .. "/4 Petals (Clubs)"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 28. Miner
jd_def["j_Crackedlatro_miner_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "bonus_str" }
    },
    text_config = { colour = G.C.DIAMONDS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "depth_str" },
        { text = ")" }
    },
    extra = {
        {
            { text = "0-50m: +25C | 50-120m: +$2", colour = G.C.UI.TEXT_INACTIVE }
        },
        {
            { text = "120-300m: X1.35 | 300m+: X1.5 & Retrigger", colour = G.C.UI.TEXT_INACTIVE }
        }
    },
    calc_function = function(card)
        local d = (card.ability and card.ability.extra and card.ability.extra.depth) or 0
        card.joker_display_values.depth_str = d .. "m Depth"
        if d >= 300 then
            card.joker_display_values.bonus_str = "X1.5 + Retrigger"
            card.joker_display_values.active = true
        elseif d >= 120 then
            card.joker_display_values.bonus_str = "X1.35 Mult"
            card.joker_display_values.active = true
        elseif d >= 50 then
            card.joker_display_values.bonus_str = "+$2 / Diamond"
            card.joker_display_values.active = true
        else
            card.joker_display_values.bonus_str = "+25 Chips / Diamond"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GOLD or G.C.CHIPS
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = lighten(G.C.SUITS["Diamonds"], 0.35)
        end
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand or not scoring_hand then return 0 end
        local d = (joker_card.ability and joker_card.ability.extra and joker_card.ability.extra.depth) or 0
        if d >= 300 and playing_card:is_suit('Diamonds') and JokerDisplay.in_scoring(playing_card, scoring_hand) then
            return 1 * JokerDisplay.calculate_joker_triggers(joker_card)
        end
        return 0
    end
}

-- 29. Joke Joker
jd_def["j_Crackedlatro_joke_joker"] = {
    text = {
        { text = "Blank -> Antimatter", colour = G.C.SECONDARY_SET.Voucher }
    },
    reminder_text = {
        { text = "(+1 Joker Slot)" }
    }
}

-- 30. Perfectionism
jd_def["j_Crackedlatro_perfectionism_joker"] = {
    text = {
        { text = "+Polychrome", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "1 in 5 chance for Negative", colour = G.C.PURPLE }
        }
    },
    calc_function = function(card)
        local is_big_or_boss = false
        if G.GAME and G.GAME.blind then
            if G.GAME.blind.boss or G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' or (G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Big') then
                is_big_or_boss = true
            end
        end
        card.joker_display_values.rem = is_big_or_boss and "Active (Big/Boss)" or "Inactive (Small Blind)"
        card.joker_display_values.active = is_big_or_boss
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.DARK_EDITION or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 31. Reaper Joker (Parca)
jd_def["j_Crackedlatro_parca_joker"] = {
    text = {
        { text = "+Invisible Joker", colour = G.C.PURPLE }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        local has_room = G.jokers and #G.jokers.cards < G.jokers.config.card_limit
        if used then
            card.joker_display_values.rem = "Used this round"
            card.joker_display_values.active = false
        elseif not has_room then
            card.joker_display_values.rem = "Joker Slots Full"
            card.joker_display_values.active = false
        else
            card.joker_display_values.rem = "Sell other Joker"
            card.joker_display_values.active = true
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.PURPLE or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 32. Infostealer Joker
jd_def["j_Crackedlatro_infostealer_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "Leaves shop: pay $10 for +X0.5, else -X0.5", colour = G.C.MONEY }
        }
    },
    calc_function = function(card)
        local dollars = (G.GAME and G.GAME.dollars) or 0
        local cost = (card.ability and card.ability.extra and card.ability.extra.cost) or 10
        if dollars >= cost then
            card.joker_display_values.rem = "Can afford: +X0.5"
            card.joker_display_values.can_afford = true
        else
            card.joker_display_values.rem = "Can't afford: -X0.5!"
            card.joker_display_values.can_afford = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.can_afford and G.C.GREEN or G.C.RED
        end
    end
}

-- 33. Supersaturated Joker (Sobresaturado)
jd_def["j_Crackedlatro_sobresaturado_joker"] = {
    text = {
        { text = "+Enh / Seal / Ed", colour = G.C.SECONDARY_SET.Enhanced }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        if used then
            card.joker_display_values.rem = "Used this round"
            card.joker_display_values.active = false
        else
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' and scoring_hand and #scoring_hand > 0 then
                local pcard = scoring_hand[1]
                local has_enh = (pcard.config and pcard.config.center and pcard.config.center ~= G.P_CENTERS.c_base) or (pcard.ability and pcard.ability.effect and pcard.ability.effect ~= 'Base')
                local has_seal = (pcard.seal ~= nil)
                local has_edition = (pcard.edition ~= nil)
                if has_enh and has_seal and has_edition then
                    card.joker_display_values.rem = "1st Card: +$10 (Saturated)"
                else
                    card.joker_display_values.rem = "Improves " .. format_short_card(pcard)
                end
                card.joker_display_values.active = true
            else
                card.joker_display_values.rem = "1st Scored Card"
                card.joker_display_values.active = true
            end
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Enhanced or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- =========================================================================
-- SECRET JOKERS (11)
-- =========================================================================

-- 34. Esteban
jd_def["j_Crackedlatro_esteban"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "♠", colour = G.C.SUITS["Spades"] },
        { text = " & " },
        { text = "♣", colour = G.C.SUITS["Clubs"] },
        { text = ": X2.5/c)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                if c:is_suit('Spades') or c:is_suit('Clubs') then
                    count = count + JokerDisplay.calculate_card_triggers(c, scoring_hand)
                end
            end
        end
        local per = (card.ability and card.ability.extra and card.ability.extra.xmult) or 2.5
        card.joker_display_values.x_mult = count > 0 and (per ^ count) or 1.0
        card.joker_display_values.active = (count > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 35. Thiago
jd_def["j_Crackedlatro_thiago"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(X1 per 20 Chips)" }
    },
    calc_function = function(card)
        local current_chips = (hand_chips and hand_chips > 0 and hand_chips) or 0
        local req = (card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or 20
        local x = math.floor(current_chips / req)
        card.joker_display_values.x_mult = math.max(1, x)
        card.joker_display_values.active = (x > 1)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 36. Black Hole
jd_def["j_Crackedlatro_black_hole_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "^" },
                { ref_table = "card.ability.extra", ref_value = "pow" }
            },
            border_colour = G.C.DARK_EDITION
        }
    },
    reminder_text = {
        { text = "(Chips & Mult)" }
    }
}

-- 37. Squele
jd_def["j_Crackedlatro_squele"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT, retrigger_type = "mult" },
        { text = " " },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "♥", colour = G.C.SUITS["Hearts"] },
        { text = " | 1/10 Bloodstone)" }
    },
    calc_function = function(card)
        local hearts = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                if c:is_suit('Hearts') then
                    hearts = hearts + JokerDisplay.calculate_card_triggers(c, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = hearts * (card.ability.extra.mult or 10)
        card.joker_display_values.x_mult = hearts > 0 and ((card.ability.extra.xmult or 1.5) ^ hearts) or 1.0
        card.joker_display_values.active = (hearts > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[4] then
            text.children[4].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 38. Bluxdir
jd_def["j_Crackedlatro_bluxdir"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "hand_level" }
    },
    text_config = { colour = G.C.ATTENTION },
    reminder_text = {
        { text = "(Levels Up on Discard)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 and G.FUNCS and G.FUNCS.get_poker_hand_info then
            local text = G.FUNCS.get_poker_hand_info(highlighted)
            if text and text ~= 'NULL' and text ~= 'Unknown' then
                card.joker_display_values.hand_level = "+1 " .. text
                card.joker_display_values.active = true
            else
                card.joker_display_values.hand_level = "+1 Level"
                card.joker_display_values.active = false
            end
        else
            card.joker_display_values.hand_level = "+1 Level"
            card.joker_display_values.active = false
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.ATTENTION
        end
    end
}

-- 39. Charles
jd_def["j_Crackedlatro_charles"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        },
        { text = " +$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY, retrigger_type = "mult" }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    extra = {
        {
            { text = "With Mochi: 1x Retrigger & 2x Synergy!", colour = HEX('ff69b4') }
        }
    },
    calc_function = function(card)
        local has_mochi = has_charles_and_mochi_jd()
        local suit_count = 0
        local card_count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            card_count = #scoring_hand
            for _, c in ipairs(scoring_hand) do
                local triggers = JokerDisplay.calculate_card_triggers(c, scoring_hand)
                if c:is_suit('Spades') or c:is_suit('Hearts') then
                    suit_count = suit_count + triggers
                end
            end
        end
        local dollars_per = (card.ability.extra.dollars or 5) * (has_mochi and 2 or 1)
        card.joker_display_values.dollars = card_count * dollars_per
        card.joker_display_values.x_mult = suit_count > 0 and ((card.ability.extra.xmult or 2) ^ suit_count) or 1.0
        card.joker_display_values.rem = has_mochi and "Best Friends! (Retrigger)" or "♠ & ♥ (+ $5/c)"
        card.joker_display_values.active = (suit_count > 0 or card_count > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = has_charles_and_mochi_jd() and HEX('ff69b4') or G.C.UI.TEXT_INACTIVE
        end
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand or not scoring_hand then return 0 end
        if has_charles_and_mochi_jd() and JokerDisplay.in_scoring(playing_card, scoring_hand) then
            return 1 * JokerDisplay.calculate_joker_triggers(joker_card)
        end
        return 0
    end
}

-- 40. Mochi
jd_def["j_Crackedlatro_mochi"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "wild_count" },
        { text = " Wilds in deck)" }
    },
    extra = {
        {
            { text = "Scored cards become Wild Cards", colour = G.C.UI.TEXT_INACTIVE }
        }
    },
    calc_function = function(card)
        local wild_count = 0
        if G.playing_cards then
            for _, pcard in ipairs(G.playing_cards) do
                if is_wild_card(pcard) then wild_count = wild_count + 1 end
            end
        end
        local gain = (card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 0.25
        card.joker_display_values.wild_count = wild_count
        card.joker_display_values.x_mult = 1.0 + (wild_count * gain)
    end
}

-- 41. Helin
jd_def["j_Crackedlatro_helin"] = {
    text = {
        {
            border_nodes = {
                { text = "^" },
                { ref_table = "card.ability.extra", ref_value = "power" }
            },
            border_colour = G.C.DARK_EDITION
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local is_first = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0
        card.joker_display_values.rem = is_first and "Active (1st Hand)" or "Inactive"
        card.joker_display_values.active = is_first
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.DARK_EDITION or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 42. RayTracing
jd_def["j_Crackedlatro_raytracing"] = {
    text = {
        { text = "+2 Spectrals", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(End of Round | Negative)" }
    }
}

-- 43. Paco
jd_def["j_Crackedlatro_paco"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "discards" },
        { text = " Discards left)" }
    },
    calc_function = function(card)
        local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
        local per = (card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or 2
        card.joker_display_values.discards = discards
        card.joker_display_values.x_mult = math.max(1, discards * per)
        card.joker_display_values.active = (discards > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.XMULT or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- 44. Yairo
jd_def["j_Crackedlatro_yairo"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            },
            border_colour = G.C.MULT
        },
        { text = " " },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp" }
            },
            border_colour = G.C.CHIPS
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "rem" },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' and scoring_hand then
            for _, c in ipairs(scoring_hand) do
                local id = (c.get_id and c:get_id()) or (c.base and c.base.id)
                local val = c.base and c.base.value
                if id == 6 or id == 7 or val == '6' or val == '7' then
                    count = count + JokerDisplay.calculate_card_triggers(c, scoring_hand)
                end
            end
        end
        local mult_per = (card.ability and card.ability.extra and card.ability.extra.xmult) or 3
        local chips_per = (card.ability and card.ability.extra and card.ability.extra.xchips) or 1.5
        card.joker_display_values.x_mult = count > 0 and (mult_per ^ count) or 1.0
        card.joker_display_values.x_chips = count > 0 and (chips_per ^ count) or 1.0
        card.joker_display_values.rem = count > 0 and (count .. " scored (6s & 7s)") or "6s & 7s scored"
        card.joker_display_values.active = (count > 0)
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.MULT or G.C.UI.TEXT_INACTIVE
        end
        if text and text.children and text.children[3] then
            text.children[3].config.colour = card.joker_display_values.active and G.C.CHIPS or G.C.UI.TEXT_INACTIVE
        end
        if reminder_text and reminder_text.children and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
    end
}

-- Automatic key aliasing for universal compatibility (with and without prefix)
for k, v in pairs(jd_def) do
    if string.sub(k, 1, 15) == "j_Crackedlatro_" then
        local short_k = "j_" .. string.sub(k, 16)
        if not jd_def[short_k] then
            jd_def[short_k] = v
        end
    end
end
