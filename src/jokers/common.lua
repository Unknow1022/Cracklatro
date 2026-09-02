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
            "{C:mult}+#1#{} Mult if played hand contains",
            "a {C:attention}Four of a Kind{} or {C:attention}Five of a Kind{}"
        }
    },
    config = { extra = { mult = 25 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands then
            local has_poker_or_five = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                      (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if has_poker_or_five then
                return {
                    mult = card.ability.extra.mult
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
            "{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult, and {C:money}$#3#{}",
            "if played hand contains a {C:attention}Four of a Kind{}",
            "or {C:attention}Five of a Kind{}"
        },
        unlock = {
            "Play a",
            "{C:attention}Five of a Kind{}"
        }
    },
    config = { extra = { chips = 250, mult = 50, dollars = 5 } },
    rarity = 1,
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars } }
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
        if context.joker_main and context.poker_hands then
            local has_poker_or_five = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                      (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if has_poker_or_five then
                ease_dollars(card.ability.extra.dollars)
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    dollars = card.ability.extra.dollars
                }
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
