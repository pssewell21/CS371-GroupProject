-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

local stageNumber = 0
local numberOfStages = 10
local itemToFindIndex = 0

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

function scene:create( event )
	local sceneGroup = self.view

	-- set up the table containing the number of items in the house for each level
	local stageItemNumbers = {}

	for stage = 1, numberOfStages do
		if (stage <= 3) then			
			stageItemNumbers[stage] = getRandomNumber(3, 5)
		elseif (stage <= 6) then
			stageItemNumbers[stage] = getRandomNumber(6, 8)
		elseif (stage <= 10) then
			stageItemNumbers[stage] = getRandomNumber(9, 15)
		end
	end

	-- TODO: Add mirrored images
	-- set up the image sheet coordinates for animations 
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
			{ x = 473, y = 111, width = 24, height = 25 },  -- 13 - Cup 1
			{ x = 473, y = 136, width = 24, height = 23 },  -- 14 - Cup 2
			{ x = 473, y = 160, width = 24, height = 23 },  -- 15 - Cup 3
			{ x = 511, y = 93, width = 22, height = 31 },  -- 16 - Pot 1
			{ x = 512, y = 125, width = 22, height = 32 },  -- 17 - Pot 2
			{ x = 510, y = 158, width = 22, height = 32 },  -- 18 - Pot 3
		}
	}
	
	-- initialize the image sheet
	sheet = graphics.newImageSheet("marioware.png", options)

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
		itemToFindIndex = getRandomNumber(8, 18)

		-- display the image in the top section
		itemToFind = display.newImage(sheet, itemToFindIndex, display.contentCenterX, 90)
		sceneGroup:insert(itemToFind)

		-- initialize the list of items in the house to find the item from
		itemsInHouse = {}

		-- TODO: Make the item to select appear in a random position in the list instead of always first
		-- include the randomly selected item to find in the list
		itemsInHouse[1] = itemToFindIndex

		-- TODO: Get the number of items in the house depending on the current stage
		local numberOfItemsInHouse = 3

		-- Get a random index for an image that will be placed in the house
		for i = 2, numberOfItemsInHouse do
			itemsInHouse[i] = getRandomNumberWithExclusions(8, 18, itemsInHouse)
		end

		-- DEBUG: Print the contents of the list of items in the house
		for _, v in pairs(itemsInHouse) do
      		print("Item In House Index: "..v)
      	end

      	-- TODO: Make sprites sizes a bit more consistent in size to make vertical placement in the house more consistent
      	--       Could also add corections to y position depending on index of the item on the image sheet and type of image it is
      	-- TODO: Add touch event listeners to the items
      	-- TODO: Create other stages
      	-- TODO: Update to not use scene 0 after proper stage logic is implemented
      	if (stageNumber == 0) then
      		local item1 = display.newImage(sheet, itemsInHouse[1], 240, 275)
			sceneGroup:insert(item1)
			local item2 = display.newImage(sheet, itemsInHouse[2], 240, 345)
			sceneGroup:insert(item1)
			local item3 = display.newImage(sheet, itemsInHouse[3], 130, 290)
			sceneGroup:insert(item1)
		elseif (stageNumber == 1) then
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


