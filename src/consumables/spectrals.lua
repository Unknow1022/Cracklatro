-- Spectral Cards

-- 1. Hierarchy
SMODS.Atlas {
    key = "c_hierarchy",
    path = "c_hierarchy.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'hierarchy',
    set = 'Spectral',
    atlas = 'c_hierarchy',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Hierarchy',
        text = {
            "Destroy {C:attention}all cards in hand{},",
            "create {C:attention}3 Steel Kings{} with {C:red}Red Seal{},",
            "{C:blue}-1 Hand{}"
        }
    },
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        for i = 1, #G.hand.cards do
            destroyed_cards[#destroyed_cards + 1] = G.hand.cards[i]
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot2')
                card:juice_up(0.4, 0.6)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                for i = #destroyed_cards, 1, -1 do
                    local d_card = destroyed_cards[i]
                    if d_card.ability and d_card.ability.name == 'Glass Card' then
                        d_card:shatter()
                    else
                        d_card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                play_sound('tarot1')
                for i = 1, 3 do
                    local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                    local chosen_suit = pseudorandom_element(suits, 'hierarchy_suit')
                    local suit_prefix = string.sub(chosen_suit, 1, 1)

                    cards[i] = create_playing_card({
                        front = G.P_CARDS[suit_prefix .. '_K'],
                        center = G.P_CENTERS.m_steel
                    }, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
                    cards[i]:set_seal('Red', nil, true)
                    cards[i]:juice_up(0.4, 0.4)
                end
                playing_card_joker_effects(cards)
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Hierarchy Created!', colour = G.C.SECONDARY_SET.Spectral })
                return true
            end
        }))
        ease_hands_played(-1)
    end
}

-- 2. Order
SMODS.Atlas {
    key = "c_order",
    path = "c_order.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'order',
    set = 'Spectral',
    atlas = 'c_order',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Order',
        text = {
            "Add a {C:green}Dark Green Seal{}",
            "to {C:attention}1 selected card{}"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local seal_key = (G.P_SEALS and G.P_SEALS['Crackedlatro_dark_green'] and 'Crackedlatro_dark_green') or 'dark_green'
                target:set_seal(seal_key, nil, true)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Dark Green Seal!', colour = HEX('1b4d2e') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- 3. Rot
SMODS.Atlas {
    key = "c_rot",
    path = "c_rot.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'rot',
    set = 'Spectral',
    atlas = 'c_rot',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Rot',
        text = {
            "Destroy {C:attention}all current Jokers{}",
            "{C:inactive}(including Eternal){},",
            "create {C:red}2 random Rare Eternal Jokers{},",
            "{C:red}-1 Discard{}"
        }
    },
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
        ease_discard(-1)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2')
                card:juice_up(0.4, 0.6)
                for i = #G.jokers.cards, 1, -1 do
                    local j = G.jokers.cards[i]
                    if j.ability then
                        j.ability.eternal = nil
                    end
                    j:start_dissolve()
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                play_sound('foil1')
                for i = 1, 2 do
                    local new_joker = create_card('Joker', G.jokers, nil, 1, nil, nil, nil, 'rot')
                    new_joker:set_eternal(true)
                    new_joker:add_to_deck()
                    G.jokers:emplace(new_joker)
                    new_joker:juice_up(0.5, 0.5)
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Rot Harvest!', colour = G.C.RED })
                return true
            end
        }))
    end
}

-- 4. Catastrophic
SMODS.Atlas {
    key = "c_catastrophic",
    path = "c_catastrophic.png",
    px = 71,
    py = 95
}

local function get_most_played_hands()
    local hands_by_count = {}
    local counts = {}
    if G.GAME and G.GAME.hands then
        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_data.visible then
                local played = hand_data.played or 0
                if not hands_by_count[played] then
                    hands_by_count[played] = {}
                    table.insert(counts, played)
                end
                table.insert(hands_by_count[played], hand_name)
            end
        end
    end
    table.sort(counts, function(a, b) return a > b end)

    local most_played = nil
    local second_played = nil

    if #counts > 0 then
        local top_count = counts[1]
        local top_group = hands_by_count[top_count]
        most_played = pseudorandom_element(top_group, 'catastrophic_top')

        local remaining_top = {}
        for _, h in ipairs(top_group) do
            if h ~= most_played then table.insert(remaining_top, h) end
        end

        if #remaining_top > 0 then
            second_played = pseudorandom_element(remaining_top, 'catastrophic_second')
        elseif #counts > 1 then
            local second_count = counts[2]
            second_played = pseudorandom_element(hands_by_count[second_count], 'catastrophic_second')
        else
            second_played = most_played
        end
    end

    return most_played or 'High Card', second_played or 'Pair'
end

local hand_to_planet = {
    ['High Card'] = 'c_pluto',
    ['Pair'] = 'c_mercury',
    ['Two Pair'] = 'c_uranus',
    ['Three of a Kind'] = 'c_venus',
    ['Straight'] = 'c_saturn',
    ['Flush'] = 'c_jupiter',
    ['Full House'] = 'c_earth',
    ['Four of a Kind'] = 'c_mars',
    ['Straight Flush'] = 'c_neptune',
    ['Five of a Kind'] = 'c_planet_x',
    ['Flush House'] = 'c_ceres',
    ['Flush Five'] = 'c_eris'
}

SMODS.Consumable {
    key = 'catastrophic',
    set = 'Spectral',
    atlas = 'c_catastrophic',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Catastrophic',
        text = {
            "{C:attention}+4 levels{} to your most played hand,",
            "creates {C:attention}3 Negative Planets{} of your",
            "most played hand,",
            "{C:red}-1 level{} to all other hands"
        }
    },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local most_played = get_most_played_hands()

        play_sound('tarot2')
        card:juice_up(0.4, 0.6)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname = most_played, level = G.GAME.hands[most_played].level + 4})
        level_up_hand(card, most_played, false, 4)

        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_name ~= most_played and hand_data.level > 1 then
                level_up_hand(card, hand_name, true, -1)
            end
        end

        local planet_key = hand_to_planet[most_played] or 'c_pluto'
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                for i = 1, 3 do
                    local p_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet_key, 'catastrophic')
                    p_card:set_edition({negative = true}, true)
                    p_card:add_to_deck()
                    G.consumeables:emplace(p_card)
                    p_card:juice_up(0.3, 0.3)
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Catastrophic!', colour = G.C.DARK_EDITION })
                return true
            end
        }))
    end
}

-- 5. Intensity
SMODS.Atlas {
    key = "c_intensity",
    path = "c_intensity.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'intensity',
    set = 'Spectral',
    atlas = 'c_intensity',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Intensity',
        text = {
            "Destroy {C:attention}5 selected cards{},",
            "create {C:attention}1 Polychrome Wild Card{}",
            "with {C:red}Red Seal{}",
            "of random rank and suit"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 5
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        for _, c in ipairs(G.hand.highlighted) do
            table.insert(destroyed_cards, c)
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot2')
                card:juice_up(0.4, 0.6)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                for i = #destroyed_cards, 1, -1 do
                    local d_card = destroyed_cards[i]
                    if d_card.ability and d_card.ability.name == 'Glass Card' then
                        d_card:shatter()
                    else
                        d_card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                local ranks = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'}
                local chosen_suit = pseudorandom_element(suits, 'intensity_suit')
                local chosen_rank = pseudorandom_element(ranks, 'intensity_rank')
                local suit_prefix = string.sub(chosen_suit, 1, 1)

                play_sound('polychrome1')
                local new_card = create_playing_card({
                    front = G.P_CARDS[suit_prefix .. '_' .. chosen_rank],
                    center = G.P_CENTERS.m_wild
                }, G.hand, nil, nil, {G.C.SECONDARY_SET.Spectral})

                new_card:set_edition('e_polychrome', true)
                new_card:set_seal('Red', nil, true)
                new_card:juice_up(0.6, 0.6)
                playing_card_joker_effects({new_card})
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Intense Genesis!', colour = G.C.SECONDARY_SET.Spectral })
                return true
            end
        }))
    end
}

-- 6. La Muchachada
SMODS.Atlas {
    key = "c_la_muchachada",
    path = "la_muchachada_joker.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'la_muchachada',
    set = 'Spectral',
    atlas = 'c_la_muchachada',
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'La Muchachada',
        text = {
            "Creates a random {C:attention}Secret Joker{}",
            "{C:inactive}(Must have room){}",
            "{C:inactive}(\"LLEGO UN MIEMBRO DE LA MUCHACHADA!!\"){}"
        }
    },
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2')
                card:juice_up(0.5, 0.8)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local secret_keys = {
                    'j_Crackedlatro_esteban', 'j_Crackedlatro_thiago', 'j_Crackedlatro_paula', 'j_Crackedlatro_black_hole_joker',
                    'j_Crackedlatro_squele', 'j_Crackedlatro_bluxdir', 'j_Crackedlatro_charles', 'j_Crackedlatro_mochi',
                    'j_Crackedlatro_helin', 'j_Crackedlatro_raytracing', 'j_Crackedlatro_paco', 'j_Crackedlatro_gabi', 'j_Crackedlatro_yairo'
                }
                local valid_secret_keys = {}
                for _, k in ipairs(secret_keys) do
                    if G.P_CENTERS and G.P_CENTERS[k] then
                        table.insert(valid_secret_keys, k)
                    end
                end
                local chosen_key = (#valid_secret_keys > 0) and pseudorandom_element(valid_secret_keys, 'la_muchachada_secret') or pseudorandom_element(secret_keys, 'la_muchachada_secret')
                play_sound('foil1')
                local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_key, 'la_muchachada')
                new_joker:add_to_deck()
                G.jokers:emplace(new_joker)
                new_joker:juice_up(0.8, 0.8)
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "LLEGO UN MIEMBRO DE LA MUCHACHADA!!", colour = G.C.DARK_EDITION })
                return true
            end
        }))
    end
}

-- 7. Refuerzo
SMODS.Atlas {
    key = "c_refuerzo",
    path = "c_refuerzo.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'refuerzo',
    set = 'Spectral',
    atlas = 'c_refuerzo',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Refuerzo',
        text = {
            "Add a {C:chips}Silver Seal{}",
            "to {C:attention}1 selected card{}"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local seal_key = (G.P_SEALS and G.P_SEALS['Crackedlatro_silver'] and 'Crackedlatro_silver') or 'silver'
                play_sound('gold_seal')
                target:set_seal(seal_key, nil, true)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Silver Seal!', colour = HEX('bdc3c7') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- 8. Supernova
SMODS.Atlas {
    key = "c_supernova",
    path = "c_supernova.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'supernova',
    set = 'Spectral',
    atlas = 'c_supernova',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Supernova',
        text = {
            "Add a {C:planet}White Seal{}",
            "to {C:attention}1 selected card{}"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local seal_key = (G.P_SEALS and G.P_SEALS['Crackedlatro_white'] and 'Crackedlatro_white') or 'white'
                play_sound('tarot2')
                target:set_seal(seal_key, nil, true)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'White Seal!', colour = G.C.WHITE })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

