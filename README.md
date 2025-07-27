# GT-Dialog-Builder-in-lua


# How to Load :
```lua
-- in GentaHax:
ihkaz = load(makeRequest("https://raw.githubusercontent.com/ihkaz/GT-Dialog-Builder-in-lua/refs/heads/main/DialogBuilder.lua","GET").content)()
-- GL terserah hehe
```
# Function List

## Spacer
#### • :addspacer(String size)
```lua
dialog = ihkaz.new()
:addspacer("small")
:build()
```

## Label
#### • :addlabel(bool withicon, {String label, String size, ItemID id})
```lua
dialog = ihkaz.new()
:addlabel(false,{label = "Aku Tidak Punya Icon",size = "small"})
:addlabel(true,{label = "Aku Punya Icon",size = "small",id = 242})
:build()
```

## Button
#### • :addbutton(bool disable, {String value, String label})
```lua
dialog = ihkaz.new()
:addbutton(false,{value = "ok_button", label = "OK"})
:addbutton(true,{value = "disabled_btn", label = "Disabled Button"})
:build()
```

## Small Text
#### • :addsmalltext(String text)
```lua
dialog = ihkaz.new()
:addsmalltext("This is small text")
:addsmalltext("Another small text line")
:build()
```

## Dialog Configuration
#### • :setDialog({String name, String closelabel, String applylabel})
```lua
dialog = ihkaz.new()
:addlabel(false,{label = "Example Dialog",size = "big"})
:addbutton(false,{value = "ok", label = "OK"})
:setDialog({
  name = "example_dialog",
  closelabel = "Cancel", 
  applylabel = "Apply"
})
:build()
```

## Body Styling
#### • :setbody({Table border, Table bg, String textcolor})
```lua
dialog = ihkaz.new()
:setbody({
  border = {255, 0, 0, 255},    -- Red border (R,G,B,A)
  bg = {0, 0, 0, 200},          -- Dark background
  textcolor = "`0"              -- White text color
})
:addlabel(false,{label = "Styled Dialog",size = "big"})
:build()
```

## Complete Example
```lua
ihkaz = load(makeRequest("https://raw.githubusercontent.com/ihkaz/GT-Dialog-Builder-in-lua/refs/heads/main/DialogBuilder.lua","GET").content)()
local dialog = ihkaz.new()
:setbody({
  textcolor = "`0",
  bg = {25, 25, 25, 255},
  border = {100, 100, 100, 255}
})
:addlabel(false,{label = "Welcome Dialog",size = "big"})
:addspacer("small")
:addlabel(true,{label = "Player Information",size = "small",id = 18})
:addsmalltext("Current Level: 125")
:addsmalltext("Gems: 50,000")
:addspacer("small")
:addbutton(false,{value = "profile", label = "View Profile"})
:addbutton(false,{value = "close", label = "Close"})
:setDialog({
  name = "welcome_dialog",
  closelabel = "Exit",
  applylabel = "OK"
})
:build()
```

## Parameter Details

### Size Options
- `"small"` - Small size
- `"big"` - Large size

### Color Format
- Colors use RGBA format: `{Red, Green, Blue, Alpha}`
- Values range from 0-255
- Alpha: 0 = transparent, 255 = opaque

### Text Color Codes
- Growtopia Color Text