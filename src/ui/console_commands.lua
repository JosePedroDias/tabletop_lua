local consts = require "src.core.consts"
local utils = require "src.core.utils"

local gamesModule = "src.games."

local M = {}

M.processCommand = function(cmd)
  local words = utils.split(cmd, " ")
  local first = table.remove(words, 1)
  if not first then return "" end

  if first == "roster" then
    if #consts.roster == 0 then return "you are alone" end
    local out = {}
    for _, username in ipairs(consts.roster) do
      table.insert(out, "- " .. username)
    end
    return out
  elseif first == "start" and #words > 0 then
    local succeeded, game = pcall(require, gamesModule .. words[1])

    if succeeded then
      consts.board:reset()
      local didOk, err = pcall(game.setup)
      if didOk then
        return "starting " .. words[1] .. "..."
      else
        print(err)
        return "error preparing game!"
      end
    else
      return "unknown game:" .. words[1] .. "!"
    end
  elseif first == "games" then
    return "supported games: go-fish"
  elseif first == "help" then
    return "supported commands: help, roster, start <game>, games"
  else
    return "unsupported command: " .. first
  end
end

return M
