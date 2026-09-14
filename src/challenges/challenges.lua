--[[
    The Cracked Balatro (Cracklatro)
    Special Synergy Challenges
    10 high-difficulty custom challenges based on specific mod synergies
--]]

local challenge_definitions = {
    -- 1. Ruleta Rusa de Negocios (High Roller's Casino)
    {
        key = 'casino_roller',
        loc_txt = {
            name = 'Ruleta Rusa de Negocios'
        },
        rules = {
            custom = {
                { id = 'no_reward' },
                { id = 'no_extra_hand_money' },
                { id = 'no_interest' }
            },
            modifiers = {
                { id = 'dollars', value = 12 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_slot_machine_joker', eternal = true, pinned = true },
            { id = 'j_Crackedlatro_shareholder_joker', eternal = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'j_golden' },
                { id = 'j_to_the_moon' },
                { id = 'j_rocket' },
                { id = 'j_satellite' },
                { id = 'v_seed_money' },
                { id = 'v_money_tree' }
            },
            banned_tags = {
                { id = 'tag_investment' },
                { id = 'tag_handy' },
                { id = 'tag_garbage' }
            },
            banned_other = {}
        }
    },

    -- 2. Silencio Absoluto (Absolute Silence)
    {
        key = 'silencio_absoluto',
        loc_txt = {
            name = 'Silencio Absoluto'
        },
        rules = {
            custom = {
                { id = 'no_reward' }
            },
            modifiers = {
                { id = 'hands', value = 3 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_falta_de_lectura_joker', eternal = true, pinned = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'j_joker' },
                { id = 'j_greedy_joker' },
                { id = 'j_lusty_joker' },
                { id = 'j_wrathful_joker' },
                { id = 'j_gluttenous_joker' },
                { id = 'j_half' },
                { id = 'j_droll' },
                { id = 'j_sly' },
                { id = 'j_clever' },
                { id = 'j_devious' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 3. Geometría Sagrada (Sacred Symmetry)
    {
        key = 'geometria_sagrada',
        loc_txt = {
            name = 'Geometría Sagrada'
        },
        rules = {
            custom = {},
            modifiers = {
                { id = 'hands', value = 3 },
                { id = 'discards', value = 3 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_symmetrical_joker', eternal = true },
            { id = 'j_Crackedlatro_balance_joker', eternal = true }
        },
        deck = {
            type = 'Challenge Deck',
            cards = {
                {s='S',r='2'},{s='S',r='3'},{s='S',r='4'},{s='S',r='5'},{s='S',r='6'},{s='S',r='7'},{s='S',r='8'},{s='S',r='9'},{s='S',r='T'},{s='S',r='J'},{s='S',r='Q'},{s='S',r='K'},{s='S',r='A'},
                {s='S',r='2'},{s='S',r='3'},{s='S',r='4'},{s='S',r='5'},{s='S',r='6'},{s='S',r='7'},{s='S',r='8'},{s='S',r='9'},{s='S',r='T'},{s='S',r='J'},{s='S',r='Q'},{s='S',r='K'},{s='S',r='A'},
                {s='H',r='2'},{s='H',r='3'},{s='H',r='4'},{s='H',r='5'},{s='H',r='6'},{s='H',r='7'},{s='H',r='8'},{s='H',r='9'},{s='H',r='T'},{s='H',r='J'},{s='H',r='Q'},{s='H',r='K'},{s='H',r='A'},
                {s='H',r='2'},{s='H',r='3'},{s='H',r='4'},{s='H',r='5'},{s='H',r='6'},{s='H',r='7'},{s='H',r='8'},{s='H',r='9'},{s='H',r='T'},{s='H',r='J'},{s='H',r='Q'},{s='H',r='K'},{s='H',r='A'}
            }
        },
        restrictions = {
            banned_cards = {
                { id = 'j_four_fingers' },
                { id = 'j_shortcut' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 4. Deuda Extrema (Predatory Loan)
    {
        key = 'deuda_extrema',
        loc_txt = {
            name = 'Deuda Extrema'
        },
        rules = {
            custom = {
                { id = 'inflation' }
            },
            modifiers = {
                { id = 'dollars', value = 18 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_infostealer_joker', eternal = true, pinned = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'v_credit_card' },
                { id = 'j_credit_card' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 5. La Forja y la Mina (The Forge & The Mine)
    {
        key = 'forja_y_mina',
        loc_txt = {
            name = 'La Forja y la Mina'
        },
        rules = {
            custom = {},
            modifiers = {
                { id = 'hand_size', value = 7 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_blacksmith_joker', eternal = true },
            { id = 'j_Crackedlatro_builder_joker', eternal = true }
        },
        deck = {
            type = 'Challenge Deck',
            cards = {
                {s='D',r='2',e='m_stone'},{s='D',r='3',e='m_stone'},{s='D',r='4',e='m_stone'},{s='D',r='5',e='m_stone'},
                {s='C',r='6',e='m_stone'},{s='C',r='7',e='m_stone'},{s='C',r='8',e='m_stone'},{s='C',r='9',e='m_stone'},
                {s='H',r='T',e='m_stone'},{s='H',r='J',e='m_stone'},{s='S',r='Q',e='m_stone'},{s='S',r='K',e='m_stone'},
                {s='D',r='A',seal='Crackedlatro_silver'},{s='C',r='A',seal='Crackedlatro_silver'},{s='H',r='A',seal='Crackedlatro_silver'},{s='S',r='A',seal='Crackedlatro_silver'},
                {s='D',r='2'},{s='D',r='3'},{s='D',r='4'},{s='D',r='5'},{s='D',r='6'},{s='D',r='7'},{s='D',r='8'},{s='D',r='9'},{s='D',r='T'},{s='D',r='J'},{s='D',r='Q'},{s='D',r='K'},
                {s='C',r='2'},{s='C',r='3'},{s='C',r='4'},{s='C',r='5'},{s='C',r='6'},{s='C',r='7'},{s='C',r='8'},{s='C',r='9'},{s='C',r='T'},{s='C',r='J'},{s='C',r='Q'},{s='C',r='K'},
                {s='H',r='2'},{s='H',r='3'},{s='H',r='4'},{s='H',r='5'},{s='H',r='6'},{s='H',r='7'},{s='H',r='8'},{s='H',r='9'},{s='H',r='T'},{s='H',r='J'},{s='H',r='Q'},{s='H',r='K'},
                {s='S',r='2'},{s='S',r='3'},{s='S',r='4'},{s='S',r='5'},{s='S',r='6'},{s='S',r='7'},{s='S',r='8'},{s='S',r='9'},{s='S',r='T'},{s='S',r='J'},{s='S',r='Q'},{s='S',r='K'}
            }
        },
        restrictions = {
            banned_cards = {
                { id = 'c_chariot' },
                { id = 'j_marble' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 6. Duelo Numérico (Duel of Parity)
    {
        key = 'duelo_numerico',
        loc_txt = {
            name = 'Duelo Numérico'
        },
        rules = {
            custom = {},
            modifiers = {
                { id = 'hands', value = 3 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_duel_of_value_joker', eternal = true, pinned = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'j_even_steven' },
                { id = 'j_odd_todd' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 7. El Lienzo Vivo (The Living Canvas)
    {
        key = 'lienzo_vivo',
        loc_txt = {
            name = 'El Lienzo Vivo'
        },
        rules = {
            custom = {},
            modifiers = {
                { id = 'hand_size', value = 7 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_charco_pintura_joker', eternal = true },
            { id = 'j_Crackedlatro_disenador_joker', eternal = true }
        },
        deck = {
            type = 'Challenge Deck',
            cards = {
                {s='D',r='A',e='m_wild'},{s='C',r='A',e='m_wild'},{s='H',r='A',e='m_wild'},{s='S',r='A',e='m_wild'},
                {s='D',r='K',e='m_wild'},{s='C',r='K',e='m_wild'},{s='H',r='K',e='m_wild'},{s='S',r='K',e='m_wild'},
                {s='D',r='Q',e='m_wild'},{s='H',r='Q',e='m_wild'},
                {s='D',r='2'},{s='D',r='3'},{s='D',r='4'},{s='D',r='5'},{s='D',r='6'},{s='D',r='7'},{s='D',r='8'},{s='D',r='9'},{s='D',r='T'},{s='D',r='J'},
                {s='C',r='2'},{s='C',r='3'},{s='C',r='4'},{s='C',r='5'},{s='C',r='6'},{s='C',r='7'},{s='C',r='8'},{s='C',r='9'},{s='C',r='T'},{s='C',r='J'},{s='C',r='Q'},
                {s='H',r='2'},{s='H',r='3'},{s='H',r='4'},{s='H',r='5'},{s='H',r='6'},{s='H',r='7'},{s='H',r='8'},{s='H',r='9'},{s='H',r='T'},{s='H',r='J'},
                {s='S',r='2'},{s='S',r='3'},{s='S',r='4'},{s='S',r='5'},{s='S',r='6'},{s='S',r='7'},{s='S',r='8'},{s='S',r='9'},{s='S',r='T'},{s='S',r='J'},{s='S',r='Q'}
            }
        },
        restrictions = {
            banned_cards = {
                { id = 'c_lovers' },
                { id = 'c_magician' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 8. Coleccionista de Brillos (Edition Tycoon)
    {
        key = 'coleccionista_brillos',
        loc_txt = {
            name = 'Coleccionista de Brillos'
        },
        rules = {
            custom = {
                { id = 'scaling', value = 2 }
            },
            modifiers = {
                { id = 'joker_slots', value = 6 },
                { id = 'reroll_cost', value = 7 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_perfectionism_joker', eternal = true },
            { id = 'j_Crackedlatro_appraiser_joker', eternal = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'v_hone' },
                { id = 'v_glow_up' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 9. Urgencias Médicas (Code Red ER)
    {
        key = 'urgencias_medicas',
        loc_txt = {
            name = 'Urgencias Médicas'
        },
        rules = {
            custom = {
                { id = 'enable_perishables_in_shop', value = true }
            },
            modifiers = {
                { id = 'hands', value = 2 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_doctor_jo_joker', eternal = true, pinned = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'j_mr_bones' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 10. Sobresaturación Singular (Singular Saturation)
    {
        key = 'sobresaturacion',
        loc_txt = {
            name = 'Sobresaturación Singular'
        },
        rules = {
            custom = {},
            modifiers = {
                { id = 'hands', value = 2 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_sobresaturado_joker', eternal = true, pinned = true }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                { id = 'j_burglar' },
                { id = 'v_grabber' },
                { id = 'v_nacho_tong' }
            },
            banned_tags = {},
            banned_other = {}
        }
    }
}

-- Synchronize / dynamic toggle for challenges in G.CHALLENGES
function cracklatro_sync_challenges(enable)
    if not G.CHALLENGES then return end

    -- Remove any existing Cracklatro challenges
    for i = #G.CHALLENGES, 1, -1 do
        local ch = G.CHALLENGES[i]
        if ch and ch.id and (string.find(ch.id, 'Crackedlatro', 1, true) or string.find(ch.id, 'c_cracklatro_', 1, true)) then
            table.remove(G.CHALLENGES, i)
        end
    end

    -- If enabled, inject the 10 challenges into G.CHALLENGES
    if enable then
        for _, ch in ipairs(challenge_definitions) do
            local ch_id = 'c_Crackedlatro_' .. ch.key
            local ch_name = (ch.loc_txt and ch.loc_txt.name) or ch.key
            table.insert(G.CHALLENGES, {
                name = ch_name,
                id = ch_id,
                rules = ch.rules or {},
                jokers = ch.jokers or {},
                consumeables = ch.consumeables or {},
                vouchers = ch.vouchers or {},
                deck = ch.deck or { type = 'Challenge Deck' },
                restrictions = ch.restrictions or {}
            })
        end
    end
end

-- SMODS.Challenge Registration
for _, def in ipairs(challenge_definitions) do
    if SMODS and SMODS.Challenge then
        SMODS.Challenge {
            key = def.key,
            loc_txt = def.loc_txt,
            rules = def.rules,
            jokers = def.jokers,
            consumeables = def.consumeables,
            vouchers = def.vouchers,
            deck = def.deck,
            restrictions = def.restrictions
        }
    end
end

-- Ensure challenges are properly synced according to current mod config
local original_init_game_challenges = Game.init_game_object
if original_init_game_challenges then
    -- Hook so challenges stay synchronized upon game initialization
    local cfg = (SMODS and SMODS.current_mod and SMODS.current_mod.config) or {}
    if cfg.new_challenges == false then
        cracklatro_sync_challenges(false)
    end
end
