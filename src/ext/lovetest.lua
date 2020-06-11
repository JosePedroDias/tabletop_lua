-- based on https://raw.githubusercontent.com/stackmachine/lovetest/master/test/lovetest.lua
local M = {}

-- Search the passed in arguments for either -t or --test
function M.detect(args)
  for _, flag in ipairs(args) do
    if flag == "-t" or flag == "--test" then return true end
  end
  return false
end

function M.run()
  local lunatest = require "src.ext.lunatest"

  for _, filename in ipairs(love.filesystem.getDirectoryItems("test")) do
    local testname = (filename:gsub(".lua", ""))
    lunatest.suite("test/" .. testname)
  end

  lunatest.run(nil, {verbose = true})
end

return M
