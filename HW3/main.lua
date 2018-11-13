-----------------------------------------------------------------------------------------
--
-- main.lua

-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
--
-- Go to the menu screen
composer.gotoScene( "menu" )
