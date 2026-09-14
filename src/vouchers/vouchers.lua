-- Vouchers Atlas
SMODS.Atlas {
    key = "cracklatro_vouchers",
    path = "vouchers.png",
    px = 71,
    py = 95
}
-- Vouchers
-- 1. Taster (Catador)
SMODS.Voucher {
    key = 'catador',
    atlas = 'cracklatro_vouchers',
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
        G.GAME.used_vouchers.v_Crackedlatro_catador = true
        G.GAME.used_vouchers.v_catador = true
        G.GAME.used_vouchers.catador = true
    end
}

-- 2. Critic (Crítico)
SMODS.Voucher {
    key = 'critico',
    atlas = 'cracklatro_vouchers',
    requires = { 'v_Crackedlatro_catador', 'v_catador' },
    pos = { x = 1, y = 0 },
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
        G.GAME.used_vouchers.v_Crackedlatro_critico = true
        G.GAME.used_vouchers.v_critico = true
        G.GAME.used_vouchers.critico = true
    end
}
