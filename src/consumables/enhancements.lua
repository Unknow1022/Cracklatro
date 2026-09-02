-- Enhancements & Custom Seals

-- Helper functions for Custom Enhancement Centers
function get_diamond_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Crackedlatro_diamond'] then return G.P_CENTERS['m_Crackedlatro_diamond'] end
        if G.P_CENTERS['m_diamond'] then return G.P_CENTERS['m_diamond'] end
        for k, v in pairs(G.P_CENTERS) do
            if type(v) == 'table' and string.find(k, 'diamond') and v.set == 'Enhanced' then
                return v
            end
        end
    end
    return G.P_CENTERS.m_steel
end

function get_investment_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Crackedlatro_investment'] then return G.P_CENTERS['m_Crackedlatro_investment'] end
        if G.P_CENTERS['m_investment'] then return G.P_CENTERS['m_investment'] end
        for k, v in pairs(G.P_CENTERS) do
            if type(v) == 'table' and string.find(k, 'investment') and v.set == 'Enhanced' then
                return v
            end
        end
    end
    return G.P_CENTERS.m_gold
end

function get_lead_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Crackedlatro_lead'] then return G.P_CENTERS['m_Crackedlatro_lead'] end
        if G.P_CENTERS['m_lead'] then return G.P_CENTERS['m_lead'] end
        for k, v in pairs(G.P_CENTERS) do
            if type(v) == 'table' and string.find(k, 'lead') and v.set == 'Enhanced' then
                return v
            end
        end
    end
    return G.P_CENTERS.m_steel
end

function get_jeweled_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Crackedlatro_jeweled'] then return G.P_CENTERS['m_Crackedlatro_jeweled'] end
        if G.P_CENTERS['m_jeweled'] then return G.P_CENTERS['m_jeweled'] end
        for k, v in pairs(G.P_CENTERS) do
            if type(v) == 'table' and string.find(k, 'jeweled') and v.set == 'Enhanced' then
                return v
            end
        end
    end
    return G.P_CENTERS.m_lucky
end

-- Seal 1: Dark Green Seal (Reworked)
SMODS.Atlas {
    key = "s_dark_green",
    path = "s_dark_green.png",
    px = 71,
    py = 95
}

SMODS.Seal {
    key = 'dark_green',
    atlas = 's_dark_green',
    pos = { x = 0, y = 0 },
    badge_colour = HEX('1b4d2e'),
    discovered = true,
    unlocked = true,
    loc_txt = {
        name = 'Dark Green Seal',
        label = 'Dark Green Seal',
        text = {
            "Gives {X:mult,C:white}X2.5{} Mult when scored,",
            "{C:green}#1# in 5{} chance to break",
            "when played"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            local prob = (G.GAME and G.GAME.probabilities.normal or 1)
            if pseudorandom('dark_green_break') < (prob / 5) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card:shatter()
                        return true
                    end
                }))
            end
            return {
                x_mult = 2.5
            }
        end
    end
}

-- Seal 2: White Seal
SMODS.Atlas {
    key = "s_white",
    path = "s_white.png",
    px = 71,
    py = 95
}

SMODS.Seal {
    key = 'white',
    atlas = 's_white',
    pos = { x = 0, y = 0 },
    badge_colour = HEX('ffffff'),
    discovered = true,
    unlocked = true,
    loc_txt = {
        name = 'White Seal',
        label = 'White Seal',
        text = {
            "Upgrades a random {C:attention}poker hand{}",
            "by {C:attention}+1 level{} when scored",
            "{C:inactive}(Once per round){}"
        }
    },
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            if not card.ability.white_seal_triggered then
                card.ability.white_seal_triggered = true
                local hands = {}
                if G.GAME and G.GAME.hands then
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then
                            table.insert(hands, k)
                        end
                    end
                    if #hands == 0 then
                        for k, v in pairs(G.GAME.hands) do
                            table.insert(hands, k)
                        end
                    end
                end
                local chosen_hand = pseudorandom_element(hands, pseudoseed('white_seal_hand')) or 'High Card'
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname = chosen_hand, level = (G.GAME.hands[chosen_hand] and G.GAME.hands[chosen_hand].level or 1) + 1})
                        level_up_hand(card, chosen_hand, false, 1)
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Level Up!', colour = G.C.SECONDARY_SET.Planet })
                        return true
                    end
                }))
            end
        end
        if context.end_of_round and card.ability then
            card.ability.white_seal_triggered = nil
        end
    end
}

-- Seal 3: Silver Seal
SMODS.Atlas {
    key = "s_silver",
    path = "s_silver.png",
    px = 71,
    py = 95
}

SMODS.Seal {
    key = 'silver',
    atlas = 's_silver',
    pos = { x = 0, y = 0 },
    badge_colour = HEX('bdc3c7'),
    discovered = true,
    unlocked = true,
    loc_txt = {
        name = 'Silver Seal',
        label = 'Silver Seal',
        text = {
            "Enhances a random card from the",
            "played hand into a {C:gold}Gold{},",
            "{C:attention}Steel{}, or {C:attention}Diamond Card{}",
            "when played and scored"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
            info_queue[#info_queue + 1] = get_diamond_enhancement_center()
        end
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            if not card.ability.silver_seal_triggered then
                card.ability.silver_seal_triggered = true
                local eligible_cards = {}
                if G.play and G.play.cards then
                    for _, c in ipairs(G.play.cards) do
                        table.insert(eligible_cards, c)
                    end
                elseif context.scoring_hand then
                    for _, c in ipairs(context.scoring_hand) do
                        table.insert(eligible_cards, c)
                    end
                end
                if #eligible_cards > 0 then
                    local target_card = pseudorandom_element(eligible_cards, pseudoseed('silver_seal_target'))
                    local enh_choices = {
                        G.P_CENTERS.m_gold,
                        G.P_CENTERS.m_steel,
                        get_diamond_enhancement_center()
                    }
                    local chosen_enh = pseudorandom_element(enh_choices, pseudoseed('silver_seal_enh'))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            play_sound('gold_seal')
                            target_card:set_ability(chosen_enh)
                            target_card:juice_up(0.5, 0.5)
                            local enh_name = (chosen_enh == G.P_CENTERS.m_gold and 'Gold Card') or (chosen_enh == G.P_CENTERS.m_steel and 'Steel Card') or 'Diamond Card'
                            card_eval_status_text(target_card, 'extra', nil, nil, nil, { message = enh_name .. '!', colour = HEX('bdc3c7') })
                            return true
                        end
                    }))
                end
            end
        end
        if context.end_of_round and card.ability then
            card.ability.silver_seal_triggered = nil
        end
    end
}

-- Enhancement 1: Diamond Card
SMODS.Atlas {
    key = "m_diamond",
    path = "m_diamond.png",
    px = 71,
    py = 95
}

SMODS.Enhancement {
    key = 'diamond',
    atlas = 'm_diamond',
    pos = { x = 0, y = 0 },
    discovered = true,
    unlocked = true,
    config = { extra = { x_mult = 1.5, dollars = 3 }, h_dollars = 3 },
    loc_txt = {
        name = 'Diamond Card',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult when {C:attention}retriggered{},",
            "gives {C:money}$#2#{} when held in hand"
        }
    },
    loc_vars = function(self, info_queue, card)
        local x_mult = (card and card.ability and card.ability.extra and card.ability.extra.x_mult) or (self.config and self.config.extra and self.config.extra.x_mult) or 1.5
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 3
        return { vars = { x_mult, dollars } }
    end,
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            if context.repetition or context.repetition_only or (card.retrigger_count and card.retrigger_count > 0) then
                return {
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
        if context.end_of_round and context.cardarea == G.hand then
            ease_dollars(card.ability.extra.dollars)
            return {
                message = '+$' .. card.ability.extra.dollars,
                colour = G.C.MONEY
            }
        end
    end
}

-- Enhancement 2: Investment Card
SMODS.Atlas {
    key = "m_investment",
    path = "m_investment.png",
    px = 71,
    py = 95
}

SMODS.Enhancement {
    key = 'investment',
    atlas = 'm_investment',
    pos = { x = 0, y = 0 },
    discovered = true,
    unlocked = true,
    config = { extra = { interest_pct = 10, max_interest = 10 } },
    loc_txt = {
        name = 'Investment Card',
        text = {
            "Earns {C:money}#1#% interest{} on your current money",
            "{C:inactive}(Max {C:money}$#2#{C:inactive}){} when held in hand at end of round"
        }
    },
    loc_vars = function(self, info_queue, card)
        local interest_pct = (card and card.ability and card.ability.extra and card.ability.extra.interest_pct) or (self.config and self.config.extra and self.config.extra.interest_pct) or 10
        local max_interest = (card and card.ability and card.ability.extra and card.ability.extra.max_interest) or (self.config and self.config.extra and self.config.extra.max_interest) or 10
        return { vars = { interest_pct, max_interest } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.hand then
            local current_money = (G.GAME and G.GAME.dollars) or 0
            local interest = math.min(card.ability.extra.max_interest, math.floor(current_money * (card.ability.extra.interest_pct / 100)))
            if interest > 0 then
                ease_dollars(interest)
                return {
                    message = '+$' .. interest .. ' Interest',
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-- Enhancement 3: Lead Card
SMODS.Atlas {
    key = "m_lead",
    path = "m_lead.png",
    px = 71,
    py = 95
}

SMODS.Enhancement {
    key = 'lead',
    atlas = 'm_lead',
    pos = { x = 0, y = 0 },
    discovered = true,
    unlocked = true,
    config = { extra = { chips = 10 } },
    loc_txt = {
        name = 'Lead Card',
        text = {
            "{C:chips}+#1#{} Chips.",
            "Transmutes permanently into a {C:gold}Gold Card{}",
            "when scored in a round-winning hand"
        }
    },
    loc_vars = function(self, info_queue, card)
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips) or (self.config and self.config.extra and self.config.extra.chips) or 10
        return { vars = { chips } }
    end,
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

-- Enhancement 4: Jeweled Card
SMODS.Atlas {
    key = "m_jeweled",
    path = "m_jeweled.png",
    px = 71,
    py = 95
}

SMODS.Enhancement {
    key = 'jeweled',
    atlas = 'm_jeweled',
    pos = { x = 0, y = 0 },
    discovered = true,
    unlocked = true,
    config = { extra = { x_mult = 1.25, dollars = 2 } },
    loc_txt = {
        name = 'Jeweled Card',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult and {C:money}$#2#{}",
            "when scored if suit is {C:diamonds}Diamonds{} or {C:hearts}Hearts{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local x_mult = (card and card.ability and card.ability.extra and card.ability.extra.x_mult) or (self.config and self.config.extra and self.config.extra.x_mult) or 1.25
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 2
        return { vars = { x_mult, dollars } }
    end,
    calculate = function(self, card, context)
        if (context.main_scoring or context.individual) and context.cardarea == G.play then
            if card:is_suit('Diamonds') or card:is_suit('Hearts') then
                ease_dollars(card.ability.extra.dollars)
                return {
                    x_mult = card.ability.extra.x_mult,
                    dollars = card.ability.extra.dollars,
                    card = card
                }
            end
        end
    end
}
