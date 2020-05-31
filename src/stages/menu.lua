-- [[ game screen handling ]] --
require "src.ui.arcmenu"
require "src.ui.console"
require "src.ui.input"
require "src.ui.board"

local M = {}

local state = {t = 0}

M.load = function()
  state.console = Console:new({
    x = 800 - 200,
    y = 0,
    width = 200,
    height = 600 - 30,
    maxLines = 12
  })
  -- state.console:addLine("Welcome!")

  state.input = Input:new({
    x = 800 - 200,
    y = 600 - 40,
    width = 200,
    height = 20 + 20,
    focused = true,
    onChange = function(v)
      print("change", v)
    end,
    onSubmit = function(v)
      print("submit", v)
      state.console:addLine(v)
      state.input:clear()
    end
  })

  state.board = Board:new({})
end

M.unload = function()
end

M.update = function(dt)
  state.t = state.t + dt
end

M.draw = function()
  state.board:draw()
  if state.menu then state.menu:draw() end
  state.console:draw()
  state.input:draw()
end

M.onKey = function(key)
  state.input:onKey(key)
  if key == "escape" then love.event.quit() end
end

M.onTextInput = function(text)
  state.input:onTextInput(text)
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

  state.input:onPointer(x, y)
end

return M
