#!/bin/bash
# Gera assets em batches de 5

set -e
export GEMINI_API_KEY="$(grep GEMINI_API_KEY ~/.bashrc | head -1 | sed 's/export GEMINI_API_KEY="\(.*\)"/\1/')"
SKILL="/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE="/home/joaosbp/mundinho-divertido/assets/images"

generate() {
    local file="$1"
    local dir="$2"
    local prompt="$3"
    
    mkdir -p "$BASE/$dir"
    
    if [ -f "$BASE/$dir/$file" ]; then
        echo "  ⚠️  $file existe"
        return 0
    fi
    
    echo "🎨 $file"
    if uv run "$SKILL" --prompt "$prompt" --filename "$file" --resolution 1K --api-key "$GEMINI_API_KEY" 2>/dev/null; then
        echo "  ✅"
        return 0
    else
        echo "  ❌"
        return 1
    fi
}

# Batch 1: Personagens restantes
echo "=== BATCH 1: Personagens restantes ==="
generate "mundo_sitting.png" "characters/player" "2D cartoon child character game sprite sitting pose, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, calm happy relaxed expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, sitting cross-legged on ground, hands resting on knees palms up, body upright, comfortable relaxed pose, slight smile, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

generate "mundo_surprised.png" "characters/player" "2D cartoon child character game sprite surprised shocked expression, 8-year-old chibi, big head small body proportions 2:1, very large expressive round eyes wide open, light blue hair short and wavy standing slightly on end, mouth open wide O shape, red coral t-shirt, blue knee shorts, white sneakers with blue laces, both hands on cheeks Home Alone pose, feet together standing straight, eyebrows raised high, exaggerated cartoon surprise expression, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"

generate "prefeito_tico_talking.png" "characters/npcs" "2D cartoon mayor NPC character game sprite talking gesture pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge, blue formal suit jacket with gold buttons, red tie, dark trousers, open mouth mid-speech expression eyes bright and engaged, medium brown skin with rosy cheeks, one hand raised with index finger pointing up making a point gesture, other hand on belly, leaning slightly forward speaking enthusiastically, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

generate "prefeito_tico_celebrating.png" "characters/npcs" "2D cartoon mayor NPC character game sprite celebrating happy pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge askew from joy, blue formal suit jacket with gold buttons, red tie loosened slightly, enormous open-mouth laugh eyes squeezed shut from happiness, medium brown skin with rosy cheeks, slight blush marks, both arms raised wide open in celebration, belly bouncing pose, legs spread wide exuberant stance, maximum joy energy, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"

echo ""
echo "=== BATCH 1 COMPLETO ==="
