--[[ 
    sets up checkers - https://en.wikipedia.org/wiki/Draughts
 ]] --
local consts = require "src.core.consts"

local Checkers = require "src.items.checkers"
local GameBoard = require "src.items.gameboard"

local M = {}

M.setup = function()
  local rotations = {0, 180}

  local board = consts.board

  local players = consts.board:getPlayers(2, 2)

  local cx = consts.W / 2
  local cy = consts.H / 2

  local gb = GameBoard:new({x = cx, y = cy})
  table.insert(board.items, gb)

  local d = 1024 / 8 * 0.6

  local c
  for y = 1, 8 do
    local clr = "black"
    if y > 4 then clr = "white" end

    for x = 1, 8 do
      if (y < 4 or y > 5) and (x + y) % 2 == 1 then
        c = Checkers:new({
          color = clr,
          x = cx + (x - 4.5) * d,
          y = cy + (y - 4.5) * d
        })
        table.insert(board.items, c)
      end
    end
  end

  consts.board:setRotation(players[1], rotations[1])
  consts.board:setRotation(players[2], rotations[2])

  board:redraw()
end

return M
