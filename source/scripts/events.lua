local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Events').extends()

function Events:init()
    self.callbacks = {}
end

-- Select an event string to listen
-- Then the callback function that should execute
function Events:on(event, callback)
    self.callbacks[event] = self.callbacks[event] or {}
    self.callbacks[event][#self.callbacks[event] + 1] = callback
end

-- Cleanup functions that won't be used any more
function Events:off(event, callback)
    table.remove(self.callbacks[event], i)
    for i, e in ipairs(self.callbacks[event]) do
        if e == callback then
            table.remove(self.callbacks[event], i)
            break
        end
    end
end

-- Trigger an event
function Events:emit(event, ...)                         -- the second parameter allows you to include any number of parameters when calling this function
    -- local fns = table.shallowcopy(self.callbacks[event]) -- just in case the array changes while we are iterating
    -- for i = 1, #fns do
    --     fns[i](...)
    -- endD
end

-- Make the import an instance of itself
Events = Events()