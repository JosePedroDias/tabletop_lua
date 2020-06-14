local consts = require "src.core.consts"
local utils = require "src.core.utils"

local gamesModule = "src.games."

local supportedGames = ""
for _, filename in ipairs(love.filesystem.getDirectoryItems("games")) do
  filename = filename:gsub(".lua", "")
  if supportedGames:len() > 0 then supportedGames = supportedGames .. ", " end
  supportedGames = supportedGames .. filename
end

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
        local msg = "starting " .. words[1] .. "..."
        SendEvent("say", msg)
        return msg
      else
        return tostring(err)
      end
    else
      return "unknown game:" .. words[1] .. "!"
    end
  elseif first == "games" then
    return "supported games: " .. supportedGames
  elseif first == "help" then
    return "supported commands: help, roster, games, start <game>"
  else
    return "unsupported command: " .. first
  end
end

return M
