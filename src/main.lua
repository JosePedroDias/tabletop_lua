-- [[ main file! ]] --
local assets = require "src.core.assets"
local consts = require "src.core.consts"
local screen = require "src.core.screen"
local stages = require "src.core.stages"
local settings = require "src.core.settings"

local lobby = require "src.stages.lobby"
local game = require "src.stages.game"

function love.load()
  settings.load()

  love.keyboard.setKeyRepeat(true)

  -- image resolution fix
  local sW, sH = screen.getCurrentResolution()
  -- screen.setSize(sW, sH, consts.W, consts.H, true)
  screen.setSize(1024, 768, consts.W, consts.H, false)

  -- load resources
  assets.load()

  stages.setStage("lobby", lobby)
  stages.setStage("game", game)

  stages.toStage("lobby")

  settings.load()
end

function love.focus(f)
  stages.currentStage.focus(f)
end

function love.update(dt)
  stages.currentStage.update(dt)
end

function love.draw()
  screen.startDraw()
  stages.currentStage.draw()
  screen.endDraw()
end

function love.keypressed(key, scancode, isRepeat)
  stages.currentStage.onKey(key, scancode, isRepeat)
end

function love.keyreleased(key, scancode)
  stages.currentStage.onKeyUp(key, scancode)
end

function love.mousepressed(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointer(x, y)
end

function love.mousemoved(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerMove(x, y)
end

function love.mousereleased(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerUp(x, y)
end

function love.textinput(text)
  stages.currentStage.onTextInput(text)
end
