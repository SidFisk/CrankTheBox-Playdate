-- Board.lua

import "BoardTile"
import "CoreLibs/graphics"

local gfx = playdate.graphics

Board = {}
class("Board").extends()

function Board:init()
    self.rows = {}
    self.cols = 9
    self.tileSize = 30
    self.spacing = 35
    self.startX = 20
    self.startY = 20

    for row = 1, 3 do
        self.rows[row] = {}
        for col = 1, self.cols do
            self.rows[row][col] = Tile(math.random(1, 9))
        end
    end

    -- Cursor starts at top-left
    self.selectedRow = 1
    self.selectedCol = 1
    self:updateSelection()
end

function Board:updateSelection()
    for row = 1, 3 do
        for col = 1, self.cols do
            self.rows[row][col]:setSelected(false)
        end
    end

    if self.rows[self.selectedRow] then
        local tile = self.rows[self.selectedRow][self.selectedCol]
        if tile then
            tile:setSelected(true)
        end
    end
end

function Board:moveSelection(dx, dy)
    self.selectedCol = math.max(1, math.min(self.cols, self.selectedCol + dx))
    self.selectedRow = math.max(1, math.min(3, self.selectedRow + dy))
    self:updateSelection()
end

function Board:getVirtualRow()
    local virtualRow = {}

    for col = 1, self.cols do
        for row = 3, 1, -1 do
            local tile = self.rows[row][col]
            if tile then
                virtualRow[col] = tile
                break
            end
        end
    end

    return virtualRow
end

function Board:draw()
    -- Draw real tiles
    for row = 1, 3 do
        for col = 1, self.cols do
            local tile = self.rows[row][col]
            local x = self.startX + (col - 1) * self.spacing
            local y = self.startY + (row - 1) * self.spacing
            tile:draw(x, y)
        end
    end

    -- Draw virtual row
    local virtualRow = self:getVirtualRow()
    local virtualY = self.startY + (3 * self.spacing) + 10

    for col = 1, self.cols do
        local tile = virtualRow[col]
        if tile then
            local x = self.startX + (col - 1) * self.spacing
            tile:draw(x, virtualY)
        end
    end
end
