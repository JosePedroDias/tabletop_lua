local lu = require "src.ext.luaunit"
local utils = require "src.core.utils"
local settings = require "src.core.settings"
local LF = love.filesystem
local FILE = "settings.json"

local M = {}

local originalData

function M:setUp()
  -- backup previous version
  local LF = love.filesystem
  originalData = LF.read(FILE)
end

function M:tearDown()
  -- restore it at the end
  if originalData then LF.write(FILE, originalData) end
end

function M:testLoadWithoutData()
  LF.write(FILE, "")

  lu.assertIsFalse(settings.load())
  lu.assertIsTrue(utils.eq(settings, {
    server = "acor.sl.pt",
    port = 1337,
    channel = "ch1",
    username = "john doe",
    email = "john.doe@somewhere.com",
    color = 1
  }), lu.prettystr(settings))
end

function M:testLoadWithData()
  LF.write(FILE, "{\"color\":2, \"server\":\"localhost\"}")

  lu.assertIsTrue(settings.load())
  lu.assertIsTrue(utils.eq(settings, {
    server = "localhost",
    port = 1337,
    channel = "ch1",
    username = "john doe",
    email = "john.doe@somewhere.com",
    color = 2
  }))
end

function M:testSaveWithoutData()
  LF.write(FILE, "")

  lu.assertIsFalse(settings.load())
  settings.username = "robin"
  lu.assertIsTrue(settings.save())
  local raw = LF.read(FILE)
  lu.assertEquals(raw,
                  "{\"server\":\"acor.sl.pt\",\"channel\":\"ch1\",\"color\":1,\"email\":\"john.doe@somewhere.com\",\"username\":\"robin\",\"port\":1337}")
end

function M:testSaveWithData()
  LF.write(FILE, "{\"color\":2, \"server\":\"localhost\"}")

  lu.assertIsTrue(settings.load())
  settings.username = "batman"
  lu.assertIsTrue(settings.save())
  local raw = LF.read(FILE)
  lu.assertEquals(raw,
                  "{\"server\":\"localhost\",\"channel\":\"ch1\",\"color\":2,\"email\":\"john.doe@somewhere.com\",\"username\":\"batman\",\"port\":1337}")
end

return M
