local lt = require "src.ext.lunatest"
local utils = require "src.core.utils"
local settings = require "src.core.settings"
local LF = love.filesystem
local FILE = "settings.json"

local eq = utils.eq

local originalData

function suite_setup()
  -- backup previous version
  local LF = love.filesystem
  originalData = LF.read(FILE)
end

function suite_teardown()
  -- restore it at the end
  if originalData then LF.write(FILE, originalData) end
end

function test_settings_load_without_data()
  LF.write(FILE, "")

  lt.assert_false(settings.load())
  lt.assert_true(eq({
    server = "acor.sl.pt",
    username = "john doe",
    email = "john.doe@somewhere.com",
    color = 1
  }, settings))
end

function test_settings_load_with_data()
  LF.write(FILE, "{\"color\":2, \"server\":\"localhost\"}")

  lt.assert_true(settings.load())
  lt.assert_true(eq({
    server = "localhost",
    username = "john doe",
    email = "john.doe@somewhere.com",
    color = 2
  }, settings))
end

function test_settings_save_without_data()
  LF.write(FILE, "")

  lt.assert_false(settings.load())
  settings.username = "robin"
  lt.assert_true(settings.save())
  local raw = LF.read(FILE)
  lt.assert_equal(
    "{\"server\":\"acor.sl.pt\",\"color\":1,\"username\":\"robin\",\"email\":\"john.doe@somewhere.com\"}",
    raw)
end

function test_settings_save_with_data()
  LF.write(FILE, "{\"color\":2, \"server\":\"localhost\"}")

  lt.assert_true(settings.load())
  settings.username = "batman"
  lt.assert_true(settings.save())
  local raw = LF.read(FILE)
  lt.assert_equal(
    "{\"server\":\"localhost\",\"color\":2,\"username\":\"batman\",\"email\":\"john.doe@somewhere.com\"}",
    raw)
end
