#!/bin/bash
# Gera TODOS os assets restantes sequencialmente

set -e
export GEMINI_API_KEY="$(grep GEMINI_API_KEY ~/.bashrc | head -1 | sed 's/export GEMINI_API_KEY="\(.*\)"/\1/')"
SKILL="/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE="/home/joaosbp/mundinho-divertido/assets/images"

TOTAL=0
OK=0
FAIL=0

gen() {
    local file="$1"
    local dir="$2"
    local prompt="$3"
    
    mkdir -p "$BASE/$dir"
    
    if [ -f "$BASE/$dir/$file" ]; then
        echo "[$TOTAL] ⚠️  $file já existe"
        return 0
    fi
    
    TOTAL=$((TOTAL + 1))
    echo ""
    echo "[$TOTAL] 🎨 $file"
    
    if uv run "$SKILL" --prompt "$prompt" --filename "$file" --resolution 1K 2>/dev/null; then
        echo "   ✅ OK"
        OK=$((OK + 1))
    else
        echo "   ❌ FALHOU"
        FAIL=$((FAIL + 1))
    fi
    
    sleep 2
}

echo "=========================================="
echo "🎮 GERANDO ASSETS RESTANTES"
echo "=========================================="

# === PERSONAGEM: RUN FRAMES ===
gen "mundo_run_frame2.png" "characters/player" "2D cartoon child character game sprite running animation frame 2 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair blown back, excited energetic expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, running pose both feet off ground mid-air leap, legs split front and back, arms pumping, body leaning forward, airborne sprint pose, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

gen "mundo_run_frame3.png" "characters/player" "2D cartoon child character game sprite running animation frame 3 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair blown back by wind speed, excited energetic expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, running pose RIGHT foot planted pushing off ground, left leg kicked forward high, left arm punched forward high, right arm pulled back, body leaning forward aggressively, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

gen "mundo_run_frame4.png" "characters/player" "2D cartoon child character game sprite running animation frame 4 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair blown back, excited energetic expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, running pose landing right foot touching ground, left leg trailing behind, arms adjusting balance, body slightly upright transitioning stride, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

# === PERSONAGEM: SITTING ===
gen "mundo_sitting.png" "characters/player" "2D cartoon child character game sprite sitting pose, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, calm happy relaxed expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, sitting cross-legged on ground, hands resting on knees palms up, body upright, comfortable relaxed pose, slight smile, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

# === PERSONAGEM: SURPRISED ===
gen "mundo_surprised.png" "characters/player" "2D cartoon child character game sprite surprised shocked expression, 8-year-old chibi, big head small body proportions 2:1, very large expressive round eyes wide open, light blue hair short and wavy standing slightly on end, mouth open wide O shape, red coral t-shirt, blue knee shorts, white sneakers with blue laces, both hands on cheeks Home Alone pose, feet together standing straight, eyebrows raised high, exaggerated cartoon surprise expression, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

# === NPCs VARIAÇÕES ===
gen "prefeito_tico_talking.png" "characters/npcs" "2D cartoon mayor NPC character game sprite talking gesture pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge, blue formal suit jacket with gold buttons, red tie, dark trousers, open mouth mid-speech expression eyes bright and engaged, medium brown skin with rosy cheeks, one hand raised with index finger pointing up making a point gesture, other hand on belly, leaning slightly forward speaking enthusiastically, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

gen "prefeito_tico_celebrating.png" "characters/npcs" "2D cartoon mayor NPC character game sprite celebrating happy pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge askew from joy, blue formal suit jacket with gold buttons, red tie loosened slightly, enormous open-mouth laugh eyes squeezed shut from happiness, medium brown skin with rosy cheeks, slight blush marks, both arms raised wide open in celebration, belly bouncing pose, legs spread wide exuberant stance, maximum joy energy, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

# === PARQUE ELEMENTOS ===
gen "escorregador.png" "buildings" "2D cartoon playground slide game asset, classic children's slide with bright red plastic slide chute, blue metal ladder with yellow rungs, yellow plastic platform at top, safety rails on sides, sturdy base, cheerful primary colors, slightly isometric top-down view angle, centered composition full slide structure visible, vector flat art style, soft colored outlines no black lines, vibrant primary colors palette, transparent background PNG, 128x128 pixels, children's game art, high quality 2D game asset, clean crisp edges"

gen "fonte_parque.png" "buildings" "2D cartoon decorative park fountain game asset, round stone basin with light gray texture, central pillar with water spraying upward, gentle water arcs falling back into basin, water surface shimmering blue, decorative stone carved details on basin edge, small coins at bottom, slightly isometric top-down view angle, centered composition full fountain visible, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette with blue water tones, transparent background PNG, 128x128 pixels, children's game art, high quality 2D game asset, clean crisp edges"

# === INTERIORES RESTANTES ===
gen "interior_mercadao.png" "interiors" "2D cartoon grocery store interior room layout game background, top-down slightly tilted perspective showing full room, abundant colorful atmosphere, multiple wooden shelving units stocked with colorful product boxes cans and bags, fresh produce section with fruit and vegetable display bins, checkout counter with register, tiled floor with red and white checker pattern, overhead pendant lighting, shopping baskets stacked near entrance, price signs and promotional banners, refrigerator section with glass doors, well-stocked inviting market feel, vector flat art style, soft colored outlines no black lines, vibrant colorful abundant palette, no characters, 512x512 pixels, children's game interior art, high quality 2D game background, clean crisp edges"

gen "interior_padaria.png" "interiors" "2D cartoon bakery interior room layout game background, top-down slightly tilted perspective showing full room, warm delicious atmosphere, glass display case counter filled with breads croissants cakes and pastries, wooden service counter with cash register, brick oven with warm orange glow and bread inside, flour bags stacked in corner, large mixing bowls on wooden worktable, rolling pin and tools, warm orange tile floor, brick wall with hanging copper pots, menu chalkboard on wall, smell-swirl decorations, cozy artisanal bakery feel, vector flat art style, soft colored outlines no black lines, warm golden brown cheerful palette, no characters, 512x512 pixels, children's game interior art, high quality 2D game background, clean crisp edges"

gen "interior_escola_sala.png" "interiors" "2D cartoon elementary school classroom interior room layout game background, top-down slightly tilted perspective showing full room, bright educational atmosphere, large green chalkboard with ABCs and math equations on wall, teacher's wooden desk, rows of small student desks with chairs, colorful alphabet poster on wall, globe on bookshelf, world map poster, potted classroom plant in corner, windows with sun streaming in, colorful crayon bins on desks, pencil holder, educational chart posters, light wood floor, encouraging cheerful classroom feel, vector flat art style, soft colored outlines no black lines, bright educational palette, no characters, 512x512 pixels, children's game interior art, high quality 2D game background, clean crisp edges"

# === ITENS MINI-GAMES: LISTA DE COMPRAS ===
gen "prateleira_vazia.png" "items" "2D cartoon store shelf unit game asset, wooden shelf unit with three levels, light wood grain texture, empty product slots on each level, small price tag rails on shelf edges, front-facing flat view, solid base with side supports, vector flat art style, soft colored outlines no black lines, warm wood brown palette, transparent background PNG, 256x128 pixels, children's game art, high quality 2D asset, clean crisp edges"

# === ITENS MINI-GAMES: PADEIRO MIRIM ===
gen "ingrediente_farinha.png" "items" "2D cartoon flour bag icon game asset, small white paper flour bag, tied at top with red string, FARINHA label on front, small cloud of flour puff at top, cute kawaii style, front-facing centered, vector flat art style, soft colored outlines no black lines, white cream palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "ingrediente_ovo.png" "items" "2D cartoon egg carton icon game asset, small cardboard egg carton with two eggs visible and white shell shining, carton lid open showing brown and white eggs, cute kawaii style, slightly angled view, vector flat art style, soft colored outlines no black lines, cream brown palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "ingrediente_leite.png" "items" "2D cartoon milk carton icon game asset, small white milk carton with blue cow illustration and LEITE text, classic gable-top carton shape, cute kawaii style, front-facing slightly angled, vector flat art style, soft colored outlines no black lines, white blue palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "ingrediente_manteiga.png" "items" "2D cartoon butter stick icon game asset, rectangular yellow butter stick in gold foil wrapper partially peeled back, MANTEIGA text on wrapper, cute kawaii style, slightly angled view showing top and front, vector flat art style, soft colored outlines no black lines, yellow gold palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "ingrediente_acucar.png" "items" "2D cartoon sugar bowl icon game asset, small white ceramic sugar bowl with lid, decorative blue flower pattern, sugar crystals spilling slightly over edge of open bowl, small spoon in bowl, cute kawaii style, front-facing slightly angled, vector flat art style, soft colored outlines no black lines, white blue palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "tigela_mistura.png" "items" "2D cartoon mixing bowl with batter game asset, large round metal mixing bowl silver with smooth surface, filled halfway with thick yellow cake batter, wooden spoon leaning in bowl handle over rim, small splashes of batter on spoon, slightly top-down angle showing batter inside, cute style, vector flat art style, soft colored outlines no black lines, silver yellow warm palette, transparent background PNG, 128x128 pixels, children's game item art, high quality 2D asset, clean crisp edges"

gen "forno_padaria.png" "items" "2D cartoon brick bakery oven game asset, classic stone brick oven with arched opening, warm orange and red fire glow from inside, golden-brown bread loaves visible through opening, small door ajar, heat wave lines rising above oven, smoke puff from small chimney, front-facing view, solid and rustic feel, vector flat art style, soft colored outlines no black lines, warm orange brick brown palette, transparent background PNG, 128x128 pixels, children's game item art, high quality 2D asset, clean crisp edges"

# === LETRAS A-Z (26 assets) ===
for letter in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z; do
    color=""
    case $letter in
        A) color="red";; B) color="orange";; C) color="yellow";; D) color="green";;
        E) color="teal";; F) color="blue";; G) color="purple";; H) color="pink";;
        I) color="red";; J) color="orange";; K) color="yellow";; L) color="green";;
        M) color="teal";; N) color="blue";; O) color="purple";; P) color="pink";;
        Q) color="red";; R) color="orange";; S) color="yellow";; T) color="green";;
        U) color="teal";; V) color="blue";; W) color="purple";; X) color="pink";;
        Y) color="red";; Z) color="orange";;
    esac
    
    gen "letra_${letter,,}.png" "items" "2D cartoon letter ${letter} block, uppercase bold playful font, bright ${color} color, rounded corners, slight 3D bevel effect, small star decoration on letter, centered on frame, cute kawaii style, vector flat art style, soft colored outlines no black lines, vibrant palette, transparent background PNG, 64x64 pixels, children's educational game asset, high quality 2D asset, clean crisp edges"
done

# === MATEMÁTICA ===
gen "objeto_circulo.png" "items" "2D cartoon counting circle shape icon game asset, single round circle shape, bright solid red color, thick border, smooth clean shape, cute kawaii style with small eyes, centered on frame, vector flat art style, soft colored outlines no black lines, vibrant palette, transparent background PNG, 64x64 pixels, children's educational math game asset, high quality 2D asset, clean crisp edges"

gen "objeto_estrela_mat.png" "items" "2D cartoon counting star shape icon game asset, single five-pointed star, bright solid yellow color, classic even star proportions, cute kawaii style with small smile face, centered on frame, vector flat art style, soft colored outlines no black lines, vibrant yellow palette, transparent background PNG, 64x64 pixels, children's educational math game asset, high quality 2D asset, clean crisp edges"

gen "objeto_quadrado.png" "items" "2D cartoon counting square shape icon game asset, single square shape with slightly rounded corners, bright solid blue color, cute kawaii style with small face, centered on frame, vector flat art style, soft colored outlines no black lines, vibrant blue palette, transparent background PNG, 64x64 pixels, children's educational math game asset, high quality 2D asset, clean crisp edges"

gen "abaco.png" "items" "2D cartoon abacus counting tool game asset, classic wooden frame abacus with two rows of colorful beads, red yellow blue green beads alternating, sturdy brown wooden frame, slightly isometric view showing bead rows clearly, cute style, vector flat art style, soft colored outlines no black lines, vibrant colorful palette, transparent background PNG, 64x64 pixels, children's educational math game asset, high quality 2D asset, clean crisp edges"

# === PINTURA LIVRE ===
gen "item_pincel.png" "items" "2D cartoon paintbrush game asset, single artist paintbrush, wooden handle with flat metal ferrule, full bristles loaded with blue paint drip, slightly angled, cute style, vector flat art style, soft colored outlines no black lines, vibrant palette, transparent background PNG, 64x64 pixels, children's art game asset, high quality 2D asset, clean crisp edges"

gen "item_paleta_tinta.png" "items" "2D cartoon paint palette game asset, classic oval wooden palette with thumb hole, six colorful paint dabs in rainbow order, red orange yellow green blue purple, slightly messy with color mixing, cute style, vector flat art style, soft colored outlines no black lines, vibrant rainbow palette, transparent background PNG, 64x64 pixels, children's art game asset, high quality 2D asset, clean crisp edges"

gen "item_tela.png" "items" "2D cartoon blank canvas on easel mini game asset, small wooden canvas stretcher frame, white blank painting surface, easel legs spread below, cute simple style, slightly angled view, vector flat art style, soft colored outlines no black lines, white warm wood palette, transparent background PNG, 64x64 pixels, children's art game asset, high quality 2D asset, clean crisp edges"

gen "item_gizao_cera.png" "items" "2D cartoon crayon game asset, single fat crayon, cylindrical shape with paper wrapper, bright rainbow gradient colors, classic crayon tip with sharp point, label showing color swirl, cute kawaii style, vector flat art style, soft colored outlines no black lines, vibrant palette, transparent background PNG, 64x64 pixels, children's art game asset, high quality 2D asset, clean crisp edges"

gen "item_borracha.png" "items" "2D cartoon pink eraser game asset, rectangular pink rubber eraser, one end used showing white core, pencil marks being erased effect, cute kawaii style, slight angle, vector flat art style, soft colored outlines no black lines, pink white palette, transparent background PNG, 64x64 pixels, children's art game asset, high quality 2D asset, clean crisp edges"

# === COLECIONÁVEIS ===
gen "adesivo_medica.png" "items" "2D cartoon doctor medical badge sticker collectible game asset, round badge shape, white cross on red background, small red heart below cross, gold star border around edge, shiny sticker appearance, cute style, vector flat art style, soft colored outlines no black lines, red white gold palette, transparent background PNG, 64x64 pixels, children's game collectible sticker art, high quality 2D asset, clean crisp edges"

gen "adesivo_carteiro.png" "items" "2D cartoon mailman badge sticker collectible game asset, round badge shape, envelope icon with wings on blue background, gold star border around edge, shiny sticker appearance, cute style, vector flat art style, soft colored outlines no black lines, blue white gold palette, transparent background PNG, 64x64 pixels, children's game collectible sticker art, high quality 2D asset, clean crisp edges"

gen "adesivo_chef.png" "items" "2D cartoon chef hat badge sticker collectible game asset, round badge shape, white puffy chef toque hat on warm orange background, small whisk and spatula crossed below hat, gold star border around edge, shiny sticker appearance, cute style, vector flat art style, soft colored outlines no black lines, orange white gold palette, transparent background PNG, 64x64 pixels, children's game collectible sticker art, high quality 2D asset, clean crisp edges"

gen "adesivo_estrela_colet.png" "items" "2D cartoon star achievement sticker collectible game asset, star shape badge, rainbow gradient fill red to purple, PARABENS text arc above star, gold glitter border, sparkle effects around edges, shiny sticker appearance, cute style, vector flat art style, soft colored outlines no black lines, rainbow gold palette, transparent background PNG, 64x64 pixels, children's game collectible sticker art, high quality 2D asset, clean crisp edges"

gen "adesivo_fita.png" "items" "2D cartoon ribbon award badge sticker collectible game asset, first place ribbon rosette, blue circular center with gold star, red ribbon tails hanging below, gold trim around rosette, shiny sticker appearance, cute style, vector flat art style, soft colored outlines no black lines, blue red gold palette, transparent background PNG, 64x64 pixels, children's game collectible sticker art, high quality 2D asset, clean crisp edges"

gen "receita_scroll.png" "items" "2D cartoon recipe scroll collectible game asset, rolled parchment scroll, cream aged paper partially unrolled, simple food drawings on visible portion bread and cake sketch, dotted text lines below, rolled curled edges top and bottom, brown ribbon tied around center, cute style, vector flat art style, soft colored outlines no black lines, warm cream brown palette, transparent background PNG, 64x64 pixels, children's game collectible item art, high quality 2D asset, clean crisp edges"

# === UI RESTANTE ===
gen "barra_progresso.png" "ui" "2D cartoon game UI progress bar, wide rounded rectangle track, dark teal empty track background, bright green fill portion covering 60% of bar, green transitions to yellow at high fill, small five-pointed star markers at 25 50 75 100 percent marks, rounded fill end cap, subtle shine highlight stripe on top, outer border soft dark shadow, vector flat art style, soft colored outlines, vibrant green yellow palette, transparent background PNG, 256x32 pixels, children's game UI element, high quality 2D asset, clean crisp edges"

gen "icone_missoes.png" "ui" "2D cartoon game UI quest missions scroll icon, rolled parchment scroll partially open showing quest checkboxes, one checked, brown leather cord tied around center, wax seal on cord with star stamp, small quill feather pen tucked in cord, golden glow around scroll edge, vector flat art style, soft colored outlines no black lines, warm parchment gold palette, transparent background PNG, 64x64 pixels, children's game UI icon, high quality 2D asset, clean crisp edges"

# === EFEITOS VFX ===
gen "vfx_confete.png" "effects" "2D cartoon celebration confetti particle effect game asset sprite sheet, colorful paper confetti pieces falling, mix of rectangular strips and small circles, rainbow colors red orange yellow green blue purple, some pieces curling mid-air, varied rotation angles, festive celebratory burst pattern expanding outward, vector flat art style, soft colored outlines, vibrant full rainbow palette, transparent background PNG, 256x256 pixels, children's game VFX sprite sheet, high quality 2D asset, clean crisp edges, 4x4 grid frames"

gen "vfx_sparkle.png" "effects" "2D cartoon magic sparkle burst star effect game asset, central bright starburst with four main rays and four secondary diagonal rays, glowing white core fading to yellow then transparent at tips, small diamond sparkle dots scattered around central burst, shimmering glow effect, magical rewarding feel, vector flat art style, soft colored outlines, vibrant white yellow golden palette, transparent background PNG, 128x128 pixels, children's game VFX sparkle magic asset, high quality 2D asset, clean crisp edges"

gen "vfx_coracao.png" "effects" "2D cartoon floating heart friendship effect game asset, single heart shape, bright pink with white shine highlight in upper left, small pink glow halo around heart, one small sparkle dot beside it, slight upward float implied by small motion blur below, cute kawaii style, vector flat art style, soft colored outlines no black lines, vibrant pink palette, transparent background PNG, 64x64 pixels, children's game VFX affection asset, high quality 2D asset, clean crisp edges"

# === TELAS DE MENU ===
gen "logo_jogo.png" "ui" "2D cartoon game logo title, large bold playful text MUNDINHO DIVERTIDO, rounded chunky bubbly letters, each letter in alternating rainbow colors, letters have slight outline in white and soft drop shadow, small star decorations scattered around text, colorful confetti around logo, sun rays emanating from behind text, festive joyful design, vector flat art style, vibrant full rainbow palette, transparent background PNG, 1024x512 pixels, children's game title logo, high quality 2D art, clean crisp edges"

gen "tela_loading.png" "backgrounds" "2D cartoon loading screen full illustration game art, sky blue gradient background with fluffy clouds, bright sun upper corner, center bottom shows cute chibi child character mid running stride enthusiastic, horizontal progress bar in lower third with star markers and partial green fill, CARREGANDO text in chunky playful font above progress bar with animated dots implied, small decorative stars and sparkles scattered in sky area, warm welcoming engaging atmosphere, vector flat art style, vibrant cheerful palette, 1920x1080 pixels, children's game loading screen, high quality 2D art, clean crisp edges"

echo ""
echo "=========================================="
echo "📊 RESUMO FINAL"
echo "=========================================="
echo "Total processado: $TOTAL"
echo "✅ Sucessos: $OK"
echo "❌ Falhas: $FAIL"
echo "=========================================="
