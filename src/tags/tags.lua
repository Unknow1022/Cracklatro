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

-- Witchcraft Tag (Tag de Brujería)
SMODS.Atlas {
    key = "tag_brujeria",
    path = "tag_brujeria.png",
    px = 34,
    py = 34
}

SMODS.Tag {
    key = 'brujeria',
    atlas = 'tag_brujeria',
    pos = { x = 0, y = 0 },
    min_ante = 1,
    loc_txt = {
        name = 'Witchcraft Tag',
        text = {
            "Gives a free",
            "{C:spectral}Mega Spectral Pack{}"
        }
    },
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' or context.type == 'immediate' or context.type == 'round_start_bonus' or context.type == 'tag_add' or context.type == 'shop_pack' then
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                local pack_center = G.P_CENTERS['p_spectral_mega_1'] or G.P_CENTERS['p_spectral_mega_2'] or G.P_CENTERS['p_spectral_jumbo_1'] or G.P_CENTERS['p_spectral_normal_1']
                if pack_center then
                    local pack = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, pack_center, {bypass_discovery_center = true, bypass_discovery_ui = true})
                    pack.cost = 0
                    pack.from_tag = true
                    G.FUNCS.use_card({config = {ref_table = pack}})
                    card_eval_status_text(pack, 'extra', nil, nil, nil, { message = 'Mega Spectral Pack!', colour = G.C.SECONDARY_SET.Spectral })
                end
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

-- Sale Tag (Tag de Oferta)
SMODS.Atlas {
    key = "tag_oferta",
    path = "tag_oferta.png",
    px = 34,
    py = 34
}

SMODS.Tag {
    key = 'oferta',
    atlas = 'tag_oferta',
    pos = { x = 0, y = 0 },
    min_ante = 1,
    loc_txt = {
        name = 'Sale Tag',
        text = {
            "All shop items and rerolls",
            "are {C:attention}50% off{} in next shop"
        }
    },
    apply = function(self, tag, context)
        if context.type == 'store_safety' or context.type == 'shop_final_pass' or context.type == 'shop_start' then
            tag:yep('+', G.C.MONEY, function()
                G.GAME.discount_percent = (G.GAME.discount_percent or 0) + 50
                if G.GAME.current_round and G.GAME.current_round.reroll_cost then
                    G.GAME.current_round.reroll_cost = math.max(1, math.floor(G.GAME.current_round.reroll_cost * 0.5))
                end
                if G.shop_jokers and G.shop_jokers.cards then
                    for _, c in ipairs(G.shop_jokers.cards) do c:set_cost() end
                end
                if G.shop_booster and G.shop_booster.cards then
                    for _, c in ipairs(G.shop_booster.cards) do c:set_cost() end
                end
                if G.shop_vouchers and G.shop_vouchers.cards then
                    for _, c in ipairs(G.shop_vouchers.cards) do c:set_cost() end
                end
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

