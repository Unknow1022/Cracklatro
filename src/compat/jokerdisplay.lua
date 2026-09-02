-- JokerDisplay Integration for Cracklatro
-- Native dynamic definitions and calculations

if not JokerDisplay then return end

local jd_def = JokerDisplay.Definitions

-- Common
jd_def["j_Crackedlatro_masterful_joker"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(4/5 of a Kind)" }
    }
}

jd_def["j_Crackedlatro_outstanding_joker"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
        { text = " $", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "dollars", colour = G.C.MONEY }
    },
    reminder_text = {
        { text = "(4/5 of a Kind)" }
    }
}

jd_def["j_Crackedlatro_blueberry_joker"] = {
    text = {
        { text = "+1 Hand", colour = G.C.BLUE }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "rounds_left" },
        { text = " rounds)" }
    }
}

-- Uncommon
jd_def["j_Crackedlatro_shareholder_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(1 Hand Win)" }
    },
    calc_function = function(card)
        local reward = (card.ability and card.ability.extra and card.ability.extra.small) or 5
        if G.GAME and G.GAME.blind then
            if G.GAME.blind.boss then
                reward = (card.ability and card.ability.extra and card.ability.extra.boss) or 8
            elseif G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' then
                reward = (card.ability and card.ability.extra and card.ability.extra.big) or 6
            end
        end
        card.joker_display_values.dollars = reward
    end
}

jd_def["j_Crackedlatro_builder_joker"] = {
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
        { text = "(3/4/5 of a Kind)" }
    }
}

jd_def["j_Crackedlatro_banquet_joker"] = {
    text = {
        { text = "3 Food Jokers", colour = G.C.ORANGE }
    },
    reminder_text = {
        { text = "(On Sell)" }
    }
}

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

jd_def["j_Crackedlatro_runway_joker"] = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = " in " },
        { ref_table = "card.ability.extra", ref_value = "odds" },
        { text = ")" }
    },
    text_config = { colour = G.C.GREEN },
    reminder_text = {
        { text = "Edition Chance" }
    },
    calc_function = function(card)
        card.joker_display_values.odds = "" .. (G.GAME and G.GAME.probabilities.normal or 1)
    end
}

jd_def["j_Crackedlatro_slot_machine_joker"] = {
    text = {
        { text = "Odds: " },
        { ref_table = "card.joker_display_values", ref_value = "prob" },
        { text = "X" }
    },
    text_config = { colour = G.C.GREEN },
    reminder_text = {
        { text = "(Scored Cards)" }
    },
    calc_function = function(card)
        card.joker_display_values.prob = "" .. (G.GAME and G.GAME.probabilities.normal or 1)
    end
}

jd_def["j_Crackedlatro_duel_of_value_joker"] = {
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
        { text = "(2 Even, 2 Odd)" }
    }
}

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
        { text = "(Solo Active)" }
    }
}

jd_def["j_Crackedlatro_chameleon_joker"] = {
    text = {
        { text = "Copy Left", colour = G.C.PURPLE }
    },
    reminder_text = {
        { text = "(If " },
        { ref_table = "card.ability.extra", ref_value = "required_rank", colour = G.C.ATTENTION },
        { text = ")" }
    }
}

-- Rare
jd_def["j_Crackedlatro_doctor_jo_joker"] = {
    text = {
        { text = "Revive", colour = G.C.RED }
    },
    reminder_text = {
        { text = "(On Destroyed)" }
    }
}

jd_def["j_Crackedlatro_symmetrical_joker"] = {
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
        { text = "(4+ Cards, 1 Suit)" }
    }
}

jd_def["j_Crackedlatro_balance_joker"] = {
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Spectral },
        { ref_table = "card.ability.extra", ref_value = "spectral_count", colour = G.C.SECONDARY_SET.Spectral },
        { text = " Spectrals", colour = G.C.SECONDARY_SET.Spectral }
    },
    reminder_text = {
        { text = "(4 of Kind, 1 Suit)" }
    }
}

jd_def["j_Crackedlatro_merchant_joker"] = {
    text = {
        { text = "-$" },
        { ref_table = "card.ability.extra", ref_value = "cost_per_shop" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(Leave Shop)" }
    }
}

jd_def["j_Crackedlatro_lover_joker"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(Hearts)" }
    }
}

jd_def["j_Crackedlatro_blacksmith_joker"] = {
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
        { text = "(+X0.05/Spade)" }
    }
}

jd_def["j_Crackedlatro_lucky_one_joker"] = {
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "dollars", colour = G.C.MONEY },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(Clubs)" }
    }
}

jd_def["j_Crackedlatro_miner_joker"] = {
    text = {
        { text = "X", colour = G.C.XMULT },
        { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT },
        { text = " +", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(Diamonds)" }
    }
}

jd_def["j_Crackedlatro_joke_joker"] = {
    text = {
        { text = "Blank ", colour = G.C.SECONDARY_SET.Voucher },
        { text = "->", colour = G.C.WHITE },
        { text = " +1 Joker", colour = G.C.DARK_EDITION }
    }
}

jd_def["j_Crackedlatro_perfectionism_joker"] = {
    text = {
        { text = "Edition", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(Big/Boss Win)" }
    }
}

-- Secret
jd_def["j_Crackedlatro_esteban"] = {
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
        { text = "(Spades/Clubs)" }
    }
}

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
        { text = "(Eats Adjacent)" }
    }
}

jd_def["j_Crackedlatro_black_hole_joker"] = {
    text = {
        { text = "^" },
        { ref_table = "card.ability.extra", ref_value = "pow" },
        { text = " Chips & Mult" }
    },
    text_config = { colour = G.C.DARK_EDITION }
}

jd_def["j_Crackedlatro_squele"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
        { text = " X", colour = G.C.XMULT },
        { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT }
    },
    reminder_text = {
        { text = "(Hearts)" }
    }
}

jd_def["j_Crackedlatro_bluxdir"] = {
    text = {
        { text = "+1 Level", colour = G.C.ATTENTION }
    },
    reminder_text = {
        { text = "(On Discard)" }
    }
}

jd_def["j_Crackedlatro_charles"] = {
    text = {
        { text = "X", colour = G.C.XMULT },
        { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT },
        { text = " +$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "dollars", colour = G.C.MONEY }
    },
    reminder_text = {
        { text = "(Spades/Hearts)" }
    }
}

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
                if is_wild_card(pcard) then
                    wild_count = wild_count + 1
                end
            end
        end
        local gain = (card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 0.25
        card.joker_display_values.wild_count = wild_count
        card.joker_display_values.xmult = 1.0 + (wild_count * gain)
    end
}

jd_def["j_Crackedlatro_helin"] = {
    text = {
        { text = "^" },
        { ref_table = "card.ability.extra", ref_value = "power" },
        { text = " Mult" }
    },
    text_config = { colour = G.C.DARK_EDITION },
    reminder_text = {
        { text = "(1st Hand)" }
    }
}

jd_def["j_Crackedlatro_raytracing"] = {
    text = {
        { text = "+2 Neg. Spectrals", colour = G.C.DARK_EDITION }
    },
    reminder_text = {
        { text = "(End of Round)" }
    }
}

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

jd_def["j_Crackedlatro_gabi"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult" }
            }
        },
        { text = " -3/4 Chips", colour = G.C.CHIPS }
    },
    text_config = { colour = G.C.WHITE },
    reminder_text = {
        { text = "(Scored Cards)" }
    }
}

jd_def["j_Crackedlatro_yairo"] = {
    text = {
        { text = "X", colour = G.C.XMULT },
        { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT },
        { text = " X", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "xchips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(6s / 7s)" }
    }
}

-- New Common Jokers
jd_def["j_Crackedlatro_dj_joker"] = {
    text = {
        { text = "Remix Card", colour = G.C.SECONDARY_SET.Enhanced }
    },
    reminder_text = {
        { text = "(1/round on 1 card)" }
    }
}

jd_def["j_Crackedlatro_lesionado_joker"] = {
    text = {
        { text = "Mr. Bones", colour = G.C.RED }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "straights_left" },
        { text = " Straights)" }
    }
}

jd_def["j_Crackedlatro_disenador_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.ability.extra", ref_value = "dollars" }
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(Wild Cards)" }
    }
}

jd_def["j_Crackedlatro_tts_joker"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
        { text = " +", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(Aces, +$2 in Hand)" }
    }
}

-- New Uncommon Jokers
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

jd_def["j_Crackedlatro_contratado_joker"] = {
    text = {
        { text = "Job Card", colour = HEX('5c1e11') }
    },
    reminder_text = {
        { text = "(1 in 3/Hand)" }
    }
}

jd_def["j_Crackedlatro_sello_aprobacion_joker"] = {
    text = {
        { text = "Random Seal", colour = G.C.GOLD }
    },
    reminder_text = {
        { text = "(1 Card Played)" }
    }
}

jd_def["j_Crackedlatro_charco_pintura_joker"] = {
    text = {
        { text = "+25 / +50", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "suit", colour = G.C.ATTENTION },
        { text = " / Wild)" }
    }
}

-- New Rare Jokers
jd_def["j_Crackedlatro_parca_joker"] = {
    text = {
        { text = "Invisible Joker", colour = G.C.PURPLE }
    },
    reminder_text = {
        { text = "(1/round on sell)" }
    }
}

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
        { text = "($" },
        { ref_table = "card.ability.extra", ref_value = "cost" },
        { text = " for +X1)" }
    }
}

jd_def["j_Crackedlatro_sobresaturado_joker"] = {
    text = {
        { text = "Enh/Seal/Ed", colour = G.C.SECONDARY_SET.Enhanced }
    },
    reminder_text = {
        { text = "(Or +$10)" }
    }
}

