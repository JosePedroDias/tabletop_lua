-- [[ screen to capture user name ]] --
local stages = require "src.core.stages"
local settings = require "src.core.settings"

require "src.ui.input"

local M = {}

local G = love.graphics

local ui = {}

M.load = function()
  local initialValues = settings.get()

  ui.input = Input:new({
    x = (800 - 200) / 2,
    y = (600 - 40) / 2,
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
  G.setColor(0.75, 0.75, 0.75, 1)
  G.rectangle("fill", 250, 230, 300, 100)

  G.setColor(0, 0, 0, 1)
  G.print("what is your name?", 260, 240)

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
