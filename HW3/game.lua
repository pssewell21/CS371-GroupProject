-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local widget = require( "widget" )
local physics = require ("physics") -- AA
local scene = composer.newScene()

local stageNumber = 1
local numberOfStages = 10

local itemToFindIndex = 0

local stageItemNumbers = {}
local verticalTransformations = {}
local itemsToRemove = {}

local imageSheet

local touchEnabled = true

local winImage
local loseImage
local continueButton

local decrementLife = false
local gameMessage

local function getRandomNumber(min, max)
	local number = math.random(min, max)
	--print("Random number: "..number)
	return number
end

local function gotoIntermediate()
     local sceneTransitionOptions = {
        effect = "slideDown",
        time = 500,
        params = { heart = lives, s = stage }
    }

    composer.gotoScene( "intermediateScene", sceneTransitionOptions )
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
-- Function to handle button events
local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
    print( "Button was pressed and released" )
    end
end

function buttonPressHandler(event)
	local sceneTransitionOptions = {
		effect = "slideDown",
		time = 500,
		params = {
			decrementLife = decrementLife,
			gameMessage = gameMessage
		}
	}

	composer.gotoScene("intermediateScene", sceneTransitionOptions)
end

function itemTouchHandler(event)
	if touchEnabled == true then
		if itemToFindIndex == event.target.index then
			print("Found the correct item")

			winImage.x = event.target.x
			winImage.y = event.target.y
			winImage.isVisible = true

			local soundEffect = audio.loadSound("win.wav") 
			audio.play(soundEffect)

			decrementLife = false			
			gameMessage = "Correct item selected!"
			timer.performWithDelay(800, function()gotoIntermediate() end, 1)
			touchEnabled = false

		else
			print("Did not find the correct item")

			loseImage.x = event.target.x
			loseImage.y = event.target.y
			loseImage.isVisible = true

			local soundEffect = audio.loadSound("lose.wav") 
			audio.play(soundEffect)

			decrementLife = true
			gameMessage = "Incorrect item selected"
			timer.performWithDelay(800, function()gotoIntermediate() end, 1)
			touchEnabled = false
		end

		continueButton.isVisible = true
	end
end

function getImage(index, x, y, touchEnabled)
	local item = display.newImage(imageSheet, index, x, y + verticalTransformations[index])
	item.index = index
	if touchEnabled == true then
		item:addEventListener("tap", itemTouchHandler)
	end

	if index >= 19 then
		item.xScale = -1
	end

	return item
end
-- ---------------------------------------------------------
-- This function stops the bird once it has been tapped on  -- AA
-- ---------------------------------------------------------
local function stopBird(event)
    event.target:pause()
    physics.pause()
    timer.performWithDelay(800, function() physics.start() end, 1)
    event.target:play()
end
-- ---------------------------------------------------------
-- This function will turn the bird around when it hits a wall -- AA
-- ---------------------------------------------------------
local function onLocalCollision( self, event )
    if ( event.phase == "began" ) then
    elseif ( event.phase == "ended" ) then
        if (event.other.myName == "left")then
            self.xScale = 1;
        elseif (event.other.myName == "right")then
            self.xScale = -1;
        end
    end
end
-- ---------------------------------------------------------
-- This will control the movement of the progress bar -- AA
-- ---------------------------------------------------------
local function mov_progressBar(event)
    p = progressBarRect.getProgress();
    p = p + 1 / 8
    if (p == 1)then
        lives = lives - 1
        stage = stage + 1
        gotoIntermediate()
    else
        progressBarRect:setProgress(p)
    end
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
	imageSheet = graphics.newImageSheet("marioware.png", options)

	seqData = 
    {
        {name = "flying", start = 6, count = 2, time = 200}
    }

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
	verticalTransformations[19] = -10
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
	local topBackground = display.newImage(imageSheet, 3, display.contentCenterX, 115)
	topBackground.xScale = 1.25
	topBackground.yScale = 1.25

	stageText = display.newText("Stage "..stageNumber, display.contentCenterX, 30, native.systemFont, 24)
	stageText:setFillColor(0, 0, 0)

	houseBackground = display.newImage(imageSheet, 1, display.contentCenterX, 355)
	houseBackground.xScale = 1.25
	houseBackground.yScale = 1.25

	local findText = display.newText("Find!", display.contentCenterX, 130, native.systemFont, 18)
	findText:setFillColor(0, 0, 0)

   -- -----------------------------------
   -- This is making the progress bar -- AA
   -- -----------------------------------
    progressBarRect = widget.newProgressView(
        {
            left = display.contentCenterX - 160, 
            top = display.contentCenterY + 238, 
            width = 320
            --isAnimated = true
        }
    )

	continueButton = widget.newButton(
    {
        label = "continueButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 100,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={255,255,0}, over={255,255,0} },
        strokeColor = { default={0,0,0}, over={0,0,0} },
        strokeWidth = 5
    })
	
	-- Center the button
	continueButton.x = display.contentCenterX
	continueButton.y = display.contentCenterY - 70
			 
	-- Change the button's label text
	continueButton:setLabel("CONTINUE")
	continueButton:addEventListener("tap", buttonPressHandler)
	continueButton.isVisible = false

	sceneGroup:insert(topBackground)
	sceneGroup:insert(stageText)
	sceneGroup:insert(houseBackground)
	sceneGroup:insert(findText)
	sceneGroup:insert(progressBarRect)
	sceneGroup:insert(continueButton)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

		local params = event.params

		if (params ~= nil and params.stage ~= nil) then
			stageNumber = params.stage
			stageText.text = "Stage "..stageNumber
		end

		-- Randomly get an index for an item that use player needs to find
		itemToFindIndex = getRandomNumber(8, 28)

		-- display the image in the top section
		itemToFind = getImage(itemToFindIndex, display.contentCenterX, 100, false)
		itemsToRemove[0] = itemToFind
		sceneGroup:insert(itemToFind)

		-- initialize the list of items in the house to find the item from
		itemsInHouse = {}

		-- include the randomly selected item to find in the list
		itemsInHouse[1] = itemToFindIndex

		local numberOfItemsInHouse = stageItemNumbers[stageNumber]

		-- Get a random index for an image that will be placed in the house
		for i = 2, numberOfItemsInHouse do
			itemsInHouse[i] = getRandomNumberWithExclusions(8, 28, itemsInHouse)
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

		if (stageNumber == 1) then	
      		local item1 = getImage(itemsInHouse[1], 260, 348, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 260, 430, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 356, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[4] ~= nil then
				local item4 = getImage(itemsInHouse[4], 100, 356, true)
				itemsToRemove[4] = item4
				sceneGroup:insert(item4)
			end

			if itemsInHouse[5] ~= nil then
				local item5 = getImage(itemsInHouse[5], 260, 308, true)
				itemsToRemove[5] = item5
				sceneGroup:insert(item5)
			end
		elseif (stageNumber == 2) then
			local item1 = getImage(itemsInHouse[1], 260, 348, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 260, 430, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 125, 358, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[4] ~= nil then
				local item4 = getImage(itemsInHouse[4], 90, 358, true)
				itemsToRemove[4] = item4
				sceneGroup:insert(item4)
			end

			if itemsInHouse[5] ~= nil then
				local item5 = getImage(itemsInHouse[5], 260, 308, true)
				itemsToRemove[5] = item5
				sceneGroup:insert(item5)
			end
		elseif (stageNumber == 3) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[4] ~= nil then
				local item4 = getImage(itemsInHouse[4], 100, 290, true)
				itemsToRemove[4] = item4
				sceneGroup:insert(item4)
			end

			if itemsInHouse[5] ~= nil then
				local item5 = getImage(itemsInHouse[5], 240, 219, true)
				itemsToRemove[5] = item5
				sceneGroup:insert(item5)
			end
		elseif (stageNumber == 4) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			
			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			

			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) --240, 219
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[6] ~= nil then
				local item6 = getImage(itemsInHouse[6], 270, 348, true)
				itemsToRemove[6] = item6
				sceneGroup:insert(item6)
			end

			if itemsInHouse[7] ~= nil then
				local item7 = getImage(itemsInHouse[7], 70, 290, true)
				itemsToRemove[7] = item7
				sceneGroup:insert(item7)
			end

			if itemsInHouse[8] ~= nil then
				local item8 = getImage(itemsInHouse[8], 260, 219, true)
				itemsToRemove[8] = item8
				sceneGroup:insert(item8)
			end

		elseif (stageNumber == 5) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			
			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			

			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) --240, 219
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[6] ~= nil then
				local item6 = getImage(itemsInHouse[6], 270, 348, true)
				itemsToRemove[6] = item6
				sceneGroup:insert(item6)
			end

			if itemsInHouse[7] ~= nil then
				local item7 = getImage(itemsInHouse[7], 70, 290, true)
				itemsToRemove[7] = item7
				sceneGroup:insert(item7)
			end

			if itemsInHouse[8] ~= nil then
				local item8 = getImage(itemsInHouse[8], 260, 219, true)
				itemsToRemove[8] = item8
				sceneGroup:insert(item8)
			end
		elseif (stageNumber == 6) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			
			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			

			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) --240, 219
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[6] ~= nil then
				local item6 = getImage(itemsInHouse[6], 270, 348, true)
				itemsToRemove[6] = item6
				sceneGroup:insert(item6)
			end

			if itemsInHouse[7] ~= nil then
				local item7 = getImage(itemsInHouse[7], 70, 290, true)
				itemsToRemove[7] = item7
				sceneGroup:insert(item7)
			end

			if itemsInHouse[8] ~= nil then
				local item8 = getImage(itemsInHouse[8], 260, 219, true)
				itemsToRemove[8] = item8
				sceneGroup:insert(item8)
			end
		elseif (stageNumber == 7) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) 
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			local item6 = getImage(itemsInHouse[6], 270, 348, true)
			itemsToRemove[6] = item6
			sceneGroup:insert(item6)

			local item7 = getImage(itemsInHouse[7], 70, 290, true)
			itemsToRemove[7] = item7
			sceneGroup:insert(item7)
			
			local item8 = getImage(itemsInHouse[8], 260, 219, true)
			itemsToRemove[8] = item8
			sceneGroup:insert(item8)
			

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[9] ~= nil then
				local item9 = getImage(itemsInHouse[9], 210, 375, true)
				itemsToRemove[9] = item9
				sceneGroup:insert(item9)
			end

			if itemsInHouse[10] ~= nil then
				local item10 = getImage(itemsInHouse[10], 30, 375, true)
				itemsToRemove[10] = item10
				sceneGroup:insert(item10)
			end

			if itemsInHouse[11] ~= nil then
				local item11 = getImage(itemsInHouse[11], 180, 375, true)
				itemsToRemove[11] = item11
				sceneGroup:insert(item11)
			end
			if itemsInHouse[12] ~= nil then
				local item12 = getImage(itemsInHouse[12], 60, 375, true)
				itemsToRemove[12] = item12
				sceneGroup:insert(item12)
			end

			if itemsInHouse[13] ~= nil then
				local item13 = getImage(itemsInHouse[13], 150, 375, true)
				itemsToRemove[13] = item13
				sceneGroup:insert(item13)
			end

			if itemsInHouse[14] ~= nil then
				local item14 = getImage(itemsInHouse[14], 90, 375, true)
				itemsToRemove[14] = item14
				sceneGroup:insert(item14)
			end

			if itemsInHouse[15] ~= nil then
				local item15 = getImage(itemsInHouse[15], 120, 375, true)
				itemsToRemove[15] = item15
				sceneGroup:insert(item15)
			end

		elseif (stageNumber == 8) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) 
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			local item6 = getImage(itemsInHouse[6], 270, 348, true)
			itemsToRemove[6] = item6
			sceneGroup:insert(item6)

			local item7 = getImage(itemsInHouse[7], 70, 290, true)
			itemsToRemove[7] = item7
			sceneGroup:insert(item7)
			
			local item8 = getImage(itemsInHouse[8], 260, 219, true)
			itemsToRemove[8] = item8
			sceneGroup:insert(item8)
			

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[9] ~= nil then
				local item9 = getImage(itemsInHouse[9], 210, 375, true)
				itemsToRemove[9] = item9
				sceneGroup:insert(item9)
			end

			if itemsInHouse[10] ~= nil then
				local item10 = getImage(itemsInHouse[10], 60, 257, true)
				itemsToRemove[10] = item10
				sceneGroup:insert(item10)
			end

			if itemsInHouse[11] ~= nil then
				local item11 = getImage(itemsInHouse[11], 180, 375, true)
				itemsToRemove[11] = item11
				sceneGroup:insert(item11)
			end
			if itemsInHouse[12] ~= nil then
				local item12 = getImage(itemsInHouse[12], 60, 375, true)
				itemsToRemove[12] = item12
				sceneGroup:insert(item12)
			end

			if itemsInHouse[13] ~= nil then
				local item13 = getImage(itemsInHouse[13], 150, 375, true)
				itemsToRemove[13] = item13
				sceneGroup:insert(item13)
			end

			if itemsInHouse[14] ~= nil then
				local item14 = getImage(itemsInHouse[14], 90, 375, true)
				itemsToRemove[14] = item14
				sceneGroup:insert(item14)
			end

			if itemsInHouse[15] ~= nil then
				local item15 = getImage(itemsInHouse[15], 120, 375, true)
				itemsToRemove[15] = item15
				sceneGroup:insert(item15)
			end
		elseif (stageNumber == 9) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) 
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			local item6 = getImage(itemsInHouse[6], 270, 348, true)
			itemsToRemove[6] = item6
			sceneGroup:insert(item6)

			local item7 = getImage(itemsInHouse[7], 70, 290, true)
			itemsToRemove[7] = item7
			sceneGroup:insert(item7)
			
			local item8 = getImage(itemsInHouse[8], 260, 219, true)
			itemsToRemove[8] = item8
			sceneGroup:insert(item8)
			

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[9] ~= nil then
				local item9 = getImage(itemsInHouse[9], 210, 375, true)
				itemsToRemove[9] = item9
				sceneGroup:insert(item9)
			end

			if itemsInHouse[10] ~= nil then
				local item10 = getImage(itemsInHouse[10], 60, 257, true)
				itemsToRemove[10] = item10
				sceneGroup:insert(item10)
			end

			if itemsInHouse[11] ~= nil then
				local item11 = getImage(itemsInHouse[11], 180, 375, true)
				itemsToRemove[11] = item11
				sceneGroup:insert(item11)
			end
			if itemsInHouse[12] ~= nil then
				local item12 = getImage(itemsInHouse[12], 60, 375, true)
				itemsToRemove[12] = item12
				sceneGroup:insert(item12)
			end

			if itemsInHouse[13] ~= nil then
				local item13 = getImage(itemsInHouse[13], 150, 375, true)
				itemsToRemove[13] = item13
				sceneGroup:insert(item13)
			end

			if itemsInHouse[14] ~= nil then
				local item14 = getImage(itemsInHouse[14], 90, 375, true)
				itemsToRemove[14] = item14
				sceneGroup:insert(item14)
			end

			if itemsInHouse[15] ~= nil then
				local item15 = getImage(itemsInHouse[15], 120, 375, true)
				itemsToRemove[15] = item15
				sceneGroup:insert(item15)
			end
		elseif (stageNumber == 10) then
			local item1 = getImage(itemsInHouse[1], 240, 283, true)
			itemsToRemove[1] = item1
			sceneGroup:insert(item1)

			local item2 = getImage(itemsInHouse[2], 240, 348, true)
			itemsToRemove[2] = item2
			sceneGroup:insert(item2)

			local item3 = getImage(itemsInHouse[3], 130, 290, true)
			itemsToRemove[3] = item3
			sceneGroup:insert(item3)

			local item4 = getImage(itemsInHouse[4], 100, 290, true)
			itemsToRemove[4] = item4
			sceneGroup:insert(item4)
			
			local item5 = getImage(itemsInHouse[5], 230, 219, true) 
			itemsToRemove[5] = item5
			sceneGroup:insert(item5)
			
			local item6 = getImage(itemsInHouse[6], 270, 348, true)
			itemsToRemove[6] = item6
			sceneGroup:insert(item6)

			local item7 = getImage(itemsInHouse[7], 70, 290, true)
			itemsToRemove[7] = item7
			sceneGroup:insert(item7)
			
			local item8 = getImage(itemsInHouse[8], 260, 219, true)
			itemsToRemove[8] = item8
			sceneGroup:insert(item8)
			

			-- Check for nil value before attempting to add the item to the view
			if itemsInHouse[9] ~= nil then
				local item9 = getImage(itemsInHouse[9], 210, 375, true)
				itemsToRemove[9] = item9
				sceneGroup:insert(item9)
			end

			if itemsInHouse[10] ~= nil then
				local item10 = getImage(itemsInHouse[10], 60, 257, true)
				itemsToRemove[10] = item10
				sceneGroup:insert(item10)
			end

			if itemsInHouse[11] ~= nil then
				local item11 = getImage(itemsInHouse[11], 180, 375, true)
				itemsToRemove[11] = item11
				sceneGroup:insert(item11)
			end
			if itemsInHouse[12] ~= nil then
				local item12 = getImage(itemsInHouse[12], 60, 375, true)
				itemsToRemove[12] = item12
				sceneGroup:insert(item12)
			end

			if itemsInHouse[13] ~= nil then
				local item13 = getImage(itemsInHouse[13], 150, 375, true)
				itemsToRemove[13] = item13
				sceneGroup:insert(item13)
			end

			if itemsInHouse[14] ~= nil then
				local item14 = getImage(itemsInHouse[14], 90, 375, true)
				itemsToRemove[14] = item14
				sceneGroup:insert(item14)
			end

			if itemsInHouse[15] ~= nil then
				local item15 = getImage(itemsInHouse[15], 120, 375, true)
				itemsToRemove[15] = item15
				sceneGroup:insert(item15)
			end
      	end

		winImage = display.newImage(imageSheet, 4)
		winImage.isVisible = false

		loseImage = display.newImage(imageSheet, 5)
		loseImage.isVisible = false

-- -----------------------------------
-- BIRD
-- -----------------------------------
<<<<<<< HEAD
        local bottom = display.newRect(display.contentCenterX,486,display.actualContentWidth,1)
		local top = display.newRect(display.contentCenterX,236,display.actualContentWidth,1)
		local right = display.newRect(319,display.contentCenterY+125,1,240)
		right:setFillColor(0,0,0)
		local left = display.newRect(1,display.contentCenterY+125,1,240)
		left:setFillColor(0,0,0)
		bottom.myName = "bottom"
		top.myName = "top"
		right.myName = "right"
	left.myName = "left"

        birds = display.newGroup()
=======
>>>>>>> fa190c04805c7d17ca74f5fc2c41526595f6d00b

		local bottom = display.newRect(display.contentCenterX,486,display.actualContentWidth,1)
		local top = display.newRect(display.contentCenterX,236,display.actualContentWidth,1)
		local right = display.newRect(319,display.contentCenterY+125,1,240)
		right:setFillColor(0,0,0)
		local left = display.newRect(1,display.contentCenterY+125,1,240)
		left:setFillColor(0,0,0)
		bottom.myName = "bottom"
		top.myName = "top"
		right.myName = "right"
		left.myName = "left"

		physics.start()
        physics.setGravity(0,0)

        physics.addBody(bottom, "static", {friction=0, bounce=1.0})
		physics.addBody(top, "static", {friction=0, bounce=1.0})
		physics.addBody(right, "static", {friction=0, bounce=1.0})
		physics.addBody(left, "static", {friction=0, bounce=1.0})

        birds = display.newGroup()

        if(stageNumber >= 4)then
            local num = 1;
            if (stageNumber >= 7) then num = 2; end

            for i=1, num do
                local bird = display.newSprite (imageSheet, seqData);   --initialize
                physics.addBody(bird, "dynamic", {bounce=1.0, filter = birdCollision})
                bird:setSequence("flying");                           --set the Y anchor
                bird.x = display.contentCenterX;                                   --set the X and Y coordinates
                bird.y = 350;
                bird.isFixedRotation = true;

                sceneGroup:insert(bird);
                bird:play();
                bird:toFront();
                bird:setLinearVelocity(75 * i, 75 * i * math.pow(-1, i%2))
                bird.collision = onLocalCollision
                bird:addEventListener( "collision" )
                bird:addEventListener("tap", stopBird);

                birds:insert(bird);
            end
        end

        progressBarRect:setProgress(0);

		sceneGroup:insert(winImage)
		sceneGroup:insert(loseImage)
	elseif ( phase == "did" ) then

		progress_timer = timer.performWithDelay(1000,upProgress,0)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		continueButton.isVisible = false
		winImage.isVisible = false
		loseImage.isVisible = false

		for i = 0, stageItemNumbers[stageNumber] do
			itemsToRemove[i]:removeSelf()
		end	

		touchEnabled = true
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

