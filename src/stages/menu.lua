-- [[ game screen handling ]] --
local arcmenu = require "src.ui.arcmenu"

local M = {}

local G = love.graphics

local state = {t = 0}

M.unload = function()
end

M.update = function(dt)
  arcmenu.update(dt)

  state.t = state.t + dt
end

M.draw = function()
  arcmenu.draw()
end

M.onKey = function(key)
end

M.load = function()
  local cbs = {
    function()
      print(1)
    end, function()
      print(2)
    end, function()
      print(3)
    end
  }
  local lbls = {"one", "two", "three"}
  arcmenu.setup(false, cbs, lbls, 400, 300)
end

M.focus = function(isFocused)
end

M.onPointer = function(x, y)
  arcmenu.onPointer(x, y)
end

M.onPointerUp = function(x, y)
  arcmenu.onPointerUp(x, y)
end

return M
