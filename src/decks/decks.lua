-- Custom Decks (Barajas)

-- 1. Caveman Deck
SMODS.Atlas {
    key = "b_cavernicola",
    path = "b_cavernicola.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'cavernicola',
    atlas = 'b_cavernicola',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Caveman Deck',
        text = {
            "Start with only {C:attention}A, 2, 3, 4, 6, 8{} of each suit in your full deck,",
            "all other starting cards are {C:attention}Stone Cards{},",
            "{C:red}-1{} Hand"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local is_combo = G.GAME and (G.GAME.cavernicola_sleeve_combo or is_sleeve_matching("cavernicola"))
                if G.playing_cards then
                    local keep_ranks = { ['Ace'] = true, ['2'] = true, ['3'] = true, ['4'] = true, ['6'] = true, ['8'] = true }
                    local silver_seal_key = (G.P_SEALS and G.P_SEALS['Crackedlatro_silver'] and 'Crackedlatro_silver') or 'silver'
                    for _, card in ipairs(G.playing_cards) do
                        local val = card.base and card.base.value
                        if not keep_ranks[val] then
                            card:set_ability(G.P_CENTERS.m_stone)
                            if is_combo then
                                card:set_seal(silver_seal_key, nil, true)
                            end
                        end
                    end
                end

                if not is_combo then
                    G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                    ease_hands_played(-1)
                end

                return true
            end
        }))
    end
}

-- 2. Strategist Deck
SMODS.Atlas {
    key = "b_strategist",
    path = "b_strategist.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'strategist',
    atlas = 'b_strategist',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Strategist Deck',
        text = {
            "Start with a {C:attention}24-card deck{}",
            "{C:inactive}(Aces, Kings, Queens, Jacks, 10s, 9s){}",
            "Start with {C:attention}Magic Trick{} voucher,",
            "Start with {C:money}$0{}, {C:red}-1{} hand, {C:red}-2{} discards,",
            "Blind score targets are {C:attention}X1.2{}"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local is_combo = G.GAME and (G.GAME.strategist_sleeve_combo or is_sleeve_matching("strategist"))
                if G.playing_cards then
                    for i = #G.playing_cards, 1, -1 do
                        local card = G.playing_cards[i]
                        local val = card.base and card.base.value
                        local keep = false
                        if is_combo then
                            -- 20 cards: Ace, King, Queen, Jack, 10
                            keep = (val == 'Ace' or val == 'King' or val == 'Queen' or val == 'Jack' or val == '10')
                        else
                            -- 24 cards: Ace, King, Queen, Jack, 10, 9
                            keep = (val == 'Ace' or val == 'King' or val == 'Queen' or val == 'Jack' or val == '10' or val == '9')
                        end
                        if not keep then
                            if card.area then
                                card.area:remove_card(card)
                            end
                            card:remove()
                            table.remove(G.playing_cards, i)
                        end
                    end
                end

                G.GAME.dollars = 0

                G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                ease_hands_played(-1)

                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 2)
                ease_discard(-2)

                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                G.GAME.used_vouchers['v_magic_trick'] = true
                if is_combo then
                    G.GAME.used_vouchers['v_tarot_merchant'] = true
                    if G.GAME.shop then
                        G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
                    end
                    G.GAME.modifiers = G.GAME.modifiers or {}
                    G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) + 1
                end

                G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * 1.2

                return true
            end
        }))
    end
}

-- 3. Overseer Deck
SMODS.Atlas {
    key = "b_overseer",
    path = "b_hateful.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'overseer',
    atlas = 'b_overseer',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Overseer Deck',
        text = {
            "Creates a random {C:spectral}Spectral card{}",
            "at the end of round {C:inactive}(except Rot and Soul){},",
            "{C:attention}Tags are always doubled{},",
            "Joker prices are {C:red}X1.5{},",
            "Start with {C:money}$2{}, {C:red}-1{} hand, {C:red}-1{} discard"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.overseer_deck = true
                local is_combo = G.GAME and (G.GAME.overseer_sleeve_combo or is_sleeve_matching("overseer"))
                if is_combo then
                    G.GAME.overseer_no_markup = true
                    G.GAME.dollars = 7
                else
                    G.GAME.dollars = 2
                    G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                    ease_hands_played(-1)
                end

                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                ease_discard(-1)

                return true
            end
        }))
    end,
    calculate = function(self, back, context)
        local is_combo = G.GAME and (G.GAME.overseer_sleeve_combo or is_sleeve_matching("overseer"))
        if not is_combo and context.end_of_round and not context.individual and not context.repetition then
            if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local forbidden = { ['c_rot'] = true, ['c_soul'] = true, ['c_Crackedlatro_rot'] = true }
                        local valid_spectrals = {}
                        if G.P_CENTER_POOLS and G.P_CENTER_POOLS['Spectral'] then
                            for _, center in ipairs(G.P_CENTER_POOLS['Spectral']) do
                                if not forbidden[center.key] and not string.find(center.key, 'rot', 1, true) and not string.find(center.key, 'soul', 1, true) then
                                    table.insert(valid_spectrals, center.key)
                                end
                            end
                        end
                        local chosen_key = (#valid_spectrals > 0) and pseudorandom_element(valid_spectrals, pseudoseed('overseer')) or 'c_ankh'
                        local scard = create_card('Spectral', G.consumeables, nil, nil, nil, nil, chosen_key, 'overseer')
                        scard:add_to_deck()
                        G.consumeables:emplace(scard)
                        scard:juice_up(0.5, 0.5)
                        return true
                    end
                }))
            end
        end
    end
}

-- 4. Friendly Deck (Baraja Amistosa)
SMODS.Atlas {
    key = "b_friendly",
    path = "b_friendly.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'friendly',
    atlas = 'b_friendly',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Friendly Deck',
        text = {
            "Start run with {C:attention}2 random Negative Eternal Jokers{},",
            "{C:inactive}(Except Legendary or Secret){},",
            "{C:red}-1{} Joker slot,",
            "{C:red}-1{} Discard"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local is_combo = G.GAME and (G.GAME.friendly_sleeve_combo or is_sleeve_matching("friendly"))
                if is_combo then
                    -- Friendly Deck + Friendly Sleeve Fusion
                    if G.jokers and G.jokers.config then
                        G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 2)
                    end
                    if G.GAME and G.GAME.starting_params and G.GAME.starting_params.joker_slots then
                        G.GAME.starting_params.joker_slots = math.max(1, G.GAME.starting_params.joker_slots - 2)
                    end

                    G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                    ease_discard(-1)

                    play_sound('foil1')
                    local legendary_spawned = false
                    for i = 1, 3 do
                        local new_joker = nil
                        -- Max 1 Legendary can spawn across the 3 generated Jokers
                        if not legendary_spawned and pseudorandom('friendly_legendary_roll_' .. i) < 0.35 then
                            new_joker = create_card('Joker', G.jokers, true, 4, nil, false, nil, 'friendly_legendary')
                            if new_joker then
                                legendary_spawned = true
                            end
                        end
                        if not new_joker then
                            local rarity_roll = pseudorandom('friendly_rarity_' .. i)
                            local rarity = (rarity_roll > 0.95 and 3) or (rarity_roll > 0.70 and 2) or 1
                            new_joker = create_card('Joker', G.jokers, false, rarity, nil, false, nil, 'friendly_deck_combo')
                        end
                        if is_secret_card(new_joker) then
                            if new_joker.area then new_joker.area:remove_card(new_joker) end
                            new_joker:remove()
                            new_joker = create_card('Joker', G.jokers, false, 1, nil, false, nil, 'friendly_fallback')
                        end
                        new_joker:set_eternal(true)
                        if new_joker.ability then new_joker.ability.eternal = true end
                        new_joker:set_edition({ negative = true }, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:juice_up(0.5, 0.5)
                    end
                else
                    if G.jokers and G.jokers.config then
                        G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
                    end
                    if G.GAME and G.GAME.starting_params and G.GAME.starting_params.joker_slots then
                        G.GAME.starting_params.joker_slots = math.max(1, G.GAME.starting_params.joker_slots - 1)
                    end

                    G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                    ease_discard(-1)

                    play_sound('foil1')
                    for i = 1, 2 do
                        local rarity_roll = pseudorandom('friendly_rarity_' .. i)
                        local rarity = (rarity_roll > 0.95 and 3) or (rarity_roll > 0.70 and 2) or 1
                        local new_joker = create_card('Joker', G.jokers, false, rarity, nil, false, nil, 'friendly_deck')
                        if is_secret_card(new_joker) then
                            if new_joker.area then new_joker.area:remove_card(new_joker) end
                            new_joker:remove()
                            new_joker = create_card('Joker', G.jokers, false, 1, nil, false, nil, 'friendly_deck_fallback')
                        end
                        new_joker:set_eternal(true)
                        if new_joker.ability then new_joker.ability.eternal = true end
                        new_joker:set_edition({ negative = true }, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:juice_up(0.5, 0.5)
                    end
                end
                return true
            end
        }))
    end
}


