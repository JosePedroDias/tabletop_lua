-- [[ game screen handling ]] --
local noobhub = require("src.ext.noobhub")

local consts = require "src.core.consts"
local settings = require "src.core.settings"
local utils = require "src.core.utils"

local Console = require "src.ui.console"
local Board = require "src.ui.board"

consts.roster = {} -- TODO: ugly

local M = {}

local hub

local ui = {}

function SendEvent(action, data)
  hub:publish({
    message = {from = settings.username, action = action, data = data}
  })
end

local function parseHubEvent(ev)
  -- ignore self messages (for vanilla noobhub servers)
  if ev.from == settings.username then return end

  if ev.action == "say" then
    ui.console:addLine(os.date("%H:%M ") .. ev.from .. ": " .. ev.data)
  elseif ev.action == "status" then
    if ev.data == "in" then
      if not utils.has(consts.roster, ev.from) then
        ui.console:addLine(os.date("%H:%M ") .. ev.from .. " got in")
        table.insert(consts.roster, ev.from)
        SendEvent("status", "in")
      end
    elseif ev.data == "out" then
      ui.console:addLine(os.date("%H:%M ") .. ev.from .. " left")
      table.remove(consts.roster, utils.indexOf(consts.roster))
    end
  else
    ui.board:onEvent(ev)
  end
end

M.load = function()
  local l = 600
  love.window.setTitle("tabletop - " .. settings.username)
  if settings.username == "p1" then
    love.window.setPosition(0, 0)
  elseif settings.username == "p2" then
    love.window.setPosition(l, 0)
  elseif settings.username == "p3" then
    love.window.setPosition(0, l)
  else
    love.window.setPosition(l, l)
  end

  hub = noobhub.new({server = settings.server, port = 1337}); -- TODO port and channel are hardcoded for now
  hub:subscribe({channel = "ch1", callback = parseHubEvent})

  SendEvent("status", "in")

  ui.console = Console:new({
    x = consts.W - 300,
    y = 0,
    width = 300,
    height = consts.H,
    maxLines = 20,
    dismissed = true
  })

  local r = 0
  if settings.username == "p2" then r = 180 end
  ui.board = Board:new({width = consts.W, height = consts.H})
  consts.board = ui.board -- TODO: ugly
end

M.unload = function()
end

M.update = function(dt)
  if hub then hub:enterFrame() end
end

M.draw = function()
  ui.board:draw()
  ui.console:draw()
end

M.onKey = function(key)
  -- print(key)
  if key == "escape" then
    SendEvent("status", "out")
    love.event.quit()
  elseif key == "f1" then
    -- gets stored in the same folder as settings. ex: ~/Library/Application Support/LOVE/tabletop
    local file = "shot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
    print("saving screenshot to " .. file)
    love.graphics.captureScreenshot(file)
  end
  ui.console:onKey(key)
end

M.onTextInput = function(text)
  ui.console:onTextInput(text)
end

M.onPointer = function(x, y)
  if ui.console:onPointer(x, y) then return end
  ui.board:onPointer(x, y)
end

M.onPointerMove = function(x, y)
  ui.board:onPointerMove(x, y)
end

M.onPointerUp = function(x, y)
  ui.board:onPointerUp(x, y)
end

return M
