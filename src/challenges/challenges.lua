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
                -- Unconditional / auto-activating scoring Jokers that break Falta de Lectura
                { id = 'j_joker' },
                { id = 'j_misprint' },
                { id = 'j_popcorn' },
                { id = 'j_gros_michel' },
                { id = 'j_cavendish' },
                { id = 'j_ice_cream' },
                { id = 'j_blue_joker' },
                { id = 'j_abstract' },
                { id = 'j_half' },
                { id = 'j_banner' },
                { id = 'j_mystic_summit' },
                { id = 'j_supernova' },
                { id = 'j_green_joker' },
                { id = 'j_bull' },
                { id = 'j_boots' },
                { id = 'j_swashbuckler' },
                { id = 'j_stone' },
                { id = 'j_stuntman' },
                { id = 'j_ceremonial' },
                { id = 'j_constellation' },
                { id = 'j_fortune_teller' },
                { id = 'j_ride_the_bus' },
                { id = 'j_red_card' },
                { id = 'j_flash' },
                { id = 'j_hologram' },
                { id = 'j_obelisk' },
                { id = 'j_erosion' },
                { id = 'j_madness' },
                { id = 'j_card_sharp' },
                -- Suit-based flat multi jokers
                { id = 'j_greedy_joker' },
                { id = 'j_lusty_joker' },
                { id = 'j_wrathful_joker' },
                { id = 'j_gluttenous_joker' },
                -- Simple unconditional hand jokers
                { id = 'j_droll' },
                { id = 'j_sly' },
                { id = 'j_clever' },
                { id = 'j_devious' },
                { id = 'j_wily' },
                { id = 'j_zany' },
                { id = 'j_mad' },
                { id = 'j_crazy' }
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
            custom = {
                { id = 'single_random_suit' }
            },
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
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                -- Banned tarots that modify ranks (Death, Strength)
                { id = 'c_death' },
                { id = 'c_strength' },
                { id = 'j_four_fingers' },
                { id = 'j_shortcut' }
            },
            banned_tags = {},
            banned_other = {}
        }
    },

    -- 4. Deuda Extrema (Predatory Loan - Infostealer Challenge)
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
                -- Fixed: Removed non-existent v_credit_card which caused the crash!
                { id = 'j_credit_card' },
                { id = 'v_clearance_sale' },
                { id = 'v_liquidation' }
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
            -- Exactly 16 Stone Cards, all are Aces (4 of each suit)
            cards = {
                {s='S',r='A',e='m_stone'},{s='S',r='A',e='m_stone'},{s='S',r='A',e='m_stone'},{s='S',r='A',e='m_stone'},
                {s='H',r='A',e='m_stone'},{s='H',r='A',e='m_stone'},{s='H',r='A',e='m_stone'},{s='H',r='A',e='m_stone'},
                {s='C',r='A',e='m_stone'},{s='C',r='A',e='m_stone'},{s='C',r='A',e='m_stone'},{s='C',r='A',e='m_stone'},
                {s='D',r='A',e='m_stone'},{s='D',r='A',e='m_stone'},{s='D',r='A',e='m_stone'},{s='D',r='A',e='m_stone'}
            }
        },
        restrictions = {
            banned_cards = {
                -- Tarots that grant enhancements
                { id = 'c_magician' },
                { id = 'c_empress' },
                { id = 'c_heirophant' },
                { id = 'c_lovers' },
                { id = 'c_chariot' },
                { id = 'c_justice' },
                { id = 'c_tower' },
                { id = 'c_devil' },
                -- Tarots that alter cards
                { id = 'c_death' },
                { id = 'c_strength' },
                -- Spectrals that alter cards, seals or enhancements
                { id = 'c_talisman' },
                { id = 'c_deja_vu' },
                { id = 'c_trance' },
                { id = 'c_medium' },
                { id = 'c_aura' },
                { id = 'c_immolate' },
                { id = 'c_grim' },
                { id = 'c_incantation' },
                { id = 'c_familiar' },
                { id = 'c_sigil' },
                { id = 'c_ouija' },
                { id = 'c_cryptid' },
                -- Jokers that alter cards or add enhancements
                { id = 'j_marble' },
                { id = 'j_midas_mask' },
                { id = 'j_vampire' },
                { id = 'j_certificate' },
                { id = 'j_dna' },
                { id = 'j_trading' }
            },
            banned_tags = {
                { id = 'tag_standard' }
            },
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
            type = 'Challenge Deck',
            -- All Face cards (J, Q, K) banned; 40 numbered cards (2..T, A)
            cards = {
                {s='S',r='2'},{s='S',r='3'},{s='S',r='4'},{s='S',r='5'},{s='S',r='6'},{s='S',r='7'},{s='S',r='8'},{s='S',r='9'},{s='S',r='T'},{s='S',r='A'},
                {s='H',r='2'},{s='H',r='3'},{s='H',r='4'},{s='H',r='5'},{s='H',r='6'},{s='H',r='7'},{s='H',r='8'},{s='H',r='9'},{s='H',r='T'},{s='H',r='A'},
                {s='C',r='2'},{s='C',r='3'},{s='C',r='4'},{s='C',r='5'},{s='C',r='6'},{s='C',r='7'},{s='C',r='8'},{s='C',r='9'},{s='C',r='T'},{s='C',r='A'},
                {s='D',r='2'},{s='D',r='3'},{s='D',r='4'},{s='D',r='5'},{s='D',r='6'},{s='D',r='7'},{s='D',r='8'},{s='D',r='9'},{s='D',r='T'},{s='D',r='A'}
            }
        },
        restrictions = {
            banned_cards = {
                { id = 'j_even_steven' },
                { id = 'j_odd_todd' },
                -- Banned all Planets EXCEPT Double Pair (c_uranus)
                { id = 'c_mercury' },
                { id = 'c_venus' },
                { id = 'c_earth' },
                { id = 'c_mars' },
                { id = 'c_jupiter' },
                { id = 'c_saturn' },
                { id = 'c_neptune' },
                { id = 'c_pluto' },
                { id = 'c_planet_x' },
                { id = 'c_ceres' },
                { id = 'c_eris' }
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
            -- Numbers (2..T) are Wild (36 cards), Figures (J, Q, K, A) are normal (16 cards)
            cards = {
                {s='S',r='2',e='m_wild'},{s='S',r='3',e='m_wild'},{s='S',r='4',e='m_wild'},{s='S',r='5',e='m_wild'},{s='S',r='6',e='m_wild'},{s='S',r='7',e='m_wild'},{s='S',r='8',e='m_wild'},{s='S',r='9',e='m_wild'},{s='S',r='T',e='m_wild'},
                {s='H',r='2',e='m_wild'},{s='H',r='3',e='m_wild'},{s='H',r='4',e='m_wild'},{s='H',r='5',e='m_wild'},{s='H',r='6',e='m_wild'},{s='H',r='7',e='m_wild'},{s='H',r='8',e='m_wild'},{s='H',r='9',e='m_wild'},{s='H',r='T',e='m_wild'},
                {s='C',r='2',e='m_wild'},{s='C',r='3',e='m_wild'},{s='C',r='4',e='m_wild'},{s='C',r='5',e='m_wild'},{s='C',r='6',e='m_wild'},{s='C',r='7',e='m_wild'},{s='C',r='8',e='m_wild'},{s='C',r='9',e='m_wild'},{s='C',r='T',e='m_wild'},
                {s='D',r='2',e='m_wild'},{s='D',r='3',e='m_wild'},{s='D',r='4',e='m_wild'},{s='D',r='5',e='m_wild'},{s='D',r='6',e='m_wild'},{s='D',r='7',e='m_wild'},{s='D',r='8',e='m_wild'},{s='D',r='9',e='m_wild'},{s='D',r='T',e='m_wild'},
                {s='S',r='J'},{s='S',r='Q'},{s='S',r='K'},{s='S',r='A'},
                {s='H',r='J'},{s='H',r='Q'},{s='H',r='K'},{s='H',r='A'},
                {s='C',r='J'},{s='C',r='Q'},{s='C',r='K'},{s='C',r='A'},
                {s='D',r='J'},{s='D',r='Q'},{s='D',r='K'},{s='D',r='A'}
            }
        },
        restrictions = {
            banned_cards = {
                -- Banned tarots that change enhancements
                { id = 'c_magician' },
                { id = 'c_empress' },
                { id = 'c_heirophant' },
                { id = 'c_lovers' },
                { id = 'c_chariot' },
                { id = 'c_justice' },
                { id = 'c_tower' },
                { id = 'c_devil' },
                -- Banned suit-benefiting jokers
                { id = 'j_ancient' },
                { id = 'j_bloodstone' },
                { id = 'j_arrowhead' },
                { id = 'j_onyx_agate' },
                { id = 'j_rough_gem' },
                { id = 'j_smeared' },
                { id = 'j_greedy_joker' },
                { id = 'j_lusty_joker' },
                { id = 'j_wrathful_joker' },
                { id = 'j_gluttenous_joker' },
                { id = 'j_idol' },
                { id = 'j_flower_pot' },
                { id = 'j_seeing_double' },
                { id = 'j_blackboard' },
                { id = 'j_castle' },
                { id = 'j_tribe' }
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
                -- Allows only 3 jokers in addition to the 2 starting ones (total 5 slots)
                { id = 'joker_slots', value = 5 },
                { id = 'reroll_cost', value = 7 }
            }
        },
        jokers = {
            { id = 'j_Crackedlatro_perfectionism_joker', eternal = true },
            { id = 'j_Crackedlatro_appraiser_joker', eternal = true }
        },
        vouchers = {
            { id = 'v_crystal_ball' },
            { id = 'v_omen_globe' },
            { id = 'v_magic_trick' },
            { id = 'v_illusion' }
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
                -- Banned jokers that add mult on played cards
                { id = 'j_scholar' },
                { id = 'j_shoot_the_moon' },
                { id = 'j_walkie_talkie' },
                { id = 'j_smiley' },
                { id = 'j_scary_face' },
                { id = 'j_even_steven' },
                { id = 'j_odd_todd' },
                { id = 'j_fibonacci' },
                { id = 'j_hack' },
                { id = 'j_photograph' },
                { id = 'j_triboulet' },
                { id = 'j_ancient' },
                { id = 'j_bloodstone' },
                { id = 'j_arrowhead' },
                { id = 'j_onyx_agate' },
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
                -- All jokers are perishable
                { id = 'all_perishable' }
            },
            modifiers = {
                { id = 'hands', value = 3 },
                { id = 'discards', value = 2 }
            }
        },
        jokers = {
            -- Starts with 5 Doctor Jo Jokers, all perishable
            { id = 'j_Crackedlatro_doctor_jo_joker', perishable = true },
            { id = 'j_Crackedlatro_doctor_jo_joker', perishable = true },
            { id = 'j_Crackedlatro_doctor_jo_joker', perishable = true },
            { id = 'j_Crackedlatro_doctor_jo_joker', perishable = true },
            { id = 'j_Crackedlatro_doctor_jo_joker', perishable = true }
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
                { id = 'hands', value = 4 },
                { id = 'discards', value = 2 },
                { id = 'dollars', value = 30 }
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
                -- Tarots that grant enhancements or editions
                { id = 'c_magician' },
                { id = 'c_empress' },
                { id = 'c_heirophant' },
                { id = 'c_lovers' },
                { id = 'c_chariot' },
                { id = 'c_justice' },
                { id = 'c_tower' },
                { id = 'c_devil' },
                { id = 'c_wheel_of_fortune' },
                -- Spectrals that grant seals, editions or alterations
                { id = 'c_talisman' },
                { id = 'c_deja_vu' },
                { id = 'c_trance' },
                { id = 'c_medium' },
                { id = 'c_aura' },
                -- Jokers that grant enhancements, seals or editions
                { id = 'j_marble' },
                { id = 'j_midas_mask' },
                { id = 'j_certificate' },
                -- Hand modifiers
                { id = 'j_burglar' },
                { id = 'v_grabber' },
                { id = 'v_nacho_tong' }
            },
            banned_tags = {
                { id = 'tag_standard' },
                { id = 'tag_foil' },
                { id = 'tag_holo' },
                { id = 'tag_polychrome' }
            },
            banned_other = {}
        }
    }
}

-- Hook for Geometría Sagrada (single random suit deck) and all_perishable challenge mechanic
local orig_game_start_run = Game.start_run
function Game:start_run(args)
    orig_game_start_run(self, args)
    if not (args and args.savetable) and G.GAME then
        local ch_id = (G.GAME.challenge) or (args and args.challenge and (args.challenge.id or args.challenge.key)) or ""
        if ch_id == 'c_Crackedlatro_geometria_sagrada' or ch_id == 'geometria_sagrada' or (G.GAME.challenge_tab and G.GAME.challenge_tab.id == 'c_Crackedlatro_geometria_sagrada') then
            if G.playing_cards and #G.playing_cards > 0 then
                local suits = { 'Spades', 'Hearts', 'Clubs', 'Diamonds' }
                local chosen_suit = pseudorandom_element(suits, pseudoseed('geometria_sagrada_suit'))
                for _, c in ipairs(G.playing_cards) do
                    c:change_suit(chosen_suit)
                end
            end
        end
    end
end

-- Hook create_card for all_perishable custom rule
local orig_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == 'Joker' and card and G.GAME and G.GAME.modifiers and G.GAME.modifiers.all_perishable then
        if card.set_perishable then
            card:set_perishable(true)
        else
            card.ability.perishable = true
            card.ability.perish_tally = G.GAME.perishable_rounds or 5
        end
    end
    return card
end

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
    local cfg = (SMODS and SMODS.current_mod and SMODS.current_mod.config) or {}
    if cfg.new_challenges == false then
        cracklatro_sync_challenges(false)
    end
end
