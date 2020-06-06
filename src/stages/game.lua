-- [[ game screen handling ]] --
local noobhub = require("src.ext.noobhub")

local Console = require "src.ui.console"

local Board = require "src.ui.board"

local consts = require "src.core.consts"
local settings = require "src.core.settings"

local M = {}

local hub

local server
local username

local state = {t = 0}
local ui = {}

function SendEvent(action, data)
  hub:publish({message = {from = username, action = action, data = data}})
end

local function parseHubEvent(ev)
  if ev.action == "say" then
    ui.console:addLine(ev.from .. ": " .. ev.data)
  else
    ui.board:onEvent(ev)
  end
end

M.load = function()
  server = settings.get()[1]
  username = settings.get()[2]

  love.window.setTitle("tabletop - " .. username)

  hub = noobhub.new({server = server, port = 1337});
  hub:subscribe({channel = "ch1", callback = parseHubEvent})

  SendEvent("say", "hello")

  ui.console = Console:new({
    x = consts.W - 200,
    y = 0,
    width = 200,
    height = consts.H,
    maxLines = 20,
    dismissed = true
  })

  ui.board = Board:new({width = consts.W, height = consts.H})
end

M.unload = function()
end

M.update = function(dt)
  state.t = state.t + dt
  if hub then hub:enterFrame() end
end

M.draw = function()
  ui.board:draw()
  ui.console:draw()
end

M.onKey = function(key)
  if key == "escape" then
    SendEvent("say", "leaving...")
    love.event.quit()
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
