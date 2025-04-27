-- Tile.lua
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animator"

--Shortcuts
local gfx <const> = playdate.graphics
local snd <const> = playdate.sound
local pd <const> = playdate

Tile = {}
class("Tile").extends()

function Tile:init(value, graphic, graphicSelected, xloc, yloc, vis, sel)
    self.value = value or 1 -- Default value is 1 if not provided
    self.selected = sel    -- Default selected state is false
    self.visible = vis      -- Default visible state is true
    self.graphic = gfx.image.new(graphic)   -- Sprite Graphic
    self.graphicSelected = gfx.image.new(graphicSelected)
    self.xlocation = xloc
    self.ylocation = yloc
    self.sprite = gfx.sprite.new(self.graphic)

    return self
end

-- Getter for value
function Tile:getValue()
    return self.value
end

-- Setter for value
function Tile:setValue(newValue)
    if newValue >= 1 and newValue <= 9 then
        self.value = newValue
    else
        error("Value must be between 1 and 9.")
    end
end

-- Getter for selected state
function Tile:isSelected()
    return self.selected
end

-- Setter for selected state
function Tile:setSelected(state)
    self.selected = state
    if state then
        gfx.sprite.removeSprite(self.sprite)
        self.sprite = gfx.sprite.new(self.graphicSelected)
    else
        gfx.sprite.removeSprite(self.sprite)
        self.sprite = gfx.sprite.new(self.graphic)
    end
end

-- Getter for visible state
function Tile:isVisible()
    return self.visible
end

-- Setter for visible state
function Tile:setVisible(state)
    if state then
        gfx.sprite.removeSprite(self.sprite)
        if self.sprite ~= nil then
            self.sprite:add()
        end
    else
        gfx.sprite.removeSprite(self.sprite)
    end
    self.visible = state
end

-- Getter for graphic
function Tile:getGraphic()
    return self.graphic
end

-- Setter for graphic
function Tile:setGraphic(graphic)
    self.graphic = graphic
end

-- Getter for graphicSelected
function Tile:getGraphicSelected()
    return self.graphicSelected
end

-- Setter for graphicSelected
function Tile:setGraphicSelected(graphicSelected)
    self.graphicSelected = graphicSelected
end

-- Setter for Location
function Tile:setLocation(xloc, yloc)
    self.xlocation = xloc
    self.ylocation = yloc
    self.sprite:moveTo(xloc,yloc)
end

return Tile