-- Common Jokers

-- Masterful Joker
SMODS.Atlas {
    key = "masterful_joker",
    path = "masterful_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'masterful_joker',
    atlas = 'masterful_joker',
    loc_txt = {
        name = 'Masterful Joker',
        text = {
            "When a {C:attention}Four of a Kind{} or {C:attention}Five of a Kind{} scores,",
            "this Joker {C:attention}masters{} that rank.",
            "Cards of {C:attention}mastered ranks{} count as {C:attention}all suits{}.",
            "{C:mult}+#1#{} Mult per mastered rank {C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}"
        }
    },
    config = { extra = { mult_per_rank = 10, bonus_mult = 0, mastered_ranks = {} } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local count = 0
        if ex.mastered_ranks then
            for _ in pairs(ex.mastered_ranks) do count = count + 1 end
        end
        local current_mult = count * (ex.mult_per_rank or 10)
        return { vars = { ex.mult_per_rank or 10, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.poker_hands then
            local has_poker_or_five = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                      (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind'])) or
                                      (context.poker_hands['Flush Five'] and next(context.poker_hands['Flush Five']))
            if has_poker_or_five and context.scoring_hand then
                local rank_counts = {}
                local target_value = nil
                for _, c in ipairs(context.scoring_hand) do
                    local val = c.base and c.base.value
                    if val then
                        rank_counts[val] = (rank_counts[val] or 0) + 1
                        if rank_counts[val] >= 4 then
                            target_value = val
                        end
                    end
                end
                if target_value then
                    card.ability.extra.mastered_ranks = card.ability.extra.mastered_ranks or {}
                    if not card.ability.extra.mastered_ranks[target_value] then
                        card.ability.extra.mastered_ranks[target_value] = true
                        return {
                            message = 'Mastered ' .. target_value .. '!',
                            colour = G.C.PURPLE
                        }
                    end
                end
            end
        end

        if context.joker_main then
            local count = 0
            if card.ability.extra.mastered_ranks then
                for _ in pairs(card.ability.extra.mastered_ranks) do count = count + 1 end
            end
            local total_mult = count * (card.ability.extra.mult_per_rank or 10)
            if total_mult > 0 then
                return {
                    mult = total_mult
                }
            end
        end
    end
}

-- Outstanding Joker
SMODS.Atlas {
    key = "outstanding_joker",
    path = "outstanding_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'outstanding_joker',
    atlas = 'outstanding_joker',
    unlocked = false,
    loc_txt = {
        name = 'Outstanding Joker',
        text = {
            "The scored card with the strictly {C:attention}highest rank{}",
            "is {C:attention}Outstanding{}: it absorbs the {C:chips}Chips{} of all other",
            "scoring cards multiplied by the hand size and {C:attention}retriggers 1 time{}"
        }
    },
    unlock = {
        "Play a",
        "{C:attention}Five of a Kind{}"
    },
    config = { extra = {} },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    check_for_unlock = function(self, args)
        if (args.type == 'hand' or args.type == 'play_hand') and (args.handname == 'Five of a Kind' or args.handname == 'Flush Five') then
            return true
        end
        if G.GAME and G.GAME.hands and G.GAME.hands['Five of a Kind'] and (G.GAME.hands['Five of a Kind'].played or 0) > 0 then
            return true
        end
    end,
    calculate = function(self, card, context)
        local highest_card = nil
        local highest_rank = -1
        local is_tied = false
        if context.scoring_hand and #context.scoring_hand >= 2 then
            for _, c in ipairs(context.scoring_hand) do
                local r = c:get_id() or 0
                if r > highest_rank then
                    highest_rank = r
                    highest_card = c
                    is_tied = false
                elseif r == highest_rank then
                    is_tied = true
                end
            end
        end

        if highest_card and not is_tied then
            if context.repetition and context.cardarea == G.play then
                if context.other_card == highest_card then
                    return {
                        repetitions = 1,
                        card = card
                    }
                end
            end

            if context.individual and context.cardarea == G.play then
                if context.other_card == highest_card then
                    local other_chips = 0
                    for _, c in ipairs(context.scoring_hand) do
                        if c ~= highest_card then
                            other_chips = other_chips + (c.base and c.base.nominal or 0) + (c.ability and c.ability.perma_bonus or 0)
                        end
                    end
                    local bonus_chips = other_chips * #context.scoring_hand
                    if bonus_chips > 0 then
                        return {
                            chips = bonus_chips,
                            message = 'Outstanding! +' .. bonus_chips .. ' Chips',
                            colour = G.C.CHIPS,
                            card = card
                        }
                    end
                end
            end
        end
    end
}

-- Blueberry
SMODS.Atlas {
    key = "blueberry_joker",
    path = "blueberry_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'blueberry_joker',
    atlas = 'blueberry_joker',
    loc_txt = {
        name = 'Blueberry',
        text = {
            "{C:blue}+1{} Hand when {C:attention}Blind{} is selected.",
            "Self-destructs after {C:attention}#1#{} round#2#{}",
            "{C:inactive}(Art by kars_on_mars){}"
        }
    },
    config = { extra = { hands = 1, rounds_left = 3 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local r = (card and card.ability and card.ability.extra and card.ability.extra.rounds_left) or 3
        return { vars = { r, (r == 1 and '' or 's') } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            ease_hands_played(card.ability.extra.hands)
            return {
                message = '+1 Hand!',
                colour = G.C.BLUE
            }
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
            if card.ability.extra.rounds_left <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Expired!',
                    colour = G.C.RED
                }
            else
                return {
                    message = card.ability.extra.rounds_left .. ' left!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

-- DJ Joker
SMODS.Atlas {
    key = "dj_joker",
    path = "dj_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'dj_joker',
    atlas = 'dj_joker',
    loc_txt = {
        name = 'DJ Joker',
        text = {
            "If played hand contains only {C:attention}1 card{},",
            "converts it into a random {C:attention}Lucky{},",
            "{C:attention}Steel{}, {C:attention}Gold{}, or {C:attention}Glass{} card",
            "{C:inactive}(Once per round, #1#){}"
        }
    },
    config = { extra = { used = false } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local used = (card and card.ability and card.ability.extra and card.ability.extra.used) or false
        local status_text = used and "Used this round" or "Available"
        return { vars = { status_text } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            if not card.ability.extra.used then
                local play_count = (context.full_hand and #context.full_hand) or (context.scoring_hand and #context.scoring_hand) or (G.play and G.play.cards and #G.play.cards) or 0
                if play_count == 1 and context.scoring_hand and #context.scoring_hand == 1 then
                    card.ability.extra.used = true
                    local target_card = context.scoring_hand[1]
                    local enhancements = { G.P_CENTERS.m_lucky, G.P_CENTERS.m_steel, G.P_CENTERS.m_gold, G.P_CENTERS.m_glass }
                    local chosen_enh = pseudorandom_element(enhancements, pseudoseed('dj_joker'))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            play_sound('tarot1')
                            target_card:set_ability(chosen_enh)
                            target_card:juice_up(0.5, 0.5)
                            card:juice_up(0.3, 0.5)
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Remixed!', colour = G.C.SECONDARY_SET.Enhanced })
                            return true
                        end
                    }))
                end
            end
        end

        if (context.end_of_round or context.setting_blind) and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.used = false
        end
    end
}

-- Designer Joker (Joker Diseñador)
SMODS.Atlas {
    key = "disenador_joker",
    path = "disenador_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'disenador_joker',
    atlas = 'disenador_joker',
    loc_txt = {
        name = 'Designer Joker',
        text = {
            "Scored {C:attention}Wild Cards{} give {C:money}$#1#{}",
            "when scored"
        }
    },
    config = { extra = { dollars = 1 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability and card.ability.extra and card.ability.extra.dollars) or 1 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if is_wild_card(context.other_card) then
                local d = (card.ability and card.ability.extra and card.ability.extra.dollars) or 1
                ease_dollars(d)
                return {
                    dollars = d,
                    card = card
                }
            end
        end
    end
}

-- TTS Joker
SMODS.Atlas {
    key = "tts_joker",
    path = "tts_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'tts_joker',
    atlas = 'tts_joker',
    loc_txt = {
        name = 'TTS',
        text = {
            "Each scored card spells its rank name: grants",
            "{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult per letter in English.",
            "If played hand has {C:attention}#3# or more letters{} {C:inactive}(#4#){},",
            "receive a {C:money}$#5#{} {C:attention}Donation{}!"
        }
    },
    config = { extra = { chips_per_letter = 4, mult_per_letter = 1, letters_target = 20, donation = 5 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local ex = (card and card.ability and card.ability.extra) or self.config.extra
        local current_hand_letters = 0
        if G.play and G.play.cards then
            local letter_counts = {
                ['2'] = 3, ['3'] = 5, ['4'] = 4, ['5'] = 4, ['6'] = 3,
                ['7'] = 5, ['8'] = 5, ['9'] = 4, ['10'] = 3,
                ['Jack'] = 4, ['Queen'] = 5, ['King'] = 4, ['Ace'] = 3
            }
            for _, c in ipairs(G.play.cards) do
                local val = c.base and c.base.value
                current_hand_letters = current_hand_letters + (letter_counts[val] or 4)
            end
        end
        return { vars = { ex.chips_per_letter, ex.mult_per_letter, ex.letters_target, current_hand_letters, ex.donation } }
    end,
    calculate = function(self, card, context)
        local letter_counts = {
            ['2'] = 3, ['3'] = 5, ['4'] = 4, ['5'] = 4, ['6'] = 3,
            ['7'] = 5, ['8'] = 5, ['9'] = 4, ['10'] = 3,
            ['Jack'] = 4, ['Queen'] = 5, ['King'] = 4, ['Ace'] = 3
        }

        if context.individual and context.cardarea == G.play then
            local val = context.other_card.base and context.other_card.base.value
            local letters = letter_counts[val] or 4
            return {
                chips = letters * card.ability.extra.chips_per_letter,
                mult = letters * card.ability.extra.mult_per_letter,
                message = letters .. ' Letters (' .. tostring(val) .. ')',
                colour = G.C.MULT,
                card = card
            }
        end

        if context.before and not context.blueprint and context.scoring_hand then
            local total_letters = 0
            for _, c in ipairs(context.scoring_hand) do
                local val = c.base and c.base.value
                total_letters = total_letters + (letter_counts[val] or 4)
            end
            if total_letters >= card.ability.extra.letters_target then
                ease_dollars(card.ability.extra.donation)
                return {
                    message = 'TTS DONATION! +$' .. card.ability.extra.donation,
                    colour = G.C.MONEY
                }
            end
        end

        if context.discard and not context.blueprint and context.other_card then
            local val = context.other_card.base and context.other_card.base.value
            local letters = letter_counts[val] or 4
            if letters >= 5 then
                ease_dollars(1)
                return {
                    message = 'Spamming Chat! +$1',
                    colour = G.C.MONEY
                }
            end
        end
    end
}
