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

-- Seal: Dark Green Seal
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
    loc_txt = {
        name = 'Dark Green Seal',
        label = 'Dark Green Seal',
        text = {
            "{C:green}#1# in 10{} chance to retrigger {C:attention}3 times{},",
            "{C:green}#1# in 5{} chance to retrigger {C:attention}2 times{},",
            "or {C:green}#1# in 2{} chance to retrigger {C:attention}1 time{}",
            "{C:inactive}(Non-cumulative){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local norm = (G.GAME and G.GAME.probabilities.normal or 1)
            if pseudorandom('dark_green_3') < (norm / 10) then
                return {
                    message = 'x3 Retrigger!',
                    repetitions = 3,
                    card = card
                }
            elseif pseudorandom('dark_green_2') < (norm / 5) then
                return {
                    message = 'x2 Retrigger!',
                    repetitions = 2,
                    card = card
                }
            elseif pseudorandom('dark_green_1') < (norm / 2) then
                return {
                    message = 'x1 Retrigger!',
                    repetitions = 1,
                    card = card
                }
            end
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
    config = { extra = { x_mult = 1.5, dollars = 5 }, h_dollars = 5 },
    loc_txt = {
        name = 'Diamond Card',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult when {C:attention}retriggered{},",
            "gives {C:money}$#2#{} when held in hand"
        }
    },
    loc_vars = function(self, info_queue, card)
        local x_mult = (card and card.ability and card.ability.extra and card.ability.extra.x_mult) or (self.config and self.config.extra and self.config.extra.x_mult) or 1.5
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 5
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
    config = { extra = { interest_pct = 10, max_interest = 6 } },
    loc_txt = {
        name = 'Investment Card',
        text = {
            "Earns {C:money}#1#% interest{} on your current money",
            "{C:inactive}(Max {C:money}$#2#{C:inactive}){} when held in hand at end of round"
        }
    },
    loc_vars = function(self, info_queue, card)
        local interest_pct = (card and card.ability and card.ability.extra and card.ability.extra.interest_pct) or (self.config and self.config.extra and self.config.extra.interest_pct) or 10
        local max_interest = (card and card.ability and card.ability.extra and card.ability.extra.max_interest) or (self.config and self.config.extra and self.config.extra.max_interest) or 6
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
    config = { extra = { x_mult = 1.1, dollars = 1 } },
    loc_txt = {
        name = 'Jeweled Card',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult and {C:money}$#2#{}",
            "when scored if suit is {C:diamonds}Diamonds{} or {C:hearts}Hearts{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local x_mult = (card and card.ability and card.ability.extra and card.ability.extra.x_mult) or (self.config and self.config.extra and self.config.extra.x_mult) or 1.1
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 1
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
