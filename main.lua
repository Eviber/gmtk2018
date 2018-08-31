local Gamestate = require "hump.gamestate"

local lg = love.graphics

local menu = {}
local game = {}

function menu:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

function game:enter()
    --Entities.clear()
    -- setup entities here
end

function game:update(dt)
    --Entities.update(dt)
end

function game:draw()
    --Entities.draw()
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
