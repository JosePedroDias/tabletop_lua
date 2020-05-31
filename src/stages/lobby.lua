-- [[ screen to capture user name ]] --
local consts = require "src.core.consts"
local stages = require "src.core.stages"
local settings = require "src.core.settings"

require "src.ui.input"

local M = {}

local G = love.graphics

local ui = {}

M.load = function()
  local initialValues = settings.get()

  ui.input = Input:new({
    x = (consts.W - 200) / 2,
    y = (consts.H - 40) / 2,
    width = 200,
    height = 40,
    focused = true,
    value = initialValues[2],
    onSubmit = function(username)
      settings.save(initialValues[1], username)
      stages.toStage("game")
    end
  })
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
end

return M
