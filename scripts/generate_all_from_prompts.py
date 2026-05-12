#!/usr/bin/env python3
"""
Script que lê docs/PROMPTS_GERACAO.md e gera TODOS os assets sequencialmente.
Extrai automaticamente o nome do arquivo e o prompt de cada seção.
"""

import subprocess
import os
import re
import time
from datetime import datetime

SKILL_SCRIPT = "/home/joaosbp/.openclaw/workspace/skills/nano-banana-pro/scripts/generate_image.py"
BASE_DIR = "/home/joaosbp/mundinho-divertido/assets/images"
PROMPTS_FILE = "/home/joaosbp/mundinho-divertido/docs/PROMPTS_GERACAO.md"
RESOLUTION = "1K"

# Mapeamento de prefixos de nome para diretórios
DIR_MAPPING = {
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
    "interior_": "interiors",
    "item_": "items",
    "maca": "items",
    "banana": "items",
    "cenoura": "items",
    "uvas": "items",
    "limao": "items",
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
    "moeda": "items",
    "estrela": "items",
    "adesivo_": "items",
    "receita_": "items",
    "bg_": "backgrounds",
    "ui_": "ui",
    "botao_": "ui",
    "painel_": "ui",
    "icone_": "ui",
    "vfx_": "effects",
    "logo_": "ui",
    "tela_": "backgrounds",
}


def get_directory_for_asset(name):
    """Determina o diretório baseado no nome do asset."""
    for prefix, directory in DIR_MAPPING.items():
        if name.lower().startswith(prefix.lower()):
            return directory
    return "misc"  # fallback


def parse_prompts_file():
    """Lê o arquivo de prompts e retorna lista de (nome, prompt)."""
    assets = []
    
    with open(PROMPTS_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Padrão: ### 1.1.1 — NOME_ASSET seguido de ```...prompt...```
    # Ou: ## 4.1.1 — ITEM_MACA
    pattern = r'#{2,4}\s+[\d.]+\s*—\s*([A-Z_0-9]+)\s*\n+```\n(.*?)```'
    
    matches = re.findall(pattern, content, re.DOTALL)
    
    for name, prompt in matches:
        # Limpar o nome
        clean_name = name.strip().lower() + ".png"
        # Limpar o prompt
        clean_prompt = prompt.strip().replace('\n', ' ')
        assets.append((clean_name, clean_prompt))
    
    return assets


def generate_asset(filename, prompt, directory):
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
    print(f"   📝 Prompt: {prompt[:80]}...")
    
    try:
        env = os.environ.copy()
        env['GEMINI_API_KEY'] = os.popen("grep GEMINI_API_KEY ~/.bashrc | head -1 | sed 's/export GEMINI_API_KEY=\"\\(.*\\)\"$/\\1/'").read().strip()
        
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
            env=env,
        )
        
        if result.returncode == 0:
            print(f"   ✅ Sucesso: {filename}")
            return True
        else:
            print(f"   ❌ Erro: {result.stderr[:200]}")
            return False
            
    except subprocess.TimeoutExpired:
        print(f"   ⏱️  Timeout: {filename}")
        return False
    except Exception as e:
        print(f"   ❌ Exceção: {e}")
        return False


def main():
    print("=" * 70)
    print("🎮 MUNDINHO DIVERTIDO - Geração Completa de Assets")
    print("=" * 70)
    print(f"\n📖 Lendo prompts de: {PROMPTS_FILE}")
    
    assets = parse_prompts_file()
    
    print(f"📊 Total de assets encontrados no arquivo: {len(assets)}")
    print(f"📁 Diretório de saída: {BASE_DIR}")
    print(f"🔧 Resolução: {RESOLUTION}")
    print("\n" + "=" * 70)
    
    success_count = 0
    fail_count = 0
    skipped_count = 0
    
    for i, (filename, prompt) in enumerate(assets, 1):
        directory = get_directory_for_asset(filename.replace('.png', ''))
        
        print(f"\n[{i}/{len(assets)}] ", end="")
        
        output_path = os.path.join(BASE_DIR, directory, filename)
        if os.path.exists(output_path):
            print(f"⚠️  {filename} já existe")
            skipped_count += 1
            continue
        
        if generate_asset(filename, prompt, directory):
            success_count += 1
        else:
            fail_count += 1
        
        # Pausa entre gerações
        time.sleep(3)
    
    print("\n" + "=" * 70)
    print("📊 RESUMO FINAL")
    print("=" * 70)
    print(f"✅ Novos gerados: {success_count}")
    print(f"⚠️  Já existiam: {skipped_count}")
    print(f"❌ Falhas: {fail_count}")
    print(f"📁 Total no arquivo: {len(assets)}")
    print("=" * 70)


if __name__ == "__main__":
    main()
