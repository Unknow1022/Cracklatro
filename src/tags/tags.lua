-- Tags

-- Discord Tag
SMODS.Atlas {
    key = "tag_discord",
    path = "tag_discord.png",
    px = 34,
    py = 34
}

SMODS.Tag {
    key = 'discord',
    atlas = 'tag_discord',
    pos = { x = 0, y = 0 },
    min_ante = 1,
    loc_txt = {
        name = 'Discord Tag',
        text = {
            "{C:green}#1# in 5{} chance to create",
            "{C:spectral}La Muchachada{}",
            "{C:inactive}(Must have room){}"
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' or context.type == 'round_start_bonus' or context.type == 'new_blind_choice' or context.type == 'tag_add' then
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                if pseudorandom('discord_tag') < ((G.GAME and G.GAME.probabilities.normal or 1) / 5) then
                    if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                        local tag_muchachada_key = (G.P_CENTERS and G.P_CENTERS['c_Crackedlatro_la_muchachada'] and 'c_Crackedlatro_la_muchachada') or 'c_la_muchachada'
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, tag_muchachada_key, 'discord_tag')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                end
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}
