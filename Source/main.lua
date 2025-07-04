-- Notes -- CRANK = "Hotel Royal" THE BOX = "High Tower"

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

--Initial Animator
local titleEnterAnimator = gfx.animator.new(1000, -100, 120, pd.easingFunctions.inOutElastic)

--Sounds


--Sprites
local firstDie = nil  -- Die #1
local secondDie = nil -- Die #2
local blank = nil -- blank tile for debugging
local classicSprite = nil    -- Classic game badge
local doubleSprite = nil     -- Double game badge
local tripleSprite = nil     -- Triple game badge
local titleCard = nil        -- Title Graphic for when the game first starts
local instructionCard = nil  -- Instructions for the game -- seen after the title
local flavorCard = nil -- Card to choose your game version
local scoreSprite = nil -- Score card for the titleCard
local a1Tile = nil -- Tile for the Classic 1
local a2Tile = nil -- Tile for the Classic 2
local a3Tile = nil -- Tile for the Classic 3
local a4Tile = nil -- Tile for the Classic 4
local a5Tile = nil -- Tile for the Classic 5
local a6Tile = nil -- Tile for the Classic 6
local a7Tile = nil -- Tile for the Classic 7
local a8Tile = nil -- Tile for the Classic 8
local a9Tile = nil -- Tile for the Classic 9
local b1Tile = nil -- Tile for the Double 1
local b2Tile = nil -- Tile for the Double 2
local b3Tile = nil -- Tile for the Double 3
local b4Tile = nil -- Tile for the Double 4
local b5Tile = nil -- Tile for the Double 5
local b6Tile = nil -- Tile for the Double 6
local b7Tile = nil -- Tile for the Double 7
local b8Tile = nil -- Tile for the Double 8
local b9Tile = nil -- Tile for the Double 9
local c1Tile = nil -- Tile for the Triple 1
local c2Tile = nil -- Tile for the Triple 2
local c3Tile = nil -- Tile for the Triple 3
local c4Tile = nil -- Tile for the Triple 4
local c5Tile = nil -- Tile for the Triple 5
local c6Tile = nil -- Tile for the Triple 6
local c7Tile = nil -- Tile for the Triple 7
local c8Tile = nil -- Tile for the Triple 8
local c9Tile = nil -- Tile for the Triple 9


--Variables
local gameFlavor = nil -- Tracks the flavor of the game
local classic = 1 -- Single row of tiles
local double = 2 -- Double row of tiles
local triple = 3 -- Triple row of tiles
local gamePhase = nil -- Tracks phase of game
local showTitlePhase = 1 -- Show the title card
local parkTitlePhase = 2 -- Show the title card
local instructionsPhase = 3 -- Show the instructions card
local instructionsParkPhase = 4
local flavorPhase = 5 -- Show the card to allow to select game flavor
local flavorParkPhase = 6
local tileFlyPhase = 7-- Bring in the tiles!
local rollPhase = 8 -- Phase to roll the dice
local tilePhase = 9 -- Phase to select and crank away tiles
local endPhase = 10 -- Endgame phase to show final score and high scores
local flavorXcord = nil -- X coordinate for the flavor selector
local flavorYcord = nil -- Y coordinate for the flavor selector
local badgeXcord = 132 -- X coordinate for the flavor badge
local badgeYcord = 200 -- Y coordinate for the flavor badge
local a1x = 25
local a1y = 36
local a2x = 69
local a2y = 36
local a3x = 113
local a3y = 36
local a4x = 157
local a4y = 36
local a5x = 201
local a5y = 36
local a6x = 245
local a6y = 36
local a7x = 289
local a7y = 36
local a8x = 333
local a8y = 36
local a9x = 377
local a9y = 36

local b9x = 25
local b9y = 51
local b8x = 69
local b8y = 51
local b7x = 113
local b7y = 51
local b6x = 157
local b6y = 51
local b5x = 201
local b5y = 51
local b4x = 245
local b4y = 51
local b3x = 289
local b3y = 51
local b2x = 333
local b2y = 51
local b1x = 377
local b1y = 51

local c1x = 25
local c1y = 66
local c2x = 69
local c2y = 66
local c3x = 113
local c3y = 66
local c4x = 157
local c4y = 66
local c5x = 201
local c5y = 66
local c6x = 245
local c6y = 66
local c7x = 289
local c7y = 66
local c8x = 333
local c8y = 66
local c9x = 377
local c9y = 66

local firstDieX = 170
local firstDieY = 132
local secondDieX = 230
local secondDieY = 132
die1Value = 0
die2Value = 0

local function showTitleCard()
	titleCard:add()
	local enterY = titleEnterAnimator:currentValue()
	titleCard:moveTo(200, enterY)
	if titleEnterAnimator:ended() then
		titleParkAnimator = gfx.animator.new(2000, 120, 200, pd.easingFunctions.inOutElastic,500)
		gamePhase = parkTitlePhase
	end
end

local function parkTitleCard()
	local parkY = titleParkAnimator:currentValue()
	titleCard:moveTo(200, parkY)
	if titleParkAnimator:ended() then
		instructionsEnterAnimator = gfx.animator.new(1000, -100, 82, pd.easingFunctions.inOutElastic)
		gamePhase = instructionsPhase
	end
end


local function showInstructionCard()
	instructionCard:add()
	local enterY = instructionsEnterAnimator:currentValue()
	instructionCard:moveTo(200, enterY)
	if pd.buttonJustPressed(pd.kButtonA) then
		instructionsParkAnimator = gfx.animator.new(750, 82, -100, pd.easingFunctions.inOutElastic)
		gamePhase = instructionsParkPhase
	end
end

local function parkInstructionCard()
	local parkY = instructionsParkAnimator:currentValue()
	instructionCard:moveTo(200, parkY)
	if instructionsParkAnimator:ended() then
		instructionCard:remove()
		flavorEnterAnimator = gfx.animator.new(1000, -100, 82, pd.easingFunctions.inOutElastic)
		gamePhase = flavorPhase
	end
end

local function showFlavorCard()
	flavorCard:add()
	local enterY = flavorEnterAnimator:currentValue()
	flavorCard:moveTo(200, enterY)

	if flavorEnterAnimator:ended() then
		
		selectorSprite:add()

		if gameFlavor == classic then
			flavorXcord = 249
			flavorYcord = 61
		elseif gameFlavor == double then
			flavorXcord = 249
			flavorYcord = 83
		elseif gameFlavor == triple then
			flavorXcord = 249
			flavorYcord = 105
		end

		selectorSprite:moveTo(flavorXcord, flavorYcord)

	end

	if playdate.buttonJustPressed(playdate.kButtonDown) then
		gameFlavor += 1
		if gameFlavor > 3 then gameFlavor = 3 end
	end

	if playdate.buttonJustPressed(playdate.kButtonUp) then
		gameFlavor -= 1
		if gameFlavor < 1 then gameFlavor = 1 end 
	end

	if pd.buttonJustPressed(pd.kButtonA) then
		flavorParkAnimator = gfx.animator.new(750, 82, -100, pd.easingFunctions.inOutElastic)
		gamePhase = flavorParkPhase
	end
end

local function parkFlavorCard()
	local enterY = flavorParkAnimator:currentValue()
	flavorCard:moveTo(200, enterY)
	-- selectorSprite:moveTo(flavorXcord, flavorYcord-enterY)
	selectorSprite:remove()	
	if flavorParkAnimator:ended() then
		flavorCard:remove()
		selectorSprite:remove()
		gamePhase = tileFlyPhase
		if gameFlavor == classic then
			classicSprite:add()
			a1Animator = gfx.animator.new(1000,300, a1y, pd.easingFunctions.inOutElastic, 100)
			a2Animator = gfx.animator.new(1000,300, a2y, pd.easingFunctions.inOutElastic, 200)
			a3Animator = gfx.animator.new(1000,300, a3y, pd.easingFunctions.inOutElastic, 300)
			a4Animator = gfx.animator.new(1000,300, a4y, pd.easingFunctions.inOutElastic, 400)
			a5Animator = gfx.animator.new(1000,300, a5y, pd.easingFunctions.inOutElastic, 500)
			a6Animator = gfx.animator.new(1000,300, a6y, pd.easingFunctions.inOutElastic, 600)
			a7Animator = gfx.animator.new(1000,300, a7y, pd.easingFunctions.inOutElastic, 700)
			a8Animator = gfx.animator.new(1000,300, a8y, pd.easingFunctions.inOutElastic, 800)
			a9Animator = gfx.animator.new(1000,300, a9y, pd.easingFunctions.inOutElastic, 900)
			a1Tile:add()
			a2Tile:add()
			a3Tile:add()
			a4Tile:add()
			a5Tile:add()
			a6Tile:add()
			a7Tile:add()
			a8Tile:add()
			a9Tile:add()
		elseif gameFlavor == double then
			doubleSprite:add()
			a1Animator = gfx.animator.new(1000,300, a1y, pd.easingFunctions.inOutElastic, 100)
			a2Animator = gfx.animator.new(1000,300, a2y, pd.easingFunctions.inOutElastic, 200)
			a3Animator = gfx.animator.new(1000,300, a3y, pd.easingFunctions.inOutElastic, 300)
			a4Animator = gfx.animator.new(1000,300, a4y, pd.easingFunctions.inOutElastic, 400)
			a5Animator = gfx.animator.new(1000,300, a5y, pd.easingFunctions.inOutElastic, 500)
			a6Animator = gfx.animator.new(1000,300, a6y, pd.easingFunctions.inOutElastic, 600)
			a7Animator = gfx.animator.new(1000,300, a7y, pd.easingFunctions.inOutElastic, 700)
			a8Animator = gfx.animator.new(1000,300, a8y, pd.easingFunctions.inOutElastic, 800)
			a9Animator = gfx.animator.new(1000,300, a9y, pd.easingFunctions.inOutElastic, 900)
			a1Tile:add()
			a2Tile:add()
			a3Tile:add()
			a4Tile:add()
			a5Tile:add()
			a6Tile:add()
			a7Tile:add()
			a8Tile:add()
			a9Tile:add()
			b1Animator = gfx.animator.new(2000,300, b1y, pd.easingFunctions.inOutElastic, 100)
			b2Animator = gfx.animator.new(2000,300, b2y, pd.easingFunctions.inOutElastic, 200)
			b3Animator = gfx.animator.new(2000,300, b3y, pd.easingFunctions.inOutElastic, 300)
			b4Animator = gfx.animator.new(2000,300, b4y, pd.easingFunctions.inOutElastic, 400)
			b5Animator = gfx.animator.new(2000,300, b5y, pd.easingFunctions.inOutElastic, 500)
			b6Animator = gfx.animator.new(2000,300, b6y, pd.easingFunctions.inOutElastic, 600)
			b7Animator = gfx.animator.new(2000,300, b7y, pd.easingFunctions.inOutElastic, 700)
			b8Animator = gfx.animator.new(2000,300, b8y, pd.easingFunctions.inOutElastic, 800)
			b9Animator = gfx.animator.new(2000,300, b9y, pd.easingFunctions.inOutElastic, 900)
			b1Tile:add()
			b2Tile:add()
			b3Tile:add()
			b4Tile:add()
			b5Tile:add()
			b6Tile:add()
			b7Tile:add()
			b8Tile:add()
			b9Tile:add()
		elseif gameFlavor == triple then
			tripleSprite:add()
			a1Animator = gfx.animator.new(1000,300, a1y, pd.easingFunctions.inOutElastic, 100)
			a2Animator = gfx.animator.new(1000,300, a2y, pd.easingFunctions.inOutElastic, 200)
			a3Animator = gfx.animator.new(1000,300, a3y, pd.easingFunctions.inOutElastic, 300)
			a4Animator = gfx.animator.new(1000,300, a4y, pd.easingFunctions.inOutElastic, 400)
			a5Animator = gfx.animator.new(1000,300, a5y, pd.easingFunctions.inOutElastic, 500)
			a6Animator = gfx.animator.new(1000,300, a6y, pd.easingFunctions.inOutElastic, 600)
			a7Animator = gfx.animator.new(1000,300, a7y, pd.easingFunctions.inOutElastic, 700)
			a8Animator = gfx.animator.new(1000,300, a8y, pd.easingFunctions.inOutElastic, 800)
			a9Animator = gfx.animator.new(1000,300, a9y, pd.easingFunctions.inOutElastic, 900)
			a1Tile:add()
			a2Tile:add()
			a3Tile:add()
			a4Tile:add()
			a5Tile:add()
			a6Tile:add()
			a7Tile:add()
			a8Tile:add()
			a9Tile:add()
			b1Animator = gfx.animator.new(2000,300, b1y, pd.easingFunctions.inOutElastic, 100)
			b2Animator = gfx.animator.new(2000,300, b2y, pd.easingFunctions.inOutElastic, 200)
			b3Animator = gfx.animator.new(2000,300, b3y, pd.easingFunctions.inOutElastic, 300)
			b4Animator = gfx.animator.new(2000,300, b4y, pd.easingFunctions.inOutElastic, 400)
			b5Animator = gfx.animator.new(2000,300, b5y, pd.easingFunctions.inOutElastic, 500)
			b6Animator = gfx.animator.new(2000,300, b6y, pd.easingFunctions.inOutElastic, 600)
			b7Animator = gfx.animator.new(2000,300, b7y, pd.easingFunctions.inOutElastic, 700)
			b8Animator = gfx.animator.new(2000,300, b8y, pd.easingFunctions.inOutElastic, 800)
			b9Animator = gfx.animator.new(2000,300, b9y, pd.easingFunctions.inOutElastic, 900)
			b1Tile:add()
			b2Tile:add()
			b3Tile:add()
			b4Tile:add()
			b5Tile:add()
			b6Tile:add()
			b7Tile:add()
			b8Tile:add()
			b9Tile:add()
			c1Animator = gfx.animator.new(3000,300, c1y, pd.easingFunctions.inOutElastic, 100)
			c2Animator = gfx.animator.new(3000,300, c2y, pd.easingFunctions.inOutElastic, 200)
			c3Animator = gfx.animator.new(3000,300, c3y, pd.easingFunctions.inOutElastic, 300)
			c4Animator = gfx.animator.new(3000,300, c4y, pd.easingFunctions.inOutElastic, 400)
			c5Animator = gfx.animator.new(3000,300, c5y, pd.easingFunctions.inOutElastic, 500)
			c6Animator = gfx.animator.new(3000,300, c6y, pd.easingFunctions.inOutElastic, 600)
			c7Animator = gfx.animator.new(3000,300, c7y, pd.easingFunctions.inOutElastic, 700)
			c8Animator = gfx.animator.new(3000,300, c8y, pd.easingFunctions.inOutElastic, 800)
			c9Animator = gfx.animator.new(3000,300, c9y, pd.easingFunctions.inOutElastic, 900)
			c1Tile:add()
			c2Tile:add()
			c3Tile:add()
			c4Tile:add()
			c5Tile:add()
			c6Tile:add()
			c7Tile:add()
			c8Tile:add()
			c9Tile:add()
		end
		scoreSprite:add()
		
	end
end

local function tileFly()
	if gameFlavor == classic then
		local enterA1 = a1Animator:currentValue()
		local enterA2 = a2Animator:currentValue()
		local enterA3 = a3Animator:currentValue()
		local enterA4 = a4Animator:currentValue()
		local enterA5 = a5Animator:currentValue()
		local enterA6 = a6Animator:currentValue()
		local enterA7 = a7Animator:currentValue()
		local enterA8 = a8Animator:currentValue()
		local enterA9 = a9Animator:currentValue()
		a1Tile:moveTo(a1x, enterA1)
		a2Tile:moveTo(a2x, enterA2)
		a3Tile:moveTo(a3x, enterA3)
		a4Tile:moveTo(a4x, enterA4)
		a5Tile:moveTo(a5x, enterA5)
		a6Tile:moveTo(a6x, enterA6)
		a7Tile:moveTo(a7x, enterA7)
		a8Tile:moveTo(a8x, enterA8)
		a9Tile:moveTo(a9x, enterA9)
		if a9Animator:ended() then
			gamePhase = rollPhase
		end
	end
	if gameFlavor == double then
		local enterA1 = a1Animator:currentValue()
		local enterA2 = a2Animator:currentValue()
		local enterA3 = a3Animator:currentValue()
		local enterA4 = a4Animator:currentValue()
		local enterA5 = a5Animator:currentValue()
		local enterA6 = a6Animator:currentValue()
		local enterA7 = a7Animator:currentValue()
		local enterA8 = a8Animator:currentValue()
		local enterA9 = a9Animator:currentValue()

		local enterB1 = b1Animator:currentValue()
		local enterB2 = b2Animator:currentValue()
		local enterB3 = b3Animator:currentValue()
		local enterB4 = b4Animator:currentValue()
		local enterB5 = b5Animator:currentValue()
		local enterB6 = b6Animator:currentValue()
		local enterB7 = b7Animator:currentValue()
		local enterB8 = b8Animator:currentValue()
		local enterB9 = b9Animator:currentValue()

		a1Tile:moveTo(a1x, enterA1)
		a2Tile:moveTo(a2x, enterA2)
		a3Tile:moveTo(a3x, enterA3)
		a4Tile:moveTo(a4x, enterA4)
		a5Tile:moveTo(a5x, enterA5)
		a6Tile:moveTo(a6x, enterA6)
		a7Tile:moveTo(a7x, enterA7)
		a8Tile:moveTo(a8x, enterA8)
		a9Tile:moveTo(a9x, enterA9)

		b1Tile:moveTo(b1x, enterB1)
		b2Tile:moveTo(b2x, enterB2)
		b3Tile:moveTo(b3x, enterB3)
		b4Tile:moveTo(b4x, enterB4)
		b5Tile:moveTo(b5x, enterB5)
		b6Tile:moveTo(b6x, enterB6)
		b7Tile:moveTo(b7x, enterB7)
		b8Tile:moveTo(b8x, enterB8)
		b9Tile:moveTo(b9x, enterB9)

		if b9Animator:ended() then
			gamePhase = rollPhase
		end
	end

	if gameFlavor == triple then
		local enterA1 = a1Animator:currentValue()
		local enterA2 = a2Animator:currentValue()
		local enterA3 = a3Animator:currentValue()
		local enterA4 = a4Animator:currentValue()
		local enterA5 = a5Animator:currentValue()
		local enterA6 = a6Animator:currentValue()
		local enterA7 = a7Animator:currentValue()
		local enterA8 = a8Animator:currentValue()
		local enterA9 = a9Animator:currentValue()

		local enterB1 = b1Animator:currentValue()
		local enterB2 = b2Animator:currentValue()
		local enterB3 = b3Animator:currentValue()
		local enterB4 = b4Animator:currentValue()
		local enterB5 = b5Animator:currentValue()
		local enterB6 = b6Animator:currentValue()
		local enterB7 = b7Animator:currentValue()
		local enterB8 = b8Animator:currentValue()
		local enterB9 = b9Animator:currentValue()

		local enterC1 = c1Animator:currentValue()
		local enterC2 = c2Animator:currentValue()
		local enterC3 = c3Animator:currentValue()
		local enterC4 = c4Animator:currentValue()
		local enterC5 = c5Animator:currentValue()
		local enterC6 = c6Animator:currentValue()
		local enterC7 = c7Animator:currentValue()
		local enterC8 = c8Animator:currentValue()
		local enterC9 = c9Animator:currentValue()

		a1Tile:moveTo(a1x, enterA1)
		a2Tile:moveTo(a2x, enterA2)
		a3Tile:moveTo(a3x, enterA3)
		a4Tile:moveTo(a4x, enterA4)
		a5Tile:moveTo(a5x, enterA5)
		a6Tile:moveTo(a6x, enterA6)
		a7Tile:moveTo(a7x, enterA7)
		a8Tile:moveTo(a8x, enterA8)
		a9Tile:moveTo(a9x, enterA9)

		b1Tile:moveTo(b1x, enterB1)
		b2Tile:moveTo(b2x, enterB2)
		b3Tile:moveTo(b3x, enterB3)
		b4Tile:moveTo(b4x, enterB4)
		b5Tile:moveTo(b5x, enterB5)
		b6Tile:moveTo(b6x, enterB6)
		b7Tile:moveTo(b7x, enterB7)
		b8Tile:moveTo(b8x, enterB8)
		b9Tile:moveTo(b9x, enterB9)

		c1Tile:moveTo(c1x, enterC1)
		c2Tile:moveTo(c2x, enterC2)
		c3Tile:moveTo(c3x, enterC3)
		c4Tile:moveTo(c4x, enterC4)
		c5Tile:moveTo(c5x, enterC5)
		c6Tile:moveTo(c6x, enterC6)
		c7Tile:moveTo(c7x, enterC7)
		c8Tile:moveTo(c8x, enterC8)
		c9Tile:moveTo(c9x, enterC9)

		if c9Animator:ended() then
			gamePhase = rollPhase
		end
	end
end

function dieAssign(dieValue)
	
	if dieValue == 1 then
		return die1
	elseif dieValue == 2 then
		return die2
	elseif dieValue == 3 then
		return die3
	elseif dieValue == 4 then
		return die4
	elseif dieValue == 5 then
		return die5
	elseif dieValue == 6 then
		return die6
	end
end

function diceRoll()
	die1Value = math.random(6)
	die2Value = math.random(6)
	firstDie = gfx.getImage(dieAssign(die1Value))
	secondDie = dieAssign(die2Value)
	
	firstDie:moveTo(firstDieX, firstDieY)
	secondDie:moveTo(secondDieX, secondDieY)
	firstDie:add()
	secondDie:add()
		
	gamePhase = waitPhase
		
	end
	
--[[ local function diceRoll()
	
	die1Value = math.random(6)
	die2Value = math.random(6)
	
	
	if die1Value == 1 then
		firstDie = die1
	elseif die1Value == 2 then
		firstDie = die2
	elseif die1Value == 3 then
		firstDie = die3
	elseif die1Value == 4 then
		firstDie = die4
	elseif die1Value == 5 then
		firstDie = die5
	elseif die1Value == 6 then
		firstDie = die6
	end
	
	if die2Value == 1 then
		secondDie = dieTwo1
	elseif die2Value == 2 then
		secondDie = dieTwo2
	elseif die2Value == 3 then
		secondDie = dieTwo3
	elseif die2Value == 4 then
		secondDie = dieTwo4
	elseif die2Value == 5 then
		secondDie = dieTwo5
	elseif die2Value == 6 then
		secondDie = dieTwo6
	end

	firstDie:moveTo(firstDieX, firstDieY)
	secondDie:moveTo(secondDieX, secondDieY)
	firstDie:add()
	secondDie:add()
	
	gamePhase = waitPhase
	
end
]]

local function wait()
	if pd.buttonJustPressed(pd.kButtonA) then
		gamePhase = rollPhase
	end
end

local function clearDice()
	
	if die1Value > 0 then firstDie:remove()
	end
	
	if die2Value > 0 then secondDie:remove()
	end
	--secondDie:remove()
end

local function debug()
	
	local blankImage = gfx.image.new("images/blank")
		blank = gfx.sprite.new(blankImage)
		blank:moveTo(50,200)
	
	blank:add()
	
	gfx.drawText("FirstDieX=" .. math.ceil(firstDieX), 0, 120)
	gfx.drawText("FirstDieY=" .. math.ceil(firstDieY), 0, 140)
	gfx.drawText("SecDieX=" .. math.ceil(secondDieX), 0, 160)
	gfx.drawText("SecDieY=" .. math.ceil(secondDieY), 0, 180)
	gfx.drawText("Die1=" .. math.ceil(die1Value), 0, 200)
	gfx.drawText("Die2=" .. math.ceil(die2Value), 0, 220)

end

local function initialize()
--initialize gamescreen.  Adds all sprites, backgrounds, to default locations


local a1Image = gfx.image.new("images/a1")
	a1Tile = gfx.sprite.new(a1Image)
	a1Tile:moveTo(500,500)
	
local a2Image = gfx.image.new("images/a2")
	a2Tile = gfx.sprite.new(a2Image)
	a2Tile:moveTo(500,500)
	
local a3Image = gfx.image.new("images/a3")
	a3Tile = gfx.sprite.new(a3Image)
	a3Tile:moveTo(500,500)
	
local a4Image = gfx.image.new("images/a4")
	a4Tile = gfx.sprite.new(a4Image)
	a4Tile:moveTo(500,500)
	
local a5Image = gfx.image.new("images/a5")
	a5Tile = gfx.sprite.new(a5Image)
	a5Tile:moveTo(500,500)
	
local a6Image = gfx.image.new("images/a6")
	a6Tile = gfx.sprite.new(a6Image)
	a6Tile:moveTo(500,500)
	
local a7Image = gfx.image.new("images/a7")
	a7Tile = gfx.sprite.new(a7Image)
	a7Tile:moveTo(500,500)
	
local a8Image = gfx.image.new("images/a8")
	a8Tile = gfx.sprite.new(a8Image)
	a8Tile:moveTo(500,500)
	
local a9Image = gfx.image.new("images/a9")
	a9Tile = gfx.sprite.new(a9Image)
	a9Tile:moveTo(500,500)

local b1Image = gfx.image.new("images/b1")
	b1Tile = gfx.sprite.new(b1Image)
	b1Tile:moveTo(500,500)
	
local b2Image = gfx.image.new("images/b2")
	b2Tile = gfx.sprite.new(b2Image)
	b2Tile:moveTo(500,500)
	
local b3Image = gfx.image.new("images/b3")
	b3Tile = gfx.sprite.new(b3Image)
	b3Tile:moveTo(500,500)
	
local b4Image = gfx.image.new("images/b4")
	b4Tile = gfx.sprite.new(b4Image)
	b4Tile:moveTo(500,500)
	
local b5Image = gfx.image.new("images/b5")
	b5Tile = gfx.sprite.new(b5Image)
	b5Tile:moveTo(500,500)
	
local b6Image = gfx.image.new("images/b6")
	b6Tile = gfx.sprite.new(b6Image)
	b6Tile:moveTo(500,500)
	
local b7Image = gfx.image.new("images/b7")
	b7Tile = gfx.sprite.new(b7Image)
	b7Tile:moveTo(500,500)
	
local b8Image = gfx.image.new("images/b8")
	b8Tile = gfx.sprite.new(b8Image)
	b8Tile:moveTo(500,500)
	
local b9Image = gfx.image.new("images/b9")
	b9Tile = gfx.sprite.new(b9Image)
	b9Tile:moveTo(500,500)

local c1Image = gfx.image.new("images/c1")
	c1Tile = gfx.sprite.new(c1Image)
	c1Tile:moveTo(500,500)
	
local c2Image = gfx.image.new("images/c2")
	c2Tile = gfx.sprite.new(c2Image)
	c2Tile:moveTo(500,500)
	
local c3Image = gfx.image.new("images/c3")
	c3Tile = gfx.sprite.new(c3Image)
	c3Tile:moveTo(500,500)
	
local c4Image = gfx.image.new("images/c4")
	c4Tile = gfx.sprite.new(c4Image)
	c4Tile:moveTo(500,500)
	
local c5Image = gfx.image.new("images/c5")
	c5Tile = gfx.sprite.new(c5Image)
	c5Tile:moveTo(500,500)
	
local c6Image = gfx.image.new("images/c6")
	c6Tile = gfx.sprite.new(c6Image)
	c6Tile:moveTo(500,500)
	
local c7Image = gfx.image.new("images/c7")
	c7Tile = gfx.sprite.new(c7Image)
	c7Tile:moveTo(500,500)
	
local c8Image = gfx.image.new("images/c8")
	c8Tile = gfx.sprite.new(c8Image)
	c8Tile:moveTo(500,500)
	
local c9Image = gfx.image.new("images/c9")
	c9Tile = gfx.sprite.new(c9Image)
	c9Tile:moveTo(500,500)

local die1Image = gfx.image.new("images/die1")
	die1 = gfx.sprite.new(die1Image)
	
local die2Image = gfx.image.new("images/die2")
	die2 = gfx.sprite.new(die2Image)

local die3Image = gfx.image.new("images/die3")
	die3 = gfx.sprite.new(die3Image)
	
local die4Image = gfx.image.new("images/die4")
	die4 = gfx.sprite.new(die4Image)

local die5Image = gfx.image.new("images/die5")
	die5 = gfx.sprite.new(die5Image)
	
local die6Image = gfx.image.new("images/die6")
	die6 = gfx.sprite.new(die6Image)
	
local die1Image = gfx.image.new("images/die1")
	dieTwo1 = gfx.sprite.new(die1Image)
		
local die2Image = gfx.image.new("images/die2")
	dieTwo2 = gfx.sprite.new(die2Image)
	
local die3Image = gfx.image.new("images/die3")
	dieTwo3 = gfx.sprite.new(die3Image)
		
local die4Image = gfx.image.new("images/die4")
	dieTwo4 = gfx.sprite.new(die4Image)
	
local die5Image = gfx.image.new("images/die5")
	dieTwo5 = gfx.sprite.new(die5Image)
		
local die6Image = gfx.image.new("images/die6")
	dieTwo6 = gfx.sprite.new(die6Image)

local classicImage = gfx.image.new("images/classic")
	classicSprite = gfx.sprite.new(classicImage)
	classicSprite:moveTo(badgeXcord, badgeYcord)	

local doubleImage = gfx.image.new("images/double")
	doubleSprite = gfx.sprite.new(doubleImage)
	doubleSprite:moveTo(badgeXcord, badgeYcord)	

local tripleImage = gfx.image.new("images/triple")
	tripleSprite = gfx.sprite.new(tripleImage)
	tripleSprite:moveTo(badgeXcord, badgeYcord)	

local flavorImage = gfx.image.new("images/flavorCard")
	flavorCard = gfx.sprite.new(flavorImage)

local selectorImage = gfx.image.new("images/selector")
	selectorSprite = gfx.sprite.new(selectorImage)

local instructionImage = gfx.image.new("images/instructionCard")
	instructionCard = gfx.sprite.new(instructionImage)
		
local titleImage = gfx.image.new("images/titleCard")
	titleCard = gfx.sprite.new(titleImage)

local classicImage = gfx.image.new("images/classic")
	classicSprite = gfx.sprite.new(classicImage)
	classicSprite:moveTo(badgeXcord, badgeYcord)
	
local scoreImage = gfx.image.new("images/score")
	scoreSprite = gfx.sprite.new(scoreImage)
	scoreSprite:moveTo(290, 200)	
	
	local backgroundImage = gfx.image.new("images/background")
	 gfx.sprite.setBackgroundDrawingCallback(
		function (x, y, width, height)
			gfx.setClipRect(x,y,width,height)
			backgroundImage:draw(0,0)
			gfx.clearClipRect()
		end
	)
	
gamePhase = showTitlePhase
gameFlavor = classic

end

initialize()

function pd.update()
	if gamePhase == showTitlePhase then
		showTitleCard()	
	elseif gamePhase == parkTitlePhase then
		parkTitleCard()
	elseif gamePhase == instructionsPhase then
		showInstructionCard()
	elseif gamePhase == instructionsParkPhase then
		parkInstructionCard()
	elseif gamePhase == flavorPhase then
		showFlavorCard()
	elseif gamePhase == flavorParkPhase then
		parkFlavorCard()
	elseif gamePhase == tileFlyPhase then
		tileFly()
	elseif gamePhase == rollPhase then
		clearDice()
		diceRoll()
	elseif gamePhase == waitPhase then
		wait()
	end
	gfx.sprite.update()
--	debug()
end



