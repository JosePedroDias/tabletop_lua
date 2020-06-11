-- [[ screen to capture user name ]] --
local consts = require "src.core.consts"
local settings = require "src.core.settings"
local stages = require "src.core.stages"

local Button = require "src.ui.button"
local Input = require "src.ui.input"

-- local Whiteboard = require "src.ui.whiteboard"

local M = {}

local G = love.graphics

local ui = {}

M.next = function()
  settings.username = ui.iusername.value
  settings.email = ui.iemail.value
  settings.save()
  stages.toStage("game")
end

M.load = function()
  ui.iusername = Input:new({
    x = (consts.W - 300) / 2,
    y = (consts.H - 140) / 2,
    width = 300,
    height = 40,
    focused = true,
    value = settings.username,
    onSubmit = M.next
  })

  ui.iemail = Input:new({
    x = (consts.W - 300) / 2,
    y = (consts.H - 40) / 2,
    width = 300,
    height = 40,
    value = settings.email,
    onSubmit = M.next
  })

  ui.bContinue = Button:new({
    x = (consts.W - 200) / 2,
    y = (consts.H + 140) / 2,
    width = 200,
    height = 40,
    label = "continue",
    onClick = M.next
  })

  -- ui.whiteboard = Whiteboard:new({width = 600, height = 400})
end

M.draw = function()
  --[[ local rw = 300
  local rh = 100

  local x = (consts.W - rw) / 2
  local y = (consts.H - rh) / 2 - 20

  G.setColor(0.75, 0.75, 0.75, 1)
  G.rectangle("fill", x, y, rw, rh)

  G.setColor(0, 0, 0, 1)
  G.print("what is your name?", x + 10, y + 10) ]]

  ui.iusername:draw()
  ui.iemail:draw()
  ui.bContinue:draw()

  -- ui.whiteboard:draw()
end

M.onKey = function(key)
  if ui.iusername:onKey(key) then return end
  if ui.iemail:onKey(key) then return end
  if key == "escape" then love.event.quit() end
end

M.onTextInput = function(text)
  if ui.iusername:onTextInput(text) then return end
  if ui.iemail:onTextInput(text) then return end
end

M.onPointer = function(x, y)
  ui.iusername:onPointer(x, y)
  ui.iemail:onPointer(x, y)
  ui.bContinue:onPointer(x, y)

  -- ui.whiteboard:onPointer(x, y)
end

return M
