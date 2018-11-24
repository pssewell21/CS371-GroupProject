local composer = require( "composer" )
local widget = require( "widget" )
local physics = require("physics")
local scene = composer.newScene()

local roboBlock
local floor
local backgroundMusic

local level = {}

local levelMovementSpeed = 35
local levelMovementEnabled = true

local firstJumpCollision = false
local jumpEnabled = true

-- The width of objects in he level
local objectWidth = 30 

-- The width of the stoke used on objects in the lvel
local objectStrokeWidth = 3

-- The combined width of the an object and its stoke on both sides (i.e. the width of a tile)
local tileWidth = objectWidth + (2 * objectStrokeWidth)

-- The number of tiles down from the top of the screen the floor is located at
local floorY = 6

local blackColorTable = {0, 0, 0}
local whiteColorTable = {1, 1, 1}
local pinkColorTable = {1 ,0, 0.9}
local transparentColorTable = {0, 0, 0, 0}
local semiTransparentColorTable = {0, 0, 0, 0.75}

local winText
local loseText

-- --------------------------------
-- This is to paint roboBlock -- AA
-- -------------------------------
local paint = {0, 1, 0.23}

local roboBlockFace = {
	type = "image",
	filename = "roboBlockFace.png"
} 

local nextSceneButton

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function gotoNextScene()
    local sceneTransitionsOptions = 
    {
        effects = "fade",
        time = 500,
    }

    composer.gotoScene("game2", sceneTransitionsOptions)
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
    if (event.other.myName ~= nil and (event.other.myName == "Floor" or event.other.myName == "TransparentSquare")) then
        if firstJumpCollision == true then
            jumpEnabled = true
        else
            firstJumpCollision = true
        end

    else
        if (event.other.myName == "EndFlag") then
            nextSceneButton.isVisible = true
            winText.isVisible = true
        else
            loseText.isVisible = true
        end
        
        levelMovementEnabled = false 
        jumpEnabled = false 
    end

    local vx, vy = roboBlock:getLinearVelocity()

    -- Set linear velocity to 0 if the block is sliding
    if vx ~= 0 then
        print("Setting linear velocity to 0")
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
    if (levelMovementEnabled == true) then
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

-- Adds a floor object to the level
local function addFloor(xStart, xEnd, y)
    local item = display.newRect(xStart, y, xEnd - xStart, display.contentHeight - y + objectStrokeWidth)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "Floor"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static", {friction = 0}) 
    table.insert(level, item)  
end

-- Adds a triangle object to the level
local function addTriangleObstacle(x, y)
    local rightVertexX = objectWidth - (2 * objectStrokeWidth)
    local vertices = {-objectStrokeWidth,-objectStrokeWidth, rightVertexX,-objectStrokeWidth, (rightVertexX / 2 - 1),-objectWidth,}
    local physicsVertices = {-objectWidth/2,objectWidth/2, objectWidth/2,objectWidth/2, 0,-objectWidth/2,}

    local item = display.newPolygon(x, y, vertices)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "Triangle"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static", {shape = physicsVertices}) 
    table.insert(level, item)  
end

-- Adds a square object to the level
local function addSquareObstacle(x, y)    
    local item = display.newRect(x, y, objectWidth, objectWidth)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "Square"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static") 
    table.insert(level, item)  

    local item = display.newRect(x, y - 1, objectWidth, objectWidth)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(transparentColorTable))
    item:setFillColor(unpack(transparentColorTable))
    item.myName = "TransparentSquare"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static", {friction = 0}) 
    table.insert(level, item) 
end

local function addEndFlag(x, y)
    local item = display.newRect(x, y - (2 * tileWidth), objectStrokeWidth, 3 * tileWidth)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "EndFlag"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static") 
    table.insert(level, item)  

    item = display.newRect(x + 1.5 * objectStrokeWidth, y - (2 * tileWidth), 1.5 * tileWidth, tileWidth)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "EndFlag"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static") 
    table.insert(level, item)  

    item = display.newText("END", x + (0.45 * tileWidth), y - (1.75 * tileWidth), native.systemFont, 14)
    item.anchorX = 0
    item.anchorY = 0
    table.insert(level, item) 
end

-- Adds an item to the level.  The caller specifies the type of item to add and the position
local function addLevelItem(type, xStartTile, xEndTile, yTile)
    local xStart = xStartTile * tileWidth

    if (xEndTile ~= nil) then
        xEnd = xEndTile * tileWidth
    end

    local y = yTile * tileWidth

    if (type == "floor") then
        if (xEnd ~= nil) then
            addFloor(xStart, xEnd, y)
        else
            print("no xEnd value provided for the floor with xStart = "..xStart.." and y = "..y)
        end
        
    elseif (type == "triangle") then
        addTriangleObstacle(xStart, y)
    elseif (type == "square") then
        addSquareObstacle(xStart, y)
    elseif (type == "endFlag") then
        addEndFlag(xStart, y)
    end
end

-- Adds a bottom object to the level.  This object is used to detect falling through pits.
local function addBottom()
    local item = display.newRect(0, display.contentHeight + tileWidth, 99999 * tileWidth, 0)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.myName = "Bottom"
    item.anchorX = 0
    item.anchorY = 0
    physics.addBody(item, "static") 
    table.insert(level, item) 
end

-- This function is used to build the level
local function buildLevel()
    local floorLevelObstacleHeight = floorY - 1

    addBottom()
    addLevelItem("floor", -2, 100, floorY)

    --addLevelItem("endFlag", 5, nil, floorLevelObstacleHeight)

    addLevelItem("triangle", 12, nil, floorLevelObstacleHeight)
    addLevelItem("square", 13, nil, floorLevelObstacleHeight)    
    addLevelItem("square", 13, nil, floorLevelObstacleHeight - 1)
    addLevelItem("triangle", 34, nil, floorLevelObstacleHeight)
    addLevelItem("square", 40, nil, floorLevelObstacleHeight)
    addLevelItem("triangle", 39, nil, floorLevelObstacleHeight)
    addLevelItem("triangle", 53, nil, floorLevelObstacleHeight)
    addLevelItem("triangle", 66, nil, floorLevelObstacleHeight)
    addLevelItem("triangle", 78, nil, floorLevelObstacleHeight)
    addLevelItem("triangle", 79, nil, floorLevelObstacleHeight)

    addLevelItem("floor", 103, 110, floorY)
    addLevelItem("floor", 113, 120, floorY)
    addLevelItem("floor", 123, 140, floorY)

    addLevelItem("endFlag", 128, nil, floorLevelObstacleHeight)
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
 
    if ( phase == "will" ) then
        physics.start()
        --physics.setDrawMode("hybrid")
        physics.setGravity(0, 9.8 * 5)
    
        local background = display.newImageRect(sceneGroup, "scene1.png", 575, 350 )
        background.x = display.contentCenterX 
        background.y = display.contentCenterY
        
        backgroundMusic = audio.loadStream("level1MusicUpdate.mp3")
    
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
    
        -- -----------------
        -- Center the button
        -- -----------------
        nextSceneButton.x = display.contentCenterX
        nextSceneButton.y = display.contentCenterY - 70
        nextSceneButton.isVisible = false
        
        -- ------------------------------
        -- Change the button's label text
        -- ------------------------------
        nextSceneButton:setLabel( "NEXT" )
        nextSceneButton:addEventListener("tap", gotoNextScene) 
    
        winText = display.newText("YOU WIN!!!", display.contentCenterX, 50, native.systemFont, 36)
        winText.isVisible = false
    
        loseText = display.newText("BOOM!!!", display.contentCenterX, 50, native.systemFont, 36)
        loseText.isVisible = false
    
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
    
        sceneGroup:insert(background)
        sceneGroup:insert(nextSceneButton)
        sceneGroup:insert(winText)
        sceneGroup:insert(loseText)
        sceneGroup:insert(roboBlock)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000})
        audio.play(backgroundMusic, {channel = 1, loops = -1})

        Runtime:addEventListener("tap", screenTouched)

        moveLevel()
    end
end 
 
function scene:hide( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen) 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen 
        physics.stop()        

        for _, item in pairs(level) do
            print("Destroying "..item.myName)

            item:removeSelf()  
        end

        -- Stop the music!
        audio.stop(1)
        audio.dispose(backgroundMusic)
    end
end 
 
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
