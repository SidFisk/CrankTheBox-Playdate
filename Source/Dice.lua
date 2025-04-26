local gfx = playdate.graphics
local snd = playdate.sound
local pd = playdate

Dice = {}
class('Dice').extends()

function Dice:init(x, y)
    self.x = x
    self.y = y
    self.value = 1

    self.faceImages = {}
    for i = 1, 6 do
        self.faceImages[i] = gfx.image.new("Images/Die" .. i)
    end

    self.sprite = gfx.sprite.new(self.faceImages[self.value])
    self.sprite:setCenter(0.5, 0.5)
    self.sprite:moveTo(self.x, self.y)
    self.sprite:add()

    self.rollSound = snd.sampleplayer.new("Sounds/roll")
    self.rolling = false
    self.rollTimeLeft = 0

    self.bouncing = false
    self.scale = 1
end

function Dice:update()
    if self.rolling then
        self.rollTimeLeft -= 1
        -- only update sprites every other update
        if self.rollTimeLeft % 2 == 0 then
            local tempValue = math.random(1, 6)
            self.sprite:setImage(self.faceImages[tempValue])
        end

        if self.rollTimeLeft <= 0 then
            self.rolling = false
            self.value = math.random(1, 6)
            self.sprite:setImage(self.faceImages[self.value])
            self:triggerBounce()
        end
    end

    -- Apply scale for bounce animation
    if self.bouncing then
        self.sprite:setScale(self.scale)
    end
end

function Dice:triggerBounce()
    self.bouncing = true
    local t = playdate.frameTimer.new(10, 1.4, 1)
    t.easingFunction = playdate.easingFunctions.outBounce
    t.timerEndedCallback = function()
        self.bouncing = false
        self.sprite:setScale(1)
    end
    t.updateCallback = function(timer)
        self.scale = timer.value
    end
end

function Dice:drawGlow()
    local img = self.faceImages[self.value]
    if img then
        gfx.setColor(gfx.kColorWhite)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        img:drawFaded(self.x - img:getSize()/2, self.y - img:getSize()/2, 0.1, gfx.image.kDitherTypeBayer8x8)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
end

function Dice:roll(duration)
    if self.rolling then return end

    self.rolling = true
    self.rollTimeLeft = duration
    self.rollSound:play()
end

function Dice:getValue()
    return self.value
end

function Dice:isRolling()
    return self.rolling
end
