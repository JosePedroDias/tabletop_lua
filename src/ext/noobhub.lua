--------------------
-- NoobHub
-- opensource multiplayer and network messaging for CoronaSDK, Moai, Gideros & LÖVE
--
-- Authors:
-- Igor Korsakov
-- Sergii Tsegelnyk
--
-- License: WTFPL
-- https://github.com/Overtorment/NoobHub
--------------------
local socket = require("socket")
require("src.ext.json")

local noobhub = {

  new = function(params) -- constructor method
    params = params or {}
    if (not params.server or not params.port) then
      print("Noobhub requires server and port to be specified");
      return false;
    end
    local self = {}
    self.buffer = ""
    self.server = params.server
    self.port = params.port

    function self:subscribe(params)
      self.channel = params.channel or "test-channel"
      self.callback = params.callback or function()
      end
      local error_message
      self.sock, error_message = socket.connect(self.server, self.port)
      if (self.sock == nil) then
        print("Noobhub connection error: " .. error_message)
        print "Problems with server..?"
        return false;
      end
      self.sock:setoption("tcp-nodelay", true) -- disable Nagle's algorithm for the connection
      self.sock:settimeout(0)
      local _, output = socket.select(nil, {self.sock}, 3)
      for _, v in ipairs(output) do
        v:send("__SUBSCRIBE__" .. self.channel .. "__ENDSUBSCRIBE__");
      end
      return true
    end

    function self:unsubscribe()
      if self.sock then
        self.sock:close()
        self.sock = nil
      end
      self.buffer = ""
    end

    function self:reconnect()
      if (not self.channel or not self.callback) then return false; end
      print("Noobhub: attempt to reconnect...");
      return self:subscribe({channel = self.channel, callback = self.callback})
    end

    function self:publish(message)
      -- TODO: add retries
      if (self.sock == nil) then
        print "NoobHub: Attempt to publish without valid subscription (bad socket)"
        self:reconnect()
        return false;
      end
      local payload = "__JSON__START__" .. json.encode(message.message) ..
                        "__JSON__END__"

      local send_result, message2, num_bytes = self.sock:send(payload)
      if (send_result == nil) then
        print("Noobhub publish error: " .. message2 .. "  sent " .. num_bytes ..
                " bytes");
        if (message2 == "closed") then self:reconnect() end
        return false;
      end
      return true
    end

    function self:enterFrame()
      local input, _ = socket.select({self.sock}, nil, 0) -- this is a way not to block runtime while reading socket. zero timeout does the trick

      for _, v in ipairs(input) do

        local got_something_new = false
        while true do
          local skt, e, p = v:receive()
          if (skt) then
            self.buffer = self.buffer .. skt;
            got_something_new = true;
          end
          if (p) then
            self.buffer = self.buffer .. p;
            got_something_new = true;
          end
          if (not skt) then break end
          if (e) then break end
        end

        -- now, checking if a message is present in buffer...
        while got_something_new do --  this is for a case of several messages stocker in the buffer
          local start = string.find(self.buffer, "__JSON__START__")
          local finish = string.find(self.buffer, "__JSON__END__")
          if (start and finish) then -- found a message!
            local message = string.sub(self.buffer, start + 15, finish - 1)
            self.buffer = string.sub(self.buffer, 1, start - 1) ..
                            string.sub(self.buffer, finish + 13) -- cutting our message from buffer
            local data = json.decode(message)
            self.callback(data)
          else
            break
          end
        end

      end

    end

    return self
  end
}

return noobhub
