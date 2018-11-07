local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 -- -----------------------------------------------------------------
-- This function will take the player back to the INTERMEDIATE SCENE -- AA
-- -------------------------------------------------------------------
 local function gotoIntermediate()
    composer.gotoScene( "intermediateScene" )
end
 
local function getRandomNumberWithExclusions(min, max, exclusions)
    local number = getRandomNumber(min, max)

-- This returns the pairs and the _, means that you dont care about the pairs, so therefore you dont assign it avalue
    for _, listItem in pairs(exclusions) do
        if listItem == number then
            -- Recursively call this function until a random number 
            -- is generated that is not contained in the exclusions list
            return getRandomNumberWithExclusions(min, max, exclusions)
        end
    end
    return number
end
--[[] local function getRandomNumber()
    math.random(8,18) -- this runs numbers 8 - 18

end
--]]
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
-- --------------------------------------------------
-- set up the image sheet coordinates for animations -- PS
-- --------------------------------------------------
    local options =
    {
        frames =
        {
            { x = 550, y = 0, width = 260, height = 200 },  -- 1 - House 1 Background
            { x = 810, y = 0, width = 260, height = 200 },  -- 2 - House 2 Background
            { x = 1068, y = 0, width = 260, height = 200 }, -- 3 - Red Square Background
            { x = 368, y = 8, width = 41, height = 41 },    -- 4 - Green Circle
            { x = 413, y = 10, width = 35, height = 35 },   -- 5 - Red X
            { x = 148, y = 22, width = 41, height = 38 },   -- 6 - Bird 1
            { x = 191, y = 22, width = 39, height = 36 },   -- 7 - Bird 2
            { x = 379, y = 122, width = 17, height = 41 },  -- 8 - Bottle 1
            { x = 403, y = 122, width = 17, height = 41 },  -- 9 - Bottle 2
            { x = 429, y = 115, width = 36, height = 21 },  -- 10 - Hat 1
            { x = 429, y = 137, width = 36, height = 21 },  -- 11 - Hat 2
            { x = 429, y = 159, width = 36, height = 21 },  -- 12 - Hat 3
            { x = 473, y = 111, width = 24, height = 25 },  -- 13 - Cup 1
            { x = 473, y = 136, width = 24, height = 23 },  -- 14 - Cup 2
            { x = 473, y = 160, width = 24, height = 23 },  -- 15 - Cup 3
            { x = 511, y = 93, width = 22, height = 31 },   -- 16 - Pot 1
            { x = 512, y = 125, width = 22, height = 32 },  -- 17 - Pot 2
            { x = 510, y = 158, width = 22, height = 32 },  -- 18 - Pot 3
        }
    }
    
-- -----------------------------------------------------------------------------
-- initialize the image sheet - PS
-- I just chaned the sheet -> itemSheet just so I personally dont get lost -- AA
-- -------------------------------------------------------------------------------
   local itemSheet = graphics.newImageSheet("marioware.png", options)
-- ------------------------------------------------------------------------------
-- setup the scene background images and text blocks -- PS
-- TODO: Possibly investigate scaling based on screen size -- PS
-- This is the red background -- AA
-- The scale may be too big -- AA
-- -------------------------------------------------------------------------------   
    local topBackground = display.newImage(itemSheet, 3, display.contentCenterX, 90)
    topBackground.xScale = 1.3 
    topBackground.yScale = 1.4

    local houseBackground = display.newImage(itemSheet, 1, display.contentCenterX, 350)
    houseBackground.xScale = 1.5
    houseBackground.yScale = 1.4

    local progressBarRect = display.newRect(display.contentCenterX, 505, 313, 30)
    progressBarRect.strokeWidth = 5
    progressBarRect:setStrokeColor(1, 1, 0)
    progressBarRect:setFillColor(0, 0, 0)







-- --------------------------------------------------------------------
--This is just putting all of the objects that is the scene in a group
-- --------------------------------------------------------------------
    sceneGroup:insert(topBackground)
    sceneGroup:insert(houseBackground)
    sceneGroup:insert(progressBarRect)



end
 

<<<<<<< HEAD
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Randomly get an index for an item that use player needs to find
		itemToFindIndex = getRandomNumber(8, 28)

		-- display the image in the top section
		itemToFind = getImage(sheet, itemToFindIndex, display.contentCenterX, 100)

		sceneGroup:insert(itemToFind)
=======
>>>>>>> 676ead577a77f2340c5a7600134781f9f0705a20



<<<<<<< HEAD
		local numberOfItemsInHouse = stageItemNumbers[stageNumber]
=======
>>>>>>> 676ead577a77f2340c5a7600134781f9f0705a20





 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
-- ---------------------------------------------------------------------
-- Randomly get an index for an item that use player needs to find - PS
-- --------------------------------------------------------------------
        math.randomseed(os.time())
        itemToFindRandNum = math.random(8,18)
-- ---------------------------------------
-- display the image in the top section
-- ---------------------------------------

        itemToFind = display.newImage(itemSheet, itemToFindRandNum, display.contentCenterX, 50)
       -- itemToFind.xScale = 1
        --itemToFind.yScale = 1 
        --sceneGroup:insert(itemToFind)


    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
