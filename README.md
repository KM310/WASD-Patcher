# WASD-Patcher
Patches Undertale to use **WASD** instead of the arrow keys.

## Requirements
- A legal copy of Undertale
- UndertaleModTool
- xdelta3 (Windows)
- DeltaPatcher

## How to build

1. Place your **original `data.win`** from Undertale into the current folder.
2. Open `data.win` with **UndertaleModTool**.
3. Navigate to:  
   `Code/gml_Object_obj_time_Step_1`
4. Delete everything **until line 388**.
5. Paste the custom WASD code.
6. Save the file as **`mod_data.win`** in the same folder.

## How to compile into .xdelta (Windows)

1. Open CMD in the current folder.
2. Make sure the folder contains:
   - `data.win` (original)
   - `mod_data.win` (modified)
   - `xdelta3.exe`
3. Run:

´´´
xdelta3.exe -e -s data.win mod_data.win wasd_patch.xdelta
´´´

This will create `wasd_patch.xdelta`.

## How to apply the patch (DeltaPatcher)

1. Open **DeltaPatcher.exe**
2. Select:
   - **Original file:** `data.win` (from Undertale)
   - **XDelta patch:** `wasd_patch.xdelta`
3. Click **Apply Patch**
4. Done!

### Powered by 

[![DeltaPatcher](https://github.com/marco-calautti/DeltaPatcher/blob/master/graphics/icon128.png)](https://github.com/marco-calautti/DeltaPatcher/)
[![UndertaleModTool](https://github.com/UnderminersTeam/UndertaleModTool/blob/master/images/logo.png)](https://github.com/UnderminersTeam/UndertaleModTool/)
[![XDelta](https://github.com/KM310/WASD-Patcher/blob/main/XDeltaCustomIcon128.png)](https://github.com/jmacd/xdelta/)






