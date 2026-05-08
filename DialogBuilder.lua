-- ihkaz.lua
-- GTDialogBuilder - Compatible with GrowLauncher & Genta
-- by iHkaz Development (KazDev)

-- ── Detect Environment ────────────────────────────────────────
local ENV = {
    isGrowLauncher = growlauncher ~= nil,
    isGenta = getDiscordID ~= nil and growlauncher == nil,
}

-- ── RTTEX Path ────────────────────────────────────────────────
local RTTEX_PATH = "/storage/emulated/0/Android/data/com.rtsoft.growtopia/files/cache/interface/large/"
local RTTEX_PATH_GL = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/interface/large/"
local function getActivePath()
    if ENV.isGrowLauncher then
        return RTTEX_PATH_GL
    end
    return RTTEX_PATH
end

-- ── Permission Check ──────────────────────────────────────────
local function checkRttexPermission()
    local activePath = getActivePath()
    local testpath = activePath .. ".perm_test"
    os.execute("mkdir -p " .. activePath .. " 2>/dev/null")
    local f = io.open(testpath, "w")
    if f then
        f:close()
        os.execute("rm " .. testpath .. " 2>/dev/null")
        return true
    end
    return false
end

-- ── HTTP Fetch ────────────────────────────────────────────────
local function httpGet(url)
    if ENV.isGenta then
        -- Genta: makeRequest support
        local r = makeRequest(url, "GET")
        return r and r.content
    else
        -- GrowLauncher: fetch (GET only)
        return fetch(url)
    end
end

-- ── Logger ────────────────────────────────────────────────────
local function logger(message, iserror)
    local tag = iserror and "`4ERROR``" or "LOGS"
    local msg = string.format("`0[DIALOG BUILDER]`` %s %s", tag, message)
    if iserror and debug and debug.traceback then
        local trace = debug.traceback("", 2)
        local lineInfo = trace:match("([^\n]*:%d+:)")
        if lineInfo then
            msg = msg .. string.format(" (at %s)", lineInfo)
        end
    end
    if logToConsole then logToConsole(msg)
    elseif log then log(msg) end
end

-- ── Send Dialog ───────────────────────────────────────────────
local function sendDialogStr(str)
    if ENV.isGenta then
        -- Genta: sendVariant dengan OnDialogRequest
        sendVariant({[0] = "OnDialogRequest", [1] = str})
    else
        -- GrowLauncher: growtopia.sendDialog atau sendVariant
        if growtopia and growtopia.sendDialog then
            growtopia.sendDialog(str)
        else
            sendVariant({[0] = "OnDialogRequest", [1] = str})
        end
    end
end

-- ── Library ───────────────────────────────────────────────────
local ihkaz = {}
ihkaz.__index = ihkaz

ihkaz.logs = logger
ihkaz.ENV = ENV

-- Import RTTEX dengan permission check
function ihkaz.importrttex(prefix)
    if type(prefix) ~= "table" then
        return logger("Error: expected table in importrttex()", true)
    end

    -- Permission check
    if not checkRttexPermission() then
        local activePath = getActivePath()
        logger("Error: No write permission to RTTEX path: " .. activePath, true)
        logger("Tip: Growtopia harus sudah pernah dibuka setidaknya sekali", false)
        return false
    end

    local activePath = getActivePath()
    local items = #prefix > 0 and prefix or {prefix}

    for _, v in ipairs(items) do
        if not v.url or not v.name then
            local missing = ""
            if not v.name then missing = missing .. "name " end
            if not v.url then missing = missing .. "url" end
            logger("Error: Missing " .. missing .. " in importrttex()", true)
        else
            local data = httpGet(v.url)
            if not data or data == "" then
                logger("Error: Failed to fetch " .. v.name, true)
            else
                os.execute("mkdir -p " .. activePath)
                local f = io.open(activePath .. v.name, "w")
                if f then
                    f:write(data)
                    f:close()
                    logger("Success Import RTTEX: " .. v.name)
                else
                    logger("Error: Failed to write " .. v.name, true)
                end
            end
        end
    end

    return true
end

-- Constructor
function ihkaz.new()
    return setmetatable({ result = {} }, ihkaz)
end

-- Internal append/prepend
function ihkaz:_append(value)
    if not value or value == "" then
        logger("Error: Cannot append empty or nil value", true)
        return self
    end
    table.insert(self.result, value)
    return self
end

function ihkaz:_prepend(value)
    if not value or value == "" then
        logger("Error: Cannot prepend empty or nil value", true)
        return self
    end
    table.insert(self.result, 1, value)
    return self
end

-- Components
function ihkaz:addspacer(size, count)
    local spacer_size, spacer_count
    if type(size) == "number" and count == nil then
        spacer_size, spacer_count = "small", size
    else
        spacer_size = (type(size) == "string") and size or "small"
        spacer_count = tonumber(count) or 1
    end
    for _ = 1, math.max(1, spacer_count) do
        self:_append(string.format("add_spacer|%s|", spacer_size))
    end
    return self
end

function ihkaz:addbanner(prefix)
    if type(prefix) ~= "table" then
        return logger("Error: expected table in addbanner()", true)
    end
    self:_append(string.format("add_banner|%s|%d|%d|",
        prefix.path, prefix.size and prefix.size.x or 0, prefix.size and prefix.size.y or 0))
    return self
end

function ihkaz:addimagebutton(prefix)
    if type(prefix) ~= "table" then
        return logger("Error: expected table in addimagebutton()", true)
    end
    if not prefix.name then return logger("Error: Missing name in addimagebutton()", true) end
    if not prefix.path then return logger("Error: Missing path in addimagebutton()", true) end
    self:_append(string.format("add_image_button|%s|%s|bannerlayout|OPENSURVEY|||||||||||",
        prefix.name, prefix.path))
    return self
end

function ihkaz:addlabel(withicon, prefix)
    local items = (type(prefix) == "table" and not prefix.label) and prefix or {prefix}
    for _, v in ipairs(items) do
        if type(v) ~= "table" then
            logger("Error: each label must be a table", true)
        elseif not v.label or v.label == "" then
            logger("Error: label text is required", true)
        elseif withicon and (not v.id or v.id == "") then
            logger("Error: icon id required when withicon is true", true)
        else
            local iconPart = withicon and v.id and (v.id .. "|") or ""
            self:_append(string.format("add_label%s|%s|%s|left|%s",
                withicon and "_with_icon" or "",
                v.size or "small",
                v.label,
                iconPart))
        end
    end
    return self
end

function ihkaz:addsmalltext(text)
    local texts = type(text) == "table" and text or {text}
    for _, v in ipairs(texts) do
        local str = tostring(v or "")
        if str == "" then
            logger("Error: text cannot be empty", true)
        else
            -- Fix: tambah left separator sesuai GT format
            self:_append("add_smalltext|" .. str .. "|left|")
        end
    end
    return self
end

function ihkaz:addbutton(disable, prefix)
    local items = (type(prefix) == "table" and not prefix.value) and prefix or {prefix}
    for _, v in ipairs(items) do
        if type(v) ~= "table" then
            logger("Error: each button must be a table", true)
        elseif not v.value or v.value == "" then
            logger("Error: button value required", true)
        elseif not v.label or v.label == "" then
            logger("Error: button label required", true)
        else
            self:_append(string.format("add_button|%s|%s|%s|0|0|",
                v.value, v.label, disable and "off" or "noflags"))
        end
    end
    return self
end

function ihkaz:setDialog(prefix)
    if type(prefix) ~= "table" then
        return logger("Error: expected table in setDialog()", true)
    end
    if not prefix.name or prefix.name == "" then
        return logger("Error: dialog name required", true)
    end
    -- Remove existing end_dialog
    for i = #self.result, 1, -1 do
        if self.result[i]:match("^end_dialog|") then
            table.remove(self.result, i)
        end
    end
    self:_append(string.format("end_dialog|%s|%s|%s",
        prefix.name,
        prefix.closelabel or "",
        prefix.applylabel or ""))
    return self
end

function ihkaz:setbody(prefix)
    if type(prefix) ~= "table" then
        return logger("Error: expected table in setbody()", true)
    end
    local temp = {}
    if prefix.textcolor then
        table.insert(temp, "set_default_color|" .. prefix.textcolor)
    end
    if prefix.border and #prefix.border == 4 then
        table.insert(temp, "set_border_color|" .. table.concat(prefix.border, ","))
    end
    if prefix.bg and #prefix.bg == 4 then
        table.insert(temp, "set_bg_color|" .. table.concat(prefix.bg, ","))
    end
    if prefix.quickexit then
        table.insert(temp, "add_quick_exit|")
    end
    for i = #temp, 1, -1 do
        self:_prepend(temp[i])
    end
    return self
end

function ihkaz:build()
    if #self.result == 0 then
        logger("Warning: building empty dialog", false)
    end
    return table.concat(self.result, "\n")
end

function ihkaz:showdialog()
    if #self.result == 0 then
        logger("Warning: building empty dialog", false)
    end
    sendDialogStr(table.concat(self.result, "\n"))
    return self
end

return ihkaz
