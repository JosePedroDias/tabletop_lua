--[[ 
    sets up chess - https://en.wikipedia.org/wiki/Chess
 ]] --
local consts = require "src.core.consts"

local Chess = require "src.items.chess"
local GameBoard = require "src.items.gameboard"

local M = {}

M.setup = function()
  local rotations = {0, 180}

  local board = consts.board

  local players = consts.board:getPlayers(2, 2)

  consts.board:setRotation(players[1], rotations[1])
  consts.board:setRotation(players[2], rotations[2])

  local cx = consts.W / 2
  local cy = consts.H / 2

  local gb = GameBoard:new({x = cx, y = cy})
  table.insert(board.items, gb)

  local function createPiece(label, color, piece)
    local cell = gb:getCell(label)
    local ch = Chess:new({
      piece = piece,
      color = color,
      x = cell.x + gb.x,
      y = cell.y + gb.y
    })
    table.insert(board.items, ch)
  end

  local items = {{"white", 1, 2}, {"black", 8, 7}}
  local letters = {"a", "b", "c", "d", "e", "f", "g", "h"}
  for _, it in ipairs(items) do
    local color = it[1]
    local n1 = it[2]
    local n2 = it[3]
    createPiece("a" .. n1, color, "rook")
    createPiece("h" .. n1, color, "rook")
    createPiece("b" .. n1, color, "knight")
    createPiece("g" .. n1, color, "knight")
    createPiece("c" .. n1, color, "bishop")
    createPiece("f" .. n1, color, "bishop")
    createPiece("d" .. n1, color, "queen")
    createPiece("e" .. n1, color, "king")
    for _, l in ipairs(letters) do createPiece(l .. n2, color, "pawn") end
  end

  board:redraw()
end

return M
