local utils = require "src.core.utils"

local M = {}

local state

M.shareState = function(state_)
  state = state_
end

M.processCommand = function(cmd)
  local words = utils.split(cmd, " ")
  local first = table.remove(words, 1)

  if first == "roster" then
    if #state.roster == 0 then return "you are alone" end
    local out = {}
    for _, username in ipairs(state.roster) do
      table.insert(out, "- " .. username)
    end
    return out
  elseif first == "help" then
    return "supported commands: help, roster"
  else
    return "unsupported command: " .. first
  end
end

return M
