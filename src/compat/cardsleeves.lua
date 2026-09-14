--[[
    The Cracked Balatro (Cracklatro)
    CardSleeves Mod Compatibility
    Adds sleeve versions of all 4 custom decks with unique combo fusion effects:
    - Friendly Sleeve (with Friendly Deck: spawns 3 Negative Eternals with up to 1 Legendary, -2 joker slots, -1 discard)
    - Caveman Sleeve (with Caveman Deck: stone cards get Silver Seals, +3 Mult and +20 Chips on score, +1 Hand)
    - Strategist Sleeve (with Strategist Deck: 20-card deck, Magic Trick + Tarot Merchant, +1 shop slot, +$1 per played hand)
    - Overseer Sleeve (with Overseer Deck: 2 Spectrals at end of round, tripled tags, removes Joker markup, +$5, +1 Hand)
--]]

-- Atlases for Custom Sleeves
SMODS.Atlas {
    key = "cracklatro_sleeves",
    path = "sleeves.png",
    px = 73,
    py = 95
}
-- Helper to parse localization strings for Sleeve objects
local function reparse_sleeve_entry(entry)
    if not entry then return end
    if loc_parse_string then
        if entry.text then
            entry.text_parsed = {}
            for _, line in ipairs(entry.text) do
                entry.text_parsed[#entry.text_parsed + 1] = loc_parse_string(line)
            end
        else
            entry.text_parsed = entry.text_parsed or {}
        end
        if entry.name then
            entry.name_parsed = {}
            local names = (type(entry.name) == 'table') and entry.name or { entry.name }
            for _, line in ipairs(names) do
                entry.name_parsed[#entry.name_parsed + 1] = loc_parse_string(line)
            end
        else
            entry.name_parsed = entry.name_parsed or {}
        end
    else
        entry.text_parsed = entry.text_parsed or {}
        entry.name_parsed = entry.name_parsed or {}
    end
end

-- Check if current selected deck matches target key
local function is_deck_matching(target_key)
    if not target_key then return false end
    local ok, res = pcall(function()
        if CardSleeves and CardSleeves.Sleeve and CardSleeves.Sleeve.get_current_deck_key then
            local current = CardSleeves.Sleeve.get_current_deck_key() or ""
            current = tostring(current)
            if current == target_key
                or current == "b_" .. target_key
                or current == "b_Crackedlatro_" .. target_key
                or string.find(current, target_key, 1, true) ~= nil then
                return true
            end
        end
        if CardSleeves and CardSleeves.current_deck then
            local current = tostring(CardSleeves.current_deck)
            if string.find(current, target_key, 1, true) ~= nil then
                return true
            end
        end
        if G and G.GAME then
            local b = G.GAME.selected_back or G.GAME.viewed_back
            if b then
                local k = b.name or (b.effect and b.effect.center and b.effect.center.key) or b.key or ""
                k = tostring(k)
                if k == target_key or string.find(k, target_key, 1, true) ~= nil then
                    return true
                end
            end
        end
        if G and G.deck and G.deck.name then
            local d = tostring(G.deck.name)
            if string.find(d, target_key, 1, true) ~= nil then
                return true
            end
        end
        return false
    end)
    return ok and res or false
end

-- Inject localization for Sleeves into G.localization.descriptions.Sleeve
local function inject_sleeve_localization()
    if not (G.localization and G.localization.descriptions) then return end
    G.localization.descriptions.Sleeve = G.localization.descriptions.Sleeve or {}

    local is_es = (G.SETTINGS and (G.SETTINGS.language == 'es' or G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')) or (G.CRACKEDLATRO_SPANISH == true)

    local sleeve_locs = {
        -- 1. Friendly Sleeve
        friendly = {
            name = is_es and "Funda Amistosa" or "Friendly Sleeve",
            text = is_es and {
                "Inicia la partida con {C:attention}1 Joker Negativo Eterno{} aleatorio",
                "{C:inactive}(Excepto Legendario o Secreto){},",
                "{C:red}-1{} Descarte"
            } or {
                "Start run with {C:attention}1 random Negative Eternal Joker{},",
                "{C:inactive}(Except Legendary or Secret){},",
                "{C:red}-1{} Discard"
            }
        },
        friendly_alt = {
            name = is_es and "Funda Amistosa (Fusión)" or "Friendly Sleeve (Fusion)",
            text = is_es and {
                "{C:attention}Fusión Amistosa{}: Genera {C:attention}3 Jokers Negativos Eternos{},",
                "con posibilidad de hasta {C:legendary}1 Joker Legendario{},",
                "pierdes {C:red}-2{} Espacios de Joker y {C:red}-1{} Descarte"
            } or {
                "{C:attention}Friendly Fusion{}: Spawns {C:attention}3 Negative Eternal Jokers{},",
                "with a maximum of {C:legendary}1 Legendary Joker{},",
                "lose {C:red}-2{} Joker slots and {C:red}-1{} Discard"
            }
        },

        -- 2. Caveman Sleeve
        cavernicola = {
            name = is_es and "Funda Cavernícola" or "Caveman Sleeve",
            text = is_es and {
                "Todas las {C:attention}Figuras{} iniciales (J, Q, K)",
                "se convierten en {C:attention}Cartas de Piedra{},",
                "{C:blue}+1{} Mano"
            } or {
                "All starting {C:attention}Face Cards{} (J, Q, K)",
                "become {C:attention}Stone Cards{},",
                "{C:blue}+1{} Hand"
            }
        },
        cavernicola_alt = {
            name = is_es and "Funda Cavernícola (Fusión)" or "Caveman Sleeve (Fusion)",
            text = is_es and {
                "{C:attention}Fusión Prehistórica{}: Todas las {C:attention}Cartas de Piedra{}",
                "iniciales reciben un {C:chips}Sello de Plata{},",
                "las Cartas de Piedra otorgan {C:mult}+3{} Mult y {C:chips}+20{} Fichas al anotar,",
                "{C:blue}+1{} Mano"
            } or {
                "{C:attention}Prehistoric Fusion{}: All starting {C:attention}Stone Cards{}",
                "receive a {C:chips}Silver Seal{},",
                "Stone Cards grant {C:mult}+3{} Mult and {C:chips}+20{} Chips when scored,",
                "{C:blue}+1{} Hand"
            }
        },

        -- 3. Strategist Sleeve
        strategist = {
            name = is_es and "Funda Estratega" or "Strategist Sleeve",
            text = is_es and {
                "Inicia con el vale {C:attention}Truco de Magia{},",
                "Inicia con {C:money}$5{}, {C:red}-1{} Descarte"
            } or {
                "Start with {C:attention}Magic Trick{} voucher,",
                "Start with {C:money}$5{}, {C:red}-1{} Discard"
            }
        },
        strategist_alt = {
            name = is_es and "Funda Estratega (Fusión)" or "Strategist Sleeve (Fusion)",
            text = is_es and {
                "{C:attention}Fusión Estratégica{}: Mazo inicial condensado a {C:attention}20 cartas{} (10 al As),",
                "Inicia con los vales {C:attention}Truco de Magia{} y {C:attention}Mercader de Tarot{},",
                "{C:attention}+1{} Espacio de carta en tienda, manos jugadas dan {C:money}+$1{}"
            } or {
                "{C:attention}Grandmaster Fusion{}: Starting deck condensed to {C:attention}20 cards{} (10s through Aces),",
                "Start with {C:attention}Magic Trick{} and {C:attention}Tarot Merchant{} vouchers,",
                "{C:attention}+1{} Shop card slot, played hands grant {C:money}+$1{}"
            }
        },

        -- 4. Overseer Sleeve
        overseer = {
            name = is_es and "Funda Supervisora" or "Overseer Sleeve",
            text = is_es and {
                "Las {C:attention}Etiquetas se duplican{} siempre,",
                "Vencer una Ciega Jefe crea una carta {C:spectral}Espectral{} aleatoria"
            } or {
                "{C:attention}Tags are always doubled{},",
                "Defeating a Boss Blind creates a random {C:spectral}Spectral card{}"
            }
        },
        overseer_alt = {
            name = is_es and "Funda Supervisora (Fusión)" or "Overseer Sleeve (Fusion)",
            text = is_es and {
                "{C:attention}Fusión Supervisora{}: Crea {C:spectral}2 cartas Espectrales{} al final de ronda,",
                "Las Etiquetas se {C:attention}triplican{} (X3),",
                "Elimina el sobrecoste de Jokers, inicia con {C:money}+$5{} y {C:blue}+1{} Mano"
            } or {
                "{C:attention}Omniscient Fusion{}: Creates {C:spectral}2 random Spectral cards{} at end of round,",
                "Tags are {C:attention}tripled{} (X3),",
                "Removes the Joker price markup penalty, start with {C:money}+$5{} and {C:blue}+1{} Hand"
            }
        }
    }

    for key, data in pairs(sleeve_locs) do
        -- Register with multiple possible prefix patterns so SMODS/CardSleeves always finds it
        local keys_to_set = {
            "sleeve_" .. key,
            "sleeve_Crackedlatro_" .. key,
            key,
            "Crackedlatro_" .. key
        }
        for _, k in ipairs(keys_to_set) do
            local entry = G.localization.descriptions.Sleeve[k] or {}
            entry.name = data.name
            entry.text = copy_table(data.text)
            reparse_sleeve_entry(entry)
            G.localization.descriptions.Sleeve[k] = entry

            if SMODS and SMODS.process_loc_text then
                pcall(function()
                    SMODS.process_loc_text(G.localization.descriptions.Sleeve, k, {
                        name = data.name,
                        text = data.text
                    })
                end)
            end
        end
    end

    -- Safeguard all entries in G.localization.descriptions.Sleeve
    for _, s_entry in pairs(G.localization.descriptions.Sleeve) do
        if type(s_entry) == 'table' then
            if not s_entry.text_parsed then reparse_sleeve_entry(s_entry) end
        end
    end

    -- Metatable protection so no nil text_parsed can EVER occur
    local sleeve_mt = getmetatable(G.localization.descriptions.Sleeve) or {}
    local orig_index = sleeve_mt.__index
    sleeve_mt.__index = function(t, k)
        local val = rawget(t, k)
        if val == nil and type(orig_index) == 'function' then
            val = orig_index(t, k)
        elseif val == nil and type(orig_index) == 'table' then
            val = orig_index[k]
        end
        if type(val) == 'table' then
            if not val.text_parsed then val.text_parsed = {} end
            if not val.name_parsed then val.name_parsed = {} end
        end
        return val
    end
    setmetatable(G.localization.descriptions.Sleeve, sleeve_mt)
end

-- Register CardSleeves objects
local registered_sleeves = false
function register_cracklatro_sleeves()
    if registered_sleeves then return end
    if not (CardSleeves and CardSleeves.Sleeve) then return end
    registered_sleeves = true

    inject_sleeve_localization()

    -- 1. Friendly Sleeve
    CardSleeves.Sleeve {
        key = "friendly",
        name = "Friendly Sleeve",
        atlas = "cracklatro_sleeves",
        pos = { x = 3, y = 0 },
        config = {},
        unlocked = true,
        discovered = true,
        loc_txt = {
            name = "Friendly Sleeve",
            text = {
                "Start run with {C:attention}1 random Negative Eternal Joker{},",
                "{C:inactive}(Except Legendary or Secret){},",
                "{C:red}-1{} Discard"
            }
        },
        loc_vars = function(self, info_queue, card)
            local is_combo = is_deck_matching("friendly")
            local key = is_combo and (self.key .. "_alt") or self.key
            return { key = key, vars = {} }
        end,
        apply = function(self, sleeve)
            G.GAME.friendly_sleeve_selected = true
            local is_combo = is_deck_matching("friendly")
            if is_combo then
                G.GAME.friendly_sleeve_combo = true
                -- Handled cooperatively with Friendly Deck apply in decks.lua
            else
                -- Standalone Friendly Sleeve: -1 Discard, +1 Negative Eternal Joker
                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                ease_discard(-1)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        play_sound('foil1')
                        local rarity_roll = pseudorandom('friendly_sleeve_rarity')
                        local rarity = (rarity_roll > 0.95 and 3) or (rarity_roll > 0.70 and 2) or 1
                        local new_joker = create_card('Joker', G.jokers, false, rarity, nil, false, nil, 'friendly_sleeve')
                        if is_secret_card(new_joker) then
                            if new_joker.area then new_joker.area:remove_card(new_joker) end
                            new_joker:remove()
                            new_joker = create_card('Joker', G.jokers, false, 1, nil, false, nil, 'friendly_sleeve_fallback')
                        end
                        new_joker:set_eternal(true)
                        if new_joker.ability then new_joker.ability.eternal = true end
                        new_joker:set_edition({ negative = true }, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
            end
        end
    }

    -- 2. Caveman Sleeve
    CardSleeves.Sleeve {
        key = "cavernicola",
        name = "Caveman Sleeve",
        atlas = "cracklatro_sleeves",
        pos = { x = 0, y = 0 },
        config = {},
        unlocked = true,
        discovered = true,
        loc_txt = {
            name = "Caveman Sleeve",
            text = {
                "All starting {C:attention}Face Cards{} (J, Q, K)",
                "become {C:attention}Stone Cards{},",
                "{C:blue}+1{} Hand"
            }
        },
        loc_vars = function(self, info_queue, card)
            local is_combo = is_deck_matching("cavernicola")
            local key = is_combo and (self.key .. "_alt") or self.key
            return { key = key, vars = {} }
        end,
        apply = function(self, sleeve)
            G.GAME.cavernicola_sleeve_selected = true
            local is_combo = is_deck_matching("cavernicola")
            if is_combo then
                G.GAME.cavernicola_sleeve_combo = true
                -- Offset -1 Hand penalty from Caveman Deck
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if G.playing_cards then
                            local silver_seal_key = (G.P_SEALS and G.P_SEALS['Crackedlatro_silver'] and 'Crackedlatro_silver') or 'silver'
                            for _, card in ipairs(G.playing_cards) do
                                if card.ability and (card.ability.name == 'Stone Card' or card.ability.effect == 'Stone Card') then
                                    card:set_seal(silver_seal_key, nil, true)
                                    card:juice_up(0.2, 0.2)
                                end
                            end
                        end
                        return true
                    end
                }))
            else
                -- Standalone Caveman Sleeve: face cards become stone cards, +1 hand
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        if G.playing_cards then
                            for _, card in ipairs(G.playing_cards) do
                                if card:is_face() then
                                    card:set_ability(G.P_CENTERS.m_stone)
                                    card:juice_up(0.2, 0.2)
                                end
                            end
                        end
                        return true
                    end
                }))
            end
        end,
        calculate = function(self, sleeve, context)
            if G.GAME and G.GAME.cavernicola_sleeve_combo then
                if context.cardarea == G.play and context.individual and context.other_card then
                    if context.other_card.ability and (context.other_card.ability.name == 'Stone Card' or context.other_card.ability.effect == 'Stone Card') then
                        return {
                            mult = 3,
                            chips = 20,
                            card = context.other_card
                        }
                    end
                end
            end
        end
    }

    -- 3. Strategist Sleeve
    CardSleeves.Sleeve {
        key = "strategist",
        name = "Strategist Sleeve",
        atlas = "cracklatro_sleeves",
        pos = { x = 1, y = 0 },
        config = {},
        unlocked = true,
        discovered = true,
        loc_txt = {
            name = "Strategist Sleeve",
            text = {
                "Start with {C:attention}Magic Trick{} voucher,",
                "Start with {C:money}$5{}, {C:red}-1{} Discard"
            }
        },
        loc_vars = function(self, info_queue, card)
            local is_combo = is_deck_matching("strategist")
            local key = is_combo and (self.key .. "_alt") or self.key
            return { key = key, vars = {} }
        end,
        apply = function(self, sleeve)
            G.GAME.strategist_sleeve_selected = true
            local is_combo = is_deck_matching("strategist")
            if is_combo then
                G.GAME.strategist_sleeve_combo = true
                -- Condense starting deck further: remove 9s as well (leaving exactly 20 cards: 10, J, Q, K, A)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        if G.playing_cards then
                            for i = #G.playing_cards, 1, -1 do
                                local card = G.playing_cards[i]
                                local val = card.base and card.base.value
                                if val == '9' then
                                    if card.area then card.area:remove_card(card) end
                                    card:remove()
                                    table.remove(G.playing_cards, i)
                                end
                            end
                        end
                        return true
                    end
                }))

                -- Start with Tarot Merchant voucher
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                G.GAME.used_vouchers['v_tarot_merchant'] = true

                -- +1 Shop card slot
                if G.GAME.shop then
                    G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
                end

                -- Played hands grant +$1
                G.GAME.modifiers = G.GAME.modifiers or {}
                G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) + 1
            else
                -- Standalone Strategist Sleeve: Magic Trick voucher, +$5, -1 Discard
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                G.GAME.used_vouchers['v_magic_trick'] = true
                ease_dollars(5)
                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                ease_discard(-1)
            end
        end
    }

    -- 4. Overseer Sleeve
    CardSleeves.Sleeve {
        key = "overseer",
        name = "Overseer Sleeve",
        atlas = "cracklatro_sleeves",
        pos = { x = 2, y = 0 },
        config = {},
        unlocked = true,
        discovered = true,
        loc_txt = {
            name = "Overseer Sleeve",
            text = {
                "{C:attention}Tags are always doubled{},",
                "Defeating a Boss Blind creates a random {C:spectral}Spectral card{}"
            }
        },
        loc_vars = function(self, info_queue, card)
            local is_combo = is_deck_matching("overseer")
            local key = is_combo and (self.key .. "_alt") or self.key
            return { key = key, vars = {} }
        end,
        apply = function(self, sleeve)
            G.GAME.overseer_sleeve_selected = true
            local is_combo = is_deck_matching("overseer")
            if is_combo then
                G.GAME.overseer_sleeve_combo = true
                G.GAME.overseer_no_markup = true
                -- Offset -1 Hand penalty and add +$5
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)
                ease_dollars(5)
            else
                -- Standalone Overseer Sleeve: tags are doubled
                G.GAME.overseer_sleeve_active = true
            end
        end,
        calculate = function(self, sleeve, context)
            local is_combo = G.GAME and G.GAME.overseer_sleeve_combo
            if is_combo then
                -- Combo effect: 2 Spectrals at end of round
                if context.end_of_round and not context.individual and not context.repetition then
                    for i = 1, 2 do
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
                                    local chosen_key = (#valid_spectrals > 0) and pseudorandom_element(valid_spectrals, pseudoseed('overseer_sleeve_combo_' .. i)) or 'c_ankh'
                                    local scard = create_card('Spectral', G.consumeables, nil, nil, nil, nil, chosen_key, 'overseer_combo')
                                    scard:add_to_deck()
                                    G.consumeables:emplace(scard)
                                    scard:juice_up(0.5, 0.5)
                                    return true
                                end
                            }))
                        end
                    end
                end
            else
                -- Standalone Overseer Sleeve: Defeating a Boss Blind creates a random Spectral card
                if context.end_of_round and G.GAME and G.GAME.blind and G.GAME.blind.boss and not context.individual and not context.repetition then
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
                                local chosen_key = (#valid_spectrals > 0) and pseudorandom_element(valid_spectrals, pseudoseed('overseer_sleeve_boss')) or 'c_ankh'
                                local scard = create_card('Spectral', G.consumeables, nil, nil, nil, nil, chosen_key, 'overseer_boss')
                                scard:add_to_deck()
                                G.consumeables:emplace(scard)
                                scard:juice_up(0.5, 0.5)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    }
end

-- Try initial registration
if CardSleeves and CardSleeves.Sleeve then
    register_cracklatro_sleeves()
end

-- Hook init_localization to ensure sleeves are registered and translated
local orig_init_loc_sleeves = init_localization
function init_localization()
    if orig_init_loc_sleeves then orig_init_loc_sleeves() end
    if CardSleeves and CardSleeves.Sleeve then
        register_cracklatro_sleeves()
    end
    inject_sleeve_localization()
end

-- Hook Game:start_run to ensure sleeve registrations and localization are fresh
local orig_game_start_run = Game.start_run
function Game:start_run(args)
    if CardSleeves and CardSleeves.Sleeve and not registered_sleeves then
        register_cracklatro_sleeves()
    end
    inject_sleeve_localization()
    return orig_game_start_run(self, args)
end

-- Defensive hook for Card.hover to guarantee sleeve entries have text_parsed
if Card and Card.hover then
    local orig_card_hover = Card.hover
    function Card:hover()
        if G.localization and G.localization.descriptions and G.localization.descriptions.Sleeve then
            for _, s_entry in pairs(G.localization.descriptions.Sleeve) do
                if type(s_entry) == 'table' and not s_entry.text_parsed then
                    reparse_sleeve_entry(s_entry)
                end
            end
        end
        return orig_card_hover(self)
    end
end
