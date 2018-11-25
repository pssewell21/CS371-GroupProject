local composer = require( "composer" )
local widget = require( "widget" )
local physics = require("physics")
local Obstacle = require("Obstacle")
local scene = composer.newScene()

local roboBlock
local backgroundMusic

local level = {}

local levelMovementSpeed = 30
local levelMovementEnabled = true

local firstJumpCollision = false
local jumpEnabled = true

-- The width of objects in the level
local objectWidth = 30 

-- The width of the stoke used on objects in the lvel
local objectStrokeWidth = 3

-- The combined width of the an object and its stoke on both sides (i.e. the width of a tile)
local tileWidth = objectWidth + (2 * objectStrokeWidth)

-- The number of tiles down from the top of the screen the floor is located at
local floorY = 6

local blackColorTable = {0, 0, 0}
local whiteColorTable = {1, 1, 1}
local transparentColorTable = {0, 0, 0, 0}
local semiTransparentColorTable = {0, 0, 0, 0.75}

local winText
local loseText

local nextSceneButton
local retryButton
local menuSceneButton

-- --------------------------------
-- This is to paint roboBlock -- AA
-- -------------------------------
local roboBlockFace = {
	type = "image",
	filename = "roboBlockFace.png"
} 

local hitObjectSound = audio.loadSound("hitObject.wav")
local jumpSound = audio.loadSound("jump.wav")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function gotoNextScene()
    local sceneTransitionsOptions = 
    {
        effect = "crossFade",
        time = 500,
    }

    composer.removeScene("game")
    composer.gotoScene("game2", sceneTransitionsOptions)
end

local function retryScene()
    local sceneTransitionsOptions = 
    {
        effect = "crossFade",
        time = 500,
    }

    composer.removeScene("game")
    composer.gotoScene("game", sceneTransitionsOptions)
end

local function gotoMenuScene()
    local sceneTransitionsOptions = 
    {
        effect = "crossFade",
        time = 500,
    }

    composer.removeScene("game")
    composer.gotoScene("titleScene", sceneTransitionsOptions)
end

-- Function to handle button events
local function handleButtonEvent(event)
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end 

-- The collision handler, this method runs when a collision occurs with a physics body
local function onCollision(event)
    print(event.target.myName..": Collision with "..event.other.myName)
    
    -- Collisions with the floor or transparent square do not result in a loss, any other collision does
    -- Collisions with the floor or transparent square enable jumping
    if event.other.myName ~= nil and (event.other.myName == "Floor" or event.other.myName == "TransparentSquare") then
        -- putting in a dumb boolean to keep the collision while the block is rising from marking jumpEnabled as true
        if firstJumpCollision == true then
            jumpEnabled = true
        else
            firstJumpCollision = true
            audio.play(jumpSound)
           
        end
    else
        if event.other.myName == "EndFlag" then
            nextSceneButton.isVisible = true
            menuSceneButton.isVisible = true
            winText.isVisible = true
        else
            -- if collising with the bottom, make the bloack a sensor so it falls through and doesn't collide forever            
            if event.other.myName ~= nil and event.other.myName == "Bottom" then
                roboBlock.isSensor = true
            end

          	audio.play(hitObjectSound)
            retryButton.isVisible = true
            menuSceneButton.isVisible = true
        end
        
        levelMovementEnabled = false 
        jumpEnabled = false 
    end

    local vx, vy = roboBlock:getLinearVelocity()

    -- Set linear velocity to 0 if the block is sliding
    if vx ~= 0 then
        --print("Setting linear velocity to 0")
        roboBlock:setLinearVelocity(0, vy)
    end
end

-- Moves roboBlock on screen touch
local function screenTouched(event)
    if jumpEnabled == true then
        roboBlock:applyLinearImpulse(0, -0.22, roboBlock.x, roboBlock.y)
        firstJumpCollision = false
        jumpEnabled = false
    end
end

-- This function is called recursively on each item in the level to move them on the screen
local function moveItem(item)
    if levelMovementEnabled == true then
        transition.moveBy(item, 
        {
            time = 150, 
            x = levelMovementSpeed * -2,
            onComplete = 
                function()
                    moveItem(item)
                end
        })
    end
end

-- Iterates through each item in the level and call moveITem to move the level
local function moveLevel()
    for _, item in pairs(level) do
        moveItem(item)        
    end
end

-- This function is used to build the level
local function buildLevel()
    local Obst = Obstacle:new(
    {
        blackColorTable = blackColorTable,
        whiteColorTable = whiteColorTable,
        transparentColorTable = transparentColorTable,
        semiTransparentColorTable = semiTransparentColorTable,
        objectWidth = objectWidth,
        objectStrokeWidth = objectStrokeWidth,
        tileWidth = tileWidth
    })

    local floorLevelObstacleHeight = floorY - 1

    level = Obst:addBottom(level)
    level = Obst:spawn(level, "floor", -2, 100, floorY)

    --level = Obst:spawn(level, "endFlag", 5, nil, floorLevelObstacleHeight)

    level = Obst:spawn(level, "triangle", 12, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "square", 13, nil, floorLevelObstacleHeight)    
    level = Obst:spawn(level, "square", 13, nil, floorLevelObstacleHeight - 1)
    level = Obst:spawn(level, "triangle", 34, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "square", 40, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "triangle", 39, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "triangle", 53, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "triangle", 66, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "triangle", 78, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "triangle", 79, nil, floorLevelObstacleHeight)
    level = Obst:spawn(level, "floor", 103, 110, floorY)
    level = Obst:spawn(level, "floor", 113, 120, floorY)
    level = Obst:spawn(level, "floor", 123, 145, floorY)
    level = Obst:spawn(level, "endFlag", 128, nil, floorLevelObstacleHeight)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function scene:create( event ) 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end 
 
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if phase == "will" then
        physics.start()
        --physics.setDrawMode("hybrid")
        physics.setGravity(0, 9.8 * 5)
    
        local background = display.newImageRect(sceneGroup, "scene1.png", 575, 350 )
        background.x = display.contentCenterX 
        background.y = display.contentCenterY
        
        backgroundMusic = audio.loadSound("level1MusicUpdate3.mp3")
    
        -- -----------------
        -- Create the widget
        -- -----------------
        nextSceneButton = widget.newButton(
        {
            label = "nextSceneButton",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 60,
            height = 40,
            cornerRadius = 2,
            fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
            strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
            strokeWidth = 5
        })

        nextSceneButton.x = display.contentCenterX + 50
        nextSceneButton.y = display.contentCenterY - 70
        nextSceneButton:setLabel("NEXT")
        nextSceneButton:addEventListener("tap", gotoNextScene) 
        nextSceneButton.isVisible = false
    
        -- -----------------
        -- Create the widget
        -- -----------------
        retryButton = widget.newButton(
        {
            label = "retryButton",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 60,
            height = 40,
            cornerRadius = 2,
            fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
            strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
            strokeWidth = 5
        })

        retryButton.x = display.contentCenterX + 50
        retryButton.y = display.contentCenterY - 70
        retryButton:setLabel("RETRY")
        retryButton:addEventListener("tap", retryScene) 
        retryButton.isVisible = false

        menuSceneButton = widget.newButton(
        {
            label = "menuSceneButton",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 60,
            height = 40,
            cornerRadius = 2,
            fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
            strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
            strokeWidth = 5
        })

        menuSceneButton.x = display.contentCenterX - 50
        menuSceneButton.y = display.contentCenterY - 70
        menuSceneButton:setLabel("MENU")
        menuSceneButton:addEventListener("tap", gotoMenuScene) 
        menuSceneButton.isVisible = false
    
        winText = display.newText("YOU WIN!!!", display.contentCenterX, 50, native.systemFont, 36)
        winText.isVisible = false
    
        --loseText = display.newText("BOOM!!!", display.contentCenterX, 50, native.systemFont, 36)
        --loseText.isVisible = false
    
        buildLevel() 

        -- Code here runs when the scene is still off screen (but is about to come on screen) 
        roboBlock = display.newRect(0, (floorY - 1) * tileWidth, objectWidth, objectWidth)
        roboBlock.strokeWidth = objectStrokeWidth
        roboBlock:setStrokeColor(unpack(blackColorTable)) 
        roboBlock.fill = roboBlockFace  -- Still trying to figure out the size -- AA
        roboBlock.myName = "RoboBlock"
        roboBlock:addEventListener("collision", onCollision)   
        physics.addBody(roboBlock, "dynamic", {bounce = 0, friction = 0})
        roboBlock.angularDamping = 100
        roboBlock.isSleepingAllowed = false
    
        sceneGroup:insert(background)
        sceneGroup:insert(nextSceneButton)
        sceneGroup:insert(retryButton)
        sceneGroup:insert(menuSceneButton)
        sceneGroup:insert(winText)
       -- sceneGroup:insert(loseText)
        sceneGroup:insert(roboBlock)
    elseif phase == "did" then
        -- Code here runs when the scene is entirely on screen 
        audio.setVolume(1, {channel = 2})
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 2, loops = -1, fadein = 5000})

        Runtime:addEventListener("tap", screenTouched)

        moveLevel()
    end
end 
 
function scene:hide( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if phase == "will" then
        -- Code here runs when the scene is on screen (but is about to go off screen) 
    elseif phase == "did" then
        -- Code here runs immediately after the scene goes entirely off screen 
    end
end 
 
function scene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view   

    Runtime:removeEventListener("tap", screenTouched) 

    physics.stop()        

    for _, item in pairs(level) do
        item:removeSelf()  
    end

    -- Stop the music!
    audio.stop(2)
    audio.dispose(backgroundMusic)
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
