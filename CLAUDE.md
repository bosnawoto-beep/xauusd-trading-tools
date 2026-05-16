# XAUUSD Trading Tools — Project Intelligence

## Project Overview
Modular trading toolkit for XAUUSD (Gold) scalping and automation.
Owner: nawoto (bosnawoto-beep)
Stack: Pine Script v6 (TradingView) + MQL5 (MetaTrader 5) + Python

---

## Active Sub-Projects

### 1. Pine Script v6 Modular Indicator Suite
- Platform: TradingView
- Language: Pine Script v6
- Style: Modular — each concept is a separate file/module
- Core concepts: SMC, ICT, Price Action
- Planned modules:
  - Market Structure (BOS, CHoCH, MSS, HH/HL/LH/LL)
  - Smart Money Concepts (Order Block, FVG, Liquidity Sweep)
  - ICT Concepts (Kill Zone, Silver Bullet, Premium/Discount)
  - Candle Pattern Detection
  - Signal Scoring System

### 2. TelegramSignalEA (MQL5 — MetaTrader 5)
- EA that receives parsed signals and executes trades on MT5
- Target broker: HF Markets
- Target account: Cent account (XAUUSDc)
- Signal sources: Gold Hub & Alpha Institute Telegram channels

### 3. TelegramForwarder (Python)
- Parses Telegram channel messages
- Extracts: symbol, direction, entry, SL, TP
- Routes parsed signals to TelegramSignalEA via socket/file bridge

---

## Trading Strategy Context

### The Sniper Setup (Primary)
All 5 must confluate for valid entry:
1. Liquidity sweep
2. Market Structure Shift (MSS)
3. POI — Order Block (OB) or Fair Value Gap (FVG)
4. Kill Zone timing
5. HTF bias alignment

### Rejection Confluence (Supplementary)
- Long wick (min 2× body size)
- Key level (OB / FVG / S&R / Equal High/Low / Round number)
- Aligned with HTF bias

---

## Folder Structure
```
xauusd-trading-tools/
├── pinescript/          # Pine Script v6 indicators
│   ├── modules/         # Individual concept modules
│   └── suite/           # Combined indicator suite
├── mql5/                # MetaTrader 5 files
│   ├── EA/              # TelegramSignalEA
│   └── indicators/      # Custom MQL5 indicators
├── python/              # Python automation
│   └── TelegramForwarder/
├── docs/                # Documentation & strategy notes
└── CLAUDE.md            # This file
```

---

## Coding Conventions

### Pine Script v6
- Always use `indicator()` not `study()`
- Use `var` for persistent variables
- Prefer `array` and `matrix` for structured data
- Comment every function with purpose + inputs + outputs
- Each module must work standalone AND as import
- Use `export` keyword for reusable functions

### MQL5
- Follow MQL5 standard naming: `OnTick()`, `OnInit()`, `OnDeinit()`
- Use `CTrade` class for order management
- All magic numbers as `input` parameters
- Error handling on every trade operation
- Log all actions with `Print()`

### Python
- Use `pyrogram` or `telethon` for Telegram client
- Async functions for message handling
- Config via `.env` file (never hardcode credentials)
- Signal parser as separate module

---

## Key Parameters (XAUUSD)
- Spread tolerance: max 30 points
- Session focus: London + New York Kill Zones
- Risk per trade: max 1-2% account
- Min RR: 1:2
- Timeframes: M1, M5, M15 (entry) | H1, H4 (bias)

---

## Do Not
- Do not use `security()` in Pine Script for live data on low TF
- Do not hardcode SL/TP in pips — always calculate from structure
- Do not use `OrderSend()` legacy — use `CTrade` in MQL5
- Do not commit `.env` files or API keys to repo
