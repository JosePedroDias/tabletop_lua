-- [[ screen to capture user name ]] --
local consts = require "src.core.consts"
local stages = require "src.core.stages"
local settings = require "src.core.settings"

local Input = require "src.ui.input"
-- local Whiteboard = require "src.ui.whiteboard"

local M = {}

local G = love.graphics

local ui = {}

M.load = function()
  ui.input = Input:new({
    x = (consts.W - 200) / 2,
    y = (consts.H - 40) / 2,
    width = 200,
    height = 40,
    focused = true,
    value = settings.username,
    onSubmit = function(username)
      settings.save(settings.server, username)
      stages.toStage("game")
    end
  })

  -- ui.whiteboard = Whiteboard:new({width = 600, height = 400})
end

M.draw = function()
  local rw = 300
  local rh = 100

  local x = (consts.W - rw) / 2
  local y = (consts.H - rh) / 2 - 20

  G.setColor(0.75, 0.75, 0.75, 1)
  G.rectangle("fill", x, y, rw, rh)

  G.setColor(0, 0, 0, 1)
  G.print("what is your name?", x + 10, y + 10)

  ui.input:draw()

  -- ui.whiteboard:draw()
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
  -- ui.whiteboard:onPointer(x, y)
end

M.onPointerMove = function(x, y)
  -- ui.whiteboard:onPointerMove(x, y)
end

M.onPointerUp = function(x, y)
  -- ui.whiteboard:onPointerUp(x, y)
end

return M
