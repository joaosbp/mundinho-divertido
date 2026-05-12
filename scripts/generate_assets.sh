#!/bin/bash
# Script para gerar todos os assets do Mundinho Divertido
# Executa sequencialmente, um por vez

set -e

SKILL_SCRIPT="/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE_DIR="/home/joaosbp/mundinho-divertido/assets/images"
RESOLUTION="1K"

# Carregar API key
export GEMINI_API_KEY="$(grep "GEMINI_API_KEY" ~/.bashrc | head -1 | sed 's/export GEMINI_API_KEY="\(.*\)"/\1/')"

echo "=========================================="
echo "🎮 MUNDINHO DIVERTIDO - Geração de Assets"
echo "=========================================="
echo ""

# Contador
TOTAL=0
SUCCESS=0
FAIL=0

# Função para gerar um asset
generate_asset() {
    local filename="$1"
    local directory="$2"
    local prompt="$3"
    
    local output_dir="$BASE_DIR/$directory"
    mkdir -p "$output_dir"
    
    local output_path="$output_dir/$filename"
    
    # Verifica se já existe
    if [ -f "$output_path" ]; then
        echo "  ⚠️  $filename já existe, pulando..."
        return 0
    fi
    
    echo ""
    echo "🎨 [$TOTAL] Gerando: $filename"
    echo "   📁 $directory"
    
    if uv run "$SKILL_SCRIPT" \
        --prompt "$prompt" \
        --filename "$filename" \
        --resolution "$RESOLUTION" \
        --api-key "$GEMINI_API_KEY" 2>&1; then
        echo "   ✅ Sucesso: $filename"
        SUCCESS=$((SUCCESS + 1))
    else
        echo "   ❌ Falha: $filename"
        FAIL=$((FAIL + 1))
    fi
    
    sleep 2
}

# ============================================
# PERSONAGEM PRINCIPAL
# ============================================
echo ""
echo "📌 SEÇÃO 1: Personagem Principal"
echo "=========================================="

TOTAL=$((TOTAL + 1))
generate_asset "mundo_idle.png" "characters/player" \
"2D cartoon child character game sprite, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, friendly smile closed mouth, red coral t-shirt with small star print, blue knee shorts, white sneakers with blue laces, neutral standing idle pose, arms relaxed slightly away from body, feet hip-width apart, weight evenly distributed, calm happy expression, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mundo_walk1.png" "characters/player" \
"2D cartoon child character game sprite walking animation frame 1 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, determined happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose LEFT foot forward stepping, right arm swung forward, left arm back, slight forward body lean, mid-stride left leg extended front, right leg bent behind, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mundo_walk2.png" "characters/player" \
"2D cartoon child character game sprite walking animation frame 2 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose mid-stride weight on LEFT leg, right foot lifting off ground behind, both arms at neutral sides slightly swung, body upright at peak of stride, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mundo_walk3.png" "characters/player" \
"2D cartoon child character game sprite walking animation frame 3 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, determined happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose RIGHT foot forward stepping, left arm swung forward, right arm back, slight forward body lean, mid-stride right leg extended front, left leg bent behind, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mundo_walk4.png" "characters/player" \
"2D cartoon child character game sprite walking animation frame 4 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose mid-stride weight on RIGHT leg, left foot lifting off ground behind, both arms at neutral sides slightly swung, body upright at peak of stride, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mundo_celebrating.png" "characters/player" \
"2D cartoon child character game sprite celebrating victory pose, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, huge open-mouth smile eyes curved happy, red coral t-shirt, blue knee shorts, white sneakers with blue laces, both arms raised high fists pumped in victory, slight jump off ground, legs spread wide landing stance, explosive joyful pose, maximum energy, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

# ============================================
# NPCs
# ============================================
echo ""
echo "📌 SEÇÃO 2: NPCs"
echo "=========================================="

TOTAL=$((TOTAL + 1))
generate_asset "prefeito_tico.png" "characters/npcs" \
"2D cartoon mayor NPC character game sprite idle pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge, blue formal suit jacket with gold buttons, red tie, dark trousers, warm big smile, medium brown skin with rosy cheeks, standing idle pose both hands relaxed at sides, authoritative yet friendly posture, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "tia_julia.png" "characters/npcs" \
"2D cartoon teacher NPC character game sprite idle pose, friendly woman 35 chibi style, hair neatly tied in high bun with yellow pencil stuck through, round glasses with thin frame, warm gentle smile, welcoming expression, yellow blouse with small flower buttons, green A-line skirt, brown flat shoes, holding open book in one arm pressed to chest, free hand at side, light brown skin, slight natural blush, knowledgeable kind aura, standing idle pose, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "dra_cassia.png" "characters/npcs" \
"2D cartoon doctor pharmacist NPC character game sprite idle pose, friendly woman 40 chibi style, hair neatly tied back in low ponytail, small square glasses, kind trustworthy smile, calm reassuring expression, white lab coat over light blue scrubs, name badge on lapel, stethoscope hanging around neck resting on chest, medium brown skin, professional yet warm demeanor, standing idle pose one hand holding clipboard at side, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "seu_correio.png" "characters/npcs" \
"2D cartoon mailman NPC character game sprite idle pose, friendly man 45 chibi style, slight stubble on face, cheerful energetic expression, red cap with brim and small mail logo badge, light blue button-up shirt with rolled sleeves, dark navy pants, brown boots, large brown mail satchel bag on shoulder overflowing with letters, light skin with rosy cheeks and freckles, hardworking honest aura, standing idle pose one hand on mail bag strap, other hand waving hello, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "cidadao.png" "characters/npcs" \
"2D cartoon citizen villager NPC character game sprite idle pose, friendly adult chibi style, generic friendly townsperson, medium build, casual everyday clothes yellow t-shirt and jeans, white sneakers, brown wavy hair medium length, warm neutral happy expression, carrying reusable shopping bag with produce peeking out, medium skin tone, friendly approachable aura, standing idle pose, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing villager style, children's game art, high quality 2D game asset, clean crisp edges"

# ============================================
# BUILDINGS
# ============================================
echo ""
echo "📌 SEÇÃO 3: Buildings"
echo "=========================================="

TOTAL=$((TOTAL + 1))
generate_asset "casa_jogador.png" "buildings" \
"2D cartoon cozy cottage house building game asset exterior, red coral triangular roof with two chimneys with smoke curl, white painted walls, wooden arched front door with round doorknob, two windows with green shutters and colorful flower boxes, small front porch with wooden steps and railing, red mailbox on post in front yard, green manicured lawn with small bushes, potted flowers on porch, warm inviting cozy atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "mercadao.png" "buildings" \
"2D cartoon grocery store market building game asset exterior, large building red and white diagonal striped canvas awning over entrance, large glass display window showing colorful fruits and vegetables, wooden framed entrance door, hanging sign banner reading MERCADAO in bold letters, wooden fruit crates displayed outside on sidewalk with apples and oranges stacked, warm brick facade with painted trim, potted plants flanking entrance, busy cheerful market atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "padaria.png" "buildings" \
"2D cartoon bakery building game asset exterior, warm golden yellow walls with brown wood trim, bread-loaf shaped decorative roof element, chimney with steam and bread smell swirls rising, bread display window with croissants and loaves, glass entrance door with flour handprints detail, hanging sign banner reading PADARIA, bread basket displayed outside, flour sack leaning against wall, warm cozy inviting atmosphere with warm glow from inside, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm golden brown palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "prefeitura.png" "buildings" \
"2D cartoon town hall city hall building game asset exterior, grand imposing but friendly gray stone facade with white decorative columns, triangular pediment above entrance, wide red carpeted steps leading to large wooden double doors, Brazilian flag on tall flagpole at top, two tall windows flanking entrance with green curtains, official seal emblem above doors, potted topiaries on steps, impressive official yet welcoming atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant palette with dignified gray and gold tones, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "escola.png" "buildings" \
"2D cartoon school building game asset exterior, cheerful bright building yellow and orange painted walls, green roof with flag pole, Brazilian flag waving at top, large windows showing colorful classroom inside, main entrance with colorful tiles spelling ESCOLA, small playground visible on side, flower garden in front, hopscotch painted on path, big friendly welcoming doors, happy energetic educational atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant yellow orange cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "farmacia.png" "buildings" \
"2D cartoon pharmacy drugstore building game asset exterior, clean white walls with large red cross symbol on facade, modern clinical look, glass windows displaying medicine boxes and green cross signs, sliding glass entrance door, hanging sign banner reading FARMACIA, green potted plants and succulents outside, small parking area, sterile clean safe welcoming atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant clean palette with white green and red cross, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "correios.png" "buildings" \
"2D cartoon post office building game asset exterior, bright sunshine yellow walls with blue postal logo on facade, postal service sign, large windows with envelope and package decorations, wide entrance door, hanging sign banner reading CORREIOS, yellow mail cart parked outside, stack of packages and parcels by entrance, letter boxes on wall, busy efficient friendly atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant yellow blue cheerful postal palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "arvore.png" "buildings" \
"2D cartoon big leafy oak tree game asset, thick brown trunk with slight texture, wide round lush green canopy with layered leaves, small colorful wildflowers growing at base of trunk, tiny bird perched in branches, full and healthy majestic tree, slightly isometric top-down view angle, centered composition full tree visible root to crown, vector flat art style, soft colored outlines no black lines, vibrant green palette, transparent background PNG, 128x128 pixels, Animal Crossing tree style, children's game art, high quality 2D game asset, clean crisp edges"

TOTAL=$((TOTAL + 1))
generate_asset "banco.png" "buildings" \
"2D cartoon park bench game asset, classic wooden slat bench with curved green painted metal frame legs, three wooden seat planks and two back planks, worn smooth wooden texture, slightly isometric top-down view angle showing seat and back clearly, centered composition full bench visible, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x64 pixels, children's game art, high quality 2D game asset, clean crisp edges"

# ============================================
# RESUMO
# ============================================
echo ""
echo "=========================================="
echo "📊 RESUMO FINAL"
echo "=========================================="
echo "✅ Sucessos: $SUCCESS"
echo "❌ Falhas: $FAIL"
echo "📁 Total processado: $TOTAL"
echo "=========================================="
