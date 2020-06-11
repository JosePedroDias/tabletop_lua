--[[ generates gravatar url. self made based on
https://en.gravatar.com/site/implement/hash/
https://en.gravatar.com/site/implement/images/
 ]] --
local md5 = require "src.ext.md5"
local utils = require "src.core.utils"

--[[ 
mp: (mystery-person)
identicon
monsterid
wavatar
retro
robohash
 ]]
local function gravatarUrl(email, size, default, forceDefault)
  local normalizedEmail = utils.trim(email):lower()
  local hash = md5.sumhexa(normalizedEmail)
  local url = "https://www.gravatar.com/avatar/" .. hash .. "?s=" ..
                tostring(size)

  if default then url = url .. "&d=" .. default end
  if forceDefault then url = url .. "&f=y" end

  return url
end

return gravatarUrl
