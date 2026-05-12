#!/usr/bin/env python3
"""
Gera TODOS os assets faltantes do PROMPTS_GERACAO.md
Extrai prompts automaticamente e executa sequencialmente.
"""

import subprocess
import os
import re
import time

SKILL = "/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE_DIR = "/home/joaosbp/mundinho-divertido/assets/images"
PROMPTS_FILE = "/home/joaosbp/mundinho-divertido/docs/PROMPTS_GERACAO.md"
RESOLUTION = "1K"

# Mapeamento de nomes para diretórios
DIR_MAP = {
    "mundo_": "characters/player",
    "prefeito_tico": "characters/npcs", 
    "tia_julia": "characters/npcs",
    "dra_cassia": "characters/npcs",
    "seu_correio": "characters/npcs",
    "cidadao": "characters/npcs",
    "casa_jogador": "buildings",
    "mercadao": "buildings",
    "padaria": "buildings",
    "prefeitura": "buildings",
    "escola": "buildings",
    "farmacia": "buildings",
    "correios": "buildings",
    "arvore": "buildings",
    "banco": "buildings",
    "escorregador": "buildings",
    "fonte": "buildings",
    "interior_": "interiors",
    "item_maca": "items",
    "item_banana": "items",
    "item_cenoura": "items",
    "item_uvas": "items",
    "item_limao": "items",
    "prateleira": "items",
    "ingrediente_": "items",
    "tigela_": "items",
    "forno_": "items",
    "letra_": "items",
    "objeto_": "items",
    "abaco": "items",
    "item_pincel": "items",
    "item_paleta": "items",
    "item_tela": "items",
    "item_gizao": "items",
    "item_borracha": "items",
    "moeda_": "items",
    "estrela_": "items",
    "adesivo_": "items",
    "receita_": "items",
    "bg_": "backgrounds",
    "ui_": "ui",
    "botao_": "ui",
    "painel_": "ui",
    "icone_": "ui",
    "barra_": "ui",
    "vfx_": "effects",
    "logo_": "ui",
    "tela_": "backgrounds",
}


def get_dir(name):
    for prefix, d in DIR_MAP.items():
        if name.lower().startswith(prefix.lower()):
            return d
    return "misc"


def parse_all_assets():
    """Extrai (nome, prompt) de todos os assets no arquivo."""
    with open(PROMPTS_FILE, 'r') as f:
        content = f.read()
    
    assets = []
    # Padrão: ### 1.1.1 — NOME_ASSET seguido de prompt em ```
    pattern = r'#{2,4}\s+[\d.]+\s*—\s*([A-Z_0-9]+)\s*\n+```\n(.*?)```'
    matches = re.findall(pattern, content, re.DOTALL)
    
    for name, prompt in matches:
        clean_name = name.strip().lower() + ".png"
        clean_prompt = prompt.strip().replace('\n', ' ')
        assets.append((clean_name, clean_prompt))
    
    return assets


def generate(filename, prompt, directory):
    out_dir = os.path.join(BASE_DIR, directory)
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)
    
    if os.path.exists(out_path):
        return "skip"
    
    try:
        env = os.environ.copy()
        env['GEMINI_API_KEY'] = os.popen(
            "grep GEMINI_API_KEY ~/.bashrc | head -1 | sed 's/export GEMINI_API_KEY=\"\\(.*\\)\"$/\\1/'"
        ).read().strip()
        
        result = subprocess.run(
            ["uv", "run", SKILL, "--prompt", prompt, "--filename", filename, "--resolution", RESOLUTION],
            cwd=out_dir,
            capture_output=True,
            text=True,
            timeout=120,
            env=env,
        )
        
        return "ok" if result.returncode == 0 else "fail"
    except:
        return "fail"


def main():
    print("=" * 70)
    print("🎮 MUNDINHO DIVERTIDO - Gerando Assets Faltantes")
    print("=" * 70)
    
    all_assets = parse_all_assets()
    print(f"📊 Total no arquivo: {len(all_assets)}")
    
    # Filtra apenas os faltantes
    missing = [(n, p) for n, p in all_assets 
               if not os.path.exists(os.path.join(BASE_DIR, get_dir(n.replace('.png','')), n))]
    
    print(f"🎯 Faltando: {len(missing)}")
    print(f"✅ Já existem: {len(all_assets) - len(missing)}")
    print("=" * 70)
    
    success = skip = fail = 0
    
    for i, (name, prompt) in enumerate(missing, 1):
        directory = get_dir(name.replace('.png', ''))
        print(f"\n[{i}/{len(missing)}] 🎨 {name}")
        
        result = generate(name, prompt, directory)
        
        if result == "ok":
            print("   ✅ Gerado!")
            success += 1
        elif result == "skip":
            print("   ⚠️  Já existe")
            skip += 1
        else:
            print("   ❌ Falhou")
            fail += 1
        
        time.sleep(2)
    
    print("\n" + "=" * 70)
    print("📊 RESUMO")
    print(f"✅ Gerados: {success}")
    print(f"⚠️  Pulados: {skip}")
    print(f"❌ Falhas: {fail}")
    print(f"📁 Total faltava: {len(missing)}")
    print("=" * 70)


if __name__ == "__main__":
    main()
