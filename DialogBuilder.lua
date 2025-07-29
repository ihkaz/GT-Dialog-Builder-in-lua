local ihkaz = {
  logfunc,
  runfunc
}
ihkaz.__index = ihkaz


function ihkaz.logs(message, iserror)
  local tag = iserror and "`4ERROR``" or "LOGS"
  local logMessage = string.format("`0[DIALOG BUILDER]`` %s", tag, message)
  if iserror then
    local trace = debug.traceback("", 2)
    local lineInfo = trace:match("([^\n]*:%d+:)")
    if lineInfo then
      logMessage = logMessage .. string.format(" (at %s)", lineInfo)
    end
  end
  
  return ihkaz.logfunc(logMessage) or logToConsole(logMessage)
end

function ihkaz.importrttex(prefix)
  local function save(path, data)
    os.execute("mkdir -p " .. path:match("^(.*)/"))
    local f = io.open(path, "w")
    if f then f:write(data) f:close() end
  end
  if type(prefix) ~= "table" then
    return ihkaz.logs("Error: expected table in importrttex()", true)
  end
  local items = #prefix > 0 and prefix or { prefix }
  local base = "/storage/emulated/0/Android/data/com.rtsoft.growtopia/files/cache/interface/large/"
  for _, v in ipairs(items) do
    if not v.url or not v.name then
      local m = (not v.name and "name" or "") .. ((not v.name and not v.url) and " and " or (not v.url and "url" or ""))
      ihkaz.logs("Error: Missing " .. m .. " in importrttex()", true)
    else
      local r = makeRequest(v.url, "GET")
      local d = r and r.content
      if not d or d == "" then
        ihkaz.logs("Error: Failed to fetch " .. v.name, true)
      else
        save(base .. v.name, d)
        ihkaz.logs("Succes Import RTTEX File. Name : " .. v.name)
      end
    end
  end
end

function ihkaz.new()
  return setmetatable({
    result = {},
  }, ihkaz)
end

function ihkaz:_prepend(value)
  if not value or value == "" then
    ihkaz.logs("Error: Cannot prepend empty or nil value", true)
    return
  end
  table.insert(self.result, 1, value)
end

function ihkaz:_append(value)
  if not value or value == "" then
    ihkaz.logs("Error: Cannot append empty or nil value", true)
    return
  end
  table.insert(self.result, value)
end


function ihkaz:addspacer(size)
  if size and type(size) ~= "string" then
    ihkaz.logs("Error: spacer size must be a string", true)
    return self
  end
  self:_append(string.format("add_spacer|%s|", size or "small"))
  return self
end

function ihkaz:addlabel(withicon, prefix)
  if type(prefix) ~= "table" then
    return ihkaz.logs("Error: expected table for second parameter in addlabel()", true)
  end
  
  if not prefix.label or prefix.label == "" then
    ihkaz.logs("Error: label text is required and cannot be empty", true)
    return self
  end
  
  if withicon and (not prefix.id or prefix.id == "") then
    ihkaz.logs("Error: icon id is required when withicon is true", true)
    return self
  end
  
  if prefix.size and type(prefix.size) ~= "string" then
    ihkaz.logs("Error: label size must be a string", true)
    return self
  end
  
  local iconPart = ""
  if withicon and prefix.id then
    iconPart = prefix.id .. "|"
  end
  self:_append(string.format("add_label%s|%s|%s|left|%s", withicon and "_with_icon" or "", prefix.size or "small", prefix.label, iconPart))
  return self
end

function ihkaz:setDialog(prefix)
  if type(prefix) ~= "table" then
    return ihkaz.logs("Error: expected table for parameter in setDialog()", true)
  end
  
  if not prefix.name or prefix.name == "" then
    ihkaz.logs("Error: dialog name is required and cannot be empty", true)
    return self
  end
  
  if prefix.closelabel and type(prefix.closelabel) ~= "string" then
    ihkaz.logs("Error: closelabel must be a string", true)
    return self
  end
  
  if prefix.applylabel and type(prefix.applylabel) ~= "string" then
    ihkaz.logs("Error: applylabel must be a string", true)
    return self
  end
  for i = #self.result, 1, -1 do
    if self.result[i]:match("^end_dialog|") then
      table.remove(self.result, i)
    end
  end
  self:_append(string.format("end_dialog|%s|%s|%s", prefix.name, prefix.closelabel or "", prefix.applylabel or ""))
  return self
end

function ihkaz:addbutton(disable, prefix)
  if type(prefix) ~= "table" then
    return ihkaz.logs("Error: expected table for second parameter in addbutton()", true)
  end
  
  if not prefix.value or prefix.value == "" then
    ihkaz.logs("Error: button value is required and cannot be empty", true)
    return self
  end
  
  if not prefix.label or prefix.label == "" then
    ihkaz.logs("Error: button label is required and cannot be empty", true)
    return self
  end
  
  if disable ~= nil and type(disable) ~= "boolean" then
    ihkaz.logs("Error: disable parameter must be a boolean", true)
    return self
  end
  
  self:_append(string.format("add_button|%s|%s|%s|0|0|", prefix.value, prefix.label, disable and "off" or "noflags"))
  return self
end

function ihkaz:addsmalltext(str)
  if not str then
    ihkaz.logs("Error: text parameter is required and cannot be nil", true)
    return self
  end
  
  local text = tostring(str)
  if text == "" then
    ihkaz.logs("Error: text cannot be empty", true)
    return self
  end
  
  self:_append("add_smalltext|" .. text .. "|")
  return self
end

function ihkaz:setbody(prefix)
  if type(prefix) ~= "table" then
    ihkaz.logs("Error: expected table for parameter in setbody()", true)
    return self
  end
  
  if prefix.border then
    if type(prefix.border) ~= "table" or #prefix.border ~= 4 then
      ihkaz.logs("Error: border must be a table with exactly 4 color values", true)
      return self
    end
    for i = 1, 4 do
      if type(prefix.border[i]) ~= "number" or prefix.border[i] < 0 or prefix.border[i] > 255 then
        ihkaz.logs("Error: border color values must be numbers between 0-255", true)
        return self
      end
    end
  end
  if prefix.bg then
    if type(prefix.bg) ~= "table" or #prefix.bg ~= 4 then
      ihkaz.logs("Error: bg must be a table with exactly 4 color values", true)
      return self
    end
    for i = 1, 4 do
      if type(prefix.bg[i]) ~= "number" or prefix.bg[i] < 0 or prefix.bg[i] > 255 then
        ihkaz.logs("Error: bg color values must be numbers between 0-255", true)
        return self
      end
    end
  end
  if prefix.textcolor and type(prefix.textcolor) ~= "string" then
    ihkaz.logs("Error: textcolor must be a string", true)
    return self
  end
  
  local border = (prefix.border and #prefix.border == 4) and "set_border_color|"..table.concat(prefix.border,",") or false
  local bg = (prefix.bg and #prefix.bg == 4) and "set_bg_color|"..table.concat(prefix.bg,",") or false
  local defcolor = prefix.textcolor and "set_default_color|"..prefix.textcolor or false
  local temp = {}
  
  if defcolor then table.insert(temp, defcolor) end
  if border then table.insert(temp, border) end
  if bg then table.insert(temp, bg) end
  if prefix.quickexit then table.insert(temp, "add_quick_exit|") end
  
  for i = #temp, 1, -1 do
    self:_prepend(temp[i])
  end
  return self
end
  
function ihkaz:build()
  if #self.result == 0 then
    ihkaz.logs("Warning: building empty dialog with no elements", false)
  end
  return table.concat(self.result, "\n")
end

function ihkaz:showdialog()
  if #self.result == 0 then
    ihkaz.logs("Warning: building empty dialog with no elements", false)
  end
  return ihkaz.runfunc({[0] = "OnDialogRequest",[1] = table.concat(self.result, "\n")}) or sendVariant({[0] = "OnDialogRequest",[1] = table.concat(self.result)})
end

return ihkaz