-- Core Utilities & Engine Hooks for Cracklatro

function is_secret_card(card)
    if not card then return false end
    if card.is_secret or (card.config and card.config.center and card.config.center.is_secret) then return true end
    local key = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    key = string.lower(tostring(key))
    local secret_names = {
        'esteban', 'thiago', 'paula', 'black_hole', 'squele', 'bluxdir', 'charles', 'mochi', 'helin', 'raytracing', 'paco', 'gabi', 'yairo'
    }
    for _, name in ipairs(secret_names) do
        if string.find(key, name) then return true end
    end
    return false
end

function is_wild_card(pcard)
    if not pcard then return false end
    if SMODS and SMODS.has_enhancement and SMODS.has_enhancement(pcard, 'm_wild') then
        return true
    end
    if pcard.ability then
        if pcard.ability.name == 'Wild Card' or pcard.ability.effect == 'Wild Card' or pcard.ability.label == 'Wild Card' then
            return true
        end
    end
    if pcard.config then
        if pcard.config.center_key == 'm_wild' then return true end
        if type(pcard.config.center) == 'table' and pcard.config.center.key == 'm_wild' then return true end
        if type(pcard.config.center) == 'string' and pcard.config.center == 'm_wild' then return true end
        if pcard.config.center == G.P_CENTERS.m_wild then return true end
    end
    return false
end

-- Job Stickers Atlas & Helpers
SMODS.Atlas {
    key = "job_stickers",
    path = "job_stickers.png",
    px = 71,
    py = 95
}

function get_card_job_info(card)
    if not card or not card.ability then return nil end
    if card.ability.gardener_job then
        return {
            name = 'Jardinero',
            idx = 0,
            badge_colour = HEX('27ae60'),
            text = {
                "Al descartar esta carta, añade",
                "+2 Fichas base permanentes a",
                "todas las cartas de su mismo palo"
            }
        }
    elseif card.ability.detective_job then
        return {
            name = 'Detective',
            idx = 1,
            badge_colour = HEX('2980b9'),
            text = {
                "En la mano inicial al iniciar ronda,",
                "revela las próximas 3 cartas que robarás",
                "y les otorga Sello Dorado o Sello Azul"
            }
        }
    elseif card.ability.chef_job then
        return {
            name = 'Chef',
            idx = 2,
            badge_colour = HEX('e67e22'),
            text = {
                "Al puntuar en figuras (J, Q, K),",
                "transforma a las demás cartas",
                "puntuadas en Cartas Multi"
            }
        }
    elseif card.ability.archaeologist_job then
        return {
            name = 'Arqueólogo',
            idx = 3,
            badge_colour = HEX('d35400'),
            text = {
                "Al puntuar en tu última mano,",
                "rescata 1 carta descartada con",
                "una edición (Foil, Holo, Poly)"
            }
        }
    end
    return nil
end

-- UIBox ability table hook
local card_generate_UIBox_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(...)
    ensure_custom_seals_discovered()
    local is_secret = is_secret_card(self)
    if is_secret then
        G.GAME_IS_RENDERING_SECRET_CARD = true
    end
    local res = card_generate_UIBox_ref(self, ...)
    G.GAME_IS_RENDERING_SECRET_CARD = false

    local job = get_card_job_info(self)
    if job and res and res.main then
        local desc_nodes = {}
        for _, line_text in ipairs(job.text) do
            table.insert(desc_nodes, {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    { n = G.UIT.T, config = { text = line_text, colour = G.C.UI.TEXT_LIGHT, scale = 0.3 } }
                }
            })
        end
        local job_ui_box = {
            n = G.UIT.R,
            config = { align = "cm", colour = G.C.CLEAR, padding = 0.05 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = "cm", colour = HEX('1c2321'), r = 0.08, padding = 0.06, minw = 2.8, emboss = 0.04 },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = "cm" },
                            nodes = {
                                { n = G.UIT.T, config = { text = "Oficio: " .. job.name, colour = job.badge_colour, scale = 0.33 } }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { align = "cm" },
                            nodes = desc_nodes
                        }
                    }
                }
            }
        }
        table.insert(res.main, job_ui_box)
    end

    return res
end

-- Job Sticker sprite rendering in Card:draw
local card_draw_ref = Card.draw
function Card:draw(layer)
    card_draw_ref(self, layer)
    if (layer == 'card' or layer == 'both' or not layer) and self.ability and self.children and not self.highlighted_shadow then
        local job = get_card_job_info(self)
        local job_atlas = G.ASSET_ATLAS and (G.ASSET_ATLAS['Crackedlatro_job_stickers'] or G.ASSET_ATLAS['job_stickers'])
        if job and job_atlas then
            if not self.children.job_sticker then
                self.children.job_sticker = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, job_atlas, { x = job.idx, y = 0 })
                self.children.job_sticker.role.draw_major = self
                self.children.job_sticker.states.hover = self.states.hover
                self.children.job_sticker.states.click = self.states.click
                self.children.job_sticker.states.drag = self.states.drag
            else
                self.children.job_sticker:set_sprite_pos({ x = job.idx, y = 0 })
                self.children.job_sticker:draw_shader('dissolve', nil, nil, nil, self.children.center)
            end
        else
            if self.children.job_sticker then
                self.children.job_sticker:remove()
                self.children.job_sticker = nil
            end
        end
    end
end

if Card.generate_card_ui then
    local gen_card_ui_ref = Card.generate_card_ui
    function Card:generate_card_ui(...)
        local is_secret = is_secret_card(self)
        if is_secret then
            G.GAME_IS_RENDERING_SECRET_CARD = true
        end
        local res = gen_card_ui_ref(self, ...)
        G.GAME_IS_RENDERING_SECRET_CARD = false
        return res
    end
end

-- Secret rarity badge hook
local create_badge_ref = create_badge
function create_badge(text, badge_colour, text_colour, scale)
    if type(text) == 'table' then
        return text
    end
    if G.GAME_IS_RENDERING_SECRET_CARD and (text == 'Legendary' or text == 'Legendario' or text == 'Secret' or text == 'Secreto' or (localize and text == localize('k_legendary'))) then
        text = 'Secreto'
        badge_colour = HEX('000000')
        text_colour = G.C.WHITE
    end
    if type(text) ~= 'string' then
        text = tostring(text or '')
    end
    return create_badge_ref(text, badge_colour, text_colour, scale)
end

function ease_job_pack_background()
    ease_colour(G.C.DYN_UI.MAIN, HEX('4a1a14'))
    ease_colour(G.C.DYN_UI.DARK, HEX('240b07'))
    ease_background_colour{new_colour = HEX('4a1a14'), special_colour = HEX('6b251b'), contrast = 2}
end

local card_open_ref = Card.open
function Card:open()
    local is_job_pack = self.ability and self.ability.set == 'Booster' and (
        (self.ability.name and string.find(self.ability.name, 'job_pack')) or
        (self.config and self.config.center and (self.config.center.kind == 'Job' or (self.config.center.key and string.find(self.config.center.key, 'job_pack'))))
    )
    local ret = card_open_ref(self)
    if is_job_pack then
        ease_job_pack_background()
    end
    return ret
end

if localize then
    local orig_localize = localize
    function localize(args, misc_cat)
        if type(args) == 'string' then
            if args == 'k_job_pack' or args == 'k_job_pack_1' or args == 'k_job_pack_2' or args == 'k_job_pack_3' then
                return 'Job Application'
            end
        elseif type(args) == 'table' then
            if args.key == 'k_job_pack' then
                return 'Job Application'
            end
        end
        local res = orig_localize(args, misc_cat)
        if res == 'ERROR' and type(args) == 'string' then
            if args == 'k_job_pack' or string.find(args, 'job_pack') then
                return 'Job Application'
            end
        end
        return res
    end
end

function check_all_suits_flushed_unlock(self, args)
    if (args.type == 'hand' or args.type == 'play_hand') and args.scoring_hand and #args.scoring_hand >= 4 then
        G.GAME.flushed_suits = G.GAME.flushed_suits or {}
        local suits = {'Hearts', 'Spades', 'Clubs', 'Diamonds'}
        for _, s in ipairs(suits) do
            local matches = true
            for _, c in ipairs(args.scoring_hand) do
                if not c:is_suit(s) then matches = false; break end
            end
            if matches then
                G.GAME.flushed_suits[s] = true
            end
        end
        if G.GAME.flushed_suits.Hearts and G.GAME.flushed_suits.Spades and G.GAME.flushed_suits.Clubs and G.GAME.flushed_suits.Diamonds then
            return true
        end
    end
    if G.GAME and G.GAME.flushed_suits and G.GAME.flushed_suits.Hearts and G.GAME.flushed_suits.Spades and G.GAME.flushed_suits.Clubs and G.GAME.flushed_suits.Diamonds then
        return true
    end
end

local card_redeem_ref = Card.redeem
function Card:redeem(...)
    local key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name)
    if key == 'v_blank' or key == 'v_Crackedlatro_blank' or key == 'blank' then
        if G.PROFILES and G.SETTINGS and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought = (G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought or 0) + 1
        end
        check_for_unlock({ type = 'blank_voucher_bought' })
    end
    return card_redeem_ref(self, ...)
end

local card_eval_ref = Card.eval_card
function Card:eval_card(context)
    local ret = card_eval_ref(self, context)
    if ret and ret.dollars and (ret.mult or ret.h_mult or ret.x_mult or ret.Xmult) then
        if G.GAME then G.GAME.lucky_hit_both = true end
        check_for_unlock({ type = 'lucky_both' })
    end

    -- Gardener Job: +2 base chips to suit on discard
    if context and context.discard and self.ability and self.ability.gardener_job then
        local suit = self.base and self.base.suit
        if suit and G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c.base and c.base.suit == suit then
                    c.ability = c.ability or {}
                    c.ability.perma_bonus = (c.ability.perma_bonus or 0) + 2
                end
            end
            ret = ret or {}
            ret.message = '+2 Chips to ' .. suit .. '!'
            ret.colour = G.C.CHIPS
            ret.card = self
        end
    end

    -- Chef Job: Face cards transform other scoring cards into Mult cards
    if context and (context.main_scoring or context.individual) and context.cardarea == G.play and self.ability and self.ability.chef_job and self:is_face() then
        if context.scoring_hand then
            for _, other_c in ipairs(context.scoring_hand) do
                if other_c ~= self and other_c.config and other_c.config.center ~= G.P_CENTERS.m_mult then
                    other_c:set_ability(G.P_CENTERS.m_mult)
                    other_c:juice_up()
                end
            end
        end
    end

    -- Archaeologist Job: Last hand rescues 1 discarded card with edition
    if context and (context.main_scoring or context.individual) and context.cardarea == G.play and self.ability and self.ability.archaeologist_job then
        if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left == 0 and not self.ability.archaeologist_triggered_this_hand then
            self.ability.archaeologist_triggered_this_hand = true
            if G.discard and G.discard.cards and #G.discard.cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.discard and G.discard.cards and #G.discard.cards > 0 then
                            local rescued = pseudorandom_element(G.discard.cards, 'archaeologist_rescue')
                            if rescued and G.hand then
                                draw_card(G.discard, G.hand, 100, 'up', nil, rescued)
                                local editions = { 'e_foil', 'e_holo', 'e_polychrome' }
                                local chosen_ed = pseudorandom_element(editions, 'archaeologist_ed')
                                rescued:set_edition(chosen_ed, true)
                            end
                        end
                        return true
                    end
                }))
                ret = ret or {}
                ret.message = 'Excavated!'
                ret.colour = G.C.GOLD
            end
        end
    end
    if context and context.end_of_round and self.ability then
        self.ability.archaeologist_triggered_this_hand = nil
    end

    -- Lead Card: Transmute to Gold on winning hand
    local center_key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name) or ''
    center_key = tostring(center_key)
    if string.find(center_key, 'lead') and context and (context.main_scoring or context.individual) and context.cardarea == G.play then
        if G.GAME and G.GAME.blind and G.GAME.chips + (hand_chips or 0) >= G.GAME.blind.chips then
            G.E_MANAGER:add_event(Event({
                func = function()
                    self:set_ability(G.P_CENTERS.m_gold)
                    self:juice_up()
                    return true
                end
            }))
        end
    end

    return ret
end

-- Blind hook for Detective Job, Stick Penalty & Custom Boss Backgrounds
local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    local ret = set_blind_ref(self, blind, reset, silent)
    if G.GAME and G.GAME.stick_penalty then
        self.chips = math.floor(self.chips * G.GAME.stick_penalty)
        G.GAME.stick_penalty = nil
    end

    if self.boss and not self.disabled and ease_custom_blind_background then
        ease_custom_blind_background(self)
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.0,
        func = function()
            if G.hand and G.hand.cards then
                local has_detective = false
                for _, c in ipairs(G.hand.cards) do
                    if c and c.ability and c.ability.detective_job then
                        has_detective = true
                        c:juice_up()
                        break
                    end
                end
                if has_detective and G.deck and G.deck.cards and #G.deck.cards > 0 then
                    local count = math.min(3, #G.deck.cards)
                    local seals = { 'Gold', 'Blue' }
                    for i = 1, count do
                        local top_c = G.deck.cards[#G.deck.cards - (i - 1)]
                        if top_c then
                            local chosen_seal = pseudorandom_element(seals, 'detective_seal')
                            top_c:set_seal(chosen_seal, true)
                        end
                    end
                end
            end
            return true
        end
    }))
    return ret
end

-- Blind disable hook to reset background
if Blind.disable then
    local blind_disable_ref = Blind.disable
    function Blind:disable()
        local ret = blind_disable_ref(self)
        if self.boss and G.C and G.C.DYN_UI then
            local default_main = (G.C.BLIND and G.C.BLIND.Small) or G.C.RED
            local default_dark = G.C.BLACK
            local bg_d = (G.C.BACKGROUND and G.C.BACKGROUND.D) or HEX('374244')
            local bg_l = (G.C.BACKGROUND and G.C.BACKGROUND.L) or HEX('374244')

            if G.C.DYN_UI.MAIN then
                ease_colour(G.C.DYN_UI.MAIN, default_main)
            end
            if G.C.DYN_UI.DARK then
                ease_colour(G.C.DYN_UI.DARK, default_dark)
            end
            if ease_background_colour then
                ease_background_colour{new_colour = bg_d, special_colour = bg_l, contrast = 1}
            end
        end
        return ret
    end
end

-- Blind defeat hook to reset background
if Blind.defeat then
    local blind_defeat_ref = Blind.defeat
    function Blind:defeat(silent)
        local ret = blind_defeat_ref(self, silent)
        if self.boss and G.C and G.C.DYN_UI then
            local default_main = (G.C.BLIND and G.C.BLIND.Small) or G.C.RED
            local default_dark = G.C.BLACK
            local bg_d = (G.C.BACKGROUND and G.C.BACKGROUND.D) or HEX('374244')
            local bg_l = (G.C.BACKGROUND and G.C.BACKGROUND.L) or HEX('374244')

            if G.C.DYN_UI.MAIN then
                ease_colour(G.C.DYN_UI.MAIN, default_main)
            end
            if G.C.DYN_UI.DARK then
                ease_colour(G.C.DYN_UI.DARK, default_dark)
            end
            if ease_background_colour then
                ease_background_colour{new_colour = bg_d, special_colour = bg_l, contrast = 1}
            end
        end
        return ret
    end
end


-- Shop dollar tracking hook for Merchant
local game_update_ref = Game.update
function Game:update(dt)
    game_update_ref(self, dt)
    if G.STATE == G.STATES.SHOP and G.GAME then
        if not G.GAME.entered_shop_dollars then
            G.GAME.entered_shop_dollars = G.GAME.dollars or 0
        end
    elseif G.STATE ~= G.STATES.SHOP and G.GAME and G.GAME.entered_shop_dollars then
        if G.GAME.entered_shop_dollars >= 50 and (G.GAME.dollars or 0) <= 10 then
            check_for_unlock({ type = 'leave_shop' })
        end
        G.GAME.entered_shop_dollars = nil
    end
end

-- Mountain Blind consumable check
local use_card_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
    if G.GAME and G.GAME.blind and (G.GAME.blind.name == 'b_Crackedlatro_mountain' or G.GAME.blind.name == 'mountain' or G.GAME.blind.key == 'b_Crackedlatro_mountain') then
        G.GAME.mountain_disabled_hand = true
    end
    return use_card_ref(self, area, copier)
end

-- Overseer Deck Hooks
local add_tag_ref = add_tag
function add_tag(tag)
    local ret = add_tag_ref(tag)
    if G.GAME and G.GAME.overseer_deck and not G.GAME.overseer_duplicating_tag and tag then
        G.GAME.overseer_duplicating_tag = true
        G.E_MANAGER:add_event(Event({
            func = function()
                local new_tag = Tag(tag.key)
                add_tag_ref(new_tag)
                G.GAME.overseer_duplicating_tag = nil
                return true
            end
        }))
    end
    return ret
end

local set_cost_ref = Card.set_cost
function Card:set_cost()
    set_cost_ref(self)
    if G.GAME and G.GAME.overseer_deck and self.ability and self.ability.set == 'Joker' then
        self.cost = math.max(1, math.floor(self.cost * 1.5))
    end
end

-- Voucher & Rarity calculation helpers
local function has_taster_voucher()
    if not G.GAME or not G.GAME.used_vouchers then return false end
    return G.GAME.used_vouchers.v_Crackedlatro_catador or G.GAME.used_vouchers.v_catador or G.GAME.used_vouchers.catador
end

local function has_critic_voucher()
    if not G.GAME or not G.GAME.used_vouchers then return false end
    return G.GAME.used_vouchers.v_Crackedlatro_critico or G.GAME.used_vouchers.v_critico or G.GAME.used_vouchers.critico
end

local function is_common_rarity(r)
    if not r then return false end
    if r == 1 or r == 'Common' or r == 'common' or tostring(r) == '1' then return true end
    if type(r) == 'number' and r > 0 and r <= 0.85 then return true end
    return false
end

local function upgrade_common_rarity(r, seed)
    local is_str = (type(r) == 'string' and not tonumber(r))
    local roll = pseudorandom(seed or 'voucher_upgrade_rarity')
    if is_str then
        return (roll < 0.75) and 'Uncommon' or 'Rare'
    else
        return (roll < 0.75) and 2 or 3
    end
end

local get_current_joker_rarity_ref = get_current_joker_rarity
function get_current_joker_rarity(area, rarity_share)
    local rarity = get_current_joker_rarity_ref(area, rarity_share)
    if G.GAME then
        if has_critic_voucher() and is_common_rarity(rarity) then
            rarity = upgrade_common_rarity(rarity, 'critico_voucher')
        elseif has_taster_voucher() and is_common_rarity(rarity) then
            if pseudorandom('catador_voucher') < 0.75 then
                rarity = upgrade_common_rarity(rarity, 'catador_voucher_rarity')
            end
        end

        if G.GAME.merchant_rare_boost and G.GAME.merchant_rare_boost > 0 then
            if rarity ~= 3 and rarity ~= 'Rare' and pseudorandom('merchant_rare') < 0.35 then
                rarity = (type(rarity) == 'string' and not tonumber(rarity)) and 'Rare' or 3
            end
        end
    end
    return rarity
end

if SMODS and SMODS.poll_rarity then
    local orig_poll_rarity = SMODS.poll_rarity
    function SMODS.poll_rarity(key, rarity_share)
        local rarity = orig_poll_rarity(key, rarity_share)
        if key == 'Joker' and G.GAME then
            if has_critic_voucher() and is_common_rarity(rarity) then
                rarity = upgrade_common_rarity(rarity, 'critico_smods_poll')
            elseif has_taster_voucher() and is_common_rarity(rarity) then
                if pseudorandom('catador_smods_poll') < 0.75 then
                    rarity = upgrade_common_rarity(rarity, 'catador_smods_poll_rarity')
                end
            end
        end
        return rarity
    end
end

-- Card generation hook for La Muchachada & Vouchers
local create_card_ref = create_card
function create_card(type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if not forced_key and type == 'Spectral' and (area == G.pack_cards or key_append == 'spe' or (G.pack_cards and area == G.pack_cards)) then
        local muchachada_center_key = (G.P_CENTERS and G.P_CENTERS['c_Crackedlatro_la_muchachada'] and 'c_Crackedlatro_la_muchachada') or 'c_la_muchachada'
        local allow_spawn = not (G.GAME and G.GAME.used_jokers and G.GAME.used_jokers[muchachada_center_key]) or (find_joker and next(find_joker("Showman")) ~= nil)
        if allow_spawn then
            local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
            if pseudorandom('la_muchachada_spectral_' .. (key_append or 'spe') .. ante) > 0.9985 then
                forced_key = muchachada_center_key
            end
        end
    end

    local card = create_card_ref(type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if type == 'Joker' and card and not forced_key and card.ability and card.ability.set == 'Joker' then
        local c_rarity = (card.config and card.config.center and card.config.center.rarity) or card.ability.rarity
        if is_common_rarity(c_rarity) then
            local should_replace = false
            if has_critic_voucher() then
                should_replace = true
            elseif has_taster_voucher() and pseudorandom('catador_create_check') < 0.75 then
                should_replace = true
            end
            if should_replace then
                local replacement_rarity = (pseudorandom('voucher_create_rarity') < 0.75) and 2 or 3
                local new_card = create_card_ref('Joker', area, legendary, replacement_rarity, skip_materialize, soulable, nil, (key_append or '') .. '_vup')
                if new_card then
                    card:remove()
                    card = new_card
                end
            end
        end
    end

    return card
end

-- Falta de Lectura activation tracker hook
local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = calculate_joker_ref(self, context)
    if ret and type(ret) == 'table' and next(ret) and not self.debuff and context and not context.falta_de_lectura_check then
        local key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name)
        local is_self = (key == 'j_Crackedlatro_falta_de_lectura_joker' or key == 'falta_de_lectura_joker' or key == 'j_falta_de_lectura_joker' or key == 'falta_de_lectura')
        if not is_self then
            if context.joker_main or context.individual or context.before or context.repetition then
                if ret.mult or ret.chips or ret.Xmult or ret.x_mult or ret.dollars or ret.x_chips or ret.p_dollars or ret.message or ret.swap then
                    G.GAME.falta_de_lectura_other_activated = true
                end
            end
        end
    end
    return ret
end

-- Doctor Jo rescue hook on Card.start_dissolve
local card_start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_sound)
    if self.ability and self.ability.set == 'Joker' and G.jokers and G.jokers.cards then
        local doctor_card = nil
        for _, j in ipairs(G.jokers.cards) do
            local key_j = (j.config and j.config.center and j.config.center.key) or j.config.center_key or j.ability.name
            local is_doctor = (key_j == 'j_Crackedlatro_doctor_jo_joker' or key_j == 'doctor_jo_joker' or key_j == 'j_doctor_jo_joker')
            if is_doctor and j ~= self and not j.getting_sliced and not j.debuff then
                doctor_card = j
                break
            end
        end

        if doctor_card then
            local key_self = (self.config and self.config.center and self.config.center.key) or self.config.center_key or self.ability.name
            local incompatible = {
                ['j_Crackedlatro_doctor_jo_joker'] = true,
                ['doctor_jo_joker'] = true,
                ['j_doctor_jo_joker'] = true,
                ['j_mr_bones'] = true,
                ['j_luchador'] = true,
                ['j_gros_michel'] = true,
                ['j_cavendish'] = true,
                ['j_ice_cream'] = true,
                ['j_popcorn'] = true,
                ['j_turtle_bean'] = true,
                ['j_ramen'] = true,
                ['j_diet_cola'] = true,
                ['j_invisible'] = true
            }

            if key_self and not incompatible[key_self] then
                doctor_card.getting_sliced = true
                local card_to_copy = self
                G.E_MANAGER:add_event(Event({
                    func = function()
                        doctor_card:start_dissolve()
                        local new_card = copy_card(card_to_copy, nil)
                        
                        new_card.pinned = nil
                        new_card.eternal = nil
                        new_card.perishable = nil
                        new_card.rental = nil
                        new_card.debuff = false
                        new_card.debuffed_by_blind = nil
                        
                        if new_card.ability then
                            new_card.ability.perishable = nil
                            new_card.ability.perishable_tally = nil
                            new_card.ability.rental = nil
                            new_card.ability.eternal = nil
                            new_card.ability.debuff = false
                        end

                        if new_card.set_debuff then
                            new_card:set_debuff(false)
                        end

                        new_card:set_edition({ polychrome = true }, true)
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        new_card:juice_up(0.8, 0.8)
                        
                        return true
                    end
                }))
            end
        end
    end

    -- Pinza Showdown card destruction check
    if (self.playing_card or (self.ability and (self.ability.set == 'Enhanced' or self.ability.set == 'Default')) or self.base) then
        if G.GAME and G.GAME.blind and (G.GAME.blind.name == 'pinza' or G.GAME.blind.key == 'b_Crackedlatro_pinza' or G.GAME.blind.name == 'b_Crackedlatro_pinza' or G.GAME.blind.name == 'The Pincer') then
            if not G.GAME.pinza_card_destroyed then
                G.GAME.pinza_card_destroyed = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        if G.jokers and G.jokers.cards then
                            for _, j in ipairs(G.jokers.cards) do
                                j:set_debuff(false)
                                j.debuff = false
                            end
                        end
                        play_sound('tarot2')
                        return true
                    end
                }))
            end
        end
    end

    return card_start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_sound)
end

-- Shatter hook for Glass cards breaking
if Card.shatter then
    local card_shatter_ref = Card.shatter
    function Card:shatter()
        if G.GAME and G.GAME.blind and (G.GAME.blind.name == 'pinza' or G.GAME.blind.key == 'b_Crackedlatro_pinza' or G.GAME.blind.name == 'b_Crackedlatro_pinza' or G.GAME.blind.name == 'The Pincer') then
            if not G.GAME.pinza_card_destroyed then
                G.GAME.pinza_card_destroyed = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        if G.jokers and G.jokers.cards then
                            for _, j in ipairs(G.jokers.cards) do
                                j:set_debuff(false)
                                j.debuff = false
                            end
                        end
                        play_sound('tarot2')
                        return true
                    end
                }))
            end
        end
        return card_shatter_ref(self)
    end
end

-- Custom USE Button Hook for Infostealer Joker
function is_infostealer_card(card)
    if not card then return false end
    local k = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    k = string.lower(tostring(k))
    return string.find(k, 'infostealer') ~= nil
end

G.FUNCS.can_use_infostealer = function(e)
    local card = e.config.ref_table
    local can_use = false
    local cost = (card and card.ability and card.ability.extra and card.ability.extra.cost) or 10
    if card and card.area == G.jokers and (G.GAME.dollars or 0) >= cost then
        if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND then
            can_use = true
        end
    end

    if can_use then
        e.config.colour = G.C.GOLD
        e.config.button = 'use_infostealer'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_infostealer = function(e)
    local card = e.config.ref_table
    if not card or card.area ~= G.jokers then return end
    card.ability.extra = card.ability.extra or {}
    local cost = card.ability.extra.cost or 10
    if (G.GAME.dollars or 0) < cost then return end

    ease_dollars(-cost)
    card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + (card.ability.extra.xmult_gain or 1.0)
    card.ability.extra.times_fed = (card.ability.extra.times_fed or 0) + 1
    card.ability.extra.cost = cost + (card.ability.extra.cost_increase or 1)

    play_sound('foil1')
    card:juice_up(0.5, 0.5)
    card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+' .. (card.ability.extra.xmult_gain or 1) .. ' XMult!', colour = G.C.XMULT })

    -- Refresh button UI in real time to show new cost
    if card.children and card.children.use_button and G.UIDEF and G.UIDEF.use_and_sell_buttons then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if card.children and card.children.use_button then
                    card.children.use_button:remove()
                    card.children.use_button = UIBox{
                        definition = G.UIDEF.use_and_sell_buttons(card),
                        config = { align = "cr", offset = { x = 0, y = 0 }, parent = card }
                    }
                end
                return true
            end
        }))
    end
end

if G.UIDEF and G.UIDEF.use_and_sell_buttons then
    local use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local retval = use_and_sell_buttons_ref(card)
        if is_infostealer_card(card) and card.area == G.jokers then
            local cost = (card and card.ability and card.ability.extra and card.ability.extra.cost) or 10
            local feed_btn = {
                n = G.UIT.R,
                config = { align = "cl" },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            align = "cr",
                            padding = 0.05,
                            r = 0.08,
                            hover = true,
                            colour = G.C.GOLD,
                            button = 'use_infostealer',
                            shadow = true,
                            func = 'can_use_infostealer',
                            ref_table = card
                        },
                        nodes = {
                            { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "USE $" .. cost,
                                    scale = 0.45,
                                    colour = G.C.UI.TEXT_LIGHT,
                                    shadow = true
                                }
                            }
                        }
                    }
                }
            }
            if retval and retval.nodes and retval.nodes[1] and retval.nodes[1].nodes then
                table.insert(retval.nodes[1].nodes, 1, feed_btn)
            end
        end
        return retval
    end
end

-- Ensure Custom Seals Discovery in UI and Collection
function ensure_custom_seals_discovered()
    local seal_keys = {
        'dark_green', 'Crackedlatro_dark_green',
        'white', 'Crackedlatro_white',
        'silver', 'Crackedlatro_silver'
    }
    if G and G.P_SEALS then
        for _, k in ipairs(seal_keys) do
            if G.P_SEALS[k] then
                G.P_SEALS[k].discovered = true
                G.P_SEALS[k].unlocked = true
            end
        end
    end
    if G and G.P_CENTER_POOLS and G.P_CENTER_POOLS.Seal then
        for _, s in ipairs(G.P_CENTER_POOLS.Seal) do
            if s.key and (string.find(s.key, 'dark_green') or string.find(s.key, 'white') or string.find(s.key, 'silver')) then
                s.discovered = true
                s.unlocked = true
            end
        end
    end
end

ensure_custom_seals_discovered()

-- Masterful Joker: Mastered ranks count as any suit
local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if G and G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and (j.config.center.key == 'j_Crackedlatro_masterful_joker' or j.config.center_key == 'j_Crackedlatro_masterful_joker') and not j.debuff then
                if j.ability and j.ability.extra and j.ability.extra.mastered_ranks then
                    local rank = self.base and self.base.value
                    if rank and j.ability.extra.mastered_ranks[rank] then
                        return true
                    end
                end
            end
        end
    end
    return card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
end

-- Lucky One: 4-Leaf Clover guarantees 100% success on next probability roll
local pseudorandom_ref = pseudorandom
function pseudorandom(seed, min, max)
    if not min and not max and G and G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config and (j.config.center.key == 'j_Crackedlatro_lucky_one_joker' or j.config.center_key == 'j_Crackedlatro_lucky_one_joker') and not j.debuff then
                if j.ability and j.ability.extra and j.ability.extra.has_four_leaf then
                    j.ability.extra.has_four_leaf = false
                    card_eval_status_text(j, 'extra', nil, nil, nil, { message = 'Clover Miracle!', colour = G.C.GREEN })
                    play_sound('tarot1')
                    return 0.0000000001
                end
            end
        end
    end
    return pseudorandom_ref(seed, min, max)
end
