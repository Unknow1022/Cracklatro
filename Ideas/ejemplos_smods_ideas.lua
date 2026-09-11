--- ==============================================================================
--- PROTOTIPOS SMODS: EJEMPLOS DE IMPLEMENTACIÓN DE IDEAS
--- ==============================================================================
--- Este archivo contiene plantillas y ejemplos de código funcionales en Lua
--- para la API de Steamodded (SMODS) de varias de las mecánicas propuestas
--- en el catálogo "50_JOKERS_CONCEPTOS.md".
--- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. Origami Joker (Joker Papiroflexia) - Geometría de Extremos y Centro
-- ------------------------------------------------------------------------------
SMODS.Joker {
    key = 'origami_joker',
    loc_txt = {
        name = 'Origami Joker',
        text = {
            "If the center card's rank equals the",
            "{C:attention}sum of the two outer cards'{} ranks,",
            "gives {X:mult,C:white}X#1#{} Mult and permanently adds",
            "their combined chips to the center card"
        }
    },
    config = { extra = { xmult = 3.2 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card.ability and card.ability.extra and card.ability.extra.xmult) or 3.2 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand and #context.scoring_hand >= 3 then
            local hand = context.scoring_hand
            local first_card = hand[1]
            local last_card = hand[#hand]
            local center_index = math.floor(#hand / 2) + 1
            local center_card = hand[center_index]

            if first_card and last_card and center_card then
                local first_val = first_card:get_id()
                local last_val = last_card:get_id()
                local center_val = center_card:get_id()

                if center_val == (first_val + last_val) then
                    -- Añadir fichas base permanentes a la carta central
                    local bonus = (first_card.base.nominal or 0) + (last_card.base.nominal or 0)
                    center_card.ability.perma_bonus = (center_card.ability.perma_bonus or 0) + bonus

                    return {
                        message = 'Origami Fold!',
                        colour = G.C.MULT,
                        Xmult_mod = card.ability.extra.xmult
                    }
                end
            end
        end
    end
}

-- ------------------------------------------------------------------------------
-- 3. Pendulum (El Péndulo) - Alternancia Rítmica Par/Impar de Manos
-- ------------------------------------------------------------------------------
SMODS.Joker {
    key = 'pendulum_joker',
    loc_txt = {
        name = 'The Pendulum',
        text = {
            "Oscillates on each played hand:",
            "Odd hands give {C:chips}+#1#{} Chips",
            "Even hands give {X:mult,C:white}X#2#{} Mult",
            "{C:inactive}(Current: #3#){}"
        }
    },
    config = { extra = { chips = 160, xmult = 2.5, swing = 1 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra
        local current_side = (extra.swing % 2 == 1) and "Odd (Chips)" or "Even (XMult)"
        return { vars = { extra.chips, extra.xmult, current_side } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local is_odd = (card.ability.extra.swing % 2 == 1)
            card.ability.extra.swing = card.ability.extra.swing + 1

            if is_odd then
                return {
                    message = '+' .. card.ability.extra.chips .. ' Chips!',
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips
                }
            else
                return {
                    message = 'X' .. card.ability.extra.xmult .. ' Mult!',
                    colour = G.C.MULT,
                    Xmult_mod = card.ability.extra.xmult
                }
            end
        end
    end
}

-- ------------------------------------------------------------------------------
-- 5. Acoustic Wave (Onda Sonora) - Amplitud Cuadrática de Rangos
-- ------------------------------------------------------------------------------
SMODS.Joker {
    key = 'acoustic_wave',
    loc_txt = {
        name = 'Acoustic Wave',
        text = {
            "Gains {C:mult}+Mult{} equal to the {C:attention}rank amplitude{}",
            "(Max rank - Min rank) squared in the scoring hand",
            "{C:inactive}(Currently gives up to {C:mult}+144{C:inactive} Mult){}"
        }
    },
    config = { extra = {} },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand and #context.scoring_hand > 1 then
            local min_val = 999
            local max_val = -999
            for _, c in ipairs(context.scoring_hand) do
                local id = c:get_id()
                if id and id > 0 then
                    if id < min_val then min_val = id end
                    if id > max_val then max_val = id end
                end
            end

            if max_val >= min_val and min_val ~= 999 then
                local amplitude = max_val - min_val
                local mult_add = amplitude * amplitude
                if mult_add > 0 then
                    return {
                        message = '+' .. mult_add .. ' Mult (Amp ' .. amplitude .. ')',
                        colour = G.C.MULT,
                        mult_mod = mult_add
                    }
                end
            end
        end
    end
}

-- ------------------------------------------------------------------------------
-- 49. Stage Magician (Mago de Escenario) - Consumibles Vacíos
-- ------------------------------------------------------------------------------
SMODS.Joker {
    key = 'stage_magician',
    loc_txt = {
        name = 'Stage Magician',
        text = {
            "If your consumable slots are {C:attention}completely empty{},",
            "all played cards have their {C:attention}enhancements and seals{}",
            "retriggered an additional time"
        }
    },
    config = { extra = { retriggers = 1 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            -- Verificar si el área de consumibles está vacía
            local empty = true
            if G.consumeables and G.consumeables.cards and #G.consumeables.cards > 0 then
                empty = false
            end

            if empty and context.other_card then
                -- Si la carta tiene alguna mejora, sello o edición
                local has_trait = context.other_card.seal or 
                                  context.other_card.edition or 
                                  (context.other_card.ability and context.other_card.ability.effect and context.other_card.ability.effect ~= 'Base')
                if has_trait then
                    return {
                        message = 'Prestidigitation!',
                        repetitions = 1,
                        card = card
                    }
                end
            end
        end
    end
}
