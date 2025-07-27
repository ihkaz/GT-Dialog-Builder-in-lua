# Growtopia Dialog Builder in LUA

A powerful and flexible dialog builder library for Growtopia Lua executors with comprehensive validation and error handling.

## Features
- ✅ **Method Chaining** - Build dialogs fluently
- ✅ **Input Validation** - Comprehensive type checking and error messages
- ✅ **Error Handling** - Built-in logging with stack traces
- ✅ **Fallback Support** - Works with different executor environments
- ✅ **Flexible Styling** - Support for colors, borders, and text formatting

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

## Color Reference

### RGBA Format
Colors use the format `{Red, Green, Blue, Alpha}` where each value is 0-255:
- **Red**: `{255, 0, 0, 255}`
- **Green**: `{0, 255, 0, 255}`
- **Blue**: `{0, 0, 255, 255}`
- **Black**: `{0, 0, 0, 255}`
- **White**: `{255, 255, 255, 255}`

### Growtopia Text Colors
Common Growtopia color codes for `textcolor`

## Error Handling

The library includes comprehensive error handling:
- **Input Validation**: All parameters are validated with descriptive error messages
- **Stack Traces**: Errors include file and line information for debugging
- **Graceful Fallbacks**: Works even if logging functions are unavailable


## Contributing

Feel free to contribute improvements, bug fixes, or additional dialog elements!

## License

This project is open source. Feel free to use and modify as needed.
