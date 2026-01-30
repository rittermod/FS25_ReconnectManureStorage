# Reconnect Manure Storage

Do your animal pens get dumped by their manure heaps when you reload your save? No warning, no goodbye — the shit just ups and leaves. Your cows have been putting in the work, and frankly, they deserve better.

**ReconnectManureStorage** helps everyone get their shit back together. It reconnects manure heaps to their rightful pens after each game load, because no animal should have to wonder where yesterday's output went.

I wanted to call this "Give Me My Shit Back", but I was told some mod portals have standards.

## The Problem

FS25 has a base game bug where manure heaps and pits lose their connection to animal pens after reloading a savegame. When that happens, manure production stalls — the pen can't offload manure to the heap, and the heap just sits there collecting dust instead of dung.

## The Fix

After all placeables are fully loaded and finalized (`Mission00:onStartMission`), the mod re-scans every manure heap for nearby animal pen stations using `getExtendableUnloadingStationsInRange` and `getExtendableLoadingStationsInRange`. Any missing connections are re-established.

The scan is idempotent — already-connected heaps are skipped. Zero performance impact during gameplay; runs once at load.

## Installation

1. Place `FS25_ReconnectManureStorage` folder (or zip) in your mods directory
2. Enable the mod
3. That's it — no configuration needed

## Compatibility

- **Multiplayer**: Supported (server-side only, no client action needed)
- **Savegame safe**: Install or remove at any time, no savegame data stored
