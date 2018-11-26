local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local backgroundMusic
local level3
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoNextScene()
    local sceneTransitionsOpitions = 
    {
        effects = "fade",
        time = 500,
    }

    composer.removeScene("game3")
    composer.gotoScene("game4", sceneTransitionsOpitions)
end

-- Function to handle button events
local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end

end 

-- The collision handler, this method runs when a collision occurs with a physics body
local function onCollisionOccurred(event)
    print(event.target.myName..": Collision with "..event.other.myName)
    
    -- Collisions with the floor or transparent square do not result in a loss, any other collision does
    -- Collisions with the floor or transparent square enable jumping
    if event.other.myName ~= nil and (event.other.myName == "Floor" or event.other.myName == "TransparentSquare") then
        -- putting in a dumb boolean to keep the collision while the block is rising from marking jumpEnabled as true
        if firstJumpCollision == true then
            jumpEnabled = true
        else
            firstJumpCollision = true      
        end
    else
        if event.other.myName == "EndFlag" then
            menuSceneButton.isVisible = true
            toBeContinued.isVisible = true
           
        else
            -- if collising with the bottom, make the bloack a sensor so it falls through and doesn't collide forever            
            if event.other.myName ~= nil and event.other.myName == "Bottom" then
                roboBlock.isSensor = true
            end
            -- ---------------------------------------------
            -- This is to show roboBlock's scared Face -- AA
            -- ---------------------------------------------
            roboBlockFace.isVisible = false
            roboBlock.fill = roboBlockScared

            audio.play(hitObjectSound)
            audio.play(loseSound)

            lostMessage.isVisible = true
            monster1.isVisible = true
            monster2.isVisible = true
            monster3.isVisible = true
            monster4.isVisible = true

            retryButton.isVisible = true
            menuSceneButton.isVisible = true
        end
        
        levelMovementEnabled = false 
        firstJumpCollision = false
        jumpEnabled = false 
    end

    local vx, vy = roboBlock:getLinearVelocity()

    -- Set linear velocity to 0 if the block is sliding
    if vx ~= 0 then
        --print("Setting linear velocity to 0")
        roboBlock:setLinearVelocity(0, vy)
    end

end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event ) 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "scene3.png", 575, 350 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY

 	-- ----------------------------
    -- Create the widget
    -- This is for testing purposes -- AA
    -- ----------------------------
    local nextSceneButton = widget.newButton(
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
    nextSceneButton.y = display.contentCenterY + 120
    
    level3 = display.newImageRect(sceneGroup, "level3.png", 100, 100)
    level3.x = display.contentCenterX - 230 
    level3.y = display.contentCenterY - 130
    level3.isVisible = true

    -- ------------------------------
    -- Change the button's label text
    -- ------------------------------
    nextSceneButton:setLabel( "NEXT" )
    nextSceneButton:addEventListener("tap", gotoNextScene)

    sceneGroup:insert(background)
 	sceneGroup:insert(nextSceneButton)
 	sceneGroup:insert(level3)

 	backgroundMusic = audio.loadStream("level2MusicUpdate.mp3")
end
  
-- show()
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 

        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000})
        audio.play(backgroundMusic, {channel = 1, loops = -1})
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
     -- Stop the music!
        audio.stop(1)
        audio.dispose(backgroundMusic)
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
