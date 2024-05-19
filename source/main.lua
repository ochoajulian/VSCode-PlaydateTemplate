-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local sfx <const> = playdate.sound
local gfx <const> = playdate.graphics

class('Ball').extends(gfx.sprite)
function Ball:init(x, y)
    local ballRadius = 16
    local ballImage = gfx.image.new(ballRadius * 2, ballRadius * 2)
    gfx.pushContext(ballImage)
    gfx.fillCircleAtPoint(ballRadius, ballRadius, ballRadius)
    gfx.popContext()
    self:setImage(ballImage)
    self:moveTo(x, y)
    self:add()
end

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.
local playerSprite = nil

local backgroundMusic = nil

local ticksPerRevolution = 6

--Set up animations
local lineSegment = playdate.geometry.lineSegment.new(0, 0, 400, 240)
local lineAnimator = gfx.animator.new(2000, lineSegment, playdate.easingFunctions.outBounce)
local ballSpriteLine = Ball(0, 0)

-- A function to set up our game environment.
function myGameSetUp()

    -- Set up the player sprite.

    local playerImage = gfx.image.new("images/IMG_0019")
    assert( playerImage ) -- make sure the image was where we thought

    playerSprite = gfx.sprite.new( playerImage )
    playerSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    playerSprite:add() -- This is critical!

    -- We want an environment displayed behind our sprite.
    -- There are generally two ways to do this:
    -- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
    -- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
    --       and call :setZIndex() with some low number so the background stays behind
    --       your other sprites.

    local backgroundImage = gfx.image.new( "Images/IMG_0018" )
    assert( backgroundImage )

    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            -- x,y,width,height is the updated area in sprite-local coordinates
            -- The clip rect is already set to this area, so we don't need to set it ourselves
            backgroundImage:draw( 0, 0 )
        end
    )

    --Set up music and sfx
    backgroundMusic = sfx.fileplayer.new("Sounds/recorder_IMA")
    assert( backgroundMusic )
    
    backgroundMusic:load("Sounds/recorder_IMA")
    backgroundMusic:play(9)

end


-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

    -- Poll the d-pad and move our player accordingly.
    -- (There are multiple ways to read the d-pad; this is the simplest.)
    -- Note that it is possible for more than one of these directions
    -- to be pressed at once, if the user is pressing diagonally.

    if playdate.buttonJustPressed(playdate.kButtonUp)
        then playerSprite:moveBy( 0, -3 )
    end        

    if playdate.buttonIsPressed( playdate.kButtonUp ) 
        then playerSprite:moveBy( 0, -6 )
    end

    if playdate.buttonIsPressed( playdate.kButtonRight ) 
        then playerSprite:moveBy( 6, 0 )
    end

    if playdate.buttonIsPressed( playdate.kButtonDown ) 
        then playerSprite:moveBy( 0, 6 )
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft)
        then playerSprite:moveBy(-1, 0)
    end

    if playdate.buttonIsPressed( playdate.kButtonLeft ) 
        then playerSprite:moveBy( -6, 0 )
    end

    local crankTicks = playdate.getCrankTicks(ticksPerRevolution)
    if crankTicks == 1
        then print("4ward tick")
    elseif crankTicks == -1 
        then print ("Backward tick")    
    end

    if playdate.isCrankDocked()
        then backgroundMusic:pause() 
            else backgroundMusic:play()
            end

    --Move Ball
    ballSpriteLine:moveTo(lineAnimator:currentValue())

    -- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)
    gfx.sprite.update()
    playdate.timer.updateTimers()
end