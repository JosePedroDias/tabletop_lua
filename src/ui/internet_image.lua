local http = require "socket.http"

local function fetchRemoteImage(url)
  local respData = http.request(url)
  local filedata = love.filesystem.newFileData(respData, "")
  local imagedata = love.image.newImageData(filedata)
  return love.graphics.newImage(imagedata)
end

return fetchRemoteImage
