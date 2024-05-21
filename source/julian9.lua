import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/animation"

local gfx <const> = playdate.graphics
local ticksPerRevolution = 6

class("julian9").extends()

function julian9:init(xspeed, yspeed)
    self.label = {
		x = 155,
		y = 110,
		xspeed = xspeed,
		yspeed = yspeed,
		width = 100,
		height = 20
	}

	self.playerImages = gfx.imagetable.new('images/player')
end

function julian9:swapColors()
	if (gfx.getBackgroundColor() == gfx.kColorWhite) then
		gfx.setBackgroundColor(gfx.kColorBlack)
		gfx.image.new("images/pxArt(2)")
		gfx.setImageDrawMode("inverted")
	else
		gfx.setBackgroundColor(gfx.kColorWhite)
		gfx.setImageDrawMode("copy")
	end
end

function julian9:update()
    local label = self.label;
    local swap = false
	
	local crankTicks = playdate.getCrankTicks(ticksPerRevolution)

    if crankTicks == 1 then
        print("Forward tick")
		gfx.drawText("Forward crank tick", label.x +30, label.y +30, label.width, label.height)
    elseif crankTicks == -1 then
        print("Backward tick")
		gfx.drawText("Backward crank tick", label.x +30, label.y +30, label.width, label.height)
    end
	
	if (label.x + label.width >= 400 or label.x <= 0) then
        label.xspeed = -label.xspeed;
		--swap = true
    end
        
    if (label.y + label.height >= 240 or label.y <= 0) then
        label.yspeed = -label.yspeed;
		--swap = true
	end

	if (swap) then
		self:swapColors()
	end

	 label.x += label.xspeed
	 label.y += label.yspeed

	 -- Each frame of the animation will last 100ms
	local frameTime = 100
	local animationImagetable = gfx.imagetable.new("images/GIF_0196")
	-- Setting the last argument to true makes it so the animation will loop
	--local animationLoop = gfx.animation.loop.new(frameTime, animationImagetable, true)
	local animationLoop = Anima

	if playdate.buttonIsPressed("up") then
        animationLoop.y = animationLoop.y - 1
    elseif playdate.buttonIsPressed("down") then
        animationLoop.y = animationLoop.y + 1
    end
    if playdate.buttonIsPressed("left") then
        animationLoop.x = animationLoop.x - 1
    elseif playdate.buttonIsPressed("right") then
        animationLoop.x = animationLoop.x + 1
    end

	
    -- Draws the animation in a loop
    --animationLoop:draw(animationLoop.x, animationLoop.y)
end

function julian9:draw()
    local label = self.label;
    gfx.drawTextInRect("Template Julian", label.x + 30, label.y, label.width + 60, label.height)
	gfx.drawText("Template Julian", label.x +30, label.y +30, label.width, label.height)
	local peggy0 = gfx.image.new("images/IMG_0191")
	--local peggy1 = gfx.image.new("images/IMG_0192")
	peggy0:draw(5, 0)
	--peggy1:draw(200, 0)
	local peggyImageTable = gfx.imagetable.new("images/GIF_0196")
	local peggySprite = AnimatedSprite.new(peggyImageTable)
	peggySprite:addState("idle")

	function playdate.graphics.sprite.update()
		sprite:playAnimation()
	end

	animationLoop:draw(animationLoop.x, animationLoop.y)
end