# Roblox Survival Game Starter 🌲⚔️

A fully-featured, server-authoritative, procedural open-world survival game framework for Roblox, built using the Rojo workflow.

## Features Implemented
- **Phase 1 (Base Building):** Raycast grid-snapping base building with DataStore persistence.
- **Phase 2 (Resources):** Raycast tree-chopping mechanics with respawning and Wood economy.
- **Phase 3 (Survival & Combat):** Hunger/Thirst loops, Starvation, and Loot Bag dropping (Wood & Rifle) upon death.
- **Phase 4 (UI & Crafting):** Script-generated screen-space Inventory Grid and Crafting Menu.
- **Phase 5 (Procedural Map):** Vertical raycast Map Generator to scatter Trees and Rocks automatically.
- **Phase 6 (PVP Raycast Guns):** High-performance hitscan Rifle framework with neon tracers and anti-exploit server validation.

## 🚀 How to Deploy and Playtest in Roblox Studio

Since this project uses **Rojo** to sync external Lua files into Roblox Studio, follow these exact steps to load the game:

### Step 1: Install Prerequisites
1. **VS Code Extensions**: 
   - Install the **Rojo** extension by *evaera* in VS Code.
2. **Roblox Studio Plugin**: 
   - Open Roblox Studio.
   - Go to the **Plugins** tab -> **Manage Plugins** -> **Find Plugins** and search for/install the **Rojo** plugin.

### Step 2: Start the Rojo Server
1. In VS Code, open this project folder (`c:\Code\Roblox-rust`).
2. Open the Command Palette (`Ctrl+Shift+P`) and search for **Rojo: Start Server**.
3. Select `default.project.json`. 
*(Alternatively, if you eventually install the Rojo CLI, you can run `rojo serve default.project.json` in your terminal).*

### Step 3: Sync into Roblox Studio
1. Open an empty Baseplate in **Roblox Studio**.
2. Go to the **Plugins** tab and click the **Rojo** icon.
3. In the Rojo panel that appears, click **Connect**.
4. You should instantly see all the folders and our code (`ReplicatedStorage`, `ServerScriptService`, etc.) populate directly into your Studio Explorer!

### Step 4: Configure Game Settings (Important!)
For DataStores (saving your base walls) to work properly, you must grant Studio access to the Roblox cloud:
1. Publish the place to Roblox (File -> **Publish to Roblox**).
2. Go to the **Home** tab -> **Game Settings** -> **Security**.
3. Toggle **Enable Studio Access to API Services** to `ON`.
4. Click Save.

### Step 5: Prepare the 3D Models
The scripts handle all the logic, but you need to provide the actual 3D art/parts!
When you press Play for the very first time, the `GameSetup` script will automatically create a `Templates` folder in `ReplicatedStorage`.
**Stop the game, and then inside `ReplicatedStorage -> Templates`, place the following items:**
1. A Part named **WallTemplate** (Size: 10, 1, 10. Make sure it's Anchored).
2. A Model named **TreeTemplate** (A basic tree model).
3. A Model named **RockTemplate** (A basic rock model).
4. A Tool named **Rifle** (Inside the tool, place a part named `Handle` so your character holds it).

### Step 6: Playtest!
1. Press **Play** (F5) in Roblox Studio.
2. The `MapGenerator` will automatically scatter the trees and rocks across the baseplate.
3. Your character will spawn, Hunger/Thirst will start ticking down.
4. Press `E` or `I` to open your Inventory UI.
5. Swing your Hatchet at trees to gather Wood, click Craft Wall, and click the ground to place it!
