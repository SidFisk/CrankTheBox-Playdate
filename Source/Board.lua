-- Board.lua

import "Tile"
import "CoreLibs/graphics"

local gfx = playdate.graphics

Board = {}
class("Board").extends()

function Board:init()
    self.tileRows = {}
    self.virtualRow = {}
    self.rows = 3
    self.cols = 9
    self.selectedRow = 3
    self.selectedCol = 1
    self.priorRow = 0
    self.priorCol = 0
    self.tileWidth = 39
    self.tileHeight = 61
    self.spacingX = 41
    self.spacingY = 63
    self.startX = 22
    self.startY = 35

    local rowTileGraphic = nil
    for row = 1, self.rows do
        self.tileRows[row] = {}
        if row == 1 then rowTileGraphic = "Images/A"
        elseif row == 2 then rowTileGraphic = "Images/b"
        elseif row == 3 then rowTileGraphic = "Images/c" end
        for col = 1, self.cols do
            self.tileRows[row][col] = Tile(col,  rowTileGraphic .. col .. ".png", rowTileGraphic .. col .. "_selected.png", 500, 500, false, false)
            self.tileRows[row][col]:setVisible(true)
        end
    end

    -- Cursor starts at bottom-left
    self:updateSelection()
end

function Board:updateSelection()
    if self.tileRows[self.priorRow] then
        local tile = self.tileRows[self.priorRow][self.priorCol]
        if tile then
            tile:setSelected(false)
            tile:setVisible(true)
        end
    end

    if self.tileRows[self.selectedRow] then
        local tile = self.tileRows[self.selectedRow][self.selectedCol]
        if tile then
            tile:setSelected(true)
            tile:setVisible(true)
        end
    end
end

function Board:moveSelection(dx, dy)
    self.priorRow = self.selectedRow
    self.priorCol = self.selectedCol
    self.selectedCol = math.max(1, math.min(self.cols, self.selectedCol + dx))
    self.selectedRow = math.max(1, math.min(self.rows, self.selectedRow + dy))
    self:updateSelection()
end

-- function Board:getVirtualRow()
--     local virtualRow = {}

--     for col = 1, self.cols do
--         for row = self.rows, 1, -1 do
--             local tile = self.tileRows[row][col]
--             if tile then
--                 virtualRow[col] = tile
--                 break
--             end
--         end
--     end

--     return virtualRow
-- end

function Board:draw()
    -- Draw real tiles
    for row = 1, self.rows do
        for col = 1, self.cols do
            local tile = self.tileRows[row][col]
            local x = self.startX + ((col - 1) * self.spacingX)
            local y = self.startY + ((row - 1) * self.spacingY)
            if tile ~= nil then
                tile:setLocation(x, y)
            end
        end
    end

    -- Draw virtual row
    -- local virtualRow = self:getVirtualRow()
    -- local virtualY = self.startY + (self.rows * self.spacingY) + 10
    -- for col = 1, self.cols do
    --     local tile = virtualRow[col]
    --     if tile then
    --         local x = self.startX + (col - 1) * self.spacingX
    --         tile:draw(x, virtualY)
    --     end
    -- end
end
