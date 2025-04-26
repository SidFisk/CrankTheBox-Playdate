-- Tile.lua

import "CoreLibs/graphics"

local gfx = playdate.graphics

Tile = {}
class("Tile").extends()

function Tile:init(value)
    self.value = value or math.random(1, 9)
    self.selected = false
end

function Tile:setSelected(selected)
    self.selected = selected
end

function Tile:draw(x, y)
    if self.selected then
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(x, y, 30, 30)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(x, y, 30, 30)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        gfx.setColor(gfx.kColorBlack)
    end

    gfx.drawRect(x, y, 30, 30)
    gfx.drawTextAligned(tostring(self.value), x + 15, y + 7, kTextAlignment.center)
end
