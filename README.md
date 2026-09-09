# 🃏 The Cracked Balatro (Cracklatro)

<div align="center">

![Balatro Version](https://img.shields.io/badge/Balatro-v1.0.1o-orange?style=for-the-badge&logo=balatro)
![Steamodded](https://img.shields.io/badge/Steamodded-v1.0.0%2B-blue?style=for-the-badge)
![Cracklatro Version](https://img.shields.io/badge/Version-1.9%20Void%20Update-9932CC?style=for-the-badge)
![JokerDisplay](https://img.shields.io/badge/JokerDisplay-Compatible-2ea44f?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-Espa%C3%B1ol%20%7C%20English-lightgrey?style=for-the-badge)

**Una expansión masiva y completa para Balatro creada sobre el framework Steamodded (SMODS).**  
Introduce una rareza secreta exclusiva, decenas de Jokers con sinergias únicas, una nueva categoría de consumibles (Cartas de Oficio), Paquetes de Refuerzo de Empleo, Ciegas Jefe dinámicas con iluminación CRT ambiental, Barajas temáticas, Sellos con efectos espectrales inéditos, Vales y Etiquetas.

[Instalación](#%EF%B8%8F-instalación-y-requisitos) • [Novedades v1.9](#-novedades-de-la-void-update-v19) • [Contenido](#-resumen-general-de-contenido) • [Jokers Secretos](#-rareza-secreta-11-jokers-secretos) • [Jokers Estándar](#-jokers-estándar-33-jokers) • [Cartas de Oficio](#-cartas-de-oficio-job-cards---10-y-paquetes-3) • [Espectrales y Sellos](#-consumibles-espectrales-8-sellos-y-mejoras) • [Ciegas Jefe](#%EF%B8%8F-ciegas-jefe-boss-blinds---12) • [Barajas](#-barajas-personalizadas-decks---4) • [FAQ](#-preguntas-frecuentes-faq)

</div>

---

## 📊 Resumen General de Contenido

| Categoría | Cantidad | Descripción |
| :--- | :---: | :--- |
| 🌟 **Jokers Secretos** | **11** | Rareza exclusiva invocable solo mediante la carta espectral *La Muchachada*. Badge negro animado. |
| 🎭 **Jokers Comunes** | **6** | Jokers iniciales accesibles con mecánicas de asimilación, TTS y tempo. |
| 💎 **Jokers Poco Comunes** | **14** | Jokers versátiles con economía dinámica, transmutaciones y escalado. |
| 👑 **Jokers Raros** | **13** | Jokers con efectos de alto impacto, protección ante debuffs y combinaciones extremas. |
| 💼 **Cartas de Oficio (Jobs)** | **10** | Nueva categoría de consumible que asigna profesiones y mejoras permanentes a tus cartas. |
| 📦 **Paquetes de Oficio (Boosters)** | **3** | Paquetes de Empleo (*Job Applications*) para adquirir Cartas de Oficio en la tienda. |
| 🌌 **Cartas Espectrales** | **8** | Manipulación caótica de baraja, sellos y la invocación de la rareza Secreta. |
| 🎴 **Mejoras y Sellos** | **7** | 4 Mejoras de carta exclusivas y 3 Sellos inéditos con animaciones y quiebre espectral. |
| 👁️ **Ciegas Jefe Dinámicas** | **12** | 9 Ciegas Jefe temáticas + 3 Ciegas Showdown (Ante 8+) con paletas de color y shaders reactivos. |
| 🎴 **Barajas Personalizadas** | **4** | Baraja Cavernícola, Baraja Estratega, Baraja Supervisora y Baraja Amistosa. |
| 🎫 **Vales de Tienda** | **2** | Catador (*Taster*) y Crítico (*Critic*) para filtrar rarezas en tienda. |
| 🏷️ **Etiquetas de Salto** | **3** | Tag Discord, Tag de Brujería y Tag de Oferta. |
| 📈 **Total Jokers** | **44** | Todos con sprites personalizados, soporte para localización y compatibilidad con **JokerDisplay**. |

---

## ⚡ Novedades de la "Void Update" (v1.9)

* 🕳️ **Ciegas Jefe Dinámicas con Paletas Reactivas**: Cada una de las 12 Ciegas Jefe cambia fluidamente en tiempo real el color del tapete de la mesa, el fondo y el filtro CRT de Balatro a sus tonalidades temáticas únicas (*The Pole, The Rod, The Magician, The Mountain, The Door, The Triangle, The Cube, The Void, The Guitar, The Phone, The Pincer, The Doppelgänger*).
* 💥 **Sistema de Quiebre Espectral (`spectral_shatter`)**:
  * Las cartas con **Sello Verde Oscuro** ahora puntúan su `X2.5 Multi` de forma limpia y garantizada.
  * Si se activa el quiebre (1 en 5), la destrucción se procesa tras finalizar la puntuación de la mano, evitando interrupciones y eliminando definitivamente el error de cartas invisibles/fantasma.
  * Nuevo efecto sonoro multicapa etéreo (`magic_crumple`, `whoosh`, `tarot`, armónicos de cristal y corte dimensional) junto con partículas en verde oscuro y turquesa espectral.
  * Se incluye soporte de curación automática (`purge_cracklatro_ghost_cards`) que sana de inmediato partidas guardadas previas.
* 🃏 **Nuevos Jokers & Reworks**:
  * **DJ Joker**: Convierte una sola carta jugada en carta mejorada aleatoria (Suerte, Metal, Oro o Vidrio).
  * **Injured Joker (*"My Leg!"*)**: +125 Fichas y X1.5 Multi en Escaleras, con probabilidad de transformarse en otros Jokers legendarios o caóticos.
  * **TTS**: Otorga Fichas y Multi por cada letra del nombre en inglés del rango puntuado y donaciones de dinero al acumular 50 letras.
  * **Reaper Joker**, **Infostealer Joker (*Eterno*)**, **Supersaturated Joker**, **Paint Puddle**, **Motorized Joker**, **Hired Joker** y **Seal of Approval**.
* 🌀 **Nuevos Sellos & Espectrales**:
  * **Sello Verde Oscuro**: `X2.5 Multi` al puntuar, 1 en 5 de romperse con animación de quiebre espectral.
  * **Sello Blanco**: Sube de nivel una mano aleatoria al puntuar (+1 nivel).
  * **Sello de Plata**: 1 en 4 de convertir en Acero; en Cartas de Acero otorga `X2 Multi` al jugarse y `X2.5 Multi` en mano.
  * Nuevas cartas espectrales **Refuerzo** (aplica Sello de Plata) y **Supernova** (aplica Sello Blanco).
* 🏷️ **Nuevas Etiquetas & Barajas**:
  * **Etiqueta de Brujería (*Witchcraft Tag*)**: Otorga un Mega Paquete Espectral gratuito.
  * **Etiqueta de Oferta (*Sale Tag*)**: 50% de descuento en artículos y rerolls de la siguiente tienda.
  * **Baraja Amistosa (*Friendly Deck*)**: Comienza con 2 Jokers Negativos y Eternos al azar, a cambio de -1 ranura de Joker y -1 descarte.
* 🌐 **Compatibilidad Completa con JokerDisplay**: Visualización en tiempo real de estadísticas, contadores de letras, heat, precios de acciones y multiplicadores en la interfaz.

---

## 🌟 Rareza Secreta (11 Jokers Secretos)

> [!IMPORTANT]
> Los Jokers Secretos **NO** aparecen en la tienda ni en paquetes de bufones ordinarios. Solo pueden invocarse mediante la carta espectral exclusiva **La Muchachada** (o con la etiqueta *Discord Tag*). Poseen un badge animado color negro azabache `Secret` y animaciones de dos capas.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        🌟 JOKERS SECRETOS (11)                         │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Esteban**: Las cartas puntuadas de **Picas** y **Tréboles** otorgan **X2.5 Multi**.  
   *(Quote: "\*Ignores the kid\*")*
2. **Thiago**: Otorga **+X1 Multi** por cada **20 Fichas** en el cómputo final de la mano jugada.  
   *(Quote: "Son, Brochacho")*
3. **Black Hole**: Eleva las Fichas finales a la potencia de **^1.5** y el Multiplicador final a la potencia de **^1.5**.  
   *(Quote: "The ultimate singularity")*
4. **Squele**: Las cartas puntuadas de **Corazones** otorgan **+10 Multi** y **X1.5 Multi**. 1 en 10 probabilidades de *Proyectar* y crear un **Bloodstone Negativo**.  
   *(Quote: "I project myself")*
5. **Bluxdir**: Al descartar cualquier mano, **sube de nivel** la mano de poker descartada (+1 nivel).  
   *(Quote: "\*Starts farming aura\*")*
6. **Charles**: Las cartas puntuadas de **Picas** y **Corazones** otorgan **X2 Multi**. Además, ganas **+$5 por cada carta puntuada**.  
   *(Quote: "Homie" — Posee sinergia especial con Mochi)*
7. **Mochi**: Las cartas puntuadas se convierten permanentemente en **Cartas Silvestres (Wild Cards)**. Otorga **+X0.25 Multi** por cada Carta Silvestre presente en tu baraja completa.  
   *(Quote: "A drawing for you! :3" — Posee sinergia especial con Charles)*
   > [!TIP]
   > **Sinergia Legendaria Charles & Mochi**: Si tienes a Charles y a Mochi en tu alineación simultáneamente, todas las cartas puntuadas se **reactivan 1 vez adicional**, y al finalizar la ronda celebran con el mensaje *"¡Best Friends!"*.
8. **Helin**: En la **primera mano** de cada ronda, eleva el Multiplicador final a la potencia de **^2 Multi**.  
   *(Quote: "What is the chat sending?")*
9. **RayTracing**: Al final de cada ronda, crea **2 cartas Espectrales Negativas aleatorias** (excepto La Muchachada).  
   *(Quote: "Depradosini Negrini")*
10. **Paco**: Otorga **X2 Multi** por cada **descarte restante** que tengas en la ronda actual.  
    *(Quote: "No need to discard, every card is useful")*
11. **Yairo**: Las cartas de rango **6** y **7** puntuadas otorgan **X3 Multi** y **X1.5 Fichas**.  
    *(Quote: "67!!!!")*

---

## 🎭 Jokers Estándar (33 Jokers)

### ⚪ Comunes (6)

* **Masterful Joker**: Al puntuar un Poker (*Four of a Kind*), Repóker (*Five of a Kind*) o Repóker de Color (*Flush Five*), asimila ese rango de forma permanente. Las cartas de rangos asimilados **cuentan como todos los palos simultáneamente**. Otorga **+10 Multi** por cada rango asimilado.
* **Outstanding Joker**: La carta puntuada con el rango estrictamente más alto es *Sobresaliente*: absorbe las fichas base de todas las demás cartas puntuadas multiplicadas por el tamaño de la mano y **se reactiva 1 vez**. *(Desbloqueo: Jugar un Repóker)*.
* **Blueberry**: Otorga **+1 Mano** al seleccionar Ciega. Se autodestruye tras 3 rondas. *(Arte por kars_on_mars)*.
* **DJ Joker**: Si la mano jugada contiene exactamente **1 sola carta**, la convierte en una carta mejorada aleatoria (**Suerte, Acero, Oro o Vidrio**) *(1 vez por ronda)*.
* **Designer Joker (Joker Diseñador)**: Las Cartas Silvestres (*Wild Cards*) otorgan **+$1** al ser puntuadas.
* **TTS**: Otorga **+4 Fichas** y **+1 Multi** por cada letra en el nombre en inglés del rango de cada carta puntuada (ej. "Ace" = 3 letras, "Queen" = 5 letras). Cada **50 letras acumuladas** otorga una donación de **+$10**.

---

### 🔵 Poco Comunes (14)

* **Shareholder Joker**: El precio de la acción fluctúa cada Ciega ($2 a $15). Otorga Multi equivalente al doble del precio y paga dividendos al final de la ronda. Superar la ciega en 1 mano activa un **Bull Market** ($12-$18); usar tu última mano provoca un **Bear Market** ($2-$5). *(Desbloqueo: Tener al menos $100)*.
* **Builder Joker**: Si las cartas puntuadas están en **orden estrictamente ascendente**, otorga **+X0.5 Multi por cada carta puntuada** (hasta X3.5). Puntuar 4 o más cartas en orden añade permanentemente **+20 Fichas** a la más alta. *(Desbloqueo: Jugar una Escalera de Color)*.
* **Banquet**: Las cartas retenidas en mano al puntuar ganan permanentemente **+2 Fichas base**. Si tienes 7 o más cartas en mano al puntuar, otorga **+X2.5 Multi**. Al venderse otorga **+$15** y genera un Joker de comida aleatorio **Negativo**.
* **Appraiser**: Gana **+$1** al final de la ronda por cada carta con Edición (*Foil, Holo, Poly*) en tu baraja completa.
* **Runway**: La carta central de la mano jugada está bajo el *Foco de la Pasarela*: gana **+X0.5 Multi** por cada rasgo único (*Mejora, Edición, Sello*) presente en las demás cartas de la mano. Al derrotar la Ciega, hereda permanentemente uno de esos rasgos.
* **Slot Machine**: Gira 3 rodillos en cada mano: 2 iguales otorgan **+$3** y **+15 Multi**; 3 iguales otorgan **+$12** y **+X2.5 Multi**; Triple 7 otorga **+$35**, **+X4 Multi** y 1 carta Espectral. Las Cartas de la Suerte fuerzan al 1er rodillo a caer en 7.
* **Duel of Value**: **X3 Multi** si la mano jugada es Doble Pareja puntuada con exactamente 2 cartas de valor par y 2 cartas de valor impar.
* **Reading Deficiency (Falta de Lectura)**: **X5 Multi** si la mano jugada no activa ningún otro Joker de tu alineación.
* **Chameleon Joker**: Copia la habilidad del Joker a su izquierda si la mano jugada contiene al menos una carta del rango requerido (el rango cambia cada ronda).
* **Injured Joker (Joker Lesionado)**: Otorga **+125 Fichas** y **X1.5 Multi** en Escaleras (*Straights*). Al final de cada ronda tiene **1 en 5** probabilidades de evolucionar/convertirse en *Motorized Joker*, *High Risk Joker*, *Invisible Joker*, *Mr. Bones*, *Vampire* o *Joker Stencil*.
* **Motorized Joker (Joker Motorizado)**: Inicia con **+20 Multi**. Cada vez que una carta se reactiva (*retrigger*), gana **+20 Multi** adicional en esa mano.
* **Hired Joker (Joker Contratado)**: **1 en 3** probabilidades en cada mano jugada de generar una Carta de Oficio (*Job Card*) aleatoria.
* **Seal of Approval (Sello de Aprobación)**: Al jugar una mano de exactamente 1 sola carta, le aplica un sello aleatorio (*Dorado, Azul, Rojo, Púrpura, Verde Oscuro, Plata o Blanco*).
* **Paint Puddle (Charco de Pintura)**: Selecciona un palo aleatorio por ronda (nunca repite el mismo palo dos veces consecutivas); las cartas de ese palo otorgan **+25 Multi** (+50 Multi si la carta es Versátil / *Wild Card*).

---

### 🔴 Raros (13)

* **Doctor Jo.**: **Inmunidad Médica**: los contadores de Jokers Perecederos nunca disminuyen y los Jokers de Alquiler son totalmente reembolsados. **¡DESPEJEN!**: si la última mano no supera la Ciega, remueve Debuffs y otorga **+1 Mano de Emergencia con X3 Multi** (1 vez por Ciega). Al destruirse otro Joker, crea una copia limpia **Policroma**.
* **Symmetrical Joker**: **X4 Multi** si la mano jugada es un Poker (*Four of a Kind*) o Repóker (*Five of a Kind*) donde todas las cartas puntuadas comparten el mismo palo.
* **Balance**: Genera **2 cartas Espectrales** si la mano jugada es un Poker con exactamente 4 cartas del mismo palo.
* **Merchant**: En tienda: +1 espacio de carta, +1 vale, +1 paquete de refuerzo, **25% de descuento en todos los artículos** y mayor tasa de Jokers Raros. Pierdes $5 al salir de la tienda.
* **Lover**: Vincula 2 cartas de tu baraja como **Almas Gemelas**. Tener a una en mano roba a su pareja de la baraja de inmediato. Si ambas puntúan juntas en la misma mano, otorgan **X3 Multi**, **+$6** y **+10 Fichas permanentes** a ambas. Los Corazones dan +10 Multi.
* **Blacksmith**: Las cartas jugadas añaden **+5 Heat** a la forja. Al alcanzar **300 Heat**, golpea el yunque: **1 en 2** probabilidades de aplicar un **Sello de Plata** o convertir en **Carta de Acero** a la carta puntuada más alta, enfriando a 0 Heat.
* **Lucky One**: Los Tréboles puntuados recolectan pétalos. Al juntar 4 pétalos, formas un **Trébol de 4 Hojas**: otorga **X2 Multi** y **garantiza al 100% el éxito de la próxima probabilidad del juego** (Rueda de la Fortuna, Lucky Cards, Space Joker, etc.) consumiendo el trébol.
* **Miner**: Los Diamantes descienden **+5m** en la mina: 0-50m (Carbón: **+25 Fichas**), 50-120m (Oro: **+$2**), 120-300m (Diamante: **+X1.35 Multi**), 300m+ (Núcleo Magmático: **+X1.5 Multi**, **reactivación** y extrae una carta Espectral al final de la ronda).
* **Joke Joker?**: No hace nada aparente... pero en secreto, si posees el Vale Blank, lo transforma inmediatamente en Antimatter (+1 espacio de Joker).
* **Perfectionism**: Al derrotar una Ciega Grande o Ciega Jefe, aplica **Policromo** a un Joker aleatorio (1 en 5 de otorgar **Negativo** en su lugar).
* **Reaper Joker (Joker Parca)**: Al vender cualquier otro Joker, genera un *Invisible Joker* (**1 vez por ronda**).
* **Infostealer Joker**: Siempre es **Eterno**. Al salir de la tienda descuenta **$10** y gana **+X0.5 Multi**; si no tienes suficiente dinero, pierde **-X0.5 Multi** (mínimo X1).
* **Supersaturated Joker (Joker Sobresaturado)**: Al puntuar, coloca una mejora faltante aleatoria (*Sello, Mejora o Edición*). Si la carta ya cuenta con Sello, Mejora y Edición simultáneamente, otorga **+$10**.

---

## 💼 Cartas de Oficio (Job Cards - 10) y Paquetes (3)

Nuevo tipo de consumible temático que asigna profesiones exclusivas y transformaciones especializadas a tus naipes:

| Carta de Oficio | Icono | Efecto Principal |
| :--- | :---: | :--- |
| **The Miner** | ⛏️ | Transforma 1 carta seleccionada en **Diamond Card (Carta de Diamante)**. |
| **The Gardener** | 🌿 | Asigna el oficio Jardinero: al descartarse, otorga **+2 Fichas base** permanentemente a todas las cartas de su mismo palo en la baraja. |
| **The Banker** | 🏦 | Transforma 1 carta seleccionada en **Investment Card (Carta de Inversión)**. |
| **The Surgeon** | 🩺 | Destruye la 1ª carta seleccionada y transfiere todas sus fichas de bonus, mejora, sello y edición a la 2ª carta seleccionada. |
| **The Alchemist** | ⚗️ | Transforma 1 carta seleccionada en **Lead Card (Carta de Plomo)**. |
| **The Butcher** | 🥩 | Destruye 1 carta (Rango 3+) y crea 2 cartas dividiendo su rango, con mejoras aleatorias de Acero, Cristal, Silvestre o Fortuna. |
| **The Detective** | 🔍 | Asigna el oficio Detective: en la mano inicial de cada ronda, revela las próximas 3 cartas a robar y les coloca Sello Dorado o Azul. |
| **The Chef** | 🍳 | Asigna el oficio Chef a una figura (J, Q, K): al puntuar, convierte a las demás cartas puntuadas en Cartas Multi. |
| **The Archaeologist** | 🏺 | Asigna el oficio Arqueólogo: al puntuar en tu última mano de la ronda, rescata 1 carta descartada y le aplica Foil, Holo o Poly. |
| **The Jeweler** | 💎 | Transforma 1 carta seleccionada en **Jeweled Card (Carta Engarzada)**. |

### 📦 Paquetes de Refuerzo de Empleo (Booster Packs)
* **Job Application**: Elige 1 de entre 3 Cartas de Oficio disponibles.
* **Jumbo Job Application**: Elige 1 de entre 5 Cartas de Oficio disponibles.
* **Mega Job Application**: Elige 2 de entre 5 Cartas de Oficio disponibles.

---

## 🌌 Consumibles Espectrales (8), Sellos y Mejoras

### 🌀 Cartas Espectrales
* **Hierarchy**: Destruye toda la mano actual, crea 3 Reyes de Acero con Sello Rojo, **-1 Mano**.
* **Order**: Aplica un **Sello Verde Oscuro** a 1 carta seleccionada.
* **Rot**: Destruye todos los Jokers actuales (incluidos Eternos), crea **2 Jokers Raros Eternos** aleatorios, **-1 Descarte**.
* **Catastrophic**: **+4 niveles** a tu mano de poker más jugada, genera **3 Planetas Negativos** de esa misma mano, y resta **-1 nivel** a todas las demás manos.
* **Intensity**: Destruye 5 cartas seleccionadas y crea 1 Carta Silvestre Policromada con Sello Rojo de rango y palo aleatorios.
* **La Muchachada**: Invoca un **Joker Secreto** aleatorio entre los 11 existentes *(exclusivo de paquetes espectrales y Discord Tag)*.
* **Refuerzo**: Aplica un **Sello de Plata** a 1 carta seleccionada.
* **Supernova**: Aplica un **Sello Blanco** a 1 carta seleccionada.

---

### ✨ Sellos Personalizados

| Sello | Visual | Efecto |
| :--- | :---: | :--- |
| **Dark Green Seal** *(Sello Verde Oscuro)* | 🟢 | Otorga **X2.5 Multi** al puntuar. **1 en 5** probabilidades de romperse al jugarse mediante el nuevo efecto **Spectral Shatter** (efecto de sonido etéreo, partículas temáticas y sin dejar cartas fantasma). |
| **White Seal** *(Sello Blanco)* | ⚪ | Al puntuar, sube de nivel una mano de poker aleatoria en **+1 nivel**. |
| **Silver Seal** *(Sello de Plata)* | 🔘 | **1 en 4** probabilidades de transmutar la carta en **Carta de Acero** al ser jugada. Al estar en una Carta de Acero, otorga **X2 Multi** al jugarse y **X2.5 Multi** mientras se mantiene en mano. |

---

### 🃏 Mejoras de Carta Exclusivas
* **Diamond Card (Carta de Diamante)**: Otorga **X1.5 Multi** al reactivarse; otorga **+$3** si se mantiene en mano al finalizar la ronda.
* **Investment Card (Carta de Inversión)**: Genera un **10% de interés** sobre tu dinero actual (hasta un máximo de $10) al tenerla en mano al final de la ronda.
* **Lead Card (Carta de Plomo)**: Otorga **+10 Fichas**. Se transmuta permanentemente en **Carta de Oro** si se puntúa en la mano que derrota la Ciega.
* **Jeweled Card (Carta Engarzada)**: Otorga **X1.25 Multi** y **+$2** al puntuar si el palo de la carta es Diamantes o Corazones.

---

## 👁️ Ciegas Jefe (Boss Blinds - 12)

Todas las Ciegas Jefe cuentan con iluminación reactiva que altera el tapete, CRT y atmósfera del juego en vivo:

### Ciegas Jefe Estándar (Ante 3+)
* **The Pole (El Poste)**: Las cartas con Edición (*Foil, Holo, Poly*) pierden **$10** al ser puntuadas.
* **The Rod (La Vara)**: Si tu puntuación triplica el objetivo de la ciega, el requisito de la siguiente ciega se incrementa en **X1.5**.
* **The Magician (El Mago)**: En el cálculo final, reduce las Fichas a la mitad y el Multiplicador a un tercio.
* **The Mountain (La Montaña)**: Usar cualquier consumible desactiva la puntuación de la siguiente mano jugada.
* **The Door (La Puerta)**: Las manos con un número impar de cartas no puntúan.
* **The Triangle (El Triángulo)**: Las manos con un número par de cartas no puntúan.
* **The Cube (El Cubo)**: Reduce las Fichas y el Multi a la mitad si el número resultante es par en el cálculo final.
* **The Guitar (La Guitarra)**: Las manos jugadas de exactamente 5 cartas quedan silenciadas y no puntúan.
* **The Phone (El Teléfono)**: Solo la 1ª carta puntúa y activa Jokers; todas las demás cartas no puntúan ni activan efectos.

### 💀 Ciegas Finales Showdown (Ante 8+)
* **The Void (El Vacío)**: Incrementa el requisito de fichas en **X1.25** tras cada mano jugada que no derrote la ciega ($8 de recompensa).
* **The Pincer (La Pinza)**: **Todos los Jokers están deshabilitados** hasta que se destruye una carta durante el combate (destruir una carta de cristal o romper una carta con Sello Verde Oscuro libera inmediatamente el poder de tus Jokers).
* **The Doppelgänger (El Doppelgänger)**: Al inicio de la ronda invoca un reflejo sombrío que clona un Joker aleatorio e invierte su habilidad en el cálculo final: resta su Multi y Fichas, y divide entre su XMulti.

---

## 🎴 Barajas Personalizadas (Decks - 4)

* **Caveman Deck (Baraja Cavernícola)**: Empiezas únicamente con A, 2, 3, 4, 6 y 8 de cada palo en tu baraja; todas las demás cartas iniciales son Cartas de Piedra. Empiezas con **-1 Mano**.
* **Strategist Deck (Baraja Estratega)**: Empiezas con una baraja compacta de 24 cartas (Ases, Reyes, Reinas, Jotas, 10s y 9s). Inicias con el vale *Magic Trick*, $0, **-1 mano**, **-2 descartes** y las ciegas escalan X1.2.
* **Overseer Deck (Baraja Supervisora)**: Crea una carta Espectral aleatoria al final de cada ronda (excepto Rot y Soul). Las etiquetas siempre se duplican. Los precios de los Jokers son X1.5. Empiezas con $2, -1 mano y -1 descarte.
* **Friendly Deck (Baraja Amistosa)**: Genera **2 Jokers aleatorios con edición Negativa y condición de Eternos** al comenzar la partida (no puede generar Legendarios ni Secretos). Inicias con **-1 Espacio de Joker** y **-1 Descarte**.

---

## 🎫 Vales y Etiquetas

### 🎫 Vales de Tienda (Vouchers - 2)
* **Taster (Catador)**: Los Jokers Comunes aparecen con menor frecuencia en la tienda (75% de reemplazo por Poco Comunes o Raros).
* **Critic (Crítico - Requiere Catador)**: Los Jokers Comunes ya no aparecen en la tienda (100% de reemplazo).

### 🏷️ Etiquetas (Tags - 3)
* **Discord Tag**: 1 en 5 probabilidades de generar la carta espectral exclusiva **La Muchachada**.
* **Witchcraft Tag (Tag de Brujería)**: Otorga un **Mega Paquete Espectral** totalmente gratuito.
* **Sale Tag (Tag de Oferta)**: Todos los artículos y rerolls de la siguiente tienda tienen un **50% de descuento**.

---

## 🛠️ Instalación y Requisitos

### Requisitos Previos
1. **Balatro** (versión original de Steam).
2. **[Steamodded (SMODS)](https://github.com/Steamodded/smods)** instalado (versión **1.0.0** o superior).
3. *(Opcional pero recomendado)* **[JokerDisplay](https://github.com/Steamodded/smods)** para ver el cálculo de variables en vivo sobre cada carta.

### Instrucciones de Instalación

1. Descarga el repositorio como archivo `.zip` o clónalo con git:
   ```bash
   git clone https://github.com/Unknow1022/Cracklatro.git
   ```
2. Mueve la carpeta `Cracklatro` (o `CRACKLATRO MOD EXAMPLE`) a tu directorio de mods de Balatro:
   * **Windows**: `%AppData%\Balatro\Mods\`  
     *(Presiona `Win + R`, escribe `%AppData%\Balatro\Mods` y pulsa Enter)*
   * **macOS**: `~/Library/Application Support/Balatro/Mods/`
   * **Linux / Steam Deck**: `~/.local/share/Balatro/Mods/` o en compatdata de Proton:  
     `~/.steam/steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods/`
3. Abre Balatro y ve al menú de **Mods**; asegúrate de que **The Cracked Balatro** figure con estado verde/activo.

---

## ❓ Preguntas Frecuentes (FAQ)

<details>
<summary><b>¿Por qué no veo a los Jokers Secretos en la tienda ni en sobres de bufones?</b></summary>
<br>
Los 11 Jokers Secretos fueron diseñados deliberadamente para ser exclusivos. Su probabilidad de aparición natural en la tienda es cero; solo pueden ser invocados al usar la carta espectral <b>La Muchachada</b> o canjeando un <b>Discord Tag</b>.
</details>

<details>
<summary><b>¿Cómo funciona el Sello Verde Oscuro y su quiebre espectral?</b></summary>
<br>
Al puntuar, la carta siempre otorga su multiplicador de <b>X2.5 Multi</b>. Durante la puntuación se calcula la probabilidad de 1 en 5; si se rompe, la destrucción física se posterga hasta que todas las cartas y Jokers hayan terminado de puntuar. En ese instante, se reproduce el efecto <code>spectral_shatter</code>, se avisa a los Jokers sobre la destrucción y la carta es purgada de forma limpia sin dejar cartas invisibles ni huecos en tu mano.
</details>

<details>
<summary><b>¿Es compatible con partidas en curso y otros mods grandes?</b></summary>
<br>
Sí. Cracklatro está desarrollado con estándares modernos de Steamodded, utilizando prefijos limpios y sin sobreescribir destructivamente tablas del motor. Además, cuenta con rutinas preventivas de limpieza para reparar estados de partidas guardadas con cartas fantasma.
</details>

---

## 👤 Créditos y Agradecimientos

* **Desarrollo, Programación & Diseño**: [Unknow102](https://github.com/Unknow1022)
* **Framework Modding**: [Steamodded (SMODS)](https://github.com/Steamodded/smods)
* **Contribución Artística**: kars_on_mars (*Arte de Blueberry Joker*)
* **Agradecimientos Especiales**: A la comunidad de Balatro Modding y a todos los que reportan sugerencias y feedback.

---

<div align="center">
  <sub>Hecho con pasión para la comunidad de Balatro. ¡Que disfrutes la experiencia Cracked! 🃏</sub>
</div>
