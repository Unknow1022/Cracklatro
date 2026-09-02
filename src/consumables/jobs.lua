-- Job Cards & Booster Packs

-- Consumable Type: Jobs
SMODS.ConsumableType {
    key = 'Job',
    primary_colour = HEX('5c1e11'),
    secondary_colour = HEX('3d1a14'),
    loc_txt = {
        name = 'Job',
        collection = 'Job Cards',
        underscores_single = 'Job Card',
        underscores_plural = 'Job Cards'
    },
    shop_rate = 0.0,
    collection_rows = { 2, 6 },
    default = 'c_Crackedlatro_minero_job'
}

local JOB_CARD_KEYS = {
    'c_Crackedlatro_minero_job',
    'c_Crackedlatro_gardener_job',
    'c_Crackedlatro_banker_job',
    'c_Crackedlatro_surgeon_job',
    'c_Crackedlatro_alchemist_job',
    'c_Crackedlatro_butcher_job',
    'c_Crackedlatro_detective_job',
    'c_Crackedlatro_chef_job',
    'c_Crackedlatro_archaeologist_job',
    'c_Crackedlatro_jeweler_job'
}

local function create_job_card_for_pack(key_append)
    local card_obj = nil
    if create_card then
        card_obj = create_card('Job', G.pack_cards, nil, nil, true, false, nil, key_append or 'job_pack')
    end
    if (not card_obj or not card_obj.config) and SMODS and SMODS.create_card then
        card_obj = SMODS.create_card({ set = 'Job', area = G.pack_cards, skip_materialize = true, key_append = key_append or 'job_pack' })
    end
    if not card_obj or not card_obj.config then
        local valid_keys = {}
        for _, k in ipairs(JOB_CARD_KEYS) do
            if G.P_CENTERS and G.P_CENTERS[k] then
                table.insert(valid_keys, k)
            end
        end
        local chosen_key = (#valid_keys > 0) and pseudorandom_element(valid_keys, pseudoseed(key_append or 'job_pack_valid')) or pseudorandom_element(JOB_CARD_KEYS, pseudoseed(key_append or 'job_pack_fallback'))
        local center = (G.P_CENTERS and G.P_CENTERS[chosen_key]) or (G.P_CENTERS and G.P_CENTERS[string.gsub(chosen_key, 'c_Crackedlatro_', 'c_')])
        if center then
            card_obj = Card(G.pack_cards.T.x + G.pack_cards.T.w/2, G.pack_cards.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        end
    end
    return card_obj
end

-- Job Consumable 1: The Miner
SMODS.Atlas {
    key = "c_minero",
    path = "c_minero.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'minero_job',
    set = 'Job',
    atlas = 'c_minero',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Miner',
        text = {
            "Enhances {C:attention}1 selected card{}",
            "into a {C:attention}Diamond Card{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = get_diamond_enhancement_center()
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
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
                local center = get_diamond_enhancement_center()
                target:set_ability(center)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Diamond Card!', colour = HEX('1b4d2e') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 2: The Gardener
SMODS.Atlas {
    key = "c_gardener",
    path = "c_gardener.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'gardener_job',
    set = 'Job',
    atlas = 'c_gardener',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Gardener',
        text = {
            "Assigns Gardener job to {C:attention}1 selected card{}.",
            "When discarded, permanently adds {C:chips}+2{} extra",
            "Chips to all cards of its suit in your full deck"
        }
    },
    in_pool = function(self, args)
        return true
    end,
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
                target.ability = target.ability or {}
                target.ability.gardener_job = true
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Gardener Hired!', colour = HEX('27ae60') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 3: The Banker
SMODS.Atlas {
    key = "c_banker",
    path = "c_banker.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'banker_job',
    set = 'Job',
    atlas = 'c_banker',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Banker',
        text = {
            "Enhances {C:attention}1 selected card{}",
            "into an {C:attention}Investment Card{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = get_investment_enhancement_center()
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('gold_seal')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local center = get_investment_enhancement_center()
                target:set_ability(center)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Investment Card!', colour = G.C.MONEY })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 4: The Surgeon
SMODS.Atlas {
    key = "c_surgeon",
    path = "c_surgeon.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'surgeon_job',
    set = 'Job',
    atlas = 'c_surgeon',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Surgeon',
        text = {
            "Destroys the {C:attention}1st selected card{} and",
            "transfers all its bonus Chips, Enhancement,",
            "Seal, and Edition to the {C:attention}2nd selected card{}"
        }
    },
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 2
    end,
    use = function(self, card, area, copier)
        local donor = G.hand.highlighted[1]
        local recipient = G.hand.highlighted[2]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2')
                card:juice_up(0.4, 0.6)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                local donor_bonus = (donor.ability and donor.ability.perma_bonus) or 0
                recipient.ability = recipient.ability or {}
                recipient.ability.perma_bonus = (recipient.ability.perma_bonus or 0) + donor_bonus

                if donor.config and donor.config.center and donor.config.center ~= G.P_CENTERS.c_base then
                    recipient:set_ability(donor.config.center)
                end

                if donor.seal then
                    recipient:set_seal(donor.seal, nil, true)
                end

                if donor.edition then
                    recipient:set_edition(donor.edition, true)
                end

                play_sound('tarot1')
                donor:start_dissolve()
                recipient:juice_up(0.6, 0.6)
                card_eval_status_text(recipient, 'extra', nil, nil, nil, { message = 'Transplanted!', colour = G.C.RED })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 5: The Alchemist
SMODS.Atlas {
    key = "c_alchemist",
    path = "c_alchemist.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'alchemist_job',
    set = 'Job',
    atlas = 'c_alchemist',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Alchemist',
        text = {
            "Enhances {C:attention}1 selected card{}",
            "into a {C:attention}Lead Card{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = get_lead_enhancement_center()
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
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
                local center = get_lead_enhancement_center()
                target:set_ability(center)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Lead Card!', colour = G.C.GREY })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 6: The Butcher
SMODS.Atlas {
    key = "c_butcher",
    path = "c_butcher.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'butcher_job',
    set = 'Job',
    atlas = 'c_butcher',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Butcher',
        text = {
            "Destroys {C:attention}1 selected card{} (Rank 3+)",
            "and creates {C:attention}2 cards{} dividing its rank",
            "{C:inactive}(if odd, one card has {C:attention}+1{C:inactive} rank){}",
            "with random {C:attention}Steel{}, {C:attention}Glass{}, {C:attention}Wild{}, or {C:attention}Lucky{} enhancements"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
            info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
            local id = G.hand.highlighted[1]:get_id()
            return id and id >= 3
        end
        return false
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        local original_suit = target.base and target.base.suit or 'Spades'
        local suit_prefix = string.sub(original_suit, 1, 1)
        local id = target:get_id() or 4
        local rank_strings = { [2]='2', [3]='3', [4]='4', [5]='5', [6]='6', [7]='7', [8]='8', [9]='9', [10]='10', [11]='J', [12]='Q', [13]='K', [14]='A' }
        local r1_num = math.max(2, math.floor(id / 2))
        local r2_num = math.max(2, (id % 2 == 0) and math.floor(id / 2) or (math.floor(id / 2) + 1))
        local rank_1_str = rank_strings[r1_num] or '2'
        local rank_2_str = rank_strings[r2_num] or '3'

        if G.hand then G.hand:unhighlight_all() end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot2')
                if card then card:juice_up(0.4, 0.6) end
                target.destroyed = true
                target:start_dissolve(nil, true)
                return true
            end
        }))

        local enhancements = { G.P_CENTERS.m_steel, G.P_CENTERS.m_glass, G.P_CENTERS.m_wild, G.P_CENTERS.m_lucky }
        for i = 1, 2 do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.25,
                func = function()
                    play_sound('tarot1')
                    local chosen_enh = pseudorandom_element(enhancements, pseudoseed('butcher_enh_' .. i))
                    local current_rank_str = (i == 1) and rank_1_str or rank_2_str
                    local new_card = create_playing_card({
                        front = G.P_CARDS[suit_prefix .. '_' .. current_rank_str] or G.P_CARDS['S_2'],
                        center = chosen_enh
                    }, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Enhanced})
                    new_card:juice_up(0.4, 0.4)
                    return true
                end
            }))
        end
    end
}

-- Job Consumable 7: The Detective
SMODS.Atlas {
    key = "c_detective",
    path = "c_detective.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'detective_job',
    set = 'Job',
    atlas = 'c_detective',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Detective',
        text = {
            "Assigns Detective job to {C:attention}1 selected card{}.",
            "When in opening hand at start of round,",
            "reveals the next 3 drawn cards and gives each",
            "a {C:gold}Gold Seal{} or {C:blue}Blue Seal{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            if G.P_SEALS and G.P_SEALS.Gold then
                info_queue[#info_queue + 1] = G.P_SEALS.Gold
            else
                info_queue[#info_queue + 1] = { key = 'gold_seal', set = 'Other' }
            end
            if G.P_SEALS and G.P_SEALS.Blue then
                info_queue[#info_queue + 1] = G.P_SEALS.Blue
            else
                info_queue[#info_queue + 1] = { key = 'blue_seal', set = 'Other' }
            end
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
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
                target.ability = target.ability or {}
                target.ability.detective_job = true
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Detective Hired!', colour = HEX('2980b9') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 8: The Chef
SMODS.Atlas {
    key = "c_chef",
    path = "c_chef.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'chef_job',
    set = 'Job',
    atlas = 'c_chef',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Chef',
        text = {
            "Assigns Chef job to {C:attention}1 selected face card{} (J, Q, K).",
            "When scored, turns all other scoring cards in the",
            "hand into {C:mult}Mult Cards{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1 and G.hand.highlighted[1]:is_face()
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
                target.ability = target.ability or {}
                target.ability.chef_job = true
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Chef Hired!', colour = HEX('e67e22') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 9: The Archaeologist
SMODS.Atlas {
    key = "c_archaeologist",
    path = "c_archaeologist.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'archaeologist_job',
    set = 'Job',
    atlas = 'c_archaeologist',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Archaeologist',
        text = {
            "Assigns Archaeologist job to {C:attention}1 selected card{}.",
            "When scored in your {C:attention}final hand{} of a round,",
            "recovers 1 discarded card and gives it a random",
            "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or {C:dark_edition}Polychrome{} edition"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
            info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
            info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
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
                target.ability = target.ability or {}
                target.ability.archaeologist_job = true
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Archaeologist Hired!', colour = HEX('d35400') })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Job Consumable 10: The Jeweler
SMODS.Atlas {
    key = "c_jeweler",
    path = "c_jeweler.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'jeweler_job',
    set = 'Job',
    atlas = 'c_jeweler',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'The Jeweler',
        text = {
            "Enhances {C:attention}1 selected card{}",
            "into a {C:attention}Jeweled Card{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = get_jeweled_enhancement_center()
        end
        return { vars = {} }
    end,
    in_pool = function(self, args)
        return true
    end,
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
                local center = get_jeweled_enhancement_center()
                target:set_ability(center)
                target:juice_up(0.5, 0.5)
                card_eval_status_text(target, 'extra', nil, nil, nil, { message = 'Jeweled Card!', colour = G.C.MULT })
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-- Booster Packs: Job Applications
SMODS.Atlas {
    key = "p_job_1",
    path = "p_job_1.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "p_job_2",
    path = "p_job_2.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "p_job_3",
    path = "p_job_3.png",
    px = 71,
    py = 95
}

SMODS.Booster {
    key = 'job_pack_1',
    atlas = 'p_job_1',
    pos = { x = 0, y = 0 },
    config = { extra = 3, choose = 1 },
    cost = 4,
    weight = 1.0,
    kind = 'Job',
    group_key = 'k_job_pack',
    draw_hand = true,
    loc_txt = {
        name = 'Job Application',
        group_name = 'Job Application',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2# Job cards{} to give",
            "a job to a card"
        }
    },
    loc_vars = function(self, info_queue, card)
        local choose = (card and card.ability and card.ability.choose) or (card and card.config and card.config.choose) or (self.config and self.config.choose) or 1
        local extra = (card and card.ability and card.ability.extra) or (card and card.config and card.config.extra) or (self.config and self.config.extra) or 3
        return { vars = { choose, extra } }
    end,
    create_card = function(self, card, i)
        return create_job_card_for_pack('job_pack')
    end,
    ease_background_colour = function(self)
        ease_job_pack_background()
    end
}

SMODS.Booster {
    key = 'job_pack_2',
    atlas = 'p_job_2',
    pos = { x = 0, y = 0 },
    config = { extra = 5, choose = 1 },
    cost = 6,
    weight = 0.5,
    kind = 'Job',
    group_key = 'k_job_pack',
    draw_hand = true,
    loc_txt = {
        name = 'Jumbo Job Application',
        group_name = 'Job Application',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2# Job cards{} to give",
            "a job to a card"
        }
    },
    loc_vars = function(self, info_queue, card)
        local choose = (card and card.ability and card.ability.choose) or (card and card.config and card.config.choose) or (self.config and self.config.choose) or 1
        local extra = (card and card.ability and card.ability.extra) or (card and card.config and card.config.extra) or (self.config and self.config.extra) or 5
        return { vars = { choose, extra } }
    end,
    create_card = function(self, card, i)
        return create_job_card_for_pack('jumbo_job_pack')
    end,
    ease_background_colour = function(self)
        ease_job_pack_background()
    end
}

SMODS.Booster {
    key = 'job_pack_3',
    atlas = 'p_job_3',
    pos = { x = 0, y = 0 },
    config = { extra = 5, choose = 2 },
    cost = 8,
    weight = 0.25,
    kind = 'Job',
    group_key = 'k_job_pack',
    draw_hand = true,
    loc_txt = {
        name = 'Mega Job Application',
        group_name = 'Job Application',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2# Job cards{} to give",
            "a job to a card"
        }
    },
    loc_vars = function(self, info_queue, card)
        local choose = (card and card.ability and card.ability.choose) or (card and card.config and card.config.choose) or (self.config and self.config.choose) or 2
        local extra = (card and card.ability and card.ability.extra) or (card and card.config and card.config.extra) or (self.config and self.config.extra) or 5
        return { vars = { choose, extra } }
    end,
    create_card = function(self, card, i)
        return create_job_card_for_pack('mega_job_pack')
    end,
    ease_background_colour = function(self)
        ease_job_pack_background()
    end
}
