-- [[ game screen handling ]] --
require("src.ext.json")
local noobhub = require("src.ext.noobhub")

require "src.ui.arcmenu"
require "src.ui.console"
require "src.ui.input"
require "src.ui.board"

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
    x = 800 - 200,
    y = 0,
    width = 200,
    height = 600 - 30,
    maxLines = 20
  })

  ui.input = Input:new({
    x = 800 - 200,
    y = 600 - 40,
    width = 200,
    height = 20 + 20,
    focused = true,
    onChange = function(v)
    end,
    onSubmit = function(v)
      ui.console:addLine(v)
      say(v)
      ui.input:clear()
    end
  })

  ui.board = Board:new({})
end

M.unload = function()
end

M.update = function(dt)
  state.t = state.t + dt
  if hub then hub:enterFrame() end
end

M.draw = function()
  ui.board:draw()
  if ui.menu then ui.menu:draw() end
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

  if ui.menu then
    ui.menu:onPointer(x, y)
  else
    ui.menu = ArcMenu:new({
      x = x,
      y = y,
      -- dismissableFirst = true,
      labels = {"one", "two", "three", "four", "five"},
      callback = function(n)
        print("got", n)
        ui.menu = nil
      end
    })
  end
end

return M
