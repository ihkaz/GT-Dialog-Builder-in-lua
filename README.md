# Growtopia Dialog Builder in LUA

A powerful and flexible dialog builder library for Growtopia Lua executors with comprehensive validation and error handling.

## Features
- ✅ **Method Chaining** - Build dialogs fluently
- ✅ **Input Validation** - Comprehensive type checking and error messages
- ✅ **Error Handling** - Built-in logging with stack traces
- ✅ **Fallback Support** - Works with different executor environments
- ✅ **Flexible Styling** - Support for colors, borders, and text formatting
- ✅ **RTTEX Import** - Download and save RTTEX files from URLs

## Installation

### For GentaHax:
```lua
ihkaz = load(makeRequest("https://raw.githubusercontent.com/ihkaz/GT-Dialog-Builder-in-lua/refs/heads/main/DialogBuilder.lua","GET").content)()
```

### For Other Executors:
```lua
ihkaz = load(makeRequest("https://raw.githubusercontent.com/ihkaz/GT-Dialog-Builder-in-lua/refs/heads/main/DialogBuilder.lua","GET").content)()
-- Configure logging function (must accept 1 string parameter)
ihkaz.logfunc = LogToConsole -- Replace with your executor's logging function
-- Configure dialog execution function
ihkaz.runfunc = SendVariant -- Replace with your executor's variant sender
```

## Quick Start

```lua
-- Simple dialog example
local dialog = ihkaz.new()
  :addlabel(false, {label = "Hello World", size = "big"})
  :addbutton(false, {value = "ok", label = "OK"})
  :setDialog({name = "hello_dialog"})
  :showdialog() -- Build and show immediately
```

## RTTEX Import Feature *(Mobile & GentaHax User Only)*

### `ihkaz.importrttex(config)`
Downloads and saves RTTEX files from URLs to the Growtopia cache directory.

> ⚠️ **Note**: This feature only works on mobile devices (Android). Desktop users should manually place RTTEX files in their game directory.

**Parameters:**
- `config` (table or array of tables): Configuration for files to download
  - `url` (string, required): The URL to download the RTTEX file from *(must be direct download link)*
  - `name` (string, required): The filename/path to save in cache (supports subdirectories)

**URL Requirements:**
- ✅ **Direct download links** (no redirects)
- ✅ **Publicly accessible** (no authentication required)
- ✅ **RTTEX file format**
- ❌ **Shortened URLs** (bit.ly, tinyurl, etc.)
- ❌ **File sharing pages** (Google Drive view links, Dropbox pages)
- ❌ **Protected/private URLs**

**Examples:**
```lua
-- Import single RTTEX file
ihkaz.importrttex({
  url = "https://raw.githubusercontent.com/user/repo/main/file.rttex",  -- Direct GitHub raw link
  name = "custom_ui.rttex"
})

-- Import multiple RTTEX files
ihkaz.importrttex({
  {url = "https://cdn.jsdelivr.net/gh/user/repo/button.rttex", name = "UI/button.rttex"},  -- CDN link
  {url = "https://yourserver.com/direct/icon.rttex", name = "ICONS/custom_icon.rttex"},    -- Direct server link
  {url = "https://drive.google.com/uc?export=download&id=FILE_ID", name = "BG/bg.rttex"}  -- Google Drive direct
})

-- Import to subdirectory (automatically creates directories)
ihkaz.importrttex({
  url = "https://cdn.example.com/special.rttex",
  name = "CUSTOM/SAVES/special_ui.rttex"
})
```

**Supported URL Types:**
```lua
-- ✅ RECOMMENDED - These will work:
"https://raw.githubusercontent.com/user/repo/main/file.rttex"           -- GitHub raw
"https://cdn.jsdelivr.net/gh/user/repo@main/file.rttex"               -- jsDelivr CDN
"https://yourserver.com/files/file.rttex"                             -- Direct server
"https://drive.google.com/uc?export=download&id=YOUR_FILE_ID"         -- Google Drive direct

-- ❌ AVOID - These won't work:
"https://github.com/user/repo/blob/main/file.rttex"                   -- GitHub page (not raw)
"https://drive.google.com/file/d/FILE_ID/view"                        -- Google Drive page
"https://bit.ly/shortlink"                                            -- Shortened URL
"https://dropbox.com/s/abc123/file.rttex?dl=0"                       -- Dropbox page
```

**Features:**
- ✅ **Auto Directory Creation** - Creates subdirectories automatically
- ✅ **Batch Import** - Import multiple files in one call
- ✅ **Error Handling** - Validates URLs and handles download failures
- ✅ **Progress Logging** - Shows import status for each file
- ✅ **Direct Download Support** - Works with GitHub, CDN, and direct server links
- ⚠️ **URL Validation** - Requires publicly accessible direct download links

**Storage Location (Android Only):**
Files are saved to: `/storage/emulated/0/Android/data/com.rtsoft.growtopia/files/cache/interface/large/`

> 💡 **For Desktop Users**: Manually place RTTEX files in your Growtopia installation's interface folder.

## API Reference

### Core Methods

#### `ihkaz.new()`
Creates a new dialog builder instance.

#### `:build()`
Returns the built dialog string without showing it.

#### `:showdialog()`
Builds and displays the dialog immediately.

### Dialog Elements

#### `:addspacer(size)`
Adds a spacer element to create vertical spacing.

**Parameters:**
- `size` (string, optional): `"small"` or `"big"` (default: `"small"`)

**Example:**
```lua
dialog:addspacer("small")
dialog:addspacer("big")
```

#### `:addlabel(withicon, config)`
Adds a text label, optionally with an icon.

**Parameters:**
- `withicon` (boolean): Whether to include an icon
- `config` (table):
  - `label` (string, required): The label text
  - `size` (string, optional): `"small"` or `"big"` (default: `"small"`)
  - `id` (number, required if withicon=true): Item ID for the icon

**Examples:**
```lua
-- Simple label
dialog:addlabel(false, {label = "Simple Label", size = "small"})

-- Label with icon
dialog:addlabel(true, {label = "With Icon", size = "big", id = 242})
```

#### `:addbutton(disable, config)`
Adds a clickable button.

**Parameters:**
- `disable` (boolean): Whether the button should be disabled
- `config` (table):
  - `value` (string, required): The button's return value when clicked
  - `label` (string, required): The button's display text

**Examples:**
```lua
-- Active button
dialog:addbutton(false, {value = "confirm", label = "Confirm"})

-- Disabled button
dialog:addbutton(true, {value = "disabled", label = "Disabled"})
```

#### `:addsmalltext(text)`
Adds small descriptive text.

**Parameters:**
- `text` (string/any): Text content (will be converted to string)

**Example:**
```lua
dialog:addsmalltext("This is small descriptive text")
dialog:addsmalltext("Line 2 of small text")
```

### Dialog Configuration

#### `:setDialog(config)`
Configures the dialog window properties.

**Parameters:**
- `config` (table):
  - `name` (string, required): Dialog identifier
  - `closelabel` (string, optional): Custom close button text
  - `applylabel` (string, optional): Custom apply button text

**Example:**
```lua
dialog:setDialog({
  name = "my_dialog",
  closelabel = "Cancel",
  applylabel = "Save"
})
```

#### `:setbody(config)`
Configures the dialog's visual appearance.

**Parameters:**
- `config` (table):
  - `border` (table, optional): Border color as `{R, G, B, A}` (0-255)
  - `bg` (table, optional): Background color as `{R, G, B, A}` (0-255)
  - `textcolor` (string, optional): Growtopia color code

**Example:**
```lua
dialog:setbody({
  border = {255, 0, 0, 255},    -- Red border
  bg = {0, 0, 0, 200},          -- Semi-transparent black background
  textcolor = "`0"              -- White text
})
```

## Advanced Examples

### Styled Information Dialog
```lua
local dialog = ihkaz.new()
  :setbody({
    textcolor = "`0",
    bg = {25, 25, 25, 255},
    border = {100, 100, 100, 255}
  })
  :addlabel(false, {label = "Player Stats", size = "big"})
  :addspacer("small")
  :addlabel(true, {label = "Level Information", size = "small", id = 18})
  :addsmalltext("Current Level: 125")
  :addsmalltext("Experience: 45,230/50,000")
  :addsmalltext("Gems: 50,000")
  :addspacer("small")
  :addbutton(false, {value = "levelup", label = "Level Up"})
  :addbutton(false, {value = "close", label = "Close"})
  :setDialog({
    name = "player_stats",
    closelabel = "Exit",
    applylabel = "OK"
  })
  :showdialog()
```

### Menu Dialog with Multiple Options
```lua
local menu = ihkaz.new()
  :addlabel(false, {label = "Main Menu", size = "big"})
  :addspacer("small")
  :addbutton(false, {value = "inventory", label = "Open Inventory"})
  :addbutton(false, {value = "shop", label = "Visit Shop"})
  :addbutton(false, {value = "friends", label = "Friends List"})
  :addbutton(true, {value = "premium", label = "Premium Features (Locked)"})
  :addspacer("small")
  :addsmalltext("Select an option to continue")
  :setDialog({name = "main_menu"})
  :showdialog()
```

### Importing Custom Assets *(Mobile Only)*
```lua
-- Import custom UI elements for your dialogs (Android only)
-- Use direct download links for best results
ihkaz.importrttex({
  {url = "https://raw.githubusercontent.com/yourname/rttex-pack/main/button_red.rttex", name = "CUSTOM/button_red.rttex"},
  {url = "https://cdn.jsdelivr.net/gh/yourname/rttex-pack/button_blue.rttex", name = "CUSTOM/button_blue.rttex"},
  {url = "https://yourserver.com/direct/wood_texture.rttex", name = "BG/wood_texture.rttex"}
})

```

## Color Reference

### RGBA Format
Colors use the format `{Red, Green, Blue, Alpha}` where each value is 0-255:
- **Red**: `{255, 0, 0, 255}`
- **Green**: `{0, 255, 0, 255}`
- **Blue**: `{0, 0, 255, 255}`
- **Black**: `{0, 0, 0, 255}`
- **White**: `{255, 255, 255, 255}`

### Growtopia Text Colors
Common Growtopia color codes for `textcolor`:

## Error Handling

The library includes comprehensive error handling:
- **Input Validation**: All parameters are validated with descriptive error messages
- **Stack Traces**: Errors include file and line information for debugging
- **Graceful Fallbacks**: Works even if logging functions are unavailable
- **RTTEX Import Validation**: Checks URLs and file names before attempting downloads

## Best Practices

### RTTEX File Management *(Mobile Only)*
- Use descriptive subdirectory names (e.g., `UI/`, `ICONS/`, `BG/`)
- Keep file names clear and consistent
- Test URLs before batch importing
- Check available storage space for large files
- **Mobile users**: Use `ihkaz.importrttex()` for automatic download
- **Desktop users**: Manually place RTTEX files in game directory

### Dialog Design
- Use consistent color schemes across dialogs
- Test dialogs on different screen sizes
- Provide clear button labels and meaningful values
- Use spacers appropriately for visual hierarchy

## Contributing

Feel free to contribute improvements, bug fixes, or additional dialog elements!

## License

This project is open source. Feel free to use and modify as needed.
