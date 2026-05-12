#!/usr/bin/env python3
"""
Script para gerar todos os assets do Mundinho Divertido sequencialmente
usando a skill nano-banana-pro.
"""

import subprocess
import os
import time
from datetime import datetime

# Configurações
SKILL_SCRIPT = "/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE_DIR = "/home/joaosbp/mundinho-divertido/assets/images"
RESOLUTION = "1K"  # Draft quality para iteração rápida

# Lista de todos os assets a serem gerados
# (nome_arquivo, diretorio, prompt)
ASSETS = [
    # === PERSONAGEM PRINCIPAL ===
    ("mundo_idle.png", "characters/player",
     "2D cartoon child character game sprite, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, friendly smile closed mouth, red coral t-shirt with small star print, blue knee shorts, white sneakers with blue laces, neutral standing idle pose, arms relaxed slightly away from body, feet hip-width apart, weight evenly distributed, calm happy expression, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    ("mundo_walk1.png", "characters/player",
     "2D cartoon child character game sprite walking animation frame 1 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, determined happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose LEFT foot forward stepping, right arm swung forward, left arm back, slight forward body lean, mid-stride left leg extended front, right leg bent behind, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    ("mundo_walk2.png", "characters/player",
     "2D cartoon child character game sprite walking animation frame 2 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose mid-stride weight on LEFT leg, right foot lifting off ground behind, both arms at neutral sides slightly swung, body upright at peak of stride, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    ("mundo_walk3.png", "characters/player",
     "2D cartoon child character game sprite walking animation frame 3 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, determined happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose RIGHT foot forward stepping, left arm swung forward, right arm back, slight forward body lean, mid-stride right leg extended front, left leg bent behind, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    ("mundo_walk4.png", "characters/player",
     "2D cartoon child character game sprite walking animation frame 4 of 4, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, happy expression, red coral t-shirt, blue knee shorts, white sneakers with blue laces, walking pose mid-stride weight on RIGHT leg, left foot lifting off ground behind, both arms at neutral sides slightly swung, body upright at peak of stride, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    ("mundo_celebrating.png", "characters/player",
     "2D cartoon child character game sprite celebrating victory pose, 8-year-old chibi, big head small body proportions 2:1, large expressive round eyes, light blue hair short and wavy, huge open-mouth smile eyes curved happy, red coral t-shirt, blue knee shorts, white sneakers with blue laces, both arms raised high fists pumped in victory, slight jump off ground, legs spread wide landing stance, explosive joyful pose, maximum energy, full body centered visible head to toe, vector flat art style, soft teal colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing chibi style, high quality 2D game asset, clean crisp edges"),
    
    # === NPCs ===
    ("prefeito_tico.png", "characters/npcs",
     "2D cartoon mayor NPC character game sprite idle pose, friendly chubby man 50s chibi style, big round belly, thick curly handlebar mustache, small round glasses, green mayor top hat with gold star badge, blue formal suit jacket with gold buttons, red tie, dark trousers, warm big smile, medium brown skin with rosy cheeks, standing idle pose both hands relaxed at sides, authoritative yet friendly posture, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("tia_julia.png", "characters/npcs",
     "2D cartoon teacher NPC character game sprite idle pose, friendly woman 35 chibi style, hair neatly tied in high bun with yellow pencil stuck through, round glasses with thin frame, warm gentle smile, welcoming expression, yellow blouse with small flower buttons, green A-line skirt, brown flat shoes, holding open book in one arm pressed to chest, free hand at side, light brown skin, slight natural blush, knowledgeable kind aura, standing idle pose, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("dra_cassia.png", "characters/npcs",
     "2D cartoon doctor pharmacist NPC character game sprite idle pose, friendly woman 40 chibi style, hair neatly tied back in low ponytail, small square glasses, kind trustworthy smile, calm reassuring expression, white lab coat over light blue scrubs, name badge on lapel, stethoscope hanging around neck resting on chest, medium brown skin, professional yet warm demeanor, standing idle pose one hand holding clipboard at side, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("seu_correio.png", "characters/npcs",
     "2D cartoon mailman NPC character game sprite idle pose, friendly man 45 chibi style, slight stubble on face, cheerful energetic expression, red cap with brim and small mail logo badge, light blue button-up shirt with rolled sleeves, dark navy pants, brown boots, large brown mail satchel bag on shoulder overflowing with letters, light skin with rosy cheeks and freckles, hardworking honest aura, standing idle pose one hand on mail bag strap, other hand waving hello, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing NPC style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("cidadao.png", "characters/npcs",
     "2D cartoon citizen villager NPC character game sprite idle pose, friendly adult chibi style, generic friendly townsperson, medium build, casual everyday clothes yellow t-shirt and jeans, white sneakers, brown wavy hair medium length, warm neutral happy expression, carrying reusable shopping bag with produce peeking out, medium skin tone, friendly approachable aura, standing idle pose, full body centered visible head to toe, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x128 pixels, Animal Crossing villager style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    # === BUILDINGS ===
    ("casa_jogador.png", "buildings",
     "2D cartoon cozy cottage house building game asset exterior, red coral triangular roof with two chimneys with smoke curl, white painted walls, wooden arched front door with round doorknob, two windows with green shutters and colorful flower boxes, small front porch with wooden steps and railing, red mailbox on post in front yard, green manicured lawn with small bushes, potted flowers on porch, warm inviting cozy atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("mercadao.png", "buildings",
     "2D cartoon grocery store market building game asset exterior, large building red and white diagonal striped canvas awning over entrance, large glass display window showing colorful fruits and vegetables, wooden framed entrance door, hanging sign banner reading MERCADAO in bold letters, wooden fruit crates displayed outside on sidewalk with apples and oranges stacked, warm brick facade with painted trim, potted plants flanking entrance, busy cheerful market atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("padaria.png", "buildings",
     "2D cartoon bakery building game asset exterior, warm golden yellow walls with brown wood trim, bread-loaf shaped decorative roof element, chimney with steam and bread smell swirls rising, bread display window with croissants and loaves, glass entrance door with flour handprints detail, hanging sign banner reading PADARIA, bread basket displayed outside, flour sack leaning against wall, warm cozy inviting atmosphere with warm glow from inside, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant warm golden brown palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("prefeitura.png", "buildings",
     "2D cartoon town hall city hall building game asset exterior, grand imposing but friendly gray stone facade with white decorative columns, triangular pediment above entrance, wide red carpeted steps leading to large wooden double doors, Brazilian flag on tall flagpole at top, two tall windows flanking entrance with green curtains, official seal emblem above doors, potted topiaries on steps, impressive official yet welcoming atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant palette with dignified gray and gold tones, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("escola.png", "buildings",
     "2D cartoon school building game asset exterior, cheerful bright building yellow and orange painted walls, green roof with flag pole, Brazilian flag waving at top, large windows showing colorful classroom inside, main entrance with colorful tiles spelling ESCOLA, small playground visible on side, flower garden in front, hopscotch painted on path, big friendly welcoming doors, happy energetic educational atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant yellow orange cheerful palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("farmacia.png", "buildings",
     "2D cartoon pharmacy drugstore building game asset exterior, clean white walls with large red cross symbol on facade, modern clinical look, glass windows displaying medicine boxes and green cross signs, sliding glass entrance door, hanging sign banner reading FARMACIA, green potted plants and succulents outside, small parking area, sterile clean safe welcoming atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant clean palette with white green and red cross, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("correios.png", "buildings",
     "2D cartoon post office building game asset exterior, bright sunshine yellow walls with blue postal logo on facade, postal service sign, large windows with envelope and package decorations, wide entrance door, hanging sign banner reading CORREIOS, yellow mail cart parked outside, stack of packages and parcels by entrance, letter boxes on wall, busy efficient friendly atmosphere, slightly isometric top-down view angle, centered composition full building visible, vector flat art style, soft colored outlines no black lines, vibrant yellow blue cheerful postal palette, transparent background PNG, 256x256 pixels, Animal Crossing building style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    # === PARQUE ELEMENTOS ===
    ("arvore.png", "buildings",
     "2D cartoon big leafy oak tree game asset, thick brown trunk with slight texture, wide round lush green canopy with layered leaves, small colorful wildflowers growing at base of trunk, tiny bird perched in branches, full and healthy majestic tree, slightly isometric top-down view angle, centered composition full tree visible root to crown, vector flat art style, soft colored outlines no black lines, vibrant green palette, transparent background PNG, 128x128 pixels, Animal Crossing tree style, children's game art, high quality 2D game asset, clean crisp edges"),
    
    ("banco.png", "buildings",
     "2D cartoon park bench game asset, classic wooden slat bench with curved green painted metal frame legs, three wooden seat planks and two back planks, worn smooth wooden texture, slightly isometric top-down view angle showing seat and back clearly, centered composition full bench visible, vector flat art style, soft colored outlines no black lines, vibrant cheerful palette, transparent background PNG, 128x64 pixels, children's game art, high quality 2D game asset, clean crisp edges"),
    
    # === INTERIORES ===
    ("interior_quarto.png", "interiors",
     "2D cartoon children's bedroom interior room layout game background, top-down slightly tilted perspective showing full room, cozy warm atmosphere, blue single bed with white pillow and star-print blanket against wall, small wooden desk with reading lamp and open book, wooden chair with cushion, colorful toy box overflowing with plush toys and blocks, bookshelf with picture books, window with yellow curtains letting in sunlight, wooden parquet floor with round colorful rug, glow-in-dark star stickers on ceiling, pennant flag on wall, personal cozy feel, vector flat art style, soft colored outlines no black lines, warm cheerful palette, no characters, 512x512 pixels, children's game interior art, high quality 2D game background, clean crisp edges"),
    
    ("interior_cozinha.png", "interiors",
     "2D cartoon family kitchen interior room layout game background, top-down slightly tilted perspective showing full room, warm homey atmosphere, wooden dining table with four mismatched chairs in center, colorful plates on table, green stove with four burners and pots, white refrigerator with drawings and magnets, deep sink with window above showing garden outside, wooden cabinets with pots hanging, tiled floor with warm orange and white pattern, hanging lamp over table, potted herb plants on windowsill, fruit bowl on counter, cheerful family kitchen feel, vector flat art style, soft colored outlines no black lines, warm golden palette, no characters, 512x512 pixels, children's game interior art, high quality 2D game background, clean crisp edges"),
    
    # === ITENS MINI-GAMES ===
    ("maca.png", "items",
     "2D cartoon apple icon game asset, single red apple, round shape with small green leaf and brown stem on top, shiny highlight spot on surface, cute kawaii style, front-facing centered, vector flat art style, soft colored outlines no black lines, vibrant red green palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"),
    
    ("banana.png", "items",
     "2D cartoon banana icon game asset, single yellow banana, classic curved shape with brown tips, shiny highlight, cute kawaii style, front-facing centered at angle, vector flat art style, soft colored outlines no black lines, vibrant yellow palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"),
    
    ("cenoura.png", "items",
     "2D cartoon carrot icon game asset, single orange carrot, tapered root with green leafy top tuft, small lines showing texture, cute kawaii style, front-facing centered slightly angled, vector flat art style, soft colored outlines no black lines, vibrant orange green palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"),
    
    ("uvas.png", "items",
     "2D cartoon grapes cluster icon game asset, bunch of purple grapes in triangular cluster, small round individual grapes, brown curling vine stem with small green leaf, shiny highlights on each grape, cute kawaii style, front-facing centered, vector flat art style, soft colored outlines no black lines, vibrant purple green palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"),
    
    ("limao.png", "items",
     "2D cartoon lemon icon game asset, single bright yellow lemon, oval pointed-end shape with small green leaf, pitted texture surface, shiny highlight, cute kawaii style, front-facing centered, vector flat art style, soft colored outlines no black lines, vibrant yellow palette, transparent background PNG, 64x64 pixels, children's game item art, high quality 2D asset, clean crisp edges"),
    
    # === ITENS COLECIONÁVEIS ===
    ("moeda.png", "items",
     "2D cartoon gold coin collectible game asset, round shiny gold coin, star symbol embossed in center, beveled edge, three sparkle star highlights glinting, slight 3D sheen effect, cute style, vector flat art style, soft colored outlines no black lines, vibrant gold yellow palette, transparent background PNG, 64x64 pixels, children's game collectible art, high quality 2D asset, clean crisp edges"),
    
    ("estrela.png", "items",
     "2D cartoon golden reward star collectible game asset, five-pointed star with happy smiling face, big cute eyes, wide grin, golden yellow with warm glow halo around it, four sparkle points around edges, cute kawaii style, vector flat art style, soft colored outlines no black lines, vibrant golden yellow palette, transparent background PNG, 64x64 pixels, children's game reward art, high quality 2D asset, clean crisp edges"),
    
    # === UI ===
    ("botao_principal.png", "ui",
     "2D cartoon game UI button, wide rounded rectangle pill shape, bright red coral solid fill, subtle lighter red highlight stripe on top third, soft dark red drop shadow below, white centered area for text label, slight raised 3D press-able appearance, clean simple design, vector flat art style, soft colored outlines, vibrant red palette, transparent background PNG, 256x64 pixels, children's game UI element, high quality 2D asset, clean crisp edges"),
    
    ("botao_pausa.png", "ui",
     "2D cartoon game UI pause button, perfect circle shape, bright orange solid fill, subtle lighter orange highlight on top, white pause symbol two vertical bars centered, soft dark shadow below, slight raised 3D appearance, clean simple design, vector flat art style, soft colored outlines, vibrant orange palette, transparent background PNG, 64x64 pixels, children's game UI element, high quality 2D asset, clean crisp edges"),
    
    ("painel_dialogo.png", "ui",
     "2D cartoon game UI dialogue speech box, wide rounded rectangle, white fill with warm brown border three pixels thick, small speech tail pointing down-left, subtle inner shadow for depth, space for character avatar circle on left side, remaining space for text, clean readable design, vector flat art style, soft brown outlines, white warm palette, transparent background PNG, 512x128 pixels, children's game UI element, high quality 2D asset, clean crisp edges"),
    
    ("icone_inventario.png", "ui",
     "2D cartoon game UI backpack inventory icon, cute blue school backpack front view, main zipper compartment, front smaller pocket, two side mesh pockets, adjustable straps visible on sides, small keychain charm hanging, slightly open top zipper showing hint of items, friendly design, vector flat art style, soft colored outlines no black lines, vibrant blue palette, transparent background PNG, 64x64 pixels, children's game UI icon, high quality 2D asset, clean crisp edges"),
    
    # === BACKGROUNDS ===
    ("bg_mapa.png", "backgrounds",
     "2D cartoon town world map background game art top-down view, wide aerial perspective of small charming town, green grass fields with texture variation, gray paved roads intersecting in grid with dashed lane markings, sidewalks with borders, scattered oak trees and bushes in groups, small flower patches, park area with pond, empty building plot outlines, seamless repeating pattern, cheerful bright daytime, soft light shadow overlay, vector flat art style, soft colored outlines, vibrant green blue warm palette, no characters no buildings just terrain, 1920x1920 pixels, children's game map background, tileable, clean edges"),
    
    ("bg_ceu.png", "backgrounds",
     "2D cartoon sky background for main menu game art, gradient blue sky from deep blue top to light sky blue bottom, three large fluffy white cumulus clouds different sizes scattered across middle, bright yellow cartoon sun with rays in upper right corner, small birds as V-shapes flying, soft light haze near horizon, cheerful welcoming daytime atmosphere, vector flat art style, soft colored outlines, vibrant blue white yellow palette, no characters, 1920x1080 pixels, children's game menu background, high quality 2D art, clean smooth gradients"),
]

def generate_asset(filename, directory, prompt):
    """Gera um asset usando a skill nano-banana-pro."""
    output_dir = os.path.join(BASE_DIR, directory)
    os.makedirs(output_dir, exist_ok=True)
    
    output_path = os.path.join(output_dir, filename)
    
    # Verifica se já existe
    if os.path.exists(output_path):
        print(f"  ⚠️  {filename} já existe, pulando...")
        return True
    
    print(f"\n🎨 Gerando: {filename}")
    print(f"   📁 {directory}")
    
    try:
        result = subprocess.run(
            [
                "uv", "run", SKILL_SCRIPT,
                "--prompt", prompt,
                "--filename", filename,
                "--resolution", RESOLUTION,
            ],
            cwd=output_dir,
            capture_output=True,
            text=True,
            timeout=120,
        )
        
        if result.returncode == 0:
            print(f"   ✅ Sucesso: {filename}")
            return True
        else:
            print(f"   ❌ Erro: {result.stderr}")
            return False
            
    except subprocess.TimeoutExpired:
        print(f"   ⏱️  Timeout: {filename}")
        return False
    except Exception as e:
        print(f"   ❌ Exceção: {e}")
        return False

def main():
    print("=" * 60)
    print("🎮 MUNDINHO DIVERTIDO - Geração de Assets")
    print("=" * 60)
    print(f"\nTotal de assets a gerar: {len(ASSETS)}")
    print(f"Resolução: {RESOLUTION}")
    print(f"Diretório base: {BASE_DIR}")
    print("\n" + "=" * 60)
    
    success_count = 0
    fail_count = 0
    
    for i, (filename, directory, prompt) in enumerate(ASSETS, 1):
        print(f"\n[{i}/{len(ASSETS)}] ", end="")
        
        if generate_asset(filename, directory, prompt):
            success_count += 1
        else:
            fail_count += 1
        
        # Pequena pausa entre gerações para não sobrecarregar a API
        time.sleep(2)
    
    print("\n" + "=" * 60)
    print("📊 RESUMO")
    print("=" * 60)
    print(f"✅ Sucessos: {success_count}")
    print(f"❌ Falhas: {fail_count}")
    print(f"📁 Total: {len(ASSETS)}")
    print("=" * 60)

if __name__ == "__main__":
    main()
