--[[ generates gravatar url. self made based on
https://en.gravatar.com/site/implement/hash/
https://en.gravatar.com/site/implement/images/
 ]] --
local md5 = require "src.ext.md5"
local utils = require "src.core.utils"

local function gravatarUrl(email, size)
  local normalizedEmail = utils.trim(email):lower()
  local hash = md5(normalizedEmail)
  return "https://www.gravatar.com/avatar/" .. hash .. "?s=" .. tostring(size)
end

return gravatarUrl
