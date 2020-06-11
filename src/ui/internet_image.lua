local http = require "socket.http"

local function fetchRemoteImage(url)
  local responseData = http.request(url)
  local filedata = love.filesystem.newFileData(responseData)
  return love.graphics.newImage(filedata)
end

return fetchRemoteImage
