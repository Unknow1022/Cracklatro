--[[
    The Cracked Balatro (Cracklatro)
    Localization & Mod Configuration System
    Provides live in-game toggle for Spanish / English descriptions
--]]

function get_cracklatro_mod()
    if SMODS and SMODS.Mods and SMODS.Mods['Crackedlatro'] then
        return SMODS.Mods['Crackedlatro']
    end
    if SMODS and SMODS.findMod then
        local found = SMODS.findMod('Crackedlatro')
        if found and found[1] then return found[1] end
    end
    if CRACKEDLATRO_MOD then
        return CRACKEDLATRO_MOD
    end
    if SMODS and SMODS.current_mod then
        return SMODS.current_mod
    end
    return nil
end

function get_cracklatro_config()
    local mod = get_cracklatro_mod()
    if mod and mod.config then
        return mod.config
    end
    if SMODS and SMODS.Mods and SMODS.Mods['Crackedlatro'] and SMODS.Mods['Crackedlatro'].config then
        return SMODS.Mods['Crackedlatro'].config
    end
    return {}
end

function save_cracklatro_config()
    local mod = get_cracklatro_mod()
    if SMODS and SMODS.save_mod_config and mod then
        pcall(function() SMODS.save_mod_config(mod) end)
    end
    local cfg = get_cracklatro_config()
    local new_runs = cfg.new_runs == true
    local new_challenges = cfg.new_challenges ~= false
    local new_spectrals_and_jobs = cfg.new_spectrals_and_jobs ~= false
    local new_boss_blinds = cfg.new_boss_blinds ~= false
    local fast_animations = cfg.fast_animations == true
    local force_english = cfg.force_english == true
    local config_str = "return {\n" ..
        "    [\"new_runs\"] = " .. tostring(new_runs) .. ",\n" ..
        "    [\"new_challenges\"] = " .. tostring(new_challenges) .. ",\n" ..
        "    [\"new_spectrals_and_jobs\"] = " .. tostring(new_spectrals_and_jobs) .. ",\n" ..
        "    [\"new_boss_blinds\"] = " .. tostring(new_boss_blinds) .. ",\n" ..
        "    [\"fast_animations\"] = " .. tostring(fast_animations) .. ",\n" ..
        "    [\"force_english\"] = " .. tostring(force_english) .. ",\n" ..
        "}\n"
    local mod_path = (mod and mod.path) or ""
    if SMODS and SMODS.NFS and SMODS.NFS.write and mod_path ~= "" then
        pcall(function() SMODS.NFS.write(mod_path .. "config.lua", config_str) end)
    elseif NFS and NFS.write and mod_path ~= "" then
        pcall(function() NFS.write(mod_path .. "config.lua", config_str) end)
    elseif love and love.filesystem and love.filesystem.write then
        pcall(function() love.filesystem.write("config.lua", config_str) end)
    end
end

-- =========================================================================
-- SPANISH LOCALIZATION DICTIONARY
-- =========================================================================

local SPANISH_DESCRIPTIONS = {
    Joker = {
        -- Common (6)
        masterful_joker = {
            name = 'Joker Magistral',
            text = {
                "Si la mano contiene un",
                "{C:attention}Póker{}, crea una carta de",
                "{C:tarot}Tarot{} aleatoria",
                "{C:inactive}(Debe haber espacio){}"
            }
        },
        outstanding_joker = {
            name = 'Joker Sobresaliente',
            text = {
                "Reactiva la carta de {C:attention}mayor valor{}",
                "en la mano jugada",
                "{C:attention}1{} vez"
            }
        },
        blueberry_joker = {
            name = 'Arándano',
            text = {
                "{C:blue}+1{} Mano al seleccionar la {C:attention}Ciega{}.",
                "Se autodestruye tras {C:attention}#1#{} ronda#2#{}",
                "{C:inactive}(Arte por kars_on_mars){}"
            }
        },
        dj_joker = {
            name = 'Joker DJ',
            text = {
                "Al puntuar exactamente {C:attention}1 carta{},",
                "la convierte en una carta {C:attention}Suerte{},",
                "{C:attention}Acero{}, {C:attention}Oro{} o {C:attention}Cristal{} aleatoria",
                "{C:inactive}(Una vez por ronda, #1#){}"
            }
        },
        disenador_joker = {
            name = 'Joker Diseñador',
            text = {
                "Las {C:attention}Cartas Multicolores{} puntuadas",
                "otorgan {C:money}$#1#{}"
            }
        },
        tts_joker = {
            name = 'TTS',
            text = {
                "Las cartas puntuadas otorgan {C:chips}+#1#{} Fichas y {C:mult}+#2#{} Multi",
                "por cada letra de su nombre en inglés."
            }
        },

        -- Uncommon (14)
        shareholder_joker = {
            name = 'Joker Accionista',
            text = {
                "El precio de la acción cambia cada ronda {C:inactive}(Actual: {C:money}$#1#{C:inactive}){}.",
                "Otorga {C:mult}+#2#{} Multi y paga {C:money}$#1#{} al final de la ronda.",
                "Vencer la Ciega en {C:attention}1 mano{} activa Mercado Alcista,",
                "usar todas las manos activa Mercado Bajista"
            }
        },
        builder_joker = {
            name = 'Joker Constructor',
            text = {
                "Si las cartas puntuadas están en {C:attention}orden ascendente{}:",
                "otorga {X:mult,C:white}X#1#{} Multi por cada carta puntuada.",
                "{C:attention}4+ cartas{} en orden añade permanentemente {C:chips}+#2#{} Fichas a la carta más alta"
            }
        },
        banquet_joker = {
            name = 'Banquete',
            text = {
                "Las cartas en mano ganan {C:chips}+#1#{} Fichas permanentes cada mano.",
                "{X:mult,C:white}X#3#{} Multi si mantienes {C:attention}#2#+ cartas{}.",
                "Al venderse, otorga {C:money}$#4#{} y crea un Joker de Comida {C:dark_edition}Negativo{}"
            }
        },
        appraiser_joker = {
            name = 'Tasador',
            text = {
                "Gana {C:money}$#1#{} al final de la ronda por cada",
                "carta con una {C:dark_edition}Edición{} en tu baraja"
            }
        },
        runway_joker = {
            name = 'Pasarela',
            text = {
                "Gana {X:mult,C:white}+X#2#{} Multi cada vez que",
                "una carta recibe una {C:enhanced}Mejora{}",
                "{C:inactive}(Actualmente {X:mult,C:white}X#1#{C:inactive} Multi){}"
            }
        },
        slot_machine_joker = {
            name = 'Tragamonedas',
            text = {
                "Gira 3 rodillos en cada mano jugada.",
                "{C:attention}Par{}: {C:money}+$#1#{} y {C:mult}+#2#{} Multi.",
                "{C:attention}Trío{}: {C:money}+$#3#{} y {X:mult,C:white}X#4#{} Multi.",
                "{C:attention}Jackpot 777{}: {C:money}+$#5#{}, {X:mult,C:white}X#6#{} Multi y una carta {C:spectral}Espectral{}.",
                "{C:green}Reto de Ronda{}: {C:attention}#7#{} {C:inactive}(#8#){}.",
                "Usa el botón {C:money}Apostar{} para ganar {C:money}X1.5{} tu apuesta al cumplir el reto"
            }
        },
        duel_of_value_joker = {
            name = 'Duelo de Valor',
            text = {
                "{X:mult,C:white}X#1#{} Multi si la {C:attention}Doble Pareja{} jugada",
                "contiene exactamente 2 cartas pares y 2 cartas impares"
            }
        },
        falta_de_lectura_joker = {
            name = 'Falta de Lectura',
            text = {
                "{X:mult,C:white}X#1#{} Multi si la mano jugada",
                "no activa {C:attention}ningún otro Joker{}"
            }
        },
        chameleon_joker = {
            name = 'Camaleón',
            text = {
                "Copia la habilidad del {C:attention}Joker a la izquierda{}",
                "si la mano jugada contiene al menos un(a) {C:attention}#1#{}",
                "{C:inactive}(El rango cambia cada ronda según la baraja){}"
            }
        },
        motorizado_joker = {
            name = 'Joker Motorizado',
            text = {
                "Gana {C:mult}+#2#{} Multi cada vez que",
                "una carta se {C:attention}reactiva{}",
                "{C:inactive}(Actualmente {C:mult}+#1#{C:inactive} Multi){}"
            }
        },
        contratado_joker = {
            name = 'Joker Contratado',
            text = {
                "{C:green}#1# en #2#{} probabilidades por mano jugada",
                "de crear una carta de {C:attention}Oficio{} aleatoria",
                "{C:inactive}(Debe haber espacio){}"
            }
        },
        sello_aprobacion_joker = {
            name = 'Sello de Aprobación',
            text = {
                "Si la mano jugada contiene solo {C:attention}1 carta{},",
                "le añade un {C:attention}Sello{} aleatorio"
            }
        },
        charco_pintura_joker = {
            name = 'Charco de Pintura',
            text = {
                "Las cartas de {C:attention}#1#{} puntuadas otorgan {C:mult}+#2#{} Multi.",
                "Las {C:attention}Cartas Multicolores{} otorgan {C:mult}+#3#{} Multi.",
                "{C:inactive}(El palo cambia cada ronda){}"
            }
        },
        lesionado_joker = {
            name = 'Joker Lesionado',
            text = {
                "{C:green}#1# en #2#{} probabilidades al final de la ronda",
                "de transformarse en otro Joker.",
                "{C:inactive}(Usa el botón superior para ver opciones){}"
            }
        },

        -- Rare (13)
        doctor_jo_joker = {
            name = 'Doctor Jo.',
            text = {
                "Elimina los {C:attention}debuffs{} de todos los Jokers.",
                "Cura Jokers {C:attention}Perecederos{} creando copias limpias.",
                "Si no se gana la ronda en la última mano: otorga",
                "{C:blue}+1 Mano{} {C:inactive}(1 por Ciega){}"
            }
        },
        symmetrical_joker = {
            name = 'Joker Simétrico',
            text = {
                "{X:mult,C:white}X#1#{} Multi si el {C:attention}Póker o Repóker{} jugado",
                "comparte el mismo palo en todas sus cartas puntuadas"
            }
        },
        balance_joker = {
            name = 'Equilibrio',
            text = {
                "Crea {C:spectral}#2# cartas Espectrales{} si el",
                "{C:attention}Póker{} jugado tiene todas las cartas del mismo palo",
                "{C:inactive}(Debe haber espacio){}"
            }
        },
        soulmates_joker = {
            name = 'Almas Gemelas',
            text = {
                "Puntuar ambas cartas otorga {X:mult,C:white}X#1#{} Multi, {C:money}+$#2#{} y {C:chips}+#3#{} Fichas permanentes.",
                "Los {C:hearts}Corazones{} puntuados otorgan {C:mult}+#4#{} Multi",
                "{C:inactive}(Almas gemelas: #5# y #6#){}"
            }
        },
        blacksmith_joker = {
            name = 'Herrero',
            text = {
                "Las cartas jugadas añaden {C:attention}+#1#{} Calor a la forja.",
                "A {C:attention}#2# de Calor{}, golpea el yunque: {C:green}1 en 2{} prob.",
                "de aplicar {C:attention}Sello Plateado{} o {C:attention}Carta de Acero{}",
                "a la carta más alta puntuada y se enfría a 0 {C:inactive}(Actual: #3#/#2#){}"
            }
        },
        giga_chad_joker = {
            name = 'Giga Chad',
            text = {
                "Reactiva todas las cartas de {C:attention}figura{}",
                "(J, Q, K) jugadas {C:attention}#1#{} veces adicionales"
            }
        },
        lucky_one_joker = {
            name = 'El Afortunado',
            text = {
                "Cada {C:attention}5{} {C:clubs}Tréboles{} puntuados, la siguiente",
                "{C:green}probabilidad{} es garantizada {C:green}(1 en 1){}.",
                "{C:inactive}(#2#/5 Tréboles, #3# - Se reinicia al final de ronda){}",
                "Gana {X:mult,C:white}+X#1#{} Multi cuando cualquier probabilidad acierta",
                "{C:inactive}(Actualmente {X:mult,C:white}X#4#{C:inactive} Multi){}"
            }
        },
        miner_joker = {
            name = 'Minero',
            text = {
                "Los {C:diamonds}Diamantes{} puntuados excavan 1m más profundo {C:inactive}(Máx 1000m, Actual: #2#m){}:",
                "0-50m: {C:chips}+25{} Fichas | 50-120m: {C:money}+$2{} | 120-300m: {X:mult,C:white}X1.35{} Multi",
                "300m+: {X:mult,C:white}X1.5{} Multi, reactivación y extrae {C:spectral}Espectral{} al final de ronda"
            }
        },
        joke_joker = {
            name = '¿Joker de Broma?',
            text = {
                "No hace nada... ¿o sí?"
            }
        },
        perfectionism_joker = {
            name = 'Perfeccionismo',
            text = {
                "Vencer la Ciega Grande o Jefe añade {C:dark_edition}Policromático{}",
                "a un Joker aleatorio {C:inactive}(#1# en #2# prob. de Negativo){}"
            }
        },
        parca_joker = {
            name = 'Joker Parca',
            text = {
                "Vender otro Joker crea un {C:attention}Joker Invisible{}",
                "{C:inactive}(Excepto Joker Invisible. Una vez por ronda, #1#){}"
            }
        },
        infostealer_joker = {
            name = 'Joker Infostealer',
            text = {
                "{C:eternal}Siempre Eterno{}.",
                "Perder {C:money}$#2#{} al salir de la tienda otorga {X:mult,C:white}+X#3#{} Multi.",
                "Si no puedes pagar, pierde {X:mult,C:white}-X#3#{} Multi",
                "{C:inactive}(Actualmente {X:mult,C:white}X#1#{C:inactive} Multi){}"
            }
        },
        sobresaturado_joker = {
            name = 'Joker Sobresaturado',
            text = {
                "Si la mano jugada contiene solo {C:attention}1 carta{}, añade una",
                "{C:enhanced}Mejora{}, {C:gold}Sello{} o {C:dark_edition}Edición{} faltante aleatoria.",
                "{C:inactive}(No sobreescribe efectos previos. Una vez por ronda, #1#){}"
            }
        },

        -- Secret (11)
        esteban = {
            name = 'Esteban',
            text = {
                "Los {C:spades}Picas{} y {C:clubs}Tréboles{} puntuados",
                "otorgan {X:mult,C:white}X#1#{} Multi",
                "{C:inactive}(\"*Ignora al niño*\"){}"
            }
        },
        thiago = {
            name = 'Thiago',
            text = {
                "Otorga {X:mult,C:white}X1{} Multi por cada",
                "{C:chips}#1# Fichas{} en la puntuación final",
                "{C:inactive}(\"Hijo, Brochacho\"){}"
            }
        },
        black_hole_joker = {
            name = 'Agujero Negro',
            text = {
                "Eleva las {C:chips}Fichas{} finales a la potencia de {C:chips}^#1#{}",
                "y el {C:mult}Multi{} final a la potencia de {C:mult}^#1#{}"
            }
        },
        squele = {
            name = 'Squele',
            text = {
                "Los {C:hearts}Corazones{} puntuados otorgan {C:mult}+#1#{} Multi y {X:mult,C:white}X#2#{} Multi.",
                "{C:green}#3# en #4#{} prob. de {C:attention}Proyectar{} y crear",
                "un {C:attention}Bloodstone{} {C:dark_edition}Negativo{}",
                "{C:inactive}(\"Me proyecto\"){}"
            }
        },
        cucu = {
            name = 'Cucu',
            text = {
                "Puntuar {C:attention}7, 8 o 9{} otorga {X:mult,C:white}X#1#{} Multi.",
                "Si se juegan los 3 rangos en la misma mano,",
                "otorga {C:money}+$#2#{} y {C:spectral}La Muchachada{}"
            }
        },
        cigarro = {
            name = 'Cigarro',
            text = {
                "Al seleccionar la Ciega, destruye {C:attention}1 carta{}",
                "al azar de tu mano y otorga {X:mult,C:white}+X#1#{} Multi permanente",
                "{C:inactive}(Actualmente {X:mult,C:white}X#2#{C:inactive} Multi){}"
            }
        },
        skate = {
            name = 'Skater',
            text = {
                "Si juegas una {C:attention}Escalera{}, gana {C:chips}+#1#{} Fichas y {C:mult}+#2#{} Multi.",
                "{C:green}1 en 4{} prob. de reactivar todas las cartas de la escalera"
            }
        },
        rebound = {
            name = 'Rebote',
            text = {
                "Reactiva la primera y última carta puntuada {C:attention}#1#{} veces.",
                "Si ambas tienen el mismo valor, otorga {X:mult,C:white}X#2#{} Multi"
            }
        },
        blind_joker = {
            name = 'Joker Ciego',
            text = {
                "Oculta tus cartas jugadas hasta puntuar.",
                "Otorga {X:mult,C:white}X#1#{} Multi si la mano supera el objetivo de la Ciega"
            }
        },
        the_end = {
            name = 'El Fin',
            text = {
                "En la última mano de la partida,",
                "multiplica la puntuación final por {X:mult,C:white}X#1#{}"
            }
        },
        dementor = {
            name = 'Dementor',
            text = {
                "Drena {C:chips}#1# Fichas{} de la Ciega al puntuar.",
                "Otorga {X:mult,C:white}X#2#{} Multi permanente por cada Ciega derrotada"
            }
        }
    },

    Job = {
        minero_job = {
            name = 'El Minero',
            text = {
                "Mejora {C:attention}1 carta seleccionada{}",
                "en una {C:attention}Carta de Diamante{}"
            }
        },
        gardener_job = {
            name = 'El Jardinero',
            text = {
                "Asigna el oficio de Jardinero a {C:attention}1 carta seleccionada{}.",
                "Al descartarla, añade permanentemente {C:chips}+2{} Fichas extra",
                "a todas las cartas de su mismo palo en tu baraja completa"
            }
        },
        banker_job = {
            name = 'El Banquero',
            text = {
                "Mejora {C:attention}1 carta seleccionada{}",
                "en una {C:attention}Carta de Inversión{}"
            }
        },
        surgeon_job = {
            name = 'El Cirujano',
            text = {
                "Destruye la {C:attention}1ra carta seleccionada{} y",
                "transfiere todas sus Fichas bonus, Mejora,",
                "Sello y Edición a la {C:attention}2da carta seleccionada{}"
            }
        },
        alchemist_job = {
            name = 'El Alquimista',
            text = {
                "Mejora {C:attention}1 carta seleccionada{}",
                "en una {C:attention}Carta de Plomo{}"
            }
        },
        butcher_job = {
            name = 'El Carnicero',
            text = {
                "Destruye {C:attention}1 carta seleccionada{} (Rango 3+)",
                "y crea {C:attention}2 cartas{} dividiendo su valor",
                "con mejoras aleatorias de {C:attention}Acero{}, {C:attention}Cristal{}, {C:attention}Multicolor{} o {C:attention}Suerte{}"
            }
        },
        detective_job = {
            name = 'El Detective',
            text = {
                "Asigna el oficio de Detective a {C:attention}1 carta seleccionada{}.",
                "Al estar en la mano inicial al empezar la ronda,",
                "revela las próximas 3 cartas a robar y les da un {C:gold}Sello Dorado{} o {C:blue}Sello Azul{}"
            }
        },
        chef_job = {
            name = 'El Chef',
            text = {
                "Asigna el oficio de Chef a {C:attention}1 figura seleccionada{} (J, Q, K).",
                "Al puntuar, transforma a todas las demás cartas",
                "puntuadas en {C:mult}Cartas Multi{}"
            }
        },
        archaeologist_job = {
            name = 'El Arqueólogo',
            text = {
                "Asigna el oficio de Arqueólogo a {C:attention}1 carta seleccionada{}.",
                "Al puntuar en tu {C:attention}última mano{} de la ronda,",
                "rescata 1 carta descartada y le da una edición {C:dark_edition}Foil{}, {C:dark_edition}Holo{} o {C:dark_edition}Poly{}"
            }
        },
        jeweler_job = {
            name = 'El Joyero',
            text = {
                "Mejora {C:attention}1 carta seleccionada{}",
                "en una {C:attention}Carta Joya{}"
            }
        }
    },

    Other = {
        gardener_job = {
            name = 'Jardinero',
            text = {
                "Al descartar esta carta, añade permanentemente",
                "{C:chips}+2{} Fichas base a todas las cartas de su mismo palo"
            }
        },
        detective_job = {
            name = 'Detective',
            text = {
                "En la mano inicial de la ronda, revela las",
                "próximas 3 cartas a robar con {C:gold}Sello Dorado{} o {C:blue}Azul{}"
            }
        },
        chef_job = {
            name = 'Chef',
            text = {
                "Al puntuar figuras (J, Q, K), transforma",
                "las demás cartas puntuadas en {C:mult}Cartas Multi{}"
            }
        },
        archaeologist_job = {
            name = 'Arqueólogo',
            text = {
                "Al puntuar en la última mano, rescata 1 carta",
                "descartada con edición {C:dark_edition}Foil{}, {C:dark_edition}Holo{} o {C:dark_edition}Poly{}"
            }
        },
        dark_green_seal = {
            name = 'Sello Verde Oscuro',
            text = {
                "Otorga {X:mult,C:white}X2.5{} Multi al puntuar,",
                "{C:green}#1# en 5{} prob. de romperse al jugarse"
            }
        },
        silver_seal = {
            name = 'Sello Plateado',
            text = {
                "{C:green}#1# en 4{} prob. de convertirse en {C:attention}Carta de Acero{} al jugarse.",
                "Con {C:attention}Carta de Acero{}: otorga {X:mult,C:white}X#2#{} Multi",
                "al puntuar y {X:mult,C:white}X#3#{} Multi en mano"
            }
        },
        white_seal = {
            name = 'Sello Blanco',
            text = {
                "Mejora una {C:attention}mano de póker{} aleatoria",
                "en {C:attention}+1 nivel{} al puntuar"
            }
        }
    },

    Blind = {
        pole = {
            name = 'El Poste',
            text = {
                "Las cartas con Edición (Foil, Holo, Poly)",
                "pierden $10 al puntuar"
            }
        },
        stick = {
            name = 'La Vara',
            text = {
                "Si la puntuación triplica el objetivo,",
                "el objetivo de la siguiente ronda es X1.5"
            }
        },
        wizard = {
            name = 'El Mago',
            text = {
                "Todas las cartas Mejoradas",
                "son debufeadas"
            }
        },
        mountain = {
            name = 'La Montaña',
            text = {
                "Usar consumibles desactiva",
                "la puntuación de la siguiente mano"
            }
        },
        door = {
            name = 'La Puerta',
            text = {
                "Las manos con cantidad impar",
                "de cartas no puntúan"
            }
        },
        triangle = {
            name = 'El Triángulo',
            text = {
                "Las manos con cantidad par",
                "de cartas no puntúan"
            }
        },
        cube = {
            name = 'El Cubo',
            text = {
                "Reduce a la mitad las Fichas y Multi finales",
                "si el número es par en el cálculo final"
            }
        },
        void = {
            name = 'El Vacío',
            text = {
                "Aumenta el requisito de fichas en",
                "{C:attention}X1.25{} tras cada mano jugada",
                "que no derrote a la ciega"
            }
        },
        guitar = {
            name = 'La Guitarra',
            text = {
                "Las manos que contienen 5 cartas",
                "no puntúan"
            }
        },
        phone = {
            name = 'El Teléfono',
            text = {
                "Solo la 1ra carta puntúa",
                "y activa Jokers"
            }
        },
        pinza = {
            name = 'La Pinza',
            text = {
                "Todos los Jokers son debufeados hasta que una",
                "carta jugable sea destruida (excepto Jokers destructores)"
            }
        },
        doppelganger = {
            name = 'El Doppelgänger',
            text = {
                "Refleja un Joker aleatorio invertido:",
                "{C:attention}#1#{}",
                "{C:red}Resta{} su Multi y Fichas,",
                "{C:red}divide{} por su XMulti cada vez que se activa"
            }
        }
    },

    Back = {
        cavernicola = {
            name = 'Baraja Cavernícola',
            text = {
                "Comienza solo con {C:attention}A, 2, 3, 4, 6, 8{} de cada palo en tu baraja,",
                "las demás cartas iniciales son {C:attention}Cartas de Piedra{},",
                "{C:red}-1{} Mano"
            }
        },
        strategist = {
            name = 'Baraja Estratega',
            text = {
                "Comienza con una baraja de {C:attention}24 cartas{}",
                "{C:inactive}(Ases, Reyes, Reinas, Jotas, 10s, 9s){},",
                "comienza con el voucher {C:attention}Truco de Magia{},",
                "comienza con {C:money}$0{}, {C:red}-1{} mano, {C:red}-2{} descartes,",
                "el objetivo de las ciegas es {C:attention}X1.2{}"
            }
        },
        overseer = {
            name = 'Baraja Supervisora',
            text = {
                "Crea una carta {C:spectral}Espectral{} aleatoria",
                "al final de la ronda {C:inactive}(excepto Pudrición y Alma){},",
                "las {C:attention}Etiquetas siempre se duplican{},",
                "los Jokers cuestan {C:red}X1.5{},",
                "comienza con {C:money}$2{}, {C:red}-1{} mano, {C:red}-1{} descarte"
            }
        },
        friendly = {
            name = 'Baraja Amistosa',
            text = {
                "Comienza con {C:attention}2 Jokers Negativos Eternos{} aleatorios,",
                "{C:inactive}(Excepto Legendarios o Secretos){},",
                "{C:red}-1{} espacio de Joker,",
                "{C:red}-1{} Descarte"
            }
        },
        perfectionist = {
            name = 'Baraja Perfeccionista',
            text = {
                "Comienza con {C:attention}3 Jokers aleatorios{}",
                "con edición {C:dark_edition}Policromático{},",
                "pero los descartes cuestan {C:money}$1{}"
            }
        },
        job = {
            name = 'Baraja Obrera',
            text = {
                "Comienza con {C:attention}2 cartas de Oficio{} aleatorias",
                "y {C:money}+$10{} extra"
            }
        }
    },

    Voucher = {
        catador = {
            name = 'Catador',
            text = {
                "Los {C:common}Jokers Comunes{} aparecen",
                "{C:attention}con menor frecuencia{} en la tienda"
            }
        },
        critico = {
            name = 'Crítico',
            text = {
                "Los {C:common}Jokers Comunes{} ya no",
                "aparecen en la tienda"
            }
        }
    },

    Tag = {
        discord = {
            name = 'Etiqueta de Discord',
            text = {
                "{C:green}#1# en 5{} prob. de crear",
                "{C:spectral}La Muchachada{}",
                "{C:inactive}(Debe haber espacio){}"
            }
        },
        brujeria = {
            name = 'Etiqueta de Brujería',
            text = {
                "Otorga un paquete {C:spectral}Espectral Mega{}",
                "gratuito"
            }
        },
        oferta = {
            name = 'Etiqueta de Oferta',
            text = {
                "Todos los artículos y tiradas de",
                "la tienda tienen {C:attention}50% de descuento{}",
                "en la próxima tienda"
            }
        }
    },

    Enhanced = {
        m_diamond = {
            name = 'Carta de Diamante',
            text = {
                "Otorga {X:mult,C:white}X#1#{} Multi al {C:attention}reactivarse{},",
                "otorga {C:money}$#2#{} al mantenerse en mano"
            }
        },
        m_investment = {
            name = 'Carta de Inversión',
            text = {
                "Genera {C:money}#1#% de interés{} de tu dinero actual",
                "{C:inactive}(Máx {C:money}$#2#{C:inactive}){} en mano al final de la ronda"
            }
        },
        m_lead = {
            name = 'Carta de Plomo',
            text = {
                "{C:chips}+#1#{} Fichas.",
                "Se transmuta permanentemente en {C:gold}Carta de Oro{}",
                "al puntuar en una mano ganadora"
            }
        },
        m_jeweled = {
            name = 'Carta Joya',
            text = {
                "Otorga {X:mult,C:white}X#1#{} Multi y {C:money}$#2#{}",
                "al puntuar si el palo es {C:diamonds}Diamantes{} o {C:hearts}Corazones{}"
            }
        }
    },

    Spectral = {
        hierarchy = {
            name = 'Jerarquía',
            text = {
                "Destruye {C:attention}todas las cartas en mano{},",
                "crea {C:attention}3 Reyes de Acero{} con {C:red}Sello Rojo{},",
                "{C:blue}-1 Mano{}"
            }
        },
        order = {
            name = 'Orden',
            text = {
                "Añade un {C:green}Sello Verde Oscuro{}",
                "a {C:attention}1 carta seleccionada{}"
            }
        },
        rot = {
            name = 'Pudrición',
            text = {
                "Destruye {C:attention}todos tus Jokers actuales{}",
                "{C:inactive}(incluyendo Eternos){},",
                "crea {C:red}2 Jokers Raros Eternos{} aleatorios,",
                "{C:red}-1 Descarte{}"
            }
        },
        catastrophic = {
            name = 'Catastrófico',
            text = {
                "{C:attention}+4 niveles{} a tu mano más jugada,",
                "crea {C:attention}3 Planetas Negativos{} de tu",
                "mano más jugada,",
                "{C:red}-1 nivel{} a todas las demás manos"
            }
        },
        intensity = {
            name = 'Intensidad',
            text = {
                "Destruye {C:attention}5 cartas seleccionadas{},",
                "crea {C:attention}1 Carta Multicolor Policromática{}",
                "con {C:red}Sello Rojo{}",
                "de palo y rango aleatorios"
            }
        },
        la_muchachada = {
            name = 'La Muchachada',
            text = {
                "Crea un {C:attention}Joker Secreto{} aleatorio",
                "{C:inactive}(Debe haber espacio){}",
                "{C:inactive}(\"LLEGO UN MIEMBRO DE LA MUCHACHADA!!\"){}"
            }
        },
        refuerzo = {
            name = 'Refuerzo',
            text = {
                "Añade un {C:chips}Sello Plateado{}",
                "a {C:attention}1 carta seleccionada{}"
            }
        },
        supernova = {
            name = 'Supernova',
            text = {
                "Añade un {C:planet}Sello Blanco{}",
                "a {C:attention}1 carta seleccionada{}"
            }
        }
    },
    Back = {
        cavernicola = {
            name = 'Baraja Cavernícola',
            text = {
                "Inicia con solo {C:attention}A, 2, 3, 4, 6, 8{} de cada palo en tu baraja completa,",
                "todas las demás cartas iniciales son {C:attention}Cartas de Piedra{},",
                "{C:red}-1{} Mano"
            }
        },
        strategist = {
            name = 'Baraja Estratega',
            text = {
                "Inicia con una baraja de {C:attention}24 cartas{}",
                "{C:inactive}(Ases, Reyes, Reinas, Jotas, 10s, 9s){}",
                "Inicia con el vale {C:attention}Truco de Magia{},",
                "Inicia con {C:money}$0{}, {C:red}-1{} mano, {C:red}-2{} descartes,",
                "El objetivo de puntos de las Ciegas es {C:attention}X1.2{}"
            }
        },
        overseer = {
            name = 'Baraja Supervisora',
            text = {
                "Crea una carta {C:spectral}Espectral{} aleatoria",
                "al final de la ronda {C:inactive}(excepto Podredumbre y Alma){},",
                "Las {C:attention}Etiquetas se duplican{} siempre,",
                "Los precios de Jokers son {C:red}X1.5{},",
                "Inicia con {C:money}$2{}, {C:red}-1{} mano, {C:red}-1{} descarte"
            }
        },
        friendly = {
            name = 'Baraja Amistosa',
            text = {
                "Inicia la partida con {C:attention}2 Jokers Negativos Eternos{} aleatorios,",
                "{C:inactive}(Excepto Legendario o Secreto){},",
                "{C:red}-1{} Espacio de Joker,",
                "{C:red}-1{} Descarte"
            }
        }
    },
    Sleeve = {
        friendly = {
            name = 'Funda Amistosa',
            text = {
                "Inicia la partida con {C:attention}1 Joker Negativo Eterno{} aleatorio",
                "{C:inactive}(Excepto Legendario o Secreto){},",
                "{C:red}-1{} Descarte"
            }
        },
        friendly_alt = {
            name = 'Funda Amistosa (Fusión)',
            text = {
                "{C:attention}Fusión Amistosa{}: Genera {C:attention}3 Jokers Negativos Eternos{},",
                "con posibilidad de hasta {C:legendary}1 Joker Legendario{},",
                "pierdes {C:red}-2{} Espacios de Joker y {C:red}-1{} Descarte"
            }
        },
        cavernicola = {
            name = 'Funda Cavernícola',
            text = {
                "Todas las {C:attention}Figuras{} iniciales (J, Q, K)",
                "se convierten en {C:attention}Cartas de Piedra{},",
                "{C:blue}+1{} Mano"
            }
        },
        cavernicola_alt = {
            name = 'Funda Cavernícola (Fusión)',
            text = {
                "{C:attention}Fusión Prehistórica{}: Todas las {C:attention}Cartas de Piedra{}",
                "iniciales reciben un {C:chips}Sello de Plata{},",
                "las Cartas de Piedra otorgan {C:mult}+3{} Mult y {C:chips}+20{} Fichas al anotar,",
                "{C:blue}+1{} Mano"
            }
        },
        strategist = {
            name = 'Funda Estratega',
            text = {
                "Inicia con el vale {C:attention}Truco de Magia{},",
                "Inicia con {C:money}$5{}, {C:red}-1{} Descarte"
            }
        },
        strategist_alt = {
            name = 'Funda Estratega (Fusión)',
            text = {
                "{C:attention}Fusión Estratégica{}: Mazo inicial condensado a {C:attention}20 cartas{} (10 al As),",
                "Inicia con los vales {C:attention}Truco de Magia{} y {C:attention}Mercader de Tarot{},",
                "{C:attention}+1{} Espacio de carta en tienda, manos jugadas dan {C:money}+$1{}"
            }
        },
        overseer = {
            name = 'Funda Supervisora',
            text = {
                "Las {C:attention}Etiquetas se duplican{} siempre,",
                "Vencer una Ciega Jefe crea una carta {C:spectral}Espectral{} aleatoria"
            }
        },
        overseer_alt = {
            name = 'Funda Supervisora (Fusión)',
            text = {
                "{C:attention}Fusión Supervisora{}: Crea {C:spectral}2 cartas Espectrales{} al final de ronda,",
                "Las Etiquetas se {C:attention}triplican{} (X3),",
                "Elimina el sobrecoste de Jokers, inicia con {C:money}+$5{} y {C:blue}+1{} Mano"
            }
        }
    },
    Other = {
        gardener_job = {
            name = "Jardinero",
            text = {
                "Al descartar esta carta, añade permanentemente",
                "{C:chips}+2{} Fichas base a todas las cartas",
                "de su mismo palo en tu baraja completa"
            }
        },
        detective_job = {
            name = "Detective",
            text = {
                "En la mano inicial de la ronda,",
                "revela las siguientes 3 cartas robadas y",
                "les otorga {C:gold}Sello Dorado{} o {C:blue}Sello Azul{}"
            }
        },
        chef_job = {
            name = "Chef",
            text = {
                "Al puntuar cartas de figura (J, Q, K),",
                "convierte todas las demás cartas puntuadas",
                "en {C:mult}Cartas Multi{}"
            }
        },
        archaeologist_job = {
            name = "Arqueólogo",
            text = {
                "Al puntuar en la mano final de la ronda,",
                "recupera 1 carta descartada con",
                "una edición ({C:dark_edition}Foil{}, {C:dark_edition}Holo{}, {C:dark_edition}Poly{})"
            }
        }
    },
    Booster = {
        job_pack_1 = {
            name = "Solicitud de Empleo",
            group_name = "Solicitud de Empleo",
            text = {
                "Elige {C:attention}#1#{} de hasta",
                "{C:attention}#2# cartas de Oficio{} para",
                "darle un oficio a una carta"
            }
        },
        job_pack_2 = {
            name = "Solicitud de Empleo Jumbo",
            group_name = "Solicitud de Empleo",
            text = {
                "Elige {C:attention}#1#{} de hasta",
                "{C:attention}#2# cartas de Oficio{} para",
                "darle un oficio a una carta"
            }
        },
        job_pack_3 = {
            name = "Solicitud de Empleo Mega",
            group_name = "Solicitud de Empleo",
            text = {
                "Elige {C:attention}#1#{} de hasta",
                "{C:attention}#2# cartas de Oficio{} para",
                "darle un oficio a una carta"
            }
        }
    }
}

-- Backup English definitions for instant live restoration
local ENGLISH_CACHE = {}

local SPANISH_CHALLENGE_NAMES = {
    -- Desafíos de Cracklatro
    ['c_Crackedlatro_casino_roller'] = 'Ruleta Rusa de Negocios',
    ['casino_roller'] = 'Ruleta Rusa de Negocios',
    ['c_Crackedlatro_silencio_absoluto'] = 'Silencio Absoluto',
    ['silencio_absoluto'] = 'Silencio Absoluto',
    ['c_Crackedlatro_geometria_sagrada'] = 'Geometría Sagrada',
    ['geometria_sagrada'] = 'Geometría Sagrada',
    ['c_Crackedlatro_deuda_extrema'] = 'Deuda Extrema',
    ['deuda_extrema'] = 'Deuda Extrema',
    ['c_Crackedlatro_forja_y_mina'] = 'La Forja y la Mina',
    ['forja_y_mina'] = 'La Forja y la Mina',
    ['c_Crackedlatro_duelo_numerico'] = 'Duelo Numérico',
    ['duelo_numerico'] = 'Duelo Numérico',
    ['c_Crackedlatro_lienzo_vivo'] = 'El Lienzo Vivo',
    ['lienzo_vivo'] = 'El Lienzo Vivo',
    ['c_Crackedlatro_coleccionista_brillos'] = 'Coleccionista de Brillos',
    ['coleccionista_brillos'] = 'Coleccionista de Brillos',
    ['c_Crackedlatro_urgencias_medicas'] = 'Urgencias Médicas',
    ['urgencias_medicas'] = 'Urgencias Médicas',
    ['c_Crackedlatro_sobresaturacion'] = 'Sobresaturación Singular',
    ['sobresaturacion'] = 'Sobresaturación Singular',

    -- Desafíos Vainilla de Balatro
    ['c_omelette_1'] = 'La Tortilla',
    ['c_city_1'] = 'Ciudad de 15 Minutos',
    ['c_rich_1'] = 'Los Ricos se Vuelven Más Ricos',
    ['c_knife_1'] = 'Al Filo de la Navaja',
    ['c_xray_1'] = 'Visión de Rayos X',
    ['c_mad_world_1'] = 'Mundo Loco',
    ['c_luxury_1'] = 'Impuesto al Lujo',
    ['c_non_perishable_1'] = 'No Perecedero',
    ['c_medusa_1'] = 'Medusa',
    ['c_double_nothing_1'] = 'Doble o Nada',
    ['c_typecast_1'] = 'Encasillamiento',
    ['c_inflation_1'] = 'Inflación',
    ['c_bram_poker_1'] = 'Bram Poker',
    ['c_fragile_1'] = 'Frágil',
    ['c_monolith_1'] = 'Monolito',
    ['c_blast_off_1'] = 'Despegue',
    ['c_five_card_1'] = 'Descarte de Cinco Cartas',
    ['c_golden_needle_1'] = 'Aguja de Oro',
    ['c_cruelty_1'] = 'Crueldad',
    ['c_jokerless_1'] = 'Sin Jokers',
}

local ENGLISH_CHALLENGE_NAMES = {
    ['c_Crackedlatro_casino_roller'] = "High Roller's Casino",
    ['casino_roller'] = "High Roller's Casino",
    ['c_Crackedlatro_silencio_absoluto'] = 'Absolute Silence',
    ['silencio_absoluto'] = 'Absolute Silence',
    ['c_Crackedlatro_geometria_sagrada'] = 'Sacred Symmetry',
    ['geometria_sagrada'] = 'Sacred Symmetry',
    ['c_Crackedlatro_deuda_extrema'] = 'Predatory Loan',
    ['deuda_extrema'] = 'Predatory Loan',
    ['c_Crackedlatro_forja_y_mina'] = 'The Forge & The Mine',
    ['forja_y_mina'] = 'The Forge & The Mine',
    ['c_Crackedlatro_duelo_numerico'] = 'Parity Duel',
    ['duelo_numerico'] = 'Parity Duel',
    ['c_Crackedlatro_lienzo_vivo'] = 'The Living Canvas',
    ['lienzo_vivo'] = 'The Living Canvas',
    ['c_Crackedlatro_coleccionista_brillos'] = 'Edition Tycoon',
    ['coleccionista_brillos'] = 'Edition Tycoon',
    ['c_Crackedlatro_urgencias_medicas'] = 'Code Red ER',
    ['urgencias_medicas'] = 'Code Red ER',
    ['c_Crackedlatro_sobresaturacion'] = 'Singular Saturation',
    ['sobresaturacion'] = 'Singular Saturation',

    ['c_omelette_1'] = 'The Omelette',
    ['c_city_1'] = '15 Minute City',
    ['c_rich_1'] = 'Rich get Richer',
    ['c_knife_1'] = "On a Knife's Edge",
    ['c_xray_1'] = 'X-ray Vision',
    ['c_mad_world_1'] = 'Mad World',
    ['c_luxury_1'] = 'Luxury Tax',
    ['c_non_perishable_1'] = 'Non-Perishable',
    ['c_medusa_1'] = 'Medusa',
    ['c_double_nothing_1'] = 'Double or Nothing',
    ['c_typecast_1'] = 'Typecast',
    ['c_inflation_1'] = 'Inflation',
    ['c_bram_poker_1'] = 'Bram Poker',
    ['c_fragile_1'] = 'Fragile',
    ['c_monolith_1'] = 'Monolith',
    ['c_blast_off_1'] = 'Blast Off',
    ['c_five_card_1'] = 'Five-Card Draw',
    ['c_golden_needle_1'] = 'Golden Needle',
    ['c_cruelty_1'] = 'Cruelty',
    ['c_jokerless_1'] = 'Jokerless',
}

local function record_english_entry(set, key, target)
    if not ENGLISH_CACHE[set] then ENGLISH_CACHE[set] = {} end
    if not ENGLISH_CACHE[set][key] and target then
        ENGLISH_CACHE[set][key] = {
            name = target.name,
            text = target.text and copy_table(target.text) or nil
        }
    end
end

-- Helper to parse localization strings
local function reparse_localization_entry(entry)
    if not entry then return end
    if loc_parse_string then
        if entry.text then
            entry.text_parsed = {}
            for _, line in ipairs(entry.text) do
                entry.text_parsed[#entry.text_parsed + 1] = loc_parse_string(line)
            end
        else
            entry.text_parsed = entry.text_parsed or {}
        end
        if entry.name then
            entry.name_parsed = {}
            local names = (type(entry.name) == 'table') and entry.name or { entry.name }
            for _, line in ipairs(names) do
                entry.name_parsed[#entry.name_parsed + 1] = loc_parse_string(line)
            end
        else
            entry.name_parsed = entry.name_parsed or {}
        end
    else
        entry.text_parsed = entry.text_parsed or {}
        entry.name_parsed = entry.name_parsed or {}
    end
end

-- =========================================================================
-- LIVE LANGUAGE SWITCHER
-- =========================================================================

function apply_cracklatro_language(use_spanish)
    G.CRACKEDLATRO_SPANISH = (use_spanish == true)

    if not G.localization or not G.localization.descriptions then return end

    local source_dict = use_spanish and SPANISH_DESCRIPTIONS or ENGLISH_CACHE

    for set_name, entries in pairs(SPANISH_DESCRIPTIONS) do
        local target_set = G.localization.descriptions[set_name]
        if target_set then
            for short_key, data in pairs(entries) do
                local keys_to_try = {
                    short_key,
                    'bl_' .. short_key,
                    'bl_Crackedlatro_' .. short_key,
                    'j_Crackedlatro_' .. short_key,
                    'j_' .. short_key,
                    'b_Crackedlatro_' .. short_key,
                    'b_' .. short_key,
                    'v_Crackedlatro_' .. short_key,
                    'v_' .. short_key,
                    'tag_Crackedlatro_' .. short_key,
                    'tag_' .. short_key,
                    'c_Crackedlatro_' .. short_key,
                    'c_' .. short_key,
                    'm_Crackedlatro_' .. short_key,
                    'm_' .. short_key,
                    'sleeve_Crackedlatro_' .. short_key,
                    'sleeve_' .. short_key,
                    'p_Crackedlatro_' .. short_key,
                    'p_' .. short_key,
                    'Crackedlatro_' .. short_key,
                    'smods_' .. short_key
                }

                for _, k in ipairs(keys_to_try) do
                    if target_set[k] then
                        record_english_entry(set_name, k, target_set[k])
                        if use_spanish then
                            target_set[k].name = data.name or target_set[k].name
                            if data.text then
                                target_set[k].text = copy_table(data.text)
                            end
                        else
                            local en = (ENGLISH_CACHE[set_name] and ENGLISH_CACHE[set_name][k])
                            if en then
                                target_set[k].name = en.name or target_set[k].name
                                if en.text then
                                    target_set[k].text = copy_table(en.text)
                                end
                            end
                        end
                        reparse_localization_entry(target_set[k])
                    end
                end
            end
        end
    end

    -- Safeguard all Sleeve and Back entries
    if G.localization.descriptions.Sleeve then
        for _, s_entry in pairs(G.localization.descriptions.Sleeve) do
            if type(s_entry) == 'table' and not s_entry.text_parsed then
                reparse_localization_entry(s_entry)
            end
        end
    end
    if G.localization.descriptions.Back then
        for _, b_entry in pairs(G.localization.descriptions.Back) do
            if type(b_entry) == 'table' and not b_entry.text_parsed then
                reparse_localization_entry(b_entry)
            end
        end
    end

    -- Sincronizar nombres de desafíos en G.localization.misc.challenge_names
    if G.localization and G.localization.misc then
        if not G.localization.misc.challenge_names then
            G.localization.misc.challenge_names = {}
        end
        local ch_dict = use_spanish and SPANISH_CHALLENGE_NAMES or ENGLISH_CHALLENGE_NAMES
        for k, v in pairs(ch_dict) do
            G.localization.misc.challenge_names[k] = v
        end

        -- Textos de reglas personalizadas de desafíos en español e inglés
        if G.localization.misc.v_dictionary then
            if use_spanish then
                G.localization.misc.v_dictionary['ch_c_single_random_suit'] = 'Toda la baraja es de un único palo aleatorio'
                G.localization.misc.v_dictionary['ch_c_all_perishable'] = 'Todos los Jokers son perecederos'
            else
                G.localization.misc.v_dictionary['ch_c_single_random_suit'] = 'Deck consists of a single random suit'
                G.localization.misc.v_dictionary['ch_c_all_perishable'] = 'All Jokers are perishable'
            end
        end
        if G.localization.misc.dictionary then
            if use_spanish then
                G.localization.misc.dictionary['ch_c_single_random_suit'] = 'Toda la baraja es de un único palo aleatorio'
                G.localization.misc.dictionary['ch_c_all_perishable'] = 'Todos los Jokers son perecederos'
                G.localization.misc.dictionary['k_job'] = 'Oficio'
                G.localization.misc.dictionary['b_job_cards'] = 'Cartas de Oficio'
                G.localization.misc.dictionary['k_job_pack'] = 'Solicitudes de Empleo'
            else
                G.localization.misc.dictionary['ch_c_single_random_suit'] = 'Deck consists of a single random suit'
                G.localization.misc.dictionary['ch_c_all_perishable'] = 'All Jokers are perishable'
                G.localization.misc.dictionary['k_job'] = 'Job'
                G.localization.misc.dictionary['b_job_cards'] = 'Job Cards'
                G.localization.misc.dictionary['k_job_pack'] = 'Job Application'
            end
        end
    end

    -- Actualizar nombres en tiempo real en G.CHALLENGES
    if G.CHALLENGES then
        local ch_dict = use_spanish and SPANISH_CHALLENGE_NAMES or ENGLISH_CHALLENGE_NAMES
        for _, ch in ipairs(G.CHALLENGES) do
            if ch and ch.id and ch_dict[ch.id] then
                ch.name = ch_dict[ch.id]
            end
        end
    end
end

-- Hook init_localization to automatically apply configured language if Balatro is set to Spanish
local original_init_loc = init_localization
function init_localization()
    if original_init_loc then original_init_loc() end
    local cfg = get_cracklatro_config()
    local is_es = false
    if not (cfg and cfg.force_english) then
        is_es = (G.SETTINGS and (G.SETTINGS.language == 'es' or G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')) or (G.CRACKEDLATRO_SPANISH == true)
    end
    apply_cracklatro_language(is_es)
end

-- =========================================================================
-- SMODS MOD CONFIG TAB REGISTRATION
-- =========================================================================

local function build_cracklatro_config_tab()
    local cfg = get_cracklatro_config()
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cm",
            padding = 0.15,
            colour = G.C.CLEAR
        },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.08 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "The Cracked Balatro (Cracklatro)",
                            scale = 0.50,
                            colour = G.C.GOLD,
                            shadow = true
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.04 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Mod Configuration",
                            scale = 0.34,
                            colour = G.C.UI.TEXT_LIGHT
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.04 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "\"This mod is crafted not to be unfair, but not to give away free wins either,",
                            scale = 0.25,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "it focuses on high-synergy long runs and unique, fun Jokers to play with,",
                            scale = 0.25,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "reading is recommended... and if you dislike reading, too bad XD\"",
                            scale = 0.25,
                            colour = G.C.GOLD
                        }
                    }
                }
            },
            -- Toggle 1: New Runs
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "New Runs",
                        ref_table = cfg,
                        ref_value = "new_runs",
                        callback = function(val)
                            save_cracklatro_config()
                        end,
                        info = {
                            "Optional. When enabled, seeds generate different",
                            "outcome variations between Cracklatro and vanilla Balatro."
                        }
                    })
                }
            },
            -- Toggle 2: New Challenges
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "New Challenges",
                        ref_table = cfg,
                        ref_value = "new_challenges",
                        callback = function(val)
                            save_cracklatro_config()
                            if cracklatro_sync_challenges then
                                cracklatro_sync_challenges(cfg.new_challenges)
                            end
                        end,
                        info = {
                            "Optional. Adds 10 high-difficulty custom challenges",
                            "centered around unique Cracklatro synergies."
                        }
                    })
                }
            },
            -- Toggle 3: New Spectrals & Job Cards
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "New Spectrals & Job Cards",
                        ref_table = cfg,
                        ref_value = "new_spectrals_and_jobs",
                        callback = function(val)
                            save_cracklatro_config()
                        end,
                        info = {
                            "Enables mod Job Cards and custom Spectral Cards.",
                            "Does not affect runs already in progress."
                        }
                    })
                }
            },
            -- Toggle 4: Custom Boss Blinds
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "Custom Boss Blinds",
                        ref_table = cfg,
                        ref_value = "new_boss_blinds",
                        callback = function(val)
                            save_cracklatro_config()
                        end,
                        info = {
                            "Enables Cracklatro's 11 custom Boss Blinds (The Pole, The Rod,",
                            "The Magician, The Door, etc.) in the blind pool."
                        }
                    })
                }
            },
            -- Toggle 5: Fast Animations
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "Fast Animations",
                        ref_table = cfg,
                        ref_value = "fast_animations",
                        callback = function(val)
                            save_cracklatro_config()
                        end,
                        info = {
                            "Reduces extra delays on custom mechanics (Slot Machine spins,",
                            "transform animations) for faster pacing."
                        }
                    })
                }
            },
            -- Toggle 6: Force English Language
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    create_toggle({
                        label = "Force English Language",
                        ref_table = cfg,
                        ref_value = "force_english",
                        callback = function(val)
                            save_cracklatro_config()
                            if apply_cracklatro_language then
                                local is_es = false
                                if not val then
                                    is_es = (G.SETTINGS and (G.SETTINGS.language == 'es' or G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')) or (G.CRACKEDLATRO_SPANISH == true)
                                end
                                apply_cracklatro_language(is_es)
                            end
                        end,
                        info = {
                            "Forces all Cracklatro cards, decks, and descriptions to",
                            "display in English regardless of Balatro's language setting."
                        }
                    })
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.06 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Settings saved in real-time",
                            scale = 0.26,
                            colour = G.C.GREEN
                        }
                    }
                }
            }
        }
    }
end

local mod_init = get_cracklatro_mod()
if mod_init then
    mod_init.config = mod_init.config or {}
    if mod_init.config.new_runs == nil then mod_init.config.new_runs = false end
    if mod_init.config.new_challenges == nil then mod_init.config.new_challenges = true end
    if mod_init.config.new_spectrals_and_jobs == nil then mod_init.config.new_spectrals_and_jobs = true end
    if mod_init.config.new_boss_blinds == nil then mod_init.config.new_boss_blinds = true end
    if mod_init.config.fast_animations == nil then mod_init.config.fast_animations = false end
    if mod_init.config.force_english == nil then mod_init.config.force_english = false end
    mod_init.config_tab = build_cracklatro_config_tab
end
if SMODS and SMODS.current_mod then
    SMODS.current_mod.config_tab = build_cracklatro_config_tab
end

