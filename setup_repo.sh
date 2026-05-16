#!/bin/bash
# setup_repo.sh — Run this from root of xauusd-trading-tools repo
# Usage: bash setup_repo.sh

set -e

echo "=== Creating folder structure ==="

mkdir -p pinescript/modules/market_structure
mkdir -p pinescript/modules/smc
mkdir -p pinescript/modules/ict
mkdir -p pinescript/modules/candle_patterns
mkdir -p pinescript/indicators
mkdir -p pinescript/library
mkdir -p mql5/experts/TelegramSignalEA
mkdir -p mql5/indicators
mkdir -p mql5/include
mkdir -p mql5/scripts
mkdir -p python/telegram_forwarder
mkdir -p python/utils
mkdir -p python/config
mkdir -p docs

echo "=== Creating .gitkeep for empty folders ==="

touch pinescript/modules/market_structure/.gitkeep
touch pinescript/modules/smc/.gitkeep
touch pinescript/modules/ict/.gitkeep
touch pinescript/modules/candle_patterns/.gitkeep
touch pinescript/indicators/.gitkeep
touch pinescript/library/.gitkeep
touch mql5/experts/TelegramSignalEA/.gitkeep
touch mql5/indicators/.gitkeep
touch mql5/include/.gitkeep
touch mql5/scripts/.gitkeep
touch python/telegram_forwarder/.gitkeep
touch python/utils/.gitkeep

echo "=== Creating .gitignore ==="

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.pyc
.env
venv/
.venv/

# Secrets
config.json
*.key
*.token
*.session

# OS
.DS_Store
Thumbs.db

# MT5 compiled
*.ex5
EOF

echo "=== Creating python/config files ==="

cat > python/config/.gitignore << 'EOF'
config.json
*.key
*.token
EOF

cat > python/config/config.example.json << 'EOF'
{
  "telegram": {
    "api_id": "YOUR_API_ID",
    "api_hash": "YOUR_API_HASH",
    "phone": "+62XXXXXXXXXX",
    "channels": ["gold_hub_channel", "alpha_institute_channel"]
  },
  "mt5": {
    "signal_output_path": "C:/Users/USER/AppData/Roaming/MetaQuotes/Terminal/Common/Files/signals/",
    "symbol": "XAUUSDc"
  }
}
EOF

echo "=== Creating README files ==="

cat > pinescript/README.md << 'EOF'
# Pine Script v6 — XAUUSD Indicators

## Structure
```
pinescript/
├── modules/
│   ├── market_structure/   # BOS, CHoCH, HH/HL/LH/LL, Swing High/Low
│   ├── smc/               # Order Block, FVG, Liquidity Sweep
│   ├── ict/               # Kill Zone, Silver Bullet, PD Array
│   └── candle_patterns/   # Engulfing, Pin Bar, Inside Bar
├── indicators/             # Full standalone indicators
└── library/                # Pine Script library exports
```

## Module Load Order (dependency)
```
candle_patterns  ← standalone
market_structure ← base
smc              ← depends: market_structure
ict              ← depends: smc
indicators       ← combines all modules
```
EOF

cat > mql5/README.md << 'EOF'
# MQL5 — MetaTrader 5

## Structure
```
mql5/
├── experts/
│   └── TelegramSignalEA/   # Signal executor dari Telegram
├── indicators/              # Custom indicators MT5
├── include/                 # Shared .mqh libraries
└── scripts/                 # One-shot utility scripts
```

## TelegramSignalEA
- Target: XAUUSDc di HF Markets (cent account)
- Signal source: Python TelegramForwarder via file IPC
- Strategy: SMC validation sebelum eksekusi
EOF

cat > python/README.md << 'EOF'
# Python — Automation & Signal Tools

## Structure
```
python/
├── telegram_forwarder/   # Parser & router sinyal dari Telegram
├── utils/                # Shared helpers
└── config/               # Config (secrets gitignored)
```

## TelegramForwarder
- Source channels: Gold Hub, Alpha Institute
- Output: Signal JSON → TelegramSignalEA (MT5)
- Deps: Telethon

## Setup
```bash
pip install -r requirements.txt
cp python/config/config.example.json python/config/config.json
# Edit config.json dengan API keys
python python/telegram_forwarder/main.py
```
EOF

cat > docs/architecture.md << 'EOF'
# System Architecture

## Signal Flow
```
[Telegram Channels]
 Gold Hub / Alpha Institute
          │
          ▼
[TelegramForwarder] (Python)
  - Parse signal text
  - Normalize format
  - Write signal file
          │
          ▼
[TelegramSignalEA] (MQL5/MT5)
  - Read signal file
  - SMC validation filter
  - Execute on XAUUSDc @ HF Markets
  - Manage: SL / TP / Breakeven / Trail
```

## Pine Script Module Dependencies
```
[market_structure] → BOS, CHoCH, Swing H/L
        ↓
      [smc]        → OB, FVG, Liquidity
        ↓
      [ict]        → Kill Zone, Silver Bullet
        ↓
  [indicators]     → Full indicator suite
```
EOF

echo "=== Git commit ==="

git add .
git commit -m "chore: init repo structure — pinescript/mql5/python"
git push

echo ""
echo "=== DONE ==="
echo "Repo structure pushed to GitHub."
