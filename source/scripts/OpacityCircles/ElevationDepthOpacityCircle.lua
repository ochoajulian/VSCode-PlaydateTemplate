local pd <const> = playdate;
local gfx <const> = pd.graphics;

class('ElevationDepthOpacityCircle').extends(gfx.sprite)
function ElevationDepthOpacityCircle:init(x, y)
    local ballRadius = 9
    local ballImage = gfx.image.new(ballRadius * 2, ballRadius * 2)
    gfx.pushContext(ballImage)
    gfx.fillCircleAtPoint(ballRadius, ballRadius, ballRadius)
    gfx.popContext()
    self:setImage(ballImage)
    ballImage:setInverted(true)
    self:moveTo(x, y)
    self:add()
end
