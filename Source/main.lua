----------------------------------------------
-- BELOW IS ERIK AND I PLAYING THE OTHER NIGHT
----------------------------------------------

-- -- main.lua
-- import "CoreLibs/object"
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
-- import "CoreLibs/timer"
-- import "CoreLibs/crank"
-- import "CoreLibs/animator"
-- -- Require the Tile class from Tile.lua
-- local Tile = import "Tile"

-- --Shortcuts
-- local gfx <const> = playdate.graphics
-- local snd <const> = playdate.sound
-- local pd <const> = playdate

-- -- Create a new Tile instance
-- local tile1 = Tile.new(1, "Images/A1.png", 500, 500, true, true)
-- tile1:setLocation(200,120)
-- tile1:setVisible(true)

-- local tile2 = Tile.new(2, "Images/A2.png", 500, 500, true, true)
-- tile2:setLocation(250,120)
-- tile2:setVisible(true)

-- function pd.update()
--     gfx.sprite.update()
-- end

-- return

----------------------------
-- BELOW IS THE DICE ROLLING
----------------------------

import "CoreLibs/object"
import "CoreLibs/graphics"
import "Board"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "Dice"

local gfx = playdate.graphics
local board = Board()

local dice1 = Dice(40, 200)
local dice2 = Dice(100, 200)
local dice3 = Dice(160, 200)
local diceList = {dice1, dice2, dice3}

local showSum = false
local sumValue = 0

local function rollDice(duration)
    for _, dice in ipairs(diceList) do
        dice:roll(duration)
    end

    showSum = false
end

local function checkIfRollFinished()
    if not dice1:isRolling()
       and not dice2:isRolling()
       and not dice3:isRolling()
       and not showSum then
        sumValue =  dice1:getValue() +
                    dice2:getValue() +
                    dice3:getValue()
        showSum = true
    end
end

function playdate.update()
    local dt = playdate.getElapsedTime()
    gfx.clear()

    -- Update
    gfx.pushContext()

    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()

    for _, dice in ipairs(diceList) do
        dice:update()
        dice:drawGlow()
    end

    gfx.popContext()

    checkIfRollFinished()

    -- Show total if done rolling
    if showSum then
        gfx.setFont(gfx.getSystemFont())
        gfx.drawTextAligned("You rolled a " .. sumValue .. "!", 250, 190, kTextAlignment.center)
    end

    board:draw()
end

function playdate.AButtonDown()
    rollDice(10)
end

function playdate.leftButtonDown()
    board:moveSelection(-1, 0)
end

function playdate.rightButtonDown()
    board:moveSelection(1, 0)
end

function playdate.upButtonDown()
    board:moveSelection(0, -1)
end

function playdate.downButtonDown()
    board:moveSelection(0, 1)
end

-- return



