-- [[ game screen handling ]] --
require("src.ext.json")
local noobhub = require("src.ext.noobhub")

local Console = require "src.ui.console"
local Input = require "src.ui.input"
local Board = require "src.ui.board"

local consts = require "src.core.consts"
local settings = require "src.core.settings"

local M = {}

local hub

local server
local username

local state = {t = 0}
local ui = {}

local function say(msg)
  hub:publish({message = {from = username, action = "say", data = msg}})
end

local function parseHubEvent(ev)
  if ev.action == "say" then
    ui.console:addLine(ev.from .. ": " .. ev.data)
  else
    -- print(json.encode(ev))
  end
end

M.load = function()
  server = settings.get()[1]
  username = settings.get()[2]

  hub = noobhub.new({server = server, port = 1337});
  hub:subscribe({channel = "ch1", callback = parseHubEvent})

  ui.console = Console:new({
    x = consts.W - 200,
    y = 0,
    width = 200,
    height = consts.H - 30,
    maxLines = 20
  })

  ui.input = Input:new({
    x = consts.W - 200,
    y = consts.H - 40,
    width = 200,
    height = 20 + 20,
    focused = true,
    onSubmit = function(v)
      ui.console:addLine(v)
      say(v)
      ui.input:clear()
    end
  })

  ui.board = Board:new({width = consts.W, height = consts.H})
end

M.unload = function()
end

M.update = function(dt)
  state.t = state.t + dt
  if hub then hub:enterFrame() end
  ui.board:update(dt)
end

M.draw = function()
  ui.board:draw()
  ui.console:draw()
  ui.input:draw()
end

M.onKey = function(key)
  ui.input:onKey(key)
  if key == "escape" then love.event.quit() end
end

M.onTextInput = function(text)
  ui.input:onTextInput(text)
end

M.onPointer = function(x, y)
  if ui.input:onPointer(x, y) then return end
  ui.board:onPointer(x, y)
end

M.onPointerMove = function(x, y)
  ui.board:onPointerMove(x, y)
end

M.onPointerUp = function(x, y)
  ui.board:onPointerUp(x, y)
end

return M
