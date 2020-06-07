-- based on https://raw.githubusercontent.com/stackmachine/lovetest/master/test/lovetest.lua
local lovetest = {}

-- Search the passed in arguments for either -t or --test
function lovetest.detect(args)
  for _, flag in ipairs(args) do
    if flag == "-t" or flag == "--test" then return true end
  end
  return false
end

function lovetest.run()
  local lunatest = require "src.ext.lunatest"

  for _, filename in ipairs(love.filesystem.getDirectoryItems("test")) do
    if filename:match("^test_.*%.lua$") then
      local testname = (filename:gsub(".lua", ""))
      lunatest.suite("test/" .. testname)
    end
  end

  lunatest.run(nil, {verbose = true})
  love.event.push("quit")
end

return lovetest
