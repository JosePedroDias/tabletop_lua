-- [[ game screen handling ]] --
require "src.ui.arcmenu"

local M = {}

local state = {t = 0}

M.load = function()
end

M.unload = function()
end

M.update = function(dt)
  state.t = state.t + dt
end

M.draw = function()
  if state.menu then state.menu:draw() end
end

M.onKey = function(key)
  if key == "escape" then love.event.quit() end
end

M.focus = function(isFocused)
end

M.onPointer = function(x, y)
  if state.menu then
    state.menu:onPointer(x, y)
  else
    state.menu = ArcMenu:new({
      x = x,
      y = y,
      -- dismissableFirst = true,
      labels = {"one", "two", "three", "four", "five"},
      callback = function(n)
        print("got", n)
        state.menu = nil
      end
    })
  end
end

M.onPointerUp = function(x, y)
end

return M
