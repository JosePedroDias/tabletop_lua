-- [[ set of constants for the game. I've been using it to attach additional globals too]] --
local M = {}

M.W = 1000
M.H = 1000

M.x0 = 0
M.y0 = 0

M.version = "0.0.3" -- used for network and config compatibility
M.gitHash = "__GITHASH__"
M.gitDate = "__GITDATE__"

-- https://en.wikipedia.org/wiki/Enhanced_Graphics_Adapter
M.colors = {
  {0, 0, 0}, -- black
  {0, 0, 0.66}, -- blue
  {0, 0.66, 0}, -- green
  {0, 0.66, 0.66}, -- cyan
  {0.66, 0, 0}, -- red
  {0.66, 0, 0.66}, -- magenta
  {0.66, 0.33, 0}, -- brown
  {0.66, 0.66, 0.66}, -- light gray
  {0.33, 0.33, 0.33}, -- dark gray
  {0.33, 0.33, 1}, -- bright blue
  {0.33, 1, 0.33}, -- bright green
  {0.33, 1, 1}, -- bright cyan
  {1, 0.33, 1}, -- bright red
  {1, 0.33, 0.33}, -- bright magenta
  {1, 1, 0.33}, -- bright yellow
  {1, 1, 1} -- white
}

return M
