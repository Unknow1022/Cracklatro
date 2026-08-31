--[[
    Mod: The Cracked Balatro (Cracklatro)
    Author: Unknow102
    Description: Comprehensive Balatro expansion featuring unique Jokers, Secret Rarity, Job Consumables, Custom Booster Packs, Boss Blinds, Decks, Vouchers, Enhancements, and Custom Seals.

    --- RAREZAS PERSONALIZADAS ---
        - Secreto (Rareza exclusiva con badge negro; únicamente invocables mediante el consumible La Muchachada)

    --- JOKERS ---
    Comunes:
        1. Masterful Joker (+25 Mult for Four/Five of a Kind)
        2. Outstanding Joker (+250 Chips, +50 Mult, and $5 for Four/Five of a Kind)
        3. Blueberry (+1 Hand at start of round; self-destructs after 3 rounds)

    Poco Comunes:
        6. Shareholder Joker ($5/$6/$8 when defeating blind in 1 hand)
        7. Builder Joker (+0.1 XMult per Three/Four/Five of a Kind played)
        8. Banquet (Creates Ice Cream, Popcorn, and Ramen when sold)
        9. Appraiser ($1 per card with Edition in your full deck)
        10. Runway (1 in 10 chance to give Edition to enhanced cards)
        11. Slot Machine (Chances for $5, $10, $10,000, or Negative Soul per scored card)
        12. Duel of Value (X3 Mult if Two Pair has 2 even cards and 2 odd cards)
        13. Falta de Lectura (X5 Mult if played hand activates no other Jokers)
        14. Chameleon Joker (Copies ability of Joker to the left if specific rank condition is met)

    Raros:
        15. Doctor Jo. (Saves destroyed Jokers and self-destructs)
        16. Symmetrical Joker (X4 Mult if Four of a Kind is same suit)
        17. Balance (Creates 2 Spectral cards when playing 4-card Four of a Kind of same suit)
        18. Merchant (+1 slot, +1 voucher, +1 pack, 25% discount, +Rare Joker rate; lose $5 when leaving shop)
        19. Lover (Scored Hearts give +50 Chips, +25 Mult, 1 in 4 chance for Negative The Lovers)
        20. Blacksmith (Gains +X0.05 Mult per scored Spade card)
        21. Lucky One (Scored Clubs give $1, +5 Mult, 1 in 4 chance for random Joker)
        22. Miner (Scored Diamonds give X1.5 Mult and +10 Chips; 1 in 7 chance to collapse into Rough Gem)
        23. Joke Joker? (Does nothing... in secret converts Blank Voucher to Antimatter)

    Legendarios:
        24. Perfectionism (At end of round, applies Foil, Holo, or Poly edition to a Joker)

    Secretos:
        25. Esteban (X2.5 Mult for scored Spades and Clubs. "*Ignores the kid*")
        26. Thiago (Gives X1 Mult per 20 Chips in final hand chips. "Son, Hijillo, Brochacho 😭")
        27. Paula (Destroys adjacent Jokers at round start, +X1 Mult per destroyed Joker. "*Ñam Ñam ñam* NOO MAMA ESPERA NO ESTOY COMIENDO")
        28. Black Hole (Elevates final Chips and Mult to ^1.5)
        29. Squele (+10 Mult & X1.5 Mult on Hearts, 1 in 10 chance to Project Negative Bloodstone. "Ahhh me proyecto")
        30. Bluxdir (Levels up discarded poker hand on discard. "*Se pone a farmear aura*")
        31. Charles (X2 Mult on Spades & Hearts, $5 for each scored card. "Pe Causa". Synergy with Mochi)
        32. Mochi (Scored cards turn into Wild Cards, +X0.25 Mult per Wild Card in full deck. "Un dibujo para ti! :3". Synergy with Charles)
        33. Helin (On 1st hand of round, squares final Mult ^2. "Pero que envian al chat")
        34. RayTracing (Creates 2 random Negative Spectrals at end of round. "Depradosini Negrini")
        35. Paco (Gives X2 Mult per remaining discard. "No es necesario descartar, todas las cartas son utiles")

    --- CONSUMIBLES, SELLOS Y MEJORAS ---
        - Hierarchy (Spectral: Destroy hand, create 3 Steel Kings with Red Seal, -1 Hand)
        - Dark Green Seal (Seal: 1 in 10 chance to retrigger 3x, 1 in 5 for 2x, 1 in 2 for 1x; non-cumulative)
        - Order (Spectral: Adds Dark Green Seal to 1 card)
        - Rot (Spectral: Destroy all Jokers including Eternal, create 2 random Eternal Jokers, -1 Discard)
        - Catastrophic (Spectral: +4 levels to most played hand, 3 Negative Planets of most played hand, -1 level to all other hands silently)
        - Intensity (Spectral: Destroy 5 selected cards, create 1 Polychrome Wild Card with Red Seal)
        - La Muchachada (Spectral: Crea un Joker Secreto aleatorio entre los 11 existentes; exclusivo de paquetes espectrales, doble rareza que El Alma)
        - Cartas de Trabajo (Job Cards): The Miner, The Gardener, The Banker, The Surgeon, The Alchemist, The Butcher, The Detective, The Chef, The Archaeologist, The Jeweler
        - Paquetes de Trabajo (Booster Packs): Job Application, Jumbo Job Application, Mega Job Application
        - Mejoras: Diamond Card, Investment Card, Lead Card, Jeweled Card

    --- ETIQUETAS (TAGS) ---
        - Discord Tag (1 in 5 chance to create La Muchachada if room)

    --- VALES (VOUCHERS) ---
        - Catador (Taster): Reduce la aparición de Jokers Comunes en la tienda
        - Crítico (Critic): Elimina por completo los Jokers Comunes de la tienda

    --- CIEGAS JEFE (BOSS BLINDS) ---
        - Boss Blinds: The Pole, The Rod, The Magician, The Mountain, The Door, The Triangle, The Cube
        - Final Boss Blind (Showdown): The Void

    --- BARAJAS ---
        - Caveman Deck (Baraja Cavernícola), Strategist Deck, Overseer Deck

    Based on the Steamodded (SMODS) framework.
--]]

-- ===================================================================
-- 0. RAREZAS Y EFECTOS VISUALES DE UI
-- ===================================================================

local function is_secret_card(card)
    if not card then return false end
    if card.is_secret or (card.config and card.config.center and card.config.center.is_secret) then return true end
    local key = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    key = string.lower(tostring(key))
    local secret_names = {
        'esteban', 'thiago', 'paula', 'black_hole', 'squele', 'bluxdir', 'charles', 'mochi', 'helin', 'raytracing', 'paco'
    }
    for _, name in ipairs(secret_names) do
        if string.find(key, name) then return true end
    end
    return false
end

-------------------------------------------------------------------
--- Job Stickers Atlas y Helper de Oficios
-------------------------------------------------------------------
SMODS.Atlas {
    key = "job_stickers",
    path = "job_stickers.png",
    px = 71,
    py = 95
}

local function get_card_job_info(card)
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

-- Hook para interceptar la generación del UIBox de los Jokers Secretos y Cartas de Oficio de forma segura
local card_generate_UIBox_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(...)
    local is_secret = is_secret_card(self)
    if is_secret then
        G.GAME_IS_RENDERING_SECRET_CARD = true
    end
    local res = card_generate_UIBox_ref(self, ...)
    G.GAME_IS_RENDERING_SECRET_CARD = false
    if is_secret and res and res.badges and #res.badges > 0 then
        res.badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end

    local job = get_card_job_info(self)
    if job and res then
        if res.badges then
            table.insert(res.badges, create_badge(job.name, job.badge_colour, G.C.WHITE, 1.0))
        end
        if res.main then
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
    end

    return res
end

-- Hook en Card:draw para renderizar el sticker del oficio en la carta activa
local card_draw_ref = Card.draw
function Card:draw(layer)
    card_draw_ref(self, layer)
    if (layer == 'card' or layer == 'both' or not layer) and self.ability and self.children and not self.highlighted_shadow then
        local job = get_card_job_info(self)
        if job and G.ASSET_ATLAS and G.ASSET_ATLAS['Cracklatro_job_stickers'] then
            if not self.children.job_sticker then
                self.children.job_sticker = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS['Cracklatro_job_stickers'], { x = job.idx, y = 0 })
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

-- Hook en create_badge para mostrar "Secreto" en fondo negro sólido y limpio
local create_badge_ref = create_badge
function create_badge(text, badge_colour, text_colour, scale)
    if G.GAME_IS_RENDERING_SECRET_CARD and (text == 'Legendary' or text == 'Legendario' or text == 'Secret' or text == 'Secreto' or (localize and text == localize('k_legendary'))) then
        text = 'Secreto'
        badge_colour = HEX('000000')
        text_colour = G.C.WHITE
    end
    return create_badge_ref(text, badge_colour, text_colour, scale)
end

-- Hook en G.UIDEF.use_and_sell_buttons para cambiar "USE" por "PULL" ÚNICAMENTE cuando las cartas están dentro de sobres (G.pack_cards)
if G.UIDEF and G.UIDEF.use_and_sell_buttons then
    local orig_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local uibox = orig_use_and_sell_buttons(card)
        if card and card.area == G.pack_cards and (
            (card.ability and (card.ability.set == 'Job' or card.ability.job or (card.ability.consumeable and card.ability.consumeable.set == 'Job'))) or
            (card.config and card.config.center and (card.config.center.set == 'Job' or card.config.center.job or card.config.center.kind == 'Job' or (card.config.center.key and string.find(card.config.center.key, 'job'))))
        ) then
            local function replace_use_text(node)
                if type(node) == 'table' then
                    if node.config and node.config.text then
                        if type(node.config.text) == 'string' then
                            local upper = string.upper(node.config.text)
                            if upper == 'USE' or upper == 'USAR' or (localize and node.config.text == localize('b_use')) then
                                node.config.text = 'PULL'
                            end
                        end
                    end
                    if node.nodes then
                        for _, child in ipairs(node.nodes) do
                            replace_use_text(child)
                        end
                    end
                end
            end
            replace_use_text(uibox)
        end
        return uibox
    end
end

-- Transición y color de fondo marrón-rojo oscuro para los Paquetes de Trabajo (Job Applications)
local function ease_job_pack_background()
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

-- Hook para localización de paquetes y botones personalizados
if localize then
    local orig_localize = localize
    function localize(args, misc_cat)
        if type(args) == 'string' then
            if args == 'k_job_pack' or args == 'k_job_pack_1' or args == 'k_job_pack_2' or args == 'k_job_pack_3' then
                return 'Job Application'
            elseif args == 'b_pull' then
                return 'PULL'
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

-- Helper global para chequear desbloqueo de 4 palos (Flush) en una misma run
local function check_all_suits_flushed_unlock(self, args)
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

-- Hook para registrar compras de Blank Voucher en el perfil
local card_redeem_ref = Card.redeem
function Card:redeem(...)
    local key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name)
    if key == 'v_blank' or key == 'v_Cracklatro_blank' or key == 'blank' then
        if G.PROFILES and G.SETTINGS and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought = (G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought or 0) + 1
        end
        check_for_unlock({ type = 'blank_voucher_bought' })
    end
    return card_redeem_ref(self, ...)
end

-- Hook para rastrear Lucky Card cuando activa dinero y mult simultáneamente (Slot Machine)
local card_eval_ref = Card.eval_card
function Card:eval_card(context)
    local ret = card_eval_ref(self, context)
    if ret and ret.dollars and (ret.mult or ret.h_mult or ret.x_mult or ret.Xmult) then
        if G.GAME then G.GAME.lucky_hit_both = true end
        check_for_unlock({ type = 'lucky_both' })
    end

    -- Gardener Job: Al descartarse, +2 Fichas permanentes a todas las cartas de su mismo palo
    if context and context.discard and self.ability and self.ability.gardener_job then
        local suit = self.base and self.base.suit
        if suit and G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c.base and c.base.suit == suit then
                    c.ability.perma_bonus = (c.ability.perma_bonus or 0) + 2
                end
            end
            ret = ret or {}
            ret.message = '+2 Chips to ' .. suit .. '!'
            ret.colour = G.C.CHIPS
            ret.card = self
        end
    end

    -- Chef Job: Al puntuar una figura (J, Q, K), transforma las demás cartas puntuadas en Mult Cards
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

    -- Archaeologist Job: Al puntuar en la última mano de la ronda, rescata 1 carta descartada con edición
    if context and (context.main_scoring or context.individual) and context.cardarea == G.play and self.ability and self.ability.archaeologist_job then
        if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left == 0 and not self.ability.archaeologist_triggered_this_hand then
            self.ability.archaeologist_triggered_this_hand = true
            if G.discard and G.discard.cards and #G.discard.cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local rescued = pseudorandom_element(G.discard.cards, 'archaeologist_rescue')
                        if rescued then
                            draw_card(G.discard, G.hand, 100, 'up', nil, rescued)
                            local editions = { 'e_foil', 'e_holo', 'e_polychrome' }
                            local chosen_ed = pseudorandom_element(editions, 'archaeologist_ed')
                            rescued:set_edition(chosen_ed, true)
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

    -- Lead Card: Transmuta a Gold Card al puntuar si la mano derrota la ciega
    local center_key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name)
    if (center_key == 'm_Cracklatro_lead' or center_key == 'm_lead' or center_key == 'Lead Card' or (self.ability and self.ability.name == 'Lead Card')) and context and (context.main_scoring or context.individual) and context.cardarea == G.play then
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

-- Hook para Detective Job en la mano inicial al comenzar la ronda
local setting_blind_detective_ref = Blind.set_blind
if setting_blind_detective_ref then
    function Blind:set_blind(blind, reset, silent)
        local res = setting_blind_detective_ref(self, blind, reset, silent)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.0,
            func = function()
                if G.hand and G.hand.cards then
                    local has_detective = false
                    for _, c in ipairs(G.hand.cards) do
                        if c.ability and c.ability.detective_job then
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
        return res
    end
end

-- Hook para guardar dinero al entrar en la tienda (Merchant)
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

-- ===================================================================
-- 1. JOKERS
-- ===================================================================

-------------------------------------------------------------------
--- 1.1 COMUNES (COMMON)
-------------------------------------------------------------------

-------------------------------------------------------------------
--- 1. Masterful Joker
-------------------------------------------------------------------
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
    rarity = 1, -- Common
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

-------------------------------------------------------------------
--- 4. Outstanding Joker
-------------------------------------------------------------------
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
    rarity = 1, -- Common
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

-------------------------------------------------------------------
--- 5. Blueberry
-------------------------------------------------------------------
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
    rarity = 1, -- Common
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

-------------------------------------------------------------------
--- 1.2 POCO COMUNES (UNCOMMON)
-------------------------------------------------------------------

-------------------------------------------------------------------
--- 6. Shareholder Joker
-------------------------------------------------------------------
SMODS.Atlas {
    key = "shareholder_joker",
    path = "shareholder_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'shareholder_joker',
    atlas = 'shareholder_joker',
    unlocked = false,
    loc_txt = {
        name = 'Shareholder Joker',
        text = {
            "Earn {C:money}$#1#{} ({C:money}$#2#{} on {C:attention}Big Blind{}, {C:money}$#3#{} on {C:attention}Boss Blind{})",
            "when defeating the Blind in only {C:attention}1 hand{}"
        },
        unlock = {
            "Have at least",
            "{C:money}$100{} at once"
        }
    },
    config = { extra = { small = 5, big = 6, boss = 8 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.small, card.ability.extra.big, card.ability.extra.boss } }
    end,
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.dollars and G.GAME.dollars >= 100 then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.current_round and G.GAME.current_round.hands_played == 1 then
                local reward = card.ability.extra.small
                if G.GAME.blind then
                    if G.GAME.blind.boss then
                        reward = card.ability.extra.boss
                    elseif G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' then
                        reward = card.ability.extra.big
                    end
                end
                return {
                    dollars = reward,
                    message = '+$' .. reward,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 7. Builder Joker
-------------------------------------------------------------------
SMODS.Atlas {
    key = "builder_joker",
    path = "builder_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'builder_joker',
    atlas = 'builder_joker',
    unlocked = false,
    loc_txt = {
        name = 'Builder Joker',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult if played hand contains",
            "a {C:attention}Three of a Kind{}, {C:attention}Four of a Kind{},",
            "or {C:attention}Five of a Kind{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        },
        unlock = {
            "Play a {C:attention}Three of a Kind{},",
            "{C:attention}Four of a Kind{}, and {C:attention}Five of a Kind{}",
            "consecutively in one run"
        }
    },
    config = { extra = { xmult = 1.0, xmult_gain = 0.1 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    check_for_unlock = function(self, args)
        if (args.type == 'hand' or args.type == 'play_hand') and args.handname then
            G.GAME.builder_streak = G.GAME.builder_streak or 0
            if args.handname == 'Three of a Kind' then
                G.GAME.builder_streak = 1
            elseif args.handname == 'Four of a Kind' and G.GAME.builder_streak == 1 then
                G.GAME.builder_streak = 2
            elseif (args.handname == 'Five of a Kind' or args.handname == 'Flush Five') and G.GAME.builder_streak == 2 then
                G.GAME.builder_streak = 3
                return true
            else
                G.GAME.builder_streak = (args.handname == 'Three of a Kind' and 1 or 0)
            end
        end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local is_valid_hand = (context.poker_hands['Three of a Kind'] and next(context.poker_hands['Three of a Kind'])) or
                                  (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                                  (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind']))
            if is_valid_hand then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Built!',
                    colour = G.C.MULT
                }
            end
        end

        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-------------------------------------------------------------------
--- 8. Banquet
-------------------------------------------------------------------
SMODS.Atlas {
    key = "banquet_joker",
    path = "banquet_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'banquet_joker',
    atlas = 'banquet_joker',
    loc_txt = {
        name = 'Banquet',
        text = {
            "When {C:attention}sold{}, creates an {C:attention}Ice Cream{},",
            "{C:attention}Popcorn{}, and {C:attention}Ramen{}",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = {} },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local food_jokers = { 'j_ice_cream', 'j_popcorn', 'j_ramen' }
                    for _, food_key in ipairs(food_jokers) do
                        if #G.jokers.cards < G.jokers.config.card_limit then
                            local new_food = create_card('Joker', G.jokers, nil, nil, nil, nil, food_key, nil)
                            new_food:add_to_deck()
                            G.jokers:emplace(new_food)
                        end
                    end
                    return true
                end
            }))
        end
    end
}

-------------------------------------------------------------------
--- 9. Appraiser
-------------------------------------------------------------------
SMODS.Atlas {
    key = "appraiser_joker",
    path = "appraiser_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'appraiser_joker',
    atlas = 'appraiser_joker',
    loc_txt = {
        name = 'Appraiser',
        text = {
            "Earn {C:money}$#1#{} at end of round for each card",
            "with an {C:dark_edition}Edition{} in your {C:attention}full deck{}",
            "{C:inactive}(Foil, Holographic, or Polychrome){}"
        }
    },
    config = { extra = { dollars_per_edition = 1 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability and card.ability.extra and card.ability.extra.dollars_per_edition) or 1 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if pcard.edition and (pcard.edition.foil or pcard.edition.holo or pcard.edition.polychrome) then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                local total_money = count * card.ability.extra.dollars_per_edition
                return {
                    dollars = total_money,
                    message = '+$' .. total_money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 10. Runway
-------------------------------------------------------------------
SMODS.Atlas {
    key = "runway_joker",
    path = "runway_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'runway_joker',
    atlas = 'runway_joker',
    loc_txt = {
        name = 'Runway',
        text = {
            "{C:green}#1# in #2#{} chance for played {C:attention}Enhanced cards{}",
            "to permanently gain a random {C:dark_edition}Edition{}",
            "{C:inactive}(Foil, Holographic, or Polychrome){}"
        }
    },
    config = { extra = { odds = 10 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.scoring_hand then
            for _, pcard in ipairs(context.scoring_hand) do
                local has_enhancement = (pcard.config and pcard.config.center and pcard.config.center ~= G.P_CENTERS.c_base) or (pcard.ability and pcard.ability.effect and pcard.ability.effect ~= 'Base')
                if has_enhancement and not pcard.edition then
                    if pseudorandom('runway') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        local editions = { 'e_foil', 'e_holo', 'e_polychrome' }
                        local chosen_edition = pseudorandom_element(editions, 'runway_choice')
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                pcard:set_edition(chosen_edition, true)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end
}

-------------------------------------------------------------------
--- 11. Slot Machine
-------------------------------------------------------------------
SMODS.Atlas {
    key = "slot_machine_joker",
    path = "slot_machine_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'slot_machine_joker',
    atlas = 'slot_machine_joker',
    unlocked = false,
    loc_txt = {
        name = 'Slot Machine',
        text = {
            "Each scored card has a chance to win:",
            "{C:green}#1# in 8{}: {C:money}$3{} | {C:green}#1# in 15{}: {C:money}$5{} | {C:green}#1# in 25{}: {C:money}$15{} | {C:green}#1# in 35{}: {C:money}$30{}",
            "{C:green}#1# in 40{}: {C:attention}Uncommon Joker{} | {C:green}#1# in 65{}: {C:red}Rare Joker{}",
            "{C:green}#1# in 125{}: {C:dark_edition}Negative{} {C:red}Rare Joker{}",
            "{C:green}#1# in 200{}: {C:dark_edition}Negative{} {C:eternal}Eternal{} {C:attention}Blueprint{}",
            "{C:green}#1# in 777{}: {C:dark_edition}Negative{} {C:spectral}The Soul{}"
        },
        unlock = {
            "Trigger both {C:mult}+20 Mult{} and",
            "{C:money}$20{} from a single",
            "{C:attention}Lucky Card{}"
        }
    },
    config = { extra = { odds_base = 1 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'lucky_both' or (G.GAME and G.GAME.lucky_hit_both) then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local prob = (G.GAME and G.GAME.probabilities.normal or 1)
            local hit = false
            local ret = {}

            -- $3 (1 in 8)
            if pseudorandom('slot_3') < prob / 8 then
                ease_dollars(3)
                ret.dollars = (ret.dollars or 0) + 3
                hit = true
            end

            -- $5 (1 in 15)
            if pseudorandom('slot_5') < prob / 15 then
                ease_dollars(5)
                ret.dollars = (ret.dollars or 0) + 5
                hit = true
            end

            -- $15 (1 in 25)
            if pseudorandom('slot_15') < prob / 25 then
                ease_dollars(15)
                ret.dollars = (ret.dollars or 0) + 15
                hit = true
            end

            -- $30 (1 in 35)
            if pseudorandom('slot_30') < prob / 35 then
                ease_dollars(30)
                ret.dollars = (ret.dollars or 0) + 30
                hit = true
            end

            -- Uncommon Joker (1 in 40)
            if pseudorandom('slot_uncommon') < prob / 40 then
                if #G.jokers.cards < G.jokers.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_joker = create_card('Joker', G.jokers, nil, 0.8, nil, nil, nil, 'slot_uncommon')
                            new_joker:add_to_deck()
                            G.jokers:emplace(new_joker)
                            return true
                        end
                    }))
                    hit = true
                end
            end

            -- Rare Joker (1 in 65)
            if pseudorandom('slot_rare') < prob / 65 then
                if #G.jokers.cards < G.jokers.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_joker = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'slot_rare')
                            new_joker:add_to_deck()
                            G.jokers:emplace(new_joker)
                            return true
                        end
                    }))
                    hit = true
                end
            end

            -- Negative Rare Joker (1 in 125)
            if pseudorandom('slot_neg_rare') < prob / 125 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_joker = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'slot_neg_rare')
                        new_joker:set_edition({negative = true}, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        return true
                    end
                }))
                hit = true
                ret.message = 'NEGATIVE RARE!'
                ret.colour = G.C.DARK_EDITION
            end

            -- Negative Eternal Blueprint (1 in 200)
            if pseudorandom('slot_blueprint') < prob / 200 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local blueprint = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_blueprint', 'slot_blueprint')
                        blueprint:set_edition({negative = true}, true)
                        blueprint.eternal = true
                        if blueprint.ability then
                            blueprint.ability.eternal = true
                        end
                        blueprint:add_to_deck()
                        G.jokers:emplace(blueprint)
                        return true
                    end
                }))
                hit = true
                ret.message = 'BLUEPRINT!'
                ret.colour = G.C.BLUE
            end

            -- Negative Soul (1 in 777)
            if pseudorandom('slot_soul') < prob / 777 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local soul_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_soul', 'slot_soul')
                        soul_card:set_edition({negative = true}, true)
                        soul_card:add_to_deck()
                        G.consumeables:emplace(soul_card)
                        return true
                    end
                }))
                hit = true
                ret.message = 'JACKPOT!'
                ret.colour = G.C.DARK_EDITION
            end

            if hit then
                ret.card = card
                return ret
            end
        end
    end
}

-------------------------------------------------------------------
--- 12. Duel of Value
-------------------------------------------------------------------
SMODS.Atlas {
    key = "duel_of_value_joker",
    path = "duel_of_value_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'duel_of_value_joker',
    atlas = 'duel_of_value_joker',
    unlocked = false,
    loc_txt = {
        name = 'Duel of Value',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand is a {C:attention}Two Pair{}",
            "scored with exactly {C:attention}2 even{} and {C:attention}2 odd{} cards",
            "{C:inactive}(Art by kars_on_mars){}"
        },
        unlock = {
            "Reach {C:attention}Ante 8{} holding both",
            "{C:attention}Odd Todd{} and {C:attention}Even Steven{}"
        }
    },
    config = { extra = { xmult = 3.0 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 8 then
            local has_odd = false
            local has_even = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    local k = (j.config and j.config.center and j.config.center.key) or j.config.center_key or (j.ability and j.ability.name)
                    if k == 'j_odd_todd' or k == 'odd_todd' then has_odd = true end
                    if k == 'j_even_steven' or k == 'even_steven' then has_even = true end
                end
            end
            if has_odd and has_even then
                return true
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and context.poker_hands['Two Pair'] and next(context.poker_hands['Two Pair']) then
            local evens = 0
            local odds = 0
            if context.scoring_hand then
                for _, scard in ipairs(context.scoring_hand) do
                    local id = scard:get_id()
                    if id and id > 0 then
                        if id % 2 == 0 then
                            evens = evens + 1
                        else
                            odds = odds + 1
                        end
                    end
                end
            end
            if evens == 2 and odds == 2 then
                return {
                    Xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 13. Falta de Lectura
-------------------------------------------------------------------
SMODS.Atlas {
    key = "falta_de_lectura_joker",
    path = "falta_de_lectura_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'falta_de_lectura_joker',
    atlas = 'falta_de_lectura_joker',
    unlocked = false,
    loc_txt = {
        name = 'Falta de Lectura',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand",
            "activates {C:attention}no other Jokers{}"
        },
        unlock = {
            "Play a scoring hand that",
            "activates {C:attention}no Jokers{}"
        }
    },
    config = { extra = { xmult = 5.0 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'no_jokers_activated' or (G.GAME and G.GAME.no_jokers_activated_hand) then
            return true
        end
    end,
    calculate = function(self, card, context)
        if context.before then
            G.GAME.falta_de_lectura_other_activated = false
        end

        if context.joker_main then
            if G.GAME.falta_de_lectura_other_activated then
                return nil
            end

            local other_will_activate = false
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    local jkey = (j.config and j.config.center and j.config.center.key) or j.config.center_key or (j.ability and j.ability.name)
                    local is_self = (jkey == 'j_Cracklatro_falta_de_lectura_joker' or jkey == 'falta_de_lectura_joker' or jkey == 'j_falta_de_lectura_joker' or jkey == 'falta_de_lectura')
                    if not is_self and not j.debuff and j.calculate_joker then
                        local check_ctx = {}
                        for k, v in pairs(context) do check_ctx[k] = v end
                        check_ctx.falta_de_lectura_check = true
                        local res = j:calculate_joker(check_ctx)
                        if res and type(res) == 'table' and next(res) then
                            if res.mult or res.chips or res.Xmult or res.x_mult or res.dollars or res.x_chips or res.p_dollars or res.message or res.swap then
                                other_will_activate = true
                                break
                            end
                        end
                    end
                end
            end

            if not other_will_activate then
                check_for_unlock({ type = 'no_jokers_activated' })
                return {
                    Xmult = card.ability.extra.xmult,
                    message = 'Lee porfavor',
                    colour = G.C.XMULT
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 1.3 RAROS (RARE)
-------------------------------------------------------------------

-------------------------------------------------------------------
--- 13. Doctor Jo.
-------------------------------------------------------------------
SMODS.Atlas {
    key = "doctor_jo_joker",
    path = "doctor_jo_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'doctor_jo_joker',
    atlas = 'doctor_jo_joker',
    loc_txt = {
        name = 'Doctor Jo.',
        text = {
            "When another compatible {C:attention}Joker{} is {C:red}destroyed{},",
            "{C:attention}Doctor Jo. self-destructs{} to create an exact",
            "copy of it without debuffs or negative stickers",
            "{C:inactive}(e.g. Perishable, Rental, Debuffed){}"
        }
    },
    config = { extra = {} },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    blueprint_compat = false
}

-- Hook on Card.start_dissolve for Doctor Jo.
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
                        
                        -- Clear all debuffs, perishable, and negative modifiers
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

                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        
                        return true
                    end
                }))
            end
        end
    end
    return card_start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_sound)
end

-------------------------------------------------------------------
--- 14. Symmetrical Joker
-------------------------------------------------------------------
SMODS.Atlas {
    key = "symmetrical_joker",
    path = "symmetrical_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'symmetrical_joker',
    atlas = 'symmetrical_joker',
    loc_txt = {
        name = 'Symmetrical Joker',
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand is a",
            "{C:attention}Four of a Kind{} or {C:attention}Five of a Kind{}",
            "where all scoring cards share the {C:attention}same suit{}"
        }
    },
    config = { extra = { xmult = 4.0 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand and context.poker_hands then
            local is_poker = (context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind'])) or
                             (context.poker_hands['Five of a Kind'] and next(context.poker_hands['Five of a Kind'])) or
                             (context.poker_hands['Flush Five'] and next(context.poker_hands['Flush Five']))
            if is_poker then
                local first_suit = context.scoring_hand[1] and context.scoring_hand[1].base and context.scoring_hand[1].base.suit
                local same_suit = true
                for _, pcard in ipairs(context.scoring_hand) do
                    if not pcard.base or pcard.base.suit ~= first_suit then
                        same_suit = false
                        break
                    end
                end
                if same_suit then
                    return {
                        Xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
}

-------------------------------------------------------------------
--- 15. Balance
-------------------------------------------------------------------
SMODS.Atlas {
    key = "balance_joker",
    path = "balance_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'balance_joker',
    atlas = 'balance_joker',
    loc_txt = {
        name = 'Balance',
        text = {
            "Creates {C:spectral}#2# Spectral cards{} if played hand",
            "is a {C:attention}Four of a Kind{} with exactly {C:attention}#1# scoring cards{}",
            "of the {C:attention}same suit{} {C:inactive}(Must have room){}"
        }
    },
    config = { extra = { cards_needed = 4, spectral_count = 2 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_needed, card.ability.extra.spectral_count } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and context.poker_hands['Four of a Kind'] and next(context.poker_hands['Four of a Kind']) then
            if context.scoring_hand and #context.scoring_hand == 4 then
                local same_suit = false
                local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                for _, suit in ipairs(suits) do
                    local matches_all = true
                    for _, pcard in ipairs(context.scoring_hand) do
                        if not pcard:is_suit(suit) then
                            matches_all = false
                            break
                        end
                    end
                    if matches_all then
                        same_suit = true
                        break
                    end
                end

                if same_suit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for i = 1, card.ability.extra.spectral_count do
                                if #G.consumeables.cards < G.consumeables.config.card_limit then
                                    local spectral_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'balance')
                                    spectral_card:add_to_deck()
                                    G.consumeables:emplace(spectral_card)
                                end
                            end
                            return true
                        end
                    }))
                    return {
                        message = 'Balance!',
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
            end
        end
    end
}

-------------------------------------------------------------------
--- 16. Merchant
-------------------------------------------------------------------
SMODS.Atlas {
    key = "merchant_joker",
    path = "merchant_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'merchant_joker',
    atlas = 'merchant_joker',
    unlocked = false,
    loc_txt = {
        name = 'Merchant',
        text = {
            "In shop: {C:attention}+1{} Card slot, {C:attention}+1{} Voucher, {C:attention}+1{} Booster Pack,",
            "{C:money}25% discount{} on all items, and {C:red}higher Rare Joker rate{}",
            "Lose {C:money}$#1#{} when leaving the shop"
        },
        unlock = {
            "Enter a shop with at least {C:money}$50{}",
            "and leave with {C:money}$10{} or less"
        }
    },
    config = { extra = { cost_per_shop = 5 } },
    rarity = 2, -- Uncommon
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost_per_shop } }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'leave_shop' or args.type == 'ending_shop' then
            if G.GAME and G.GAME.entered_shop_dollars and G.GAME.entered_shop_dollars >= 50 and (G.GAME.dollars or 0) <= 10 then
                return true
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
        G.GAME.modifiers.extra_vouchers = (G.GAME.modifiers.extra_vouchers or 0) + 1
        G.GAME.modifiers.extra_packs = (G.GAME.modifiers.extra_packs or 0) + 1
        G.GAME.discount_percent = (G.GAME.discount_percent or 0) + 25
        G.GAME.merchant_rare_boost = (G.GAME.merchant_rare_boost or 0) + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = math.max(1, (G.GAME.shop.joker_max or 3) - 1)
        G.GAME.modifiers.extra_vouchers = math.max(0, (G.GAME.modifiers.extra_vouchers or 0) - 1)
        G.GAME.modifiers.extra_packs = math.max(0, (G.GAME.modifiers.extra_packs or 0) - 1)
        G.GAME.discount_percent = math.max(0, (G.GAME.discount_percent or 0) - 25)
        G.GAME.merchant_rare_boost = math.max(0, (G.GAME.merchant_rare_boost or 0) - 1)
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            ease_dollars(-card.ability.extra.cost_per_shop)
            return {
                message = '-$' .. card.ability.extra.cost_per_shop,
                colour = G.C.MONEY
            }
        end
    end
}

-------------------------------------------------------------------
--- 17. Lover
-------------------------------------------------------------------
SMODS.Atlas {
    key = "lover_joker",
    path = "lover_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'lover_joker',
    atlas = 'lover_joker',
    unlocked = false,
    loc_txt = {
        name = 'Lover',
        text = {
            "Scored {C:hearts}Hearts{} give {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to create a {C:dark_edition}Negative{}",
            "{C:tarot}The Lovers{} Tarot card {C:inactive}(Must have room){}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { chips = 50, mult = 25, odds = 4 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') then
                if pseudorandom('lover_joker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local lovers_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_lovers')
                            lovers_card:set_edition({negative = true}, true)
                            lovers_card:add_to_deck()
                            G.consumeables:emplace(lovers_card)
                            return true
                        end
                    }))
                end
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 18. Blacksmith
-------------------------------------------------------------------
SMODS.Atlas {
    key = "blacksmith_joker",
    path = "blacksmith_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'blacksmith_joker',
    atlas = 'blacksmith_joker',
    unlocked = false,
    loc_txt = {
        name = 'Blacksmith',
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for each",
            "scored {C:spades}Spade{} card played",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { xmult = 1.0, xmult_gain = 0.05 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit('Spades') then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-------------------------------------------------------------------
--- 19. Lucky One
-------------------------------------------------------------------
SMODS.Atlas {
    key = "lucky_one_joker",
    path = "lucky_one_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'lucky_one_joker',
    atlas = 'lucky_one_joker',
    unlocked = false,
    loc_txt = {
        name = 'Lucky One',
        text = {
            "Scored {C:clubs}Clubs{} give {C:money}$#1#{} and {C:mult}+#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to create a random",
            "{C:attention}Common{} or {C:attention}Uncommon Joker{} {C:inactive}(Must have room){}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { dollars = 1, mult = 5, odds = 4 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.mult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Clubs') then
                if pseudorandom('lucky_one_joker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    if #G.jokers.cards < G.jokers.config.card_limit then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local rarities = { 0, 0.8 } -- 0: Common, 0.8: Uncommon
                                local chosen_rarity = pseudorandom_element(rarities, 'lucky_one_rarity')
                                local new_joker = create_card('Joker', G.jokers, nil, chosen_rarity, nil, nil, nil, 'lucky_one')
                                new_joker:add_to_deck()
                                G.jokers:emplace(new_joker)
                                return true
                            end
                        }))
                    end
                end
                return {
                    dollars = card.ability.extra.dollars,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 20. Miner
-------------------------------------------------------------------
SMODS.Atlas {
    key = "miner_joker",
    path = "miner_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'miner_joker',
    atlas = 'miner_joker',
    unlocked = false,
    loc_txt = {
        name = 'Miner',
        text = {
            "Scored {C:diamonds}Diamonds{} give {X:mult,C:white}X#1#{} Mult and {C:chips}+#2#{} Chips.",
            "{C:green}#3# in #4#{} chance at end of round to collapse and",
            "transform into a {C:attention}Rough Gem{}"
        },
        unlock = {
            "Play a {C:attention}Flush{} of all 4 suits",
            "{C:inactive}(Hearts, Spades, Clubs, Diamonds){}",
            "in a single run"
        }
    },
    config = { extra = { xmult = 1.5, chips = 10, odds = 7 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.chips, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = check_all_suits_flushed_unlock,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') then
                return {
                    x_mult = card.ability.extra.xmult,
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if pseudorandom('miner_cavein') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve()
                        local gem = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_rough_gem')
                        gem:add_to_deck()
                        G.jokers:emplace(gem)
                        return true
                    end
                }))
                return {
                    message = 'CAVE-IN!',
                    colour = G.C.RED
                }
            else
                return {
                    message = 'Mining!',
                    colour = G.C.GOLD
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 21. Joke Joker?
-------------------------------------------------------------------
SMODS.Atlas {
    key = "joke_joker",
    path = "joke_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'joke_joker',
    atlas = 'joke_joker',
    unlocked = false,
    loc_txt = {
        name = 'Joke Joker?',
        text = {
            "Does nothing... or does it?"
        },
        unlock = {
            "Redeem the {C:attention}Blank Voucher{}",
            "a total of {C:attention}2 times{}"
        }
    },
    config = { extra = {} },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    check_for_unlock = function(self, args)
        local count = (G.PROFILES and G.SETTINGS and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].blank_vouchers_bought) or 0
        if count >= 2 then
            return true
        end
    end,
    calculate = function(self, card, context)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_blank'] then
            G.GAME.used_vouchers['v_blank'] = nil
            G.GAME.used_vouchers['v_antimatter'] = true
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            return {
                message = 'Antimatter!',
                colour = G.C.SECONDARY_SET.Voucher
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_blank'] then
            G.GAME.used_vouchers['v_blank'] = nil
            G.GAME.used_vouchers['v_antimatter'] = true
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    end
}

-------------------------------------------------------------------
--- 25. Camaleón (Chameleon)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "chameleon_joker",
    path = "chameleon_joker.png",
    px = 71,
    py = 95
}

local function get_available_deck_ranks()
    local ranks = {}
    local seen = {}
    if G.playing_cards then
        for _, pcard in ipairs(G.playing_cards) do
            local val = pcard.base and pcard.base.value
            if val and not seen[val] then
                seen[val] = true
                table.insert(ranks, val)
            end
        end
    end
    return ranks
end

local function ensure_chameleon_rank(card)
    card.ability = card.ability or {}
    card.ability.extra = card.ability.extra or {}
    local ranks = get_available_deck_ranks()
    if #ranks > 0 then
        local current = card.ability.extra.required_rank
        local found = false
        if current then
            for _, r in ipairs(ranks) do
                if r == current then found = true; break end
            end
        end
        if not found or not current then
            card.ability.extra.required_rank = pseudorandom_element(ranks, 'chameleon_rank')
        end
    else
        card.ability.extra.required_rank = card.ability.extra.required_rank or 'Ace'
    end
end

SMODS.Joker {
    key = 'chameleon_joker',
    atlas = 'chameleon_joker',
    loc_txt = {
        name = 'Chameleon',
        text = {
            "Copies ability of the {C:attention}Joker to the left{}",
            "if played hand contains at least one {C:attention}#1#{}",
            "{C:inactive}(Rank changes every round from full deck){}"
        }
    },
    config = { extra = { required_rank = 'Ace' } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        ensure_chameleon_rank(card)
        return { vars = { card.ability.extra.required_rank or 'Ace' } }
    end,
    calculate = function(self, card, context)
        ensure_chameleon_rank(card)

        if context.setting_blind and not context.blueprint then
            local ranks = get_available_deck_ranks()
            if #ranks > 0 then
                card.ability.extra.required_rank = pseudorandom_element(ranks, 'chameleon_rank_round')
            end
        end

        -- Check if played hand contains required rank card
        local rank_played = false
        local target_rank = card.ability.extra.required_rank
        local cards_to_check = context.full_hand or context.scoring_hand or (G.play and G.play.cards)

        if cards_to_check then
            for _, c in ipairs(cards_to_check) do
                if c.base and c.base.value == target_rank then
                    rank_played = true
                    break
                end
            end
        end

        -- If required rank was played, copy the Joker to the left
        if rank_played and G.jokers and G.jokers.cards then
            local my_idx = nil
            for idx, j in ipairs(G.jokers.cards) do
                if j == card then my_idx = idx; break end
            end

            if my_idx and my_idx > 1 then
                local left_joker = G.jokers.cards[my_idx - 1]
                if left_joker and left_joker ~= card then
                    context.blueprint = (context.blueprint or 0) + 1
                    context.blueprint_card = card
                    local ret = left_joker:calculate_joker(context)
                    if ret then
                        ret.card = card
                        return ret
                    end
                end
            end
        end
    end
}

-------------------------------------------------------------------
--- 1.4 LEGENDARIOS (LEGENDARY)
-------------------------------------------------------------------

local function is_wild_card(pcard)
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

-------------------------------------------------------------------
--- 1.5 SECRETOS (SECRET)
-------------------------------------------------------------------

-------------------------------------------------------------------
--- 22. Esteban
-------------------------------------------------------------------
SMODS.Atlas {
    key = "esteban_joker",
    path = "esteban_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'esteban',
    atlas = 'esteban_joker',
    loc_txt = {
        name = 'Esteban',
        text = {
            "Scored {C:spades}Spades{} and {C:clubs}Clubs{}",
            "cards give {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(\"*Ignores the kid*\")"
        }
    },
    config = { extra = { xmult = 2.5 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    -- Exclusivo: no aparece en tiendas, sobres ni cartas The Soul
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 2.5
        return { vars = { xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') then
                return {
                    x_mult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 2.5,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 26. Thiago
-------------------------------------------------------------------
SMODS.Atlas {
    key = "thiago_joker",
    path = "thiago_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'thiago',
    atlas = 'thiago_joker',
    loc_txt = {
        name = 'Thiago',
        text = {
            "Gives {X:mult,C:white}X1{} Mult for every",
            "{C:chips}#1# Chips{} in final hand chips",
            "{C:inactive}(\"Son, Hijillo, Brochacho 😭\")"
        }
    },
    config = { extra = { chips_per_xmult = 20 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    -- Exclusivo: no aparece en tiendas, sobres ni cartas The Soul
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local chips_req = (card and card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or (self.config and self.config.extra and self.config.extra.chips_per_xmult) or 20
        return { vars = { chips_req } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_chips = (hand_chips and hand_chips > 0 and hand_chips) or (context.chips and context.chips > 0 and context.chips) or 0
            local chips_req = (card.ability and card.ability.extra and card.ability.extra.chips_per_xmult) or 20
            local xmult = math.floor(current_chips / chips_req)
            if xmult > 1 then
                return {
                    Xmult = xmult,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 27. Paula
-------------------------------------------------------------------
SMODS.Atlas {
    key = "paula_joker",
    path = "paula_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'paula',
    atlas = 'paula_joker',
    loc_txt = {
        name = 'Paula',
        text = {
            "At start of round, {C:red}destroys{} adjacent",
            "Jokers and gains {X:mult,C:white}+X1{} Mult",
            "for each Joker destroyed",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}",
            "{C:inactive}(\"*Ñam Ñam ñam* NOO MAMA ESPERA NO ESTOY COMIENDO\")"
        }
    },
    config = { extra = { xmult = 1.0 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    -- Exclusivo: no aparece en tiendas, sobres ni cartas The Soul
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 1.0
        return { vars = { xmult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        my_pos = i
                        break
                    end
                end
            end
            if my_pos then
                local jokers_to_destroy = {}
                if my_pos > 1 then
                    local left_j = G.jokers.cards[my_pos - 1]
                    if left_j and not (left_j.ability and left_j.ability.eternal) and not left_j.getting_sliced then
                        table.insert(jokers_to_destroy, left_j)
                    end
                end
                if my_pos < #G.jokers.cards then
                    local right_j = G.jokers.cards[my_pos + 1]
                    if right_j and not (right_j.ability and right_j.ability.eternal) and not right_j.getting_sliced then
                        table.insert(jokers_to_destroy, right_j)
                    end
                end

                if #jokers_to_destroy > 0 then
                    for _, j in ipairs(jokers_to_destroy) do
                        j.getting_sliced = true
                    end
                    local count = #jokers_to_destroy
                    card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + count
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for _, j in ipairs(jokers_to_destroy) do
                                j:start_dissolve()
                            end
                            return true
                        end
                    }))
                    return {
                        message = '*Ñam Ñam ñam*',
                        colour = G.C.XMULT
                    }
                end
            end
        end

        if context.joker_main and card.ability.extra.xmult and card.ability.extra.xmult > 1 then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
    end
}

-------------------------------------------------------------------
--- 23. Black Hole (Agujero Negro - Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "black_hole_joker",
    path = "black_hole_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'black_hole_joker',
    atlas = 'black_hole_joker',
    loc_txt = {
        name = 'Black Hole',
        text = {
            "Elevates final {C:chips}Chips{} to the power of {C:chips}^#1#{}",
            "and final {C:mult}Mult{} to the power of {C:mult}^#1#{}"
        }
    },
    config = { extra = { pow = 1.5 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    -- Exclusivo: no aparece en tiendas, sobres ni cartas The Soul
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local pow = (card and card.ability and card.ability.extra and card.ability.extra.pow) or (self.config and self.config.extra and self.config.extra.pow) or 1.5
        return { vars = { pow } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local pow = (card.ability and card.ability.extra and card.ability.extra.pow) or 1.5

            if hand_chips and hand_chips > 1 then
                hand_chips = math.floor(hand_chips ^ pow)
            end
            if mult and mult > 1 then
                mult = math.floor(mult ^ pow)
            end

            update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })

            return {
                message = '^' .. tostring(pow) .. '!',
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end
}

-------------------------------------------------------------------
--- 28. Squele (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "squele_joker",
    path = "squele_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'squele',
    atlas = 'squele_joker',
    loc_txt = {
        name = 'Squele',
        text = {
            "Scored {C:hearts}Hearts{} cards give {C:mult}+#1#{} Mult",
            "and {X:mult,C:white}X#2#{} Mult.",
            "{C:green}#3# in #4#{} chance to {C:attention}Project{} and create",
            "a {C:dark_edition}Negative{} {C:attention}Bloodstone{}",
            "{C:inactive}(\"Ahhh me proyecto\")"
        }
    },
    config = { extra = { mult = 10, xmult = 1.5, odds = 10 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local mult = (card and card.ability and card.ability.extra and card.ability.extra.mult) or (self.config and self.config.extra and self.config.extra.mult) or 10
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 1.5
        local odds = (card and card.ability and card.ability.extra and card.ability.extra.odds) or (self.config and self.config.extra and self.config.extra.odds) or 10
        return { vars = { mult, xmult, (G.GAME and G.GAME.probabilities.normal or 1), odds } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit('Hearts') then
            local norm = (G.GAME and G.GAME.probabilities.normal or 1)
            local odds = (card.ability and card.ability.extra and card.ability.extra.odds) or 10
            local does_project = pseudorandom('squele_project') < (norm / odds)

            if does_project and G.jokers then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_j = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_bloodstone', 'squele')
                        new_j:set_edition({ negative = true }, true)
                        new_j:add_to_deck()
                        G.jokers:emplace(new_j)
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Negative Bloodstone!', colour = G.C.DARK_EDITION })
                        return true
                    end
                }))
                return {
                    mult = card.ability.extra.mult,
                    x_mult = card.ability.extra.xmult,
                    card = card
                }
            else
                return {
                    mult = card.ability.extra.mult,
                    x_mult = card.ability.extra.xmult,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 29. Bluxdir (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "bluxdir_joker",
    path = "bluxdir_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'bluxdir',
    atlas = 'bluxdir_joker',
    loc_txt = {
        name = 'Bluxdir',
        text = {
            "When a hand is {C:attention}discarded{},",
            "levels up the discarded {C:attention}poker hand{}",
            "{C:inactive}(\"*Se pone a farmear aura*\")"
        }
    },
    config = {},
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.hook and context.full_hand and #context.full_hand > 0 then
            local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
            if text and text ~= 'NULL' and G.GAME and G.GAME.hands and G.GAME.hands[text] then
                level_up_hand(card, text, false, 1)
            end
        end
    end
}

-------------------------------------------------------------------
--- 30. Charles (Secreto)
-------------------------------------------------------------------
local function is_charles_card(card)
    if not card then return false end
    local k = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    k = string.lower(tostring(k))
    return string.find(k, 'charles') ~= nil
end

local function is_mochi_card(card)
    if not card then return false end
    local k = (card.config and card.config.center and card.config.center.key) or card.config.center_key or (card.ability and card.ability.name) or ''
    k = string.lower(tostring(k))
    return string.find(k, 'mochi') ~= nil
end

local function has_charles_and_mochi()
    if not (G.jokers and G.jokers.cards) then return false end
    local has_charles = false
    local has_mochi = false
    for _, j in ipairs(G.jokers.cards) do
        if is_charles_card(j) then has_charles = true end
        if is_mochi_card(j) then has_mochi = true end
    end
    return has_charles and has_mochi
end

SMODS.Atlas {
    key = "charles_joker",
    path = "charles_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'charles',
    atlas = 'charles_joker',
    loc_txt = {
        name = 'Charles',
        text = {
            "Scored {C:spades}Spades{} and {C:hearts}Hearts{} cards",
            "give {X:mult,C:white}X#1#{} Mult.",
            "Earn {C:money}$#2#{} for {C:attention}each scored card{}.",
            "{C:inactive}(\"Pe Causa\")"
        }
    },
    config = { extra = { xmult = 2, dollars = 5 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult) or (self.config and self.config.extra and self.config.extra.xmult) or 2
        local dollars = (card and card.ability and card.ability.extra and card.ability.extra.dollars) or (self.config and self.config.extra and self.config.extra.dollars) or 5
        return { vars = { xmult, dollars } }
    end,
    calculate = function(self, card, context)
        -- Charles + Mochi Synergy: Retrigger cards 1 time
        if context.repetition and context.cardarea == G.play then
            if has_charles_and_mochi() then
                return {
                    repetitions = 1,
                    card = card
                }
            end
        end

        -- Charles + Mochi Synergy: End of round message (1 sola vez al ganar la ronda)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if has_charles_and_mochi() then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = '¡Mejores amigos!', colour = HEX('ff69b4') })
                        card:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end
        end

        if context.individual and context.cardarea == G.play then
            local dollars = (card.ability and card.ability.extra and card.ability.extra.dollars) or 5
            local gives_xmult = context.other_card:is_suit('Spades') or context.other_card:is_suit('Hearts')
            local xmult = (card.ability and card.ability.extra and card.ability.extra.xmult) or 2

            ease_dollars(dollars)
            if gives_xmult then
                return {
                    x_mult = xmult,
                    dollars = dollars,
                    card = card
                }
            else
                return {
                    dollars = dollars,
                    card = card
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 31. Mochi (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "mochi_joker",
    path = "mochi_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'mochi',
    atlas = 'mochi_joker',
    loc_txt = {
        name = 'Mochi',
        text = {
            "Scored cards become {C:attention}Wild Cards{}.",
            "Gives {X:mult,C:white}+X#1#{} Mult for each",
            "{C:attention}Wild Card{} in your full deck",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            "{C:inactive}(\"Un dibujo para ti! :3\")"
        }
    },
    config = { extra = { xmult_gain = 0.25 } },
    rarity = 4, -- Legendary tier internamente para animación 2-layer
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local xmult_gain = (card and card.ability and card.ability.extra and card.ability.extra.xmult_gain) or (self.config and self.config.extra and self.config.extra.xmult_gain) or 0.25
        local wild_count = 0
        if G.playing_cards then
            for _, pcard in ipairs(G.playing_cards) do
                if is_wild_card(pcard) then
                    wild_count = wild_count + 1
                end
            end
        end
        local current_xmult = 1.0 + (wild_count * xmult_gain)
        return { vars = { xmult_gain, current_xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config and context.other_card.config.center ~= G.P_CENTERS.m_wild then
                context.other_card:set_ability(G.P_CENTERS.m_wild)
                context.other_card:juice_up()
            end
        end

        if context.joker_main then
            local wild_count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if is_wild_card(pcard) then
                        wild_count = wild_count + 1
                    end
                end
            end
            local xmult_gain = (card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 0.25
            local total_xmult = 1.0 + (wild_count * xmult_gain)
            if total_xmult > 1 then
                return {
                    Xmult = total_xmult
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 32. Helin (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "helin_joker",
    path = "helin_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'helin',
    atlas = 'helin_joker',
    loc_txt = {
        name = 'Helin',
        text = {
            "On {C:attention}first hand{} of round,",
            "elevates final {C:mult}Mult{} to the power of {X:mult,C:white}^#1#{}",
            "{C:inactive}(\"Pero que envian al chat\")"
        }
    },
    config = { extra = { power = 2 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local power = (card and card.ability and card.ability.extra and card.ability.extra.power) or (self.config and self.config.extra and self.config.extra.power) or 2
        return { vars = { power } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0 then
            local pow = (card.ability and card.ability.extra and card.ability.extra.power) or 2

            if mult and mult > 1 then
                mult = math.floor(mult ^ pow)
            end

            update_hand_text({ sound = 'multhit2', modded = true }, { mult = mult })

            return {
                message = '^' .. tostring(pow) .. ' Mult!',
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end
}

-------------------------------------------------------------------
--- 33. RayTracing (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "raytracing_joker",
    path = "raytracing_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'raytracing',
    atlas = 'raytracing_joker',
    loc_txt = {
        name = 'RayTracing',
        text = {
            "Creates {C:attention}2{} random {C:dark_edition}Negative{}",
            "{C:spectral}Spectral{} cards at end of round",
            "{C:inactive}(Except La Muchachada){}",
            "{C:inactive}(\"Depradosini Negrini\")"
        }
    },
    config = {},
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local spectral_cards = {}
                    if G.P_CENTER_POOLS and G.P_CENTER_POOLS['Spectral'] then
                        for _, center in ipairs(G.P_CENTER_POOLS['Spectral']) do
                            if center.key ~= 'c_Cracklatro_la_muchachada' and center.key ~= 'c_la_muchachada' and center.key ~= 'la_muchachada' then
                                table.insert(spectral_cards, center.key)
                            end
                        end
                    end
                    for i = 1, 2 do
                        local chosen_spectral = (#spectral_cards > 0) and pseudorandom_element(spectral_cards, 'raytracing_spectral') or 'c_ankh'
                        local new_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, chosen_spectral, 'raytracing')
                        new_card:set_edition({ negative = true }, true)
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                    end
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+2 Negative Spectrals!', colour = G.C.DARK_EDITION })
                    card:juice_up(0.6, 0.6)
                    return true
                end
            }))
        end
    end
}

-------------------------------------------------------------------
--- 34. Paco (Secreto)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "paco_joker",
    path = "paco_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'paco',
    atlas = 'paco_joker',
    loc_txt = {
        name = 'Paco',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult for each",
            "remaining {C:attention}discard{} you currently have",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            "{C:inactive}(\"No es necesario descartar, todas las cartas son utiles\")"
        }
    },
    config = { extra = { xmult_per_discard = 2 } },
    rarity = 4,
    is_secret = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 20,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
    end,
    set_badges = function(self, card, badges)
        if badges and #badges > 0 then
            badges[1] = create_badge('Secreto', HEX('000000'), G.C.WHITE, 1.2)
        end
    end,
    loc_vars = function(self, info_queue, card)
        local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
        local xmult_per_discard = (card and card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or (self.config and self.config.extra and self.config.extra.xmult_per_discard) or 2
        local total_xmult = math.max(1, discards * xmult_per_discard)
        return { vars = { xmult_per_discard, total_xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
            local xmult_per_discard = (card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or 2
            local total_xmult = discards * xmult_per_discard
            if total_xmult > 1 then
                return {
                    Xmult = total_xmult
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- 24. Perfectionism
-------------------------------------------------------------------
SMODS.Atlas {
    key = "perfectionism_joker",
    path = "perfectionism_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'perfectionism_joker',
    atlas = 'perfectionism_joker',
    unlocked = false,
    loc_txt = {
        name = 'Perfectionism',
        text = {
            "When defeating a {C:attention}Big Blind{}",
            "or {C:attention}Boss Blind{}, apply {C:dark_edition}Polychrome{}",
            "to a random {C:attention}Joker{} {C:inactive}(Except itself){}",
            "{C:inactive}({C:green}#1# in #2#{} chance for {C:dark_edition}Negative{}{C:inactive}){}"
        },
        unlock = {
            "Have {C:attention}5 Jokers{} with an",
            "{C:dark_edition}Edition{} at the same time"
        }
    },
    config = { extra = { odds = 5 } },
    rarity = 3, -- Rare
    pos = { x = 0, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    check_for_unlock = function(self, args)
        if G.jokers and G.jokers.cards then
            local count = 0
            for _, j in ipairs(G.jokers.cards) do
                if j.edition then
                    count = count + 1
                end
            end
            if count >= 5 then
                return true
            end
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.individual and not context.repetition then
            local is_big_or_boss = false
            if G.GAME and G.GAME.blind then
                if G.GAME.blind.boss or G.GAME.blind.name == 'Big Blind' or G.GAME.blind.key == 'b_big' or (G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Big') then
                    is_big_or_boss = true
                end
            end

            if is_big_or_boss then
                local candidates = {}
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        local is_self = (j == card) or (context.blueprint_card and j == context.blueprint_card)
                        if not is_self and not (j.edition and j.edition.negative) then
                            table.insert(candidates, j)
                        end
                    end
                end

                if #candidates > 0 then
                    local uneditioned = {}
                    for _, j in ipairs(candidates) do
                        if not j.edition then
                            table.insert(uneditioned, j)
                        end
                    end

                    local target = nil
                    if #uneditioned > 0 then
                        target = pseudorandom_element(uneditioned, 'perfectionism_target')
                    else
                        target = pseudorandom_element(candidates, 'perfectionism_target')
                    end

                    if target then
                        local chosen_edition = 'e_polychrome'
                        local is_neg = pseudorandom('perfectionism_neg') < (G.GAME.probabilities.normal / card.ability.extra.odds)
                        if is_neg then
                            chosen_edition = 'e_negative'
                        end

                        G.E_MANAGER:add_event(Event({
                            func = function()
                                target:set_edition(chosen_edition, true)
                                target:juice_up(0.5, 0.5)
                                return true
                            end
                        }))

                        local chosen_msg = is_neg and "Negative!" or pseudorandom_element({"Perfected!", "Refined!"}, 'perfectionism_msg')

                        return {
                            message = chosen_msg,
                            colour = G.C.DARK_EDITION
                        }
                    end
                end
            end
        end
    end
}


-- ===================================================================
-- 2. MEJORAS Y CONSUMIBLES (SPECTRALES Y SELLOS)
-- ===================================================================

-------------------------------------------------------------------
--- Spectral 1: Hierarchy (Jerarquía)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_hierarchy",
    path = "c_hierarchy.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'hierarchy',
    set = 'Spectral',
    atlas = 'c_hierarchy',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Hierarchy',
        text = {
            "Destroy {C:attention}all cards in hand{},",
            "create {C:attention}3 Steel Kings{} with {C:red}Red Seal{},",
            "{C:blue}-1 Hand{}"
        }
    },
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        for _, c in ipairs(G.hand.cards) do
            table.insert(destroyed_cards, c)
        end
        ease_hands_played(-1)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, c in ipairs(destroyed_cards) do
                    c:start_dissolve()
                end
                for i = 1, 3 do
                    local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                    local chosen_suit = pseudorandom_element(suits, 'hierarchy_suit')
                    local suit_prefix = string.sub(chosen_suit, 1, 1)

                    local new_card = create_playing_card({
                        front = G.P_CARDS[suit_prefix .. '_K'],
                        center = G.P_CENTERS.m_steel
                    }, G.hand, nil, nil, {G.C.SECONDARY_SET.Spectral})

                    new_card:set_seal('Red', true)
                end
                return true
            end
        }))
    end
}

local function get_dark_green_seal_key()
    if G.P_SEALS then
        if G.P_SEALS['Cracklatro_dark_green'] then return 'Cracklatro_dark_green' end
        if G.P_SEALS['dark_green'] then return 'dark_green' end
        if G.P_SEALS['seel_Cracklatro_dark_green'] then return 'seel_Cracklatro_dark_green' end
        if G.P_SEALS['seel_dark_green'] then return 'seel_dark_green' end
        for k, v in pairs(G.P_SEALS) do
            if type(v) == 'table' and string.find(k, 'dark_green') then
                return k
            end
        end
    end
    return 'Cracklatro_dark_green'
end

-------------------------------------------------------------------
--- Seal: Dark Green Seal (Sello Verde Oscuro)
-------------------------------------------------------------------
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

-- Alias G.P_SEALS entries for maximum compatibility across all SMODS versions
G.E_MANAGER:add_event(Event({
    func = function()
        if G.P_SEALS then
            local valid_seal = G.P_SEALS['Cracklatro_dark_green'] or G.P_SEALS['dark_green'] or G.P_SEALS['seel_Cracklatro_dark_green'] or G.P_SEALS['seel_dark_green']
            if not valid_seal then
                for k, v in pairs(G.P_SEALS) do
                    if type(v) == 'table' and string.find(k, 'dark_green') then
                        valid_seal = v
                        break
                    end
                end
            end
            if valid_seal then
                G.P_SEALS['dark_green'] = valid_seal
                G.P_SEALS['Cracklatro_dark_green'] = valid_seal
                G.P_SEALS['seel_dark_green'] = valid_seal
                G.P_SEALS['seel_Cracklatro_dark_green'] = valid_seal
            end
        end
        return true
    end
}))

-------------------------------------------------------------------
--- Spectral 2: Order (Orden)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_order",
    path = "c_order.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'order',
    set = 'Spectral',
    atlas = 'c_order',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Order',
        text = {
            "Add a {C:green}Dark Green Seal{}",
            "to {C:attention}1 selected card{}"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                local seal_key = get_dark_green_seal_key()
                target:set_seal(seal_key, true)
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Spectral 3: Rot (Putrefacción)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_rot",
    path = "c_rot.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'rot',
    set = 'Spectral',
    atlas = 'c_rot',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Rot',
        text = {
            "Destroy {C:attention}all current Jokers{}",
            "{C:inactive}(including Eternal){},",
            "create {C:red}2 random Rare Eternal Jokers{},",
            "{C:red}-1 Discard{}"
        }
    },
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
        ease_discard(-1)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.jokers.cards, 1, -1 do
                    local j = G.jokers.cards[i]
                    if j.ability then
                        j.ability.eternal = nil
                    end
                    j:start_dissolve()
                end
                for i = 1, 2 do
                    local new_joker = create_card('Joker', G.jokers, nil, 1, nil, nil, nil, 'rot')
                    new_joker:set_eternal(true)
                    new_joker:add_to_deck()
                    G.jokers:emplace(new_joker)
                end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Spectral 4: Catastrophic
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_catastrophic",
    path = "c_catastrophic.png",
    px = 71,
    py = 95
}

local function get_most_played_hands()
    local hands_by_count = {}
    local counts = {}
    if G.GAME and G.GAME.hands then
        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_data.visible then
                local played = hand_data.played or 0
                if not hands_by_count[played] then
                    hands_by_count[played] = {}
                    table.insert(counts, played)
                end
                table.insert(hands_by_count[played], hand_name)
            end
        end
    end
    table.sort(counts, function(a, b) return a > b end)

    local most_played = nil
    local second_played = nil

    if #counts > 0 then
        local top_count = counts[1]
        local top_group = hands_by_count[top_count]
        most_played = pseudorandom_element(top_group, 'catastrophic_top')

        local remaining_top = {}
        for _, h in ipairs(top_group) do
            if h ~= most_played then table.insert(remaining_top, h) end
        end

        if #remaining_top > 0 then
            second_played = pseudorandom_element(remaining_top, 'catastrophic_second')
        elseif #counts > 1 then
            local second_count = counts[2]
            second_played = pseudorandom_element(hands_by_count[second_count], 'catastrophic_second')
        else
            second_played = most_played
        end
    end

    return most_played or 'High Card', second_played or 'Pair'
end

local hand_to_planet = {
    ['High Card'] = 'c_pluto',
    ['Pair'] = 'c_mercury',
    ['Two Pair'] = 'c_uranus',
    ['Three of a Kind'] = 'c_venus',
    ['Straight'] = 'c_saturn',
    ['Flush'] = 'c_jupiter',
    ['Full House'] = 'c_earth',
    ['Four of a Kind'] = 'c_mars',
    ['Straight Flush'] = 'c_neptune',
    ['Five of a Kind'] = 'c_planet_x',
    ['Flush House'] = 'c_ceres',
    ['Flush Five'] = 'c_eris'
}

SMODS.Consumable {
    key = 'catastrophic',
    set = 'Spectral',
    atlas = 'c_catastrophic',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Catastrophic',
        text = {
            "{C:attention}+4 levels{} to your most played hand,",
            "creates {C:attention}3 Negative Planets{} of your",
            "most played hand,",
            "{C:red}-1 level{} to all other hands"
        }
    },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local most_played = get_most_played_hands()

        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname = most_played, level = G.GAME.hands[most_played].level + 4})
        level_up_hand(card, most_played, false, 4)

        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_name ~= most_played and hand_data.level > 1 then
                level_up_hand(card, hand_name, true, -1)
            end
        end

        local planet_key = hand_to_planet[most_played] or 'c_pluto'
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 3 do
                    local p_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet_key, 'catastrophic')
                    p_card:set_edition({negative = true}, true)
                    p_card:add_to_deck()
                    G.consumeables:emplace(p_card)
                end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Spectral 5: Intensity
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_intensity",
    path = "c_intensity.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'intensity',
    set = 'Spectral',
    atlas = 'c_intensity',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Intensity',
        text = {
            "Destroy {C:attention}5 selected cards{},",
            "create {C:attention}1 Polychrome Wild Card{}",
            "with {C:red}Red Seal{}",
            "of random rank and suit"
        }
    },
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 5
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        for _, c in ipairs(G.hand.highlighted) do
            table.insert(destroyed_cards, c)
        end
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, c in ipairs(destroyed_cards) do
                    c:start_dissolve()
                end
                local suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                local ranks = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'}
                local chosen_suit = pseudorandom_element(suits, 'intensity_suit')
                local chosen_rank = pseudorandom_element(ranks, 'intensity_rank')
                local suit_prefix = string.sub(chosen_suit, 1, 1)

                local new_card = create_playing_card({
                    front = G.P_CARDS[suit_prefix .. '_' .. chosen_rank],
                    center = G.P_CENTERS.m_wild
                }, G.hand, nil, nil, {G.C.SECONDARY_SET.Spectral})

                new_card:set_edition('e_polychrome', true)
                new_card:set_seal('Red', true)
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Spectral 6: La Muchachada
-------------------------------------------------------------------
SMODS.Atlas {
    key = "c_la_muchachada",
    path = "la_muchachada_joker.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'la_muchachada',
    set = 'Spectral',
    atlas = 'c_la_muchachada',
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'La Muchachada',
        text = {
            "Creates a random {C:attention}Secret Joker{}",
            "{C:inactive}(Must have room){}",
            "{C:inactive}(\"LLEGO UN MIEMBRO DE LA MUCHACHADA!!\"){}"
        }
    },
    -- Exclusivo: solo se puede obtener a través de paquetes espectrales y Discord Tag
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                local secret_keys = {
                    'j_Cracklatro_esteban', 'j_Cracklatro_thiago', 'j_Cracklatro_paula', 'j_Cracklatro_black_hole_joker',
                    'j_Cracklatro_squele', 'j_Cracklatro_bluxdir', 'j_Cracklatro_charles', 'j_Cracklatro_mochi',
                    'j_Cracklatro_helin', 'j_Cracklatro_raytracing', 'j_Cracklatro_paco'
                }
                local chosen_key = pseudorandom_element(secret_keys, 'la_muchachada_secret')
                local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_key, 'la_muchachada')
                new_joker:add_to_deck()
                G.jokers:emplace(new_joker)
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "LLEGO UN MIEMBRO DE LA MUCHACHADA!!", colour = G.C.DARK_EDITION })
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Helpers for Custom Enhancement Centers
-------------------------------------------------------------------
local function get_diamond_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Cracklatro_diamond'] then return G.P_CENTERS['m_Cracklatro_diamond'] end
        if G.P_CENTERS['m_diamond'] then return G.P_CENTERS['m_diamond'] end
    end
    return G.P_CENTERS.m_steel
end

local function get_investment_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Cracklatro_investment'] then return G.P_CENTERS['m_Cracklatro_investment'] end
        if G.P_CENTERS['m_investment'] then return G.P_CENTERS['m_investment'] end
    end
    return G.P_CENTERS.m_gold
end

local function get_lead_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Cracklatro_lead'] then return G.P_CENTERS['m_Cracklatro_lead'] end
        if G.P_CENTERS['m_lead'] then return G.P_CENTERS['m_lead'] end
    end
    return G.P_CENTERS.m_steel
end

local function get_jeweled_enhancement_center()
    if G.P_CENTERS then
        if G.P_CENTERS['m_Cracklatro_jeweled'] then return G.P_CENTERS['m_Cracklatro_jeweled'] end
        if G.P_CENTERS['m_jeweled'] then return G.P_CENTERS['m_jeweled'] end
    end
    return G.P_CENTERS.m_lucky
end

-------------------------------------------------------------------
--- Enhancement 1: Diamond Card
-------------------------------------------------------------------
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

-------------------------------------------------------------------
--- Enhancement 2: Investment Card (Carta de Inversión)
-------------------------------------------------------------------
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

-------------------------------------------------------------------
--- Enhancement 3: Lead Card (Carta de Plomo)
-------------------------------------------------------------------
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

-------------------------------------------------------------------
--- Enhancement 4: Jeweled Card (Carta Engarzada)
-------------------------------------------------------------------
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

-------------------------------------------------------------------
--- Consumable Type: Jobs
-------------------------------------------------------------------
SMODS.ConsumableType {
    key = 'Job',
    primary_colour = HEX('5c1e11'),
    secondary_colour = HEX('3d1a14'),
    loc_txt = {
        name = 'Job',
        collection = 'Job Cards',
        underscores_single = 'Job Card',
        underscores_plural = 'Job Cards',
        b_pull = 'PULL'
    },
    shop_rate = 0.0, -- No aparecen en los consumibles comunes de la tienda
    collection_rows = { 2, 6 },
    default = 'c_Cracklatro_minero_job'
}

local JOB_CARD_KEYS = {
    'c_Cracklatro_minero_job',
    'c_Cracklatro_gardener_job',
    'c_Cracklatro_banker_job',
    'c_Cracklatro_surgeon_job',
    'c_Cracklatro_alchemist_job',
    'c_Cracklatro_butcher_job',
    'c_Cracklatro_detective_job',
    'c_Cracklatro_chef_job',
    'c_Cracklatro_archaeologist_job',
    'c_Cracklatro_jeweler_job'
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
        local chosen_key = pseudorandom_element(JOB_CARD_KEYS, pseudoseed(key_append or 'job_pack_fallback'))
        local center = (G.P_CENTERS and G.P_CENTERS[chosen_key]) or (G.P_CENTERS and G.P_CENTERS[string.gsub(chosen_key, 'c_Cracklatro_', 'c_')])
        if center then
            card_obj = Card(G.pack_cards.T.x + G.pack_cards.T.w/2, G.pack_cards.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        end
    end
    return card_obj
end

-------------------------------------------------------------------
--- Job Consumable 1: The Miner
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                local center = get_diamond_enhancement_center()
                target:set_ability(center)
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 2: The Gardener (El Jardinero)
-------------------------------------------------------------------
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
            func = function()
                target.ability = target.ability or {}
                target.ability.gardener_job = true
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 3: The Banker (El Banquero)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                local center = get_investment_enhancement_center()
                target:set_ability(center)
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 4: The Surgeon (El Cirujano)
-------------------------------------------------------------------
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
            func = function()
                -- Transfer permanent bonus chips
                local donor_bonus = (donor.ability and donor.ability.perma_bonus) or 0
                recipient.ability = recipient.ability or {}
                recipient.ability.perma_bonus = (recipient.ability.perma_bonus or 0) + donor_bonus

                -- Transfer enhancement
                if donor.config and donor.config.center and donor.config.center ~= G.P_CENTERS.c_base then
                    recipient:set_ability(donor.config.center)
                end

                -- Transfer seal
                if donor.seal then
                    recipient:set_seal(donor.seal, true)
                end

                -- Transfer edition
                if donor.edition then
                    recipient:set_edition(donor.edition, true)
                end

                donor:start_dissolve()
                recipient:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 5: The Alchemist (El Alquimista)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                local center = get_lead_enhancement_center()
                target:set_ability(center)
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 6: The Butcher (El Carnicero)
-------------------------------------------------------------------
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
            "Destroys {C:attention}1 selected card{} (Rank 4+)",
            "and creates {C:attention}2 cards{} of half its rank with",
            "a random {C:attention}Steel{}, {C:attention}Glass{}, {C:attention}Wild{}, or {C:attention}Lucky{} enhancement"
        }
    },
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
            local id = G.hand.highlighted[1]:get_id()
            return id and id >= 4
        end
        return false
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        local original_suit = target.base and target.base.suit or 'Spades'
        local suit_prefix = string.sub(original_suit, 1, 1)
        local id = target:get_id() or 4
        local half_rank_num = math.max(2, math.floor(id / 2))
        local rank_strings = { [2]='2', [3]='3', [4]='4', [5]='5', [6]='6', [7]='7', [8]='8', [9]='9', [10]='10' }
        local chosen_rank_str = rank_strings[half_rank_num] or '2'

        G.E_MANAGER:add_event(Event({
            func = function()
                target:start_dissolve()
                local enhancements = { G.P_CENTERS.m_steel, G.P_CENTERS.m_glass, G.P_CENTERS.m_wild, G.P_CENTERS.m_lucky }
                for i = 1, 2 do
                    local chosen_enh = pseudorandom_element(enhancements, 'butcher_enh_' .. i)
                    local new_card = create_playing_card({
                        front = G.P_CARDS[suit_prefix .. '_' .. chosen_rank_str] or G.P_CARDS['S_2'],
                        center = chosen_enh
                    }, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                    new_card:juice_up()
                end
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 7: The Detective (El Detective)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                target.ability = target.ability or {}
                target.ability.detective_job = true
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 8: The Chef (El Chef)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1 and G.hand.highlighted[1]:is_face()
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                target.ability = target.ability or {}
                target.ability.chef_job = true
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 9: The Archaeologist (El Arqueólogo)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                target.ability = target.ability or {}
                target.ability.archaeologist_job = true
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Job Consumable 10: The Jeweler (El Joyero)
-------------------------------------------------------------------
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
    in_pool = function(self, args)
        return true
    end,
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local target = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                local center = get_jeweled_enhancement_center()
                target:set_ability(center)
                target:juice_up()
                if G.hand then G.hand:unhighlight_all() end
                return true
            end
        }))
    end
}


-------------------------------------------------------------------
--- Voucher 1: Taster
-------------------------------------------------------------------
SMODS.Atlas {
    key = "v_catador",
    path = "v_catador.png",
    px = 71,
    py = 95
}

SMODS.Voucher {
    key = 'catador',
    atlas = 'v_catador',
    pos = { x = 0, y = 0 },
    cost = 10,
    loc_txt = {
        name = 'Taster',
        text = {
            "{C:common}Common Jokers{} appear",
            "{C:attention}less frequently{} in shop"
        }
    },
    redeem = function(self, card)
        G.GAME.used_vouchers = G.GAME.used_vouchers or {}
        G.GAME.used_vouchers.v_Cracklatro_catador = true
        G.GAME.used_vouchers.v_catador = true
    end
}

-------------------------------------------------------------------
--- Voucher 2: Critic
-------------------------------------------------------------------
SMODS.Atlas {
    key = "v_critico",
    path = "v_critico.png",
    px = 71,
    py = 95
}

SMODS.Voucher {
    key = 'critico',
    atlas = 'v_critico',
    requires = { 'v_catador' },
    pos = { x = 0, y = 0 },
    cost = 10,
    loc_txt = {
        name = 'Critic',
        text = {
            "{C:common}Common Jokers{} no longer",
            "appear in shop"
        }
    },
    redeem = function(self, card)
        G.GAME.used_vouchers = G.GAME.used_vouchers or {}
        G.GAME.used_vouchers.v_Cracklatro_critico = true
        G.GAME.used_vouchers.v_critico = true
    end
}

-------------------------------------------------------------------
--- Booster Packs: Job Applications
-------------------------------------------------------------------
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


-- ===================================================================
-- 3. CIEGAS JEFE (BOSS BLINDS)
-- ===================================================================

-------------------------------------------------------------------
--- Boss Blind 1: The Pole (El Poste)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_pole",
    path = "b_pole.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'pole',
    atlas = 'b_pole',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('7f8c8d'),
    loc_txt = {
        name = 'The Pole',
        text = {
            "Cards with Editions (Foil, Holo, Poly)",
            "lose $10 when scored"
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and context.other_card.edition then
            ease_dollars(-10)
            return {
                message = '-$10',
                colour = G.C.MONEY
            }
        end
    end
}

-------------------------------------------------------------------
--- Boss Blind 2: The Rod / The Stick (La Vara)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_stick",
    path = "b_stick.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'stick',
    atlas = 'b_stick',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('145a32'),
    loc_txt = {
        name = 'The Rod',
        text = {
            "If score triples target,",
            "next round target is X1.5"
        }
    },
    defeat = function(self)
        if G.GAME.chips and G.GAME.blind and G.GAME.chips >= G.GAME.blind.chips * 3 then
            G.GAME.stick_penalty = 1.5
        end
    end
}

-------------------------------------------------------------------
--- Boss Blind 3: The Magician (El Mago)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_wizard",
    path = "b_wizard.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'wizard',
    atlas = 'b_wizard',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('8e44ad'),
    loc_txt = {
        name = 'The Magician',
        text = {
            "At final scoring, halves final Chips",
            "and reduces final Mult to 1/3"
        }
    },
    calculate = function(self, card, context)
        if context.before then
            G.GAME.wizard_triggered = nil
        end
        if context.final_scoring_step and not G.GAME.wizard_triggered then
            G.GAME.wizard_triggered = true
            return {
                x_chips = 0.5,
                Xmult = 1 / 3,
                message = '/2 Chips, /3 Mult!',
                colour = HEX('8e44ad')
            }
        end
    end
}

-------------------------------------------------------------------
--- Boss Blind 4: The Mountain (La Montaña)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_mountain",
    path = "b_mountain.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'mountain',
    atlas = 'b_mountain',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('0e6655'),
    loc_txt = {
        name = 'The Mountain',
        text = {
            "Using consumables disables",
            "scoring on the next hand"
        }
    }
}

-------------------------------------------------------------------
--- Boss Blind 5: The Door (La Puerta)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_door",
    path = "b_door.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'door',
    atlas = 'b_door',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('e84393'),
    loc_txt = {
        name = 'The Door',
        text = {
            "Hands with odd number",
            "of cards do not score"
        }
    },
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local odd_hand_names = {
            ['High Card'] = true,
            ['Three of a Kind'] = true,
            ['Full House'] = true,
            ['Five of a Kind'] = true,
            ['Straight'] = true,
            ['Flush'] = true,
            ['Straight Flush'] = true,
            ['Flush House'] = true,
            ['Flush Five'] = true
        }
        if #cards % 2 ~= 0 or odd_hand_names[text] then
            return 0, 0, true
        end
        return mult, hand_chips, false
    end
}

-------------------------------------------------------------------
--- Boss Blind 6: The Triangle (El Triángulo)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_triangle",
    path = "b_triangle.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'triangle',
    atlas = 'b_triangle',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 3, max = 10 },
    boss_colour = HEX('1b4f72'),
    loc_txt = {
        name = 'The Triangle',
        text = {
            "Hands with even number",
            "of cards do not score"
        }
    },
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local even_hand_names = {
            ['Pair'] = true,
            ['Two Pair'] = true,
            ['Four of a Kind'] = true
        }
        if #cards % 2 == 0 or even_hand_names[text] then
            return 0, 0, true
        end
        return mult, hand_chips, false
    end
}

-------------------------------------------------------------------
--- Boss Blind 7: The Cube (El Cubo)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_cube",
    path = "b_cube.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'cube',
    atlas = 'b_cube',
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX('3498db'),
    loc_txt = {
        name = 'The Cube',
        text = {
            "Halves final Chips and Mult",
            "if the number is even in final scoring"
        }
    },
    calculate = function(self, card, context)
        if context.before then
            G.GAME.cube_triggered = nil
        end
        if context.final_scoring_step and not G.GAME.cube_triggered then
            G.GAME.cube_triggered = true
            local cur_chips = (hand_chips and hand_chips > 0 and hand_chips) or (context.chips and context.chips > 0 and context.chips) or 0
            local cur_mult = (mult and mult > 0 and mult) or (context.mult and context.mult > 0 and context.mult) or 0
            local mod_chips = (cur_chips > 0 and cur_chips % 2 == 0) and 0.5 or 1
            local mod_mult = (cur_mult > 0 and cur_mult % 2 == 0) and 0.5 or 1
            if mod_chips < 1 or mod_mult < 1 then
                return {
                    x_chips = mod_chips,
                    Xmult = mod_mult,
                    message = 'Cube Halved!',
                    colour = HEX('3498db')
                }
            end
        end
    end
}

-------------------------------------------------------------------
--- Boss Blind 8: The Void (El Vacío - Ciega Jefe Final / Showdown)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_void",
    path = "b_void.png",
    px = 34,
    py = 34
}

SMODS.Blind {
    key = 'void',
    atlas = 'b_void',
    pos = { x = 0, y = 0 },
    dollars = 8,
    mult = 2,
    boss = { min = 8, max = 10, showdown = true },
    showdown = true,
    boss_colour = HEX('1a052e'),
    loc_txt = {
        name = 'The Void',
        text = {
            "Increases chip requirement by",
            "{C:attention}X1.25{} after each played hand",
            "that does not defeat the blind"
        }
    },
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME and G.GAME.blind and G.GAME.chips < G.GAME.blind.chips then
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.25)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    message = 'X1.25 Target!',
                    colour = HEX('8e44ad')
                }
            end
        end
    end
}

-- Ensure G.ANIMATION_ATLAS and G.ASSET_ATLAS entries exist for all custom blinds for external mod compatibility (e.g. Cartomancer)
local function sync_blind_atlases()
    local blind_atlases = {'b_pole', 'b_stick', 'b_wizard', 'b_mountain', 'b_door', 'b_triangle', 'b_cube', 'b_void'}
    for _, key in ipairs(blind_atlases) do
        local atlas_obj = (SMODS and SMODS.Atlases and SMODS.Atlases[key]) or (G.ASSET_ATLAS and G.ASSET_ATLAS[key]) or (G.ANIMATION_ATLAS and G.ANIMATION_ATLAS[key])
        if atlas_obj then
            if G.ASSET_ATLAS and not G.ASSET_ATLAS[key] then G.ASSET_ATLAS[key] = atlas_obj end
            if G.ANIMATION_ATLAS and not G.ANIMATION_ATLAS[key] then G.ANIMATION_ATLAS[key] = atlas_obj end
        end
    end
end

sync_blind_atlases()
G.E_MANAGER:add_event(Event({
    func = function()
        sync_blind_atlases()
        return true
    end
}))


-- ===================================================================
-- 4. BARAJAS (DECKS)
-- ===================================================================

-------------------------------------------------------------------
--- Back: Caveman Deck (Baraja Cavernícola)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_cavernicola",
    path = "b_cavernicola.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'cavernicola',
    atlas = 'b_cavernicola',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Caveman Deck',
        text = {
            "Start with only {C:attention}A, 2, 3, 4, 6, 8{} of each suit in your full deck,",
            "all other starting cards are {C:attention}Stone Cards{},",
            "{C:red}-1{} Hand"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.playing_cards then
                    local keep_ranks = { ['Ace'] = true, ['2'] = true, ['3'] = true, ['4'] = true, ['6'] = true, ['8'] = true }
                    for _, card in ipairs(G.playing_cards) do
                        local val = card.base and card.base.value
                        if not keep_ranks[val] then
                            card:set_ability(G.P_CENTERS.m_stone)
                        end
                    end
                end

                -- -1 Hand
                G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                ease_hands_played(-1)

                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Back: Strategist Deck (Baraja Estratega)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_strategist",
    path = "b_strategist.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'strategist',
    atlas = 'b_strategist',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Strategist Deck',
        text = {
            "Start with a {C:attention}24-card deck{}",
            "{C:inactive}(Aces, Kings, Queens, Jacks, 10s, 9s){}",
            "Start with {C:attention}Magic Trick{} voucher,",
            "Start with {C:money}$0{}, {C:red}-1{} hand, {C:red}-2{} discards,",
            "Blind score targets are {C:attention}X1.2{}"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.playing_cards then
                    for i = #G.playing_cards, 1, -1 do
                        local card = G.playing_cards[i]
                        local val = card.base and card.base.value
                        local keep = (val == 'Ace' or val == 'King' or val == 'Queen' or val == 'Jack' or val == '10' or val == '9')
                        if not keep then
                            if card.area then
                                card.area:remove_card(card)
                            end
                            card:remove()
                            table.remove(G.playing_cards, i)
                        end
                    end
                end

                -- Start with $0
                G.GAME.dollars = 0

                -- -1 Hand, -2 Discards
                G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                ease_hands_played(-1)

                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 2)
                ease_discard(-2)

                -- Starting voucher: Magic Trick
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                G.GAME.used_vouchers['v_magic_trick'] = true

                -- X1.2 Blind Chip Scaling
                G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * 1.2

                return true
            end
        }))
    end
}

-------------------------------------------------------------------
--- Back: Overseer Deck (Baraja Supervisora)
-------------------------------------------------------------------
SMODS.Atlas {
    key = "b_overseer",
    path = "b_hateful.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'overseer',
    atlas = 'b_overseer',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Overseer Deck',
        text = {
            "Creates a random {C:spectral}Spectral card{}",
            "at the end of round {C:inactive}(except Rot and Soul){},",
            "{C:attention}Tags are always doubled{},",
            "Joker prices are {C:red}X1.5{},",
            "Start with {C:money}$2{}, {C:red}-1{} hand, {C:red}-1{} discard"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.overseer_deck = true

                -- Start with $2 instead of $4
                G.GAME.dollars = 2

                -- -1 Hand, -1 Discard
                G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
                ease_hands_played(-1)

                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - 1)
                ease_discard(-1)

                return true
            end
        }))
    end,
    calculate = function(self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local forbidden = { ['c_rot'] = true, ['c_soul'] = true }
                        for i = 1, 35 do
                            local scard = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'overseer')
                            local skey = (scard.config and scard.config.center and scard.config.center.key) or scard.ability.name
                            if not forbidden[skey] and not forbidden[scard.config.center_key] then
                                scard:add_to_deck()
                                G.consumeables:emplace(scard)
                                break
                            else
                                scard:remove()
                            end
                        end
                        return true
                    end
                }))
            end
        end
    end
}


-- ===================================================================
-- 4.1 ETIQUETAS (TAGS)
-- ===================================================================

-------------------------------------------------------------------
--- Tag: Discord Tag
-------------------------------------------------------------------
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
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_Cracklatro_la_muchachada', 'discord_tag')
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


-- ===================================================================
-- 5. GAMEPLAY HOOKS
-- ===================================================================

-- Hook for Stick Penalty (1.5x score on next blind if 3x target beaten)
local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    local ret = set_blind_ref(self, blind, reset, silent)
    if G.GAME.stick_penalty then
        self.chips = math.floor(self.chips * G.GAME.stick_penalty)
        G.GAME.stick_penalty = nil
    end
    return ret
end

-- Hook for Mountain Blind (using consumable disables next scoring hand)
local use_card_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
    if G.GAME and G.GAME.blind and (G.GAME.blind.name == 'b_Crackedlatro_mountain' or G.GAME.blind.name == 'mountain') then
        G.GAME.mountain_disabled_hand = true
    end
    return use_card_ref(self, area, copier)
end

-- Hook for Overseer Deck: Always Double Tags
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

-- Hook for Overseer Deck: X1.5 Joker Prices
local set_cost_ref = Card.set_cost
function Card:set_cost()
    set_cost_ref(self)
    if G.GAME and G.GAME.overseer_deck and self.ability and self.ability.set == 'Joker' then
        self.cost = math.max(1, math.floor(self.cost * 1.5))
    end
end

-- Hook for Merchant Rare Boost, Catador & Crítico Vouchers
local get_current_joker_rarity_ref = get_current_joker_rarity
function get_current_joker_rarity(area, rarity_share)
    local rarity = get_current_joker_rarity_ref(area, rarity_share)
    if G.GAME then
        -- Crítico Voucher: Common jokers disappear completely from shop
        if G.GAME.used_vouchers and (G.GAME.used_vouchers.v_Cracklatro_critico or G.GAME.used_vouchers.v_critico) then
            if rarity == 1 then
                rarity = (pseudorandom('critico_voucher') < 0.85) and 2 or 3
            end
        -- Catador Voucher: Common jokers appear significantly less frequently
        elseif G.GAME.used_vouchers and (G.GAME.used_vouchers.v_Cracklatro_catador or G.GAME.used_vouchers.v_catador) then
            if rarity == 1 and pseudorandom('catador_voucher') < 0.60 then
                rarity = (pseudorandom('catador_voucher_rarity') < 0.85) and 2 or 3
            end
        end

        -- Merchant Rare Boost
        if G.GAME.merchant_rare_boost and G.GAME.merchant_rare_boost > 0 then
            if rarity ~= 3 and pseudorandom('merchant_rare') < 0.35 then
                rarity = 3
            end
        end
    end
    return rarity
end

-- Hook for La Muchachada spawn in Spectral Packs & Herrero Legendary Joker
local create_card_ref = create_card
function create_card(type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    -- La Muchachada: solo aparece en paquetes espectrales con el doble de rareza que El Alma (0.15% vs 0.3% / 1 en 666.67)
    if not forced_key and type == 'Spectral' and (area == G.pack_cards or key_append == 'spe' or (G.pack_cards and area == G.pack_cards)) then
        local muchachada_center_key = (G.P_CENTERS and G.P_CENTERS['c_Cracklatro_la_muchachada'] and 'c_Cracklatro_la_muchachada') or (G.P_CENTERS and G.P_CENTERS['c_la_muchachada'] and 'c_la_muchachada') or 'c_Cracklatro_la_muchachada'
        local allow_spawn = not (G.GAME and G.GAME.used_jokers and G.GAME.used_jokers[muchachada_center_key]) or (find_joker and next(find_joker("Showman")) ~= nil)
        if allow_spawn then
            local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
            if pseudorandom('la_muchachada_spectral_' .. (key_append or 'spe') .. ante) > 0.9985 then
                forced_key = muchachada_center_key
            end
        end
    end

    local card = create_card_ref(type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if type == 'Joker' and card and not card.edition then
        local has_herrero = false
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                local jkey = (j.config and j.config.center and j.config.center.key) or j.config.center_key or j.ability.name
                if jkey == 'j_Cracklatro_herrero_joker' or jkey == 'herrero_joker' or jkey == 'j_herrero_joker' then
                    if not j.debuff then
                        has_herrero = true
                        break
                    end
                end
            end
        end
        if has_herrero then
            local editions = { 'e_foil', 'e_holo', 'e_polychrome' }
            local chosen = pseudorandom_element(editions, 'herrero_edition')
            card:set_edition(chosen, true)
        end
    end
    return card
end

-- Hook for Falta de Lectura (tracks whether any other Joker activates during hand scoring)
local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = calculate_joker_ref(self, context)
    if ret and type(ret) == 'table' and next(ret) and not self.debuff and context and not context.falta_de_lectura_check then
        local key = (self.config and self.config.center and self.config.center.key) or self.config.center_key or (self.ability and self.ability.name)
        local is_self = (key == 'j_Cracklatro_falta_de_lectura_joker' or key == 'falta_de_lectura_joker' or key == 'j_falta_de_lectura_joker' or key == 'falta_de_lectura')
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


-- ===================================================================
-- 6. COMPATIBILIDAD CON JOKERDISPLAY
-- ===================================================================
if JokerDisplay then
    local jd_def = JokerDisplay.Definitions

    jd_def["j_Cracklatro_masterful_joker"] = {
        text = {
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(4/5 of a Kind)" }
        }
    }

    jd_def["j_Cracklatro_outstanding_joker"] = {
        text = {
            { text = "+250", colour = G.C.CHIPS },
            { text = " +50", colour = G.C.MULT },
            { text = " $5", colour = G.C.MONEY }
        },
        reminder_text = {
            { text = "(4/5 of a Kind)" }
        }
    }

    jd_def["j_Cracklatro_blueberry_joker"] = {
        text = {
            { text = "+1 Hand", colour = G.C.BLUE }
        },
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "rounds_left" },
            { text = " rounds" }
        }
    }

    jd_def["j_Cracklatro_shareholder_joker"] = {
        text = {
            { text = "+$", colour = G.C.MONEY },
            { ref_table = "card.ability.extra", ref_value = "small", colour = G.C.MONEY }
        },
        reminder_text = {
            { text = "(1 Hand defeat)" }
        }
    }

    jd_def["j_Cracklatro_builder_joker"] = {
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT }
        }
    }

    jd_def["j_Cracklatro_banquet_joker"] = {
        text = {
            { text = "3 Food Jokers", colour = G.C.ORANGE }
        },
        reminder_text = {
            { text = "(On Sell)" }
        }
    }

    jd_def["j_Cracklatro_appraiser_joker"] = {
        calc_function = function(card)
            local count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if pcard.edition and (pcard.edition.foil or pcard.edition.holo or pcard.edition.polychrome) then
                        count = count + 1
                    end
                end
            end
            card.joker_display_values.edition_dollars = count * (card.ability.extra.dollars_per_edition or 1)
        end,
        text = {
            { text = "+$", colour = G.C.MONEY },
            { ref_table = "card.joker_display_values", ref_value = "edition_dollars", colour = G.C.MONEY }
        }
    }

    jd_def["j_Cracklatro_runway_joker"] = {
        text = {
            { text = "1 in 10 Edition", colour = G.C.GREEN }
        }
    }

    jd_def["j_Cracklatro_slot_machine_joker"] = {
        text = {
            { text = "Slot Machine", colour = G.C.GOLD }
        }
    }

    jd_def["j_Cracklatro_duel_of_value_joker"] = {
        text = {
            { text = "X3", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(2 Even, 2 Odd)" }
        }
    }

    jd_def["j_Cracklatro_doctor_jo_joker"] = {
        text = {
            { text = "Saves Destroyed", colour = G.C.RED }
        }
    }

    jd_def["j_Cracklatro_symmetrical_joker"] = {
        text = {
            { text = "X4", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(4 of a Kind, 1 Suit)" }
        }
    }

    jd_def["j_Cracklatro_balance_joker"] = {
        text = {
            { text = "2 Spectrals", colour = G.C.SECONDARY_SET.Spectral }
        },
        reminder_text = {
            { text = "(4 Cards, 1 Suit)" }
        }
    }

    jd_def["j_Cracklatro_merchant_joker"] = {
        text = {
            { text = "-$5", colour = G.C.MONEY }
        },
        reminder_text = {
            { text = "(Leave Shop)" }
        }
    }

    jd_def["j_Cracklatro_lover_joker"] = {
        text = {
            { text = "+50", colour = G.C.CHIPS },
            { text = " +25", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(Scored Hearts)" }
        }
    }

    jd_def["j_Cracklatro_blacksmith_joker"] = {
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT }
        }
    }

    jd_def["j_Cracklatro_lucky_one_joker"] = {
        text = {
            { text = "+$1", colour = G.C.MONEY },
            { text = " +5", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(Scored Clubs)" }
        }
    }

    jd_def["j_Cracklatro_miner_joker"] = {
        text = {
            { text = "X1.5", colour = G.C.XMULT },
            { text = " +10", colour = G.C.CHIPS }
        },
        reminder_text = {
            { text = "(Scored Diamonds)" }
        }
    }

    jd_def["j_Cracklatro_joke_joker"] = {
        text = {
            { text = "Blank -> Antimatter", colour = G.C.SECONDARY_SET.Voucher }
        }
    }

    jd_def["j_Cracklatro_la_muchachada_joker"] = {
        calc_function = function(card)
            local wild_count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if is_wild_card(pcard) then
                        wild_count = wild_count + 1
                    end
                end
            end
            card.joker_display_values.la_muchachada_xmult = 1.5 + math.floor(wild_count / 5) * 1.5
        end,
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.joker_display_values", ref_value = "la_muchachada_xmult", colour = G.C.XMULT }
        }
    }

    jd_def["j_Cracklatro_esteban"] = {
        text = {
            { text = "X2.5", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(Spades/Clubs)" }
        }
    }
    jd_def["j_esteban"] = jd_def["j_Cracklatro_esteban"]

    jd_def["j_Cracklatro_thiago"] = {
        calc_function = function(card)
            local current_chips = (hand_chips and hand_chips > 0 and hand_chips) or 0
            card.joker_display_values.thiago_xmult = math.max(1, math.floor(current_chips / 20))
        end,
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.joker_display_values", ref_value = "thiago_xmult", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(/20 Chips)" }
        }
    }
    jd_def["j_thiago"] = jd_def["j_Cracklatro_thiago"]

    jd_def["j_Cracklatro_black_hole_joker"] = {
        text = {
            { text = "^1.5 Chips & Mult", colour = G.C.DARK_EDITION }
        }
    }

    jd_def["j_black_hole_joker"] = {
        text = {
            { text = "^1.5 Chips & Mult", colour = G.C.DARK_EDITION }
        }
    }

    jd_def["j_Cracklatro_perfectionism_joker"] = {
        text = {
            { text = "Poly / Neg", colour = G.C.DARK_EDITION }
        }
    }

    jd_def["j_perfectionism_joker"] = {
        text = {
            { text = "Poly / Neg", colour = G.C.DARK_EDITION }
        }
    }

    jd_def["j_Cracklatro_falta_de_lectura_joker"] = {
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(No Jokers Active)" }
        }
    }

    jd_def["j_Cracklatro_chameleon_joker"] = {
        text = {
            { text = "Copy Left if ", colour = G.C.PURPLE },
            { ref_table = "card.ability.extra", ref_value = "required_rank", colour = G.C.ATTENTION }
        }
    }
    jd_def["j_chameleon_joker"] = {
        text = {
            { text = "Copy Left if ", colour = G.C.PURPLE },
            { ref_table = "card.ability.extra", ref_value = "required_rank", colour = G.C.ATTENTION }
        }
    }

    jd_def["j_Cracklatro_squele"] = {
        text = {
            { text = "+10", colour = G.C.MULT },
            { text = " X1.5", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(Hearts)" }
        }
    }
    jd_def["j_squele"] = jd_def["j_Cracklatro_squele"]

    jd_def["j_Cracklatro_bluxdir"] = {
        text = {
            { text = "+1 Level", colour = G.C.ATTENTION }
        },
        reminder_text = {
            { text = "(On Discard)" }
        }
    }
    jd_def["j_bluxdir"] = jd_def["j_Cracklatro_bluxdir"]

    jd_def["j_Cracklatro_charles"] = {
        text = {
            { text = "X2", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(Spades/Hearts, +$5 Scored)" }
        }
    }
    jd_def["j_charles"] = jd_def["j_Cracklatro_charles"]

    jd_def["j_Cracklatro_mochi"] = {
        calc_function = function(card)
            local wild_count = 0
            if G.playing_cards then
                for _, pcard in ipairs(G.playing_cards) do
                    if is_wild_card(pcard) then
                        wild_count = wild_count + 1
                    end
                end
            end
            local xmult_gain = (card.ability and card.ability.extra and card.ability.extra.xmult_gain) or 0.25
            card.joker_display_values.mochi_xmult = 1.0 + (wild_count * xmult_gain)
        end,
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.joker_display_values", ref_value = "mochi_xmult", colour = G.C.XMULT }
        }
    }
    jd_def["j_mochi"] = jd_def["j_Cracklatro_mochi"]

    jd_def["j_Cracklatro_helin"] = {
        text = {
            { text = "^2 Mult", colour = G.C.DARK_EDITION }
        },
        reminder_text = {
            { text = "(1st Hand)" }
        }
    }
    jd_def["j_helin"] = jd_def["j_Cracklatro_helin"]

    jd_def["j_Cracklatro_raytracing"] = {
        text = {
            { text = "+2 Neg. Spectral", colour = G.C.DARK_EDITION }
        },
        reminder_text = {
            { text = "(End of Round)" }
        }
    }
    jd_def["j_raytracing"] = jd_def["j_Cracklatro_raytracing"]

    jd_def["j_Cracklatro_paco"] = {
        calc_function = function(card)
            local discards = (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left) or 0
            local xmult_per_discard = (card.ability and card.ability.extra and card.ability.extra.xmult_per_discard) or 2
            card.joker_display_values.paco_xmult = math.max(1, discards * xmult_per_discard)
        end,
        text = {
            { text = "X", colour = G.C.XMULT },
            { ref_table = "card.joker_display_values", ref_value = "paco_xmult", colour = G.C.XMULT }
        },
        reminder_text = {
            { text = "(Per Discard)" }
        }
    }
    jd_def["j_paco"] = jd_def["j_Cracklatro_paco"]
end

