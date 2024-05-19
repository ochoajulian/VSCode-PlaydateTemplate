import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics
local ticksPerRevolution = 6

class("dvd3").extends()

function dvd3:init(xspeed, yspeed)
    self.label = {
		x = 155,
		y = 110,
		xspeed = xspeed,
		yspeed = yspeed,
		width = 100,
		height = 20
	}
end

function dvd3:swapColors()
	if (gfx.getBackgroundColor() == gfx.kColorWhite) then
		gfx.setBackgroundColor(gfx.kColorBlack)
		gfx.image.new("images/pxArt(2)")
		gfx.setImageDrawMode("inverted")
	else
		gfx.setBackgroundColor(gfx.kColorWhite)
		gfx.setImageDrawMode("copy")
	end
end

function dvd3:update()
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
		swap = true
    end
        
    if (label.y + label.height >= 240 or label.y <= 0) then
        label.yspeed = -label.yspeed;
		swap = true
	end

	if (swap) then
		self:swapColors()
	end

	 label.x += label.xspeed
	 label.y += label.yspeed
end

function dvd3:draw()
    local label = self.label;
    gfx.drawTextInRect("Template Julian", label.x + 30, label.y, label.width + 60, label.height)
	gfx.drawText("Template Julian", label.x +30, label.y +30, label.width, label.height)
	gfx.image.new("images/pxArt(2)")
	gfx.drawCircleAtPoint(120, 120, 18);
end