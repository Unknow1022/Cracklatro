-- JokerDisplay Integration for Cracklatro
-- Native dynamic definitions and calculations (Compact & Real-Time)

if not JokerDisplay then return end

local jd_def = JokerDisplay.Definitions

-- Helpers for compact card formatting
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
    if not (G.jokers and G.jokers.cards) then return false end
    local has_charles, has_mochi = false, false
    for _, j in ipairs(G.jokers.cards) do
        local k = string.lower(tostring((j.config and j.config.center and j.config.center.key) or (j.ability and j.ability.name) or ''))
        if string.find(k, 'charles') then has_charles = true end
        if string.find(k, 'mochi') then has_mochi = true end
    end
    return has_charles and has_mochi
end

-- =========================================================================
-- COMMON JOKERS (6)
-- =========================================================================

-- Masterful Joker
jd_def["j_Crackedlatro_masterful_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count" },
        { text = " Mastered)" }
    },
    calc_function = function(card)
        local count = 0
        if card.ability and card.ability.extra and card.ability.extra.mastered_ranks then
            for _ in pairs(card.ability.extra.mastered_ranks) do count = count + 1 end
        end
        card.joker_display_values.count = count
        card.joker_display_values.mult = count * ((card.ability and card.ability.extra and card.ability.extra.mult_per_rank) or 10)
    end
}

-- Outstanding Joker (Real-time calculation of highest card absorption)
jd_def["j_Crackedlatro_outstanding_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(Highest 1x Retrigger)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted >= 2 then
            local highest_rank = -1
            local highest_card = nil
            local is_tied = false
            for _, c in ipairs(highlighted) do
                local r = c:get_id() or 0
                if r > highest_rank then
                    highest_rank = r
                    highest_card = c
                    is_tied = false
                elseif r == highest_rank then
                    is_tied = true
                end
            end
            if highest_card and not is_tied then
                local other_chips = 0
                for _, c in ipairs(highlighted) do
                    if c ~= highest_card then
                        other_chips = other_chips + (c.base and c.base.nominal or 0) + (c.ability and c.ability.perma_bonus or 0)
                    end
                end
                local bonus = other_chips * #highlighted
                card.joker_display_values.chips = "+" .. bonus .. " Chips"
            else
                card.joker_display_values.chips = "+0 (Tied)"
            end
        else
            card.joker_display_values.chips = "Retrigger"
        end
    end
}

-- Blueberry
jd_def["j_Crackedlatro_blueberry_joker"] = {
    text = {
        { text = "+1 Hand", colour = G.C.BLUE }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "rounds_left" },
        { text = " rnds left)" }
    }
}

-- DJ Joker (Real-time availability indicator)
jd_def["j_Crackedlatro_dj_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Enhanced },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        if used then
            card.joker_display_values.status = "Used"
            card.joker_display_values.rem = "(Used this round)"
        else
            local highlighted = (G.hand and G.hand.highlighted) or {}
            if #highlighted == 1 then
                card.joker_display_values.status = "Active"
                card.joker_display_values.rem = "(Will Remix Card)"
            else
                card.joker_display_values.status = "Ready"
                card.joker_display_values.rem = "(Play 1 Card)"
            end
        end
    end
}

-- Designer Joker (Real-time total dollars from selected Wild cards)
jd_def["j_Crackedlatro_disenador_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "dollars" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(Wild Cards)" }
    },
    calc_function = function(card)
        local wild_count = 0
        local highlighted = (G.hand and G.hand.highlighted) or {}
        for _, c in ipairs(highlighted) do
            if is_wild_card(c) then wild_count = wild_count + 1 end
        end
        if wild_count > 0 then
            card.joker_display_values.dollars = "+$" .. wild_count
        else
            card.joker_display_values.dollars = "+$1/Wild"
        end
    end
}

-- TTS Joker (Real-time letter calculation and progress)
jd_def["j_Crackedlatro_tts_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "letters_progress" },
        { text = "/50: +$10)" }
    },
    calc_function = function(card)
        local letter_counts = {
            ['2'] = 3, ['3'] = 5, ['4'] = 4, ['5'] = 4, ['6'] = 3,
            ['7'] = 5, ['8'] = 5, ['9'] = 4, ['10'] = 3,
            ['Jack'] = 4, ['Queen'] = 5, ['King'] = 4, ['Ace'] = 3
        }
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 then
            local total_letters = 0
            for _, c in ipairs(highlighted) do
                local val = c.base and c.base.value
                total_letters = total_letters + (letter_counts[val] or 4)
            end
            local chips = total_letters * ((card.ability and card.ability.extra and card.ability.extra.chips_per_letter) or 4)
            local mult = total_letters * ((card.ability and card.ability.extra and card.ability.extra.mult_per_letter) or 1)
            card.joker_display_values.text_val = "+" .. chips .. " +" .. mult
        else
            card.joker_display_values.text_val = "+4C / +1M"
        end
    end
}

-- =========================================================================
-- UNCOMMON JOKERS (14)
-- =========================================================================

-- Shareholder Joker
jd_def["j_Crackedlatro_shareholder_joker"] = {
    text = {
        { text = "Stock: $" },
        { ref_table = "card.ability.extra", ref_value = "current_price" },
        { text = " (+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" },
        { text = "M)" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(Pays Price at End)" }
    },
    calc_function = function(card)
        local p = (card.ability and card.ability.extra and card.ability.extra.current_price) or 8
        card.joker_display_values.mult = p * 2
    end
}

-- Builder Joker (Real-time ascending structure check)
jd_def["j_Crackedlatro_builder_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted >= 2 then
            local is_ascending = true
            for i = 1, #highlighted - 1 do
                local cur_id = highlighted[i]:get_id() or 0
                local next_id = highlighted[i + 1]:get_id() or 0
                if cur_id >= next_id then
                    is_ascending = false
                    break
                end
            end
            if is_ascending then
                local mult = 1 + (#highlighted * 0.5)
                card.joker_display_values.xmult = "X" .. string.format("%.1f", mult)
                card.joker_display_values.rem = "(Stable: Ascending)"
            else
                card.joker_display_values.xmult = "+10 Chips"
                card.joker_display_values.rem = "(Unstable Order)"
            end
        else
            card.joker_display_values.xmult = "+X0.5/card"
            card.joker_display_values.rem = "(Ascending Order)"
        end
    end
}

-- Banquet (Real-time held cards threshold check)
jd_def["j_Crackedlatro_banquet_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local in_hand = (G.hand and G.hand.cards and #G.hand.cards) or 0
        local highlighted = (G.hand and G.hand.highlighted and #G.hand.highlighted) or 0
        local held = math.max(0, in_hand - highlighted)
        if held >= 7 then
            card.joker_display_values.text_val = "X2.5"
            card.joker_display_values.rem = "(" .. held .. "/7: Active)"
        else
            card.joker_display_values.text_val = "+2 Chips"
            card.joker_display_values.rem = "(" .. held .. "/7 Held)"
        end
    end
}

-- Appraiser
jd_def["j_Crackedlatro_appraiser_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count" },
        { text = " Editions)" }
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

-- Runway (Real-time unique traits calculation)
jd_def["j_Crackedlatro_runway_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted >= 1 then
            local center_idx = math.ceil(#highlighted / 2)
            local center_card = highlighted[center_idx]
            local traits = {}
            for _, sc in ipairs(highlighted) do
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
            local total_xmult = 1 + (trait_count * 0.5)
            card.joker_display_values.xmult = "X" .. string.format("%.1f", total_xmult)
            card.joker_display_values.rem = "(" .. trait_count .. " Unique Traits)"
        else
            card.joker_display_values.xmult = "+X0.5/trait"
            card.joker_display_values.rem = "(Center Card Model)"
        end
    end
}

-- Slot Machine
jd_def["j_Crackedlatro_slot_machine_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.GOLD }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local has_lucky = false
        local highlighted = (G.hand and G.hand.highlighted) or {}
        for _, sc in ipairs(highlighted) do
            if sc.ability and (sc.ability.name == 'Lucky Card' or sc.ability.effect == 'Lucky Card') then
                has_lucky = true
                break
            end
        end
        if has_lucky then
            card.joker_display_values.text_val = "7 | ? | ?"
            card.joker_display_values.rem = "(Lucky: Reel 1 = 7)"
        else
            card.joker_display_values.text_val = "Slot Machine"
            card.joker_display_values.rem = "(2/3 Match | 777)"
        end
    end
}

-- Duel of Value (Real-time 2 even 2 odd validation)
jd_def["j_Crackedlatro_duel_of_value_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted == 4 then
            local even_count, odd_count = 0, 0
            for _, c in ipairs(highlighted) do
                local id = c:get_id() or 0
                if id >= 2 and id <= 10 then
                    if id % 2 == 0 then even_count = even_count + 1 else odd_count = odd_count + 1 end
                elseif id == 14 then
                    odd_count = odd_count + 1
                end
            end
            if even_count == 2 and odd_count == 2 then
                card.joker_display_values.xmult = "X3.0"
                card.joker_display_values.rem = "(Active!)"
                return
            end
        end
        card.joker_display_values.xmult = "X1.0"
        card.joker_display_values.rem = "(2 Even, 2 Odd)"
    end
}

-- Reading Deficiency (Falta de Lectura)
jd_def["j_Crackedlatro_falta_de_lectura_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { text = "(No Other Jokers)" }
    }
}

-- Chameleon Joker (Real-time copy state check)
jd_def["j_Crackedlatro_chameleon_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.PURPLE }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local req = card.ability and card.ability.extra and card.ability.extra.required_rank or 'Ace'
        local has_rank = false
        local highlighted = (G.hand and G.hand.highlighted) or {}
        for _, c in ipairs(highlighted) do
            local val = c.base and c.base.value
            if val == req or tostring(c:get_id()) == tostring(req) then
                has_rank = true
                break
            end
        end
        if has_rank then
            card.joker_display_values.status = "Active"
            card.joker_display_values.rem = "(Copy Left: " .. req .. ")"
        else
            card.joker_display_values.status = "Needs " .. req
            card.joker_display_values.rem = "(Copy Joker Left)"
        end
    end
}

-- Motorized Joker
jd_def["j_Crackedlatro_motorizado_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(+20 on Retrigger)" }
    }
}

-- Hired Joker (Joker Contratado)
jd_def["j_Crackedlatro_contratado_joker"] = {
    text = {
        { text = "Job Card", colour = HEX('5c1e11') }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        if G.consumeables and #G.consumeables.cards >= G.consumeables.config.card_limit then
            card.joker_display_values.rem = "(Slots Full!)"
        else
            card.joker_display_values.rem = "(1 in 3 Chance)"
        end
    end
}

-- Seal of Approval (Sello de Aprobación)
jd_def["j_Crackedlatro_sello_aprobacion_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.GOLD }
    },
    reminder_text = {
        { text = "(Random Seal)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        card.joker_display_values.status = (#highlighted == 1) and "Active" or "1 Card"
    end
}

-- Paint Puddle (Charco de Pintura - Real-time suit & wild mult calculation)
jd_def["j_Crackedlatro_charco_pintura_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "mult_str", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "suit", colour = G.C.ATTENTION },
        { text = " / Wild)" }
    },
    calc_function = function(card)
        local suit = card.ability and card.ability.extra and card.ability.extra.suit or 'Hearts'
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 then
            local suit_count, wild_count = 0, 0
            for _, c in ipairs(highlighted) do
                if is_wild_card(c) then
                    wild_count = wild_count + 1
                elseif c:is_suit(suit) then
                    suit_count = suit_count + 1
                end
            end
            local total_mult = (wild_count * 50) + (suit_count * 25)
            card.joker_display_values.mult_str = "+" .. total_mult .. " Mult"
        else
            card.joker_display_values.mult_str = "+25 / +50"
        end
    end
}

-- Injured Joker (Joker Lesionado)
jd_def["j_Crackedlatro_lesionado_joker"] = {
    text = {
        { text = "+125 X1.5", colour = G.C.XMULT }
    },
    reminder_text = {
        { text = "(Straight | 1/5 Morph)" }
    }
}

-- =========================================================================
-- RARE JOKERS (13)
-- =========================================================================

-- Doctor Jo.
jd_def["j_Crackedlatro_doctor_jo_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.GREEN }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local hands_left = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left) or 0
        local used = card.ability and card.ability.extra and card.ability.extra.defibrillator_used
        if used then
            card.joker_display_values.status = "Used"
            card.joker_display_values.rem = "(Free Rentals)"
        elseif hands_left == 1 then
            card.joker_display_values.status = "CLEAR (X3)!"
            card.joker_display_values.rem = "(Defibrillator Ready)"
        else
            card.joker_display_values.status = "Insurance"
            card.joker_display_values.rem = "(Free Rentals | Defib)"
        end
    end
}

-- Symmetrical Joker (Real-time 4+ same suit check)
jd_def["j_Crackedlatro_symmetrical_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted >= 4 then
            local suit_counts = { Hearts = 0, Diamonds = 0, Spades = 0, Clubs = 0 }
            for _, c in ipairs(highlighted) do
                for s in pairs(suit_counts) do
                    if c:is_suit(s) then suit_counts[s] = suit_counts[s] + 1 end
                end
            end
            local same_suit = false
            for _, count in pairs(suit_counts) do
                if count >= 4 then same_suit = true; break end
            end
            if same_suit then
                card.joker_display_values.xmult = "X4.0"
                card.joker_display_values.rem = "(Active!)"
                return
            end
        end
        card.joker_display_values.xmult = "X1.0"
        card.joker_display_values.rem = "(4+ Kind, 1 Suit)"
    end
}

-- Balance
jd_def["j_Crackedlatro_balance_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.SECONDARY_SET.Spectral }
    },
    reminder_text = {
        { text = "(4 of Kind, 1 Suit)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        card.joker_display_values.status = (#highlighted >= 4) and "Active (+2)" or "+2 Spectrals"
    end
}

-- Merchant
jd_def["j_Crackedlatro_merchant_joker"] = {
    text = {
        { text = "-$" },
        { ref_table = "card.ability.extra", ref_value = "cost_per_shop" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(On Shop Exit)" }
    }
}

-- Lover (Soulmates - Compact shorthand & real-time combo detection)
jd_def["j_Crackedlatro_lover_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.HEARTS }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local sm1, sm2 = get_or_pick_soulmates()
        local s1 = format_short_card(sm1)
        local s2 = format_short_card(sm2)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        local has_sm1, has_sm2 = false, false
        local heart_count = 0
        for _, c in ipairs(highlighted) do
            if c == sm1 then has_sm1 = true end
            if c == sm2 then has_sm2 = true end
            if c:is_suit('Hearts') then heart_count = heart_count + 1 end
        end

        if has_sm1 and has_sm2 then
            card.joker_display_values.text_val = "X3 +$6"
            card.joker_display_values.rem = "(Soulmates Active!)"
        elseif heart_count > 0 then
            card.joker_display_values.text_val = "+" .. (heart_count * 10) .. "M"
            card.joker_display_values.rem = "(" .. s1 .. " & " .. s2 .. ")"
        else
            card.joker_display_values.text_val = "X3 +$6"
            card.joker_display_values.rem = "(" .. s1 .. " & " .. s2 .. ")"
        end
    end
}

-- Blacksmith (Real-time heat progress)
jd_def["j_Crackedlatro_blacksmith_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.ORANGE }
    },
    reminder_text = {
        { text = "(Seal/Steel at 300)" }
    },
    calc_function = function(card)
        local temp = (card.ability and card.ability.extra and card.ability.extra.temp) or 0
        local highlighted = (G.hand and G.hand.highlighted) or {}
        local gain = #highlighted * 5
        if temp + gain >= 300 then
            card.joker_display_values.text_val = "FORGE READY!"
        else
            card.joker_display_values.text_val = temp .. "/300 Heat"
        end
    end
}

-- Lucky One (Real-time petals tracking)
jd_def["j_Crackedlatro_lucky_one_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.GREEN }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local has = card.ability and card.ability.extra and card.ability.extra.has_four_leaf
        local petals = (card.ability and card.ability.extra and card.ability.extra.petals) or 0
        if has then
            card.joker_display_values.status = "X2 Mult"
            card.joker_display_values.rem = "(100% Win Roll)"
        else
            card.joker_display_values.status = petals .. "/4 Petals"
            card.joker_display_values.rem = "(Score Clubs)"
        end
    end
}

-- Miner (Real-time strata indicator)
jd_def["j_Crackedlatro_miner_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "depth_str", colour = G.C.BLUE }
    },
    reminder_text = {
        { text = "(Score Diamonds)" }
    },
    calc_function = function(card)
        local d = (card.ability and card.ability.extra and card.ability.extra.depth) or 0
        if d < 50 then
            card.joker_display_values.depth_str = d .. "m (+25C)"
        elseif d < 100 then
            card.joker_display_values.depth_str = d .. "m (+$2)"
        elseif d < 200 then
            card.joker_display_values.depth_str = d .. "m (X1.35)"
        else
            card.joker_display_values.depth_str = d .. "m (Core: X1.5)"
        end
    end
}

-- Joke Joker
jd_def["j_Crackedlatro_joke_joker"] = {
    text = {
        { text = "Blank -> +1 Joker", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(Shop Voucher)" }
    }
}

-- Perfectionism (Real-time Blind active check)
jd_def["j_Crackedlatro_perfectionism_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(Adds Polychrome)" }
    },
    calc_function = function(card)
        local is_big_or_boss = false
        if G.GAME and G.GAME.blind then
            if G.GAME.blind.boss or G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' or (G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Big') then
                is_big_or_boss = true
            end
        end
        card.joker_display_values.status = is_big_or_boss and "Active (Big/Boss)" or "Inactive (Small)"
    end
}

-- Reaper Joker (Parca)
jd_def["j_Crackedlatro_parca_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.PURPLE }
    },
    reminder_text = {
        { text = "(Morphs to Invisible)" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        card.joker_display_values.status = used and "Used" or "Ready on Sell"
    end
}

-- Infostealer Joker (Warning if cannot afford)
jd_def["j_Crackedlatro_infostealer_joker"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local dollars = (G.GAME and G.GAME.dollars) or 0
        if dollars >= 10 then
            card.joker_display_values.rem = "(Can afford: +X0.5)"
        else
            card.joker_display_values.rem = "(Can't afford: -X0.5!)"
        end
    end
}

-- Supersaturated Joker (Sobresaturado)
jd_def["j_Crackedlatro_sobresaturado_joker"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.SECONDARY_SET.Enhanced }
    },
    reminder_text = {
        { text = "(1st Scored Card)" }
    },
    calc_function = function(card)
        local used = card.ability and card.ability.extra and card.ability.extra.used
        card.joker_display_values.status = used and "Used" or "Enh/Seal/Ed"
    end
}

-- =========================================================================
-- SECRET JOKERS (13)
-- =========================================================================

-- Esteban (Real-time Spades & Clubs mult)
jd_def["j_Crackedlatro_esteban"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "xmult_str", colour = G.C.XMULT }
    },
    reminder_text = {
        { text = "(♠ & ♣)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 then
            local count = 0
            for _, c in ipairs(highlighted) do
                if c:is_suit('Spades') or c:is_suit('Clubs') then count = count + 1 end
            end
            if count > 0 then
                card.joker_display_values.xmult_str = "X" .. string.format("%.1f", 2.5 ^ count)
            else
                card.joker_display_values.xmult_str = "X1.0"
            end
        else
            card.joker_display_values.xmult_str = "X2.5/card"
        end
    end
}

-- Thiago
jd_def["j_Crackedlatro_thiago"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { text = "(/20 Chips)" }
    },
    calc_function = function(card)
        local current_chips = (hand_chips and hand_chips > 0 and hand_chips) or 0
        local req = (card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or 20
        card.joker_display_values.xmult = math.max(1, math.floor(current_chips / req))
    end
}

-- Paula (Adjacent eat preview)
jd_def["j_Crackedlatro_paula"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local my_pos = nil
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
        end
        local eatable = 0
        if my_pos and G.jokers and G.jokers.cards then
            if my_pos > 1 then
                local lj = G.jokers.cards[my_pos - 1]
                if lj and not (lj.ability and lj.ability.eternal) then eatable = eatable + 1 end
            end
            if my_pos < #G.jokers.cards then
                local rj = G.jokers.cards[my_pos + 1]
                if rj and not (rj.ability and rj.ability.eternal) then eatable = eatable + 1 end
            end
        end
        card.joker_display_values.rem = "(+" .. eatable .. " on Round Start)"
    end
}

-- Black Hole
jd_def["j_Crackedlatro_black_hole_joker"] = {
    text = {
        { text = "^1.5 C & M", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(Chips & Mult)" }
    }
}

-- Squele (Real-time Hearts mult)
jd_def["j_Crackedlatro_squele"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(♥ | 1/10 Spec)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 then
            local hearts = 0
            for _, c in ipairs(highlighted) do
                if c:is_suit('Hearts') then hearts = hearts + 1 end
            end
            if hearts > 0 then
                local mult = hearts * 10
                local xmult = string.format("%.1f", 1.5 ^ hearts)
                card.joker_display_values.text_val = "+" .. mult .. " X" .. xmult
            else
                card.joker_display_values.text_val = "+0 X1.0"
            end
        else
            card.joker_display_values.text_val = "+10 X1.5"
        end
    end
}

-- Bluxdir (Real-time hand level up target on discard)
jd_def["j_Crackedlatro_bluxdir"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.ATTENTION }
    },
    reminder_text = {
        { text = "(On Discard)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 and G.FUNCS and G.FUNCS.get_poker_hand_info then
            local text = G.FUNCS.get_poker_hand_info(highlighted)
            if text and text ~= 'NULL' then
                card.joker_display_values.status = "+1 " .. text
            else
                card.joker_display_values.status = "+1 Level"
            end
        else
            card.joker_display_values.status = "+1 Level"
        end
    end
}

-- Charles (Real-time cards & synergy)
jd_def["j_Crackedlatro_charles"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        local has_mochi = has_charles_and_mochi_jd()
        if #highlighted > 0 then
            local suits_count = 0
            for _, c in ipairs(highlighted) do
                if c:is_suit('Spades') or c:is_suit('Hearts') then suits_count = suits_count + 1 end
            end
            local dollars = #highlighted * 5 * (has_mochi and 2 or 1)
            local mult_base = 2 ^ suits_count
            local mult_str = (suits_count > 0 and ("X" .. mult_base) or "")
            card.joker_display_values.text_val = mult_str .. " +$" .. dollars
        else
            card.joker_display_values.text_val = "X2 +$5"
        end
        card.joker_display_values.rem = has_mochi and "(Best Friends! 2x)" or "(♠ & ♥ | +$5/card)"
    end
}

-- Mochi
jd_def["j_Crackedlatro_mochi"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "wild_count" },
        { text = " Wilds)" }
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
        card.joker_display_values.xmult = string.format("%.2f", 1.0 + (wild_count * gain))
    end
}

-- Helin (Real-time active on first hand only)
jd_def["j_Crackedlatro_helin"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local is_first = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0
        if is_first then
            card.joker_display_values.status = "^2 Mult"
            card.joker_display_values.rem = "(Active this hand)"
        else
            card.joker_display_values.status = "Inactive"
            card.joker_display_values.rem = "(1st Hand only)"
        end
    end
}

-- RayTracing
jd_def["j_Crackedlatro_raytracing"] = {
    text = {
        { text = "+2 Spectrals", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(End of Round | Negative)" }
    }
}

-- Paco (Real-time discards mult)
jd_def["j_Crackedlatro_paco"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "discards" },
        { text = " Discards)" }
    },
    calc_function = function(card)
        local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
        local per_discard = (card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or 2
        card.joker_display_values.discards = discards
        card.joker_display_values.xmult = math.max(1, discards * per_discard)
    end
}

-- Gabi (Real-time scored cards XMult)
jd_def["j_Crackedlatro_gabi"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.XMULT }
    },
    reminder_text = {
        { text = "(-75% Chips)" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        if #highlighted > 0 then
            card.joker_display_values.text_val = "X" .. (4 ^ #highlighted)
        else
            card.joker_display_values.text_val = "X4/card"
        end
    end
}

-- Yairo (Real-time 6 & Ace secret combo detection)
jd_def["j_Crackedlatro_yairo"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "text_val", colour = G.C.XMULT }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rem" }
    },
    calc_function = function(card)
        local highlighted = (G.hand and G.hand.highlighted) or {}
        local has_six, has_ace = false, false
        local six_or_seven = 0
        for _, c in ipairs(highlighted) do
            local id = (c.get_id and c:get_id()) or (c.base and c.base.id)
            local val = c.base and c.base.value
            if id == 6 or val == '6' then has_six = true; six_or_seven = six_or_seven + 1 end
            if id == 7 or val == '7' then six_or_seven = six_or_seven + 1 end
            if id == 14 or id == 1 or val == 'Ace' or val == '1' then has_ace = true end
        end

        if has_six and has_ace then
            card.joker_display_values.text_val = "X4M X2C"
            card.joker_display_values.rem = "(Secret Combo!)"
        elseif six_or_seven > 0 then
            card.joker_display_values.text_val = "X3M X1.5C"
            card.joker_display_values.rem = "(" .. six_or_seven .. " 6s/7s)"
        else
            card.joker_display_values.text_val = "X3M X1.5C"
            card.joker_display_values.rem = "(6s, 7s | 6 & A)"
        end
    end
}
