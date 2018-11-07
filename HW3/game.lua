-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

local stageNumber = 1
local numberOfStages = 10
local itemToFindIndex = 0

local stageItemNumbers = {}
local verticalTransformations = {}
local stageItems = {}

local function getRandomNumber(min, max)
	local number = math.random(min, max)
	--print("Random number: "..number)
	return number
end

local function getRandomNumberWithExclusions(min, max, exclusions)
	local number = getRandomNumber(min, max)

	for _, listItem in pairs(exclusions) do
      	if listItem == number then
      		-- Recursively call this function until a random number 
      		-- is generated that is not contained in the exclusions list
        	return getRandomNumberWithExclusions(min, max, exclusions)
      	end
    end
	return number
end

function buttonPressHandler(event)
	local sceneTransitionOptions = {
		effect = "slideUp",
		time = 500
		--,
		--params = {
		--	speed = ballSpeed
		--}
	}

	composer.gotoScene("game", sceneTransitionOptions)
end

function getImage(sheet, index, x, y)
	local item = display.newImage(sheet, index, x, y + verticalTransformations[index])

	if index >= 19 then
		item.xScale = -1
	end

	return item
end

function scene:create( event )
	local sceneGroup = self.view

	-- set up the table containing the number of items in the house for each level
	for stage = 1, numberOfStages do
		if (stage <= 3) then			
			stageItemNumbers[stage] = getRandomNumber(3, 5)
		elseif (stage <= 6) then
			stageItemNumbers[stage] = getRandomNumber(6, 8)
		elseif (stage <= 10) then
			stageItemNumbers[stage] = getRandomNumber(9, 15)
		end
	end

	-- set up the image sheet coordinates 
	local options =
	{
		frames =
		{
			{ x = 550, y = 0, width = 260, height = 200 },  -- 1 - House 1 Background
			{ x = 810, y = 0, width = 260, height = 200 },  -- 2 - House 2 Background
			{ x = 1068, y = 0, width = 260, height = 200 }, -- 3 - Red Square Background
			{ x = 368, y = 8, width = 41, height = 41 },  -- 4 - Green Circle
			{ x = 413, y = 10, width = 35, height = 35 },  -- 5 - Red X
			{ x = 148, y = 22, width = 41, height = 38 },  -- 6 - Bird 1
			{ x = 191, y = 22, width = 39, height = 36 },  -- 7 - Bird 2
			{ x = 379, y = 122, width = 17, height = 41 },  -- 8 - Bottle 1
			{ x = 403, y = 122, width = 17, height = 41 },  -- 9 - Bottle 2
			{ x = 429, y = 115, width = 36, height = 21 },  -- 10 - Hat 1
			{ x = 429, y = 137, width = 36, height = 21 },  -- 11 - Hat 2
			{ x = 429, y = 159, width = 36, height = 21 },  -- 12 - Hat 3
			{ x = 473, y = 111, width = 24, height = 24 },  -- 13 - Cup 1
			{ x = 473, y = 136, width = 24, height = 23 },  -- 14 - Cup 2
			{ x = 473, y = 160, width = 24, height = 23 },  -- 15 - Cup 3
			{ x = 511, y = 93, width = 22, height = 31 },  -- 16 - Pot 1
			{ x = 512, y = 125, width = 22, height = 32 },  -- 17 - Pot 2
			{ x = 510, y = 158, width = 22, height = 32 },  -- 18 - Pot 3
			-- Note that the reversed frames are not actually reversed, logic in the getImage function
			-- will reverse them when creating the image.
			-- Bottle 1 reverse would be the same thing
			{ x = 403, y = 122, width = 17, height = 41 },  -- 19 - Bottle 2 Reverse
			{ x = 429, y = 115, width = 36, height = 21 },  -- 20 - Hat 1 Reverse
			{ x = 429, y = 137, width = 36, height = 21 },  -- 21 - Hat 2 Reverse
			{ x = 429, y = 159, width = 36, height = 21 },  -- 22 - Hat 3 Reverse
			{ x = 473, y = 111, width = 24, height = 24 },  -- 23 - Cup 1 Reverse
			{ x = 473, y = 136, width = 24, height = 23 },  -- 24 - Cup 2 Reverse
			{ x = 473, y = 160, width = 24, height = 23 },  -- 25 - Cup 3 Reverse
			{ x = 511, y = 93, width = 22, height = 31 },  -- 26 - Pot 1 Reverse
			{ x = 512, y = 125, width = 22, height = 32 },  -- 27 - Pot 2 Reverse
			{ x = 510, y = 158, width = 22, height = 32 },  -- 28 - Pot 3 Reverse
		}
	}
	
	-- initialize the image sheet
	sheet = graphics.newImageSheet("marioware.png", options)

	-- set up tranformation values so items appear consistently where we want them to in the house
	verticalTransformations[8] = -10
	verticalTransformations[9] = -10
	verticalTransformations[10] = 0
	verticalTransformations[11] = 0
	verticalTransformations[12] = 0
	verticalTransformations[13] = -2
	verticalTransformations[14] = -2
	verticalTransformations[15] = -2
	verticalTransformations[16] = -6
	verticalTransformations[17] = -6
	verticalTransformations[18] = -6
	verticalTransformations[19] = 10
	verticalTransformations[20] = 0
	verticalTransformations[21] = 0
	verticalTransformations[22] = 0
	verticalTransformations[23] = -2
	verticalTransformations[24] = -2
	verticalTransformations[25] = -2
	verticalTransformations[26] = -6
	verticalTransformations[27] = -6
	verticalTransformations[28] = -6

	-- setup the scene background images and text blocks
	-- TODO: Possibly investigate scaling based on screen size
	local topBackground = display.newImage(sheet, 3, display.contentCenterX, 100)

	stageText = display.newText("Stage "..stageNumber, display.contentCenterX, 30, native.systemFont, 24)
	stageText:setFillColor(0, 0, 0)

	houseBackground = display.newImage(sheet, 1, display.contentCenterX, 290)

	local findText = display.newText("Find!", display.contentCenterX, 130, native.systemFont, 18)
	findText:setFillColor(0, 0, 0)

	local progressBarRect = display.newRect(display.contentCenterX, 400, 255, 20)
	progressBarRect.strokeWidth = 2
	progressBarRect:setStrokeColor(1, 1, 0)
	progressBarRect:setFillColor(0, 0, 0)

	sceneGroup:insert(topBackground)
	sceneGroup:insert(stageText)
	sceneGroup:insert(houseBackground)
	sceneGroup:insert(findText)
	sceneGroup:insert(progressBarRect)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Rendomly get an index for an item that use player needs to find
		itemToFindIndex = getRandomNumber(8, 28)

		-- display the image in the top section
		itemToFind = getImage(sheet, itemToFindIndex, display.contentCenterX, 100)

		sceneGroup:insert(itemToFind)

		-- initialize the list of items in the house to find the item from
		itemsInHouse = {}

		-- include the randomly selected item to find in the list
		itemsInHouse[1] = itemToFindIndex

		-- TODO: Get the number of items in the house depending on the current stage
		local numberOfItemsInHouse = stageItemNumbers[stageNumber]

		-- Get a random index for an image that will be placed in the house
		for i = 2, numberOfItemsInHouse do
			itemsInHouse[i] = getRandomNumberWithExclusions(8, 18, itemsInHouse)
		end

		-- Swap the first item in the list with a randomly selected item in the list
		-- This prevents to item to select from always appearing in the same position
		local swapIndex = getRandomNumber(1, numberOfItemsInHouse)
		local tempItem = itemsInHouse[swapIndex]
		itemsInHouse[swapIndex] = itemsInHouse[1]
		itemsInHouse[1] = tempItem

		-- DEBUG: Print the contents of the list of items in the house
		for _, v in pairs(itemsInHouse) do
      		print("Item In House Index: "..v)
      	end

      	-- TODO: Add touch event listeners to the items
      	-- TODO: Create other stages
		if (stageNumber == 1) then	
      		local item1 = getImage(sheet, itemsInHouse[1], 240, 283)
			sceneGroup:insert(item1)

			local item2 = getImage(sheet, itemsInHouse[2], 240, 348)
			sceneGroup:insert(item2)

			local item3 = getImage(sheet, itemsInHouse[3], 130, 290)
			sceneGroup:insert(item3)

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[4] ~= nil then
				local item4 = getImage(sheet, itemsInHouse[4], 100, 290)
				sceneGroup:insert(item4)
			end

			if itemsInHouse[5] ~= nil then
				local item5 = getImage(sheet, itemsInHouse[5], 240, 219)
				sceneGroup:insert(item5)
			end
		elseif (stageNumber == 2) then
		elseif (stageNumber == 3) then
		elseif (stageNumber == 4) then
		elseif (stageNumber == 5) then
		elseif (stageNumber == 6) then
		elseif (stageNumber == 7) then
		elseif (stageNumber == 8) then
		elseif (stageNumber == 9) then
		elseif (stageNumber == 10) then
      	end

	elseif ( phase == "did" ) then
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
