--[[
@NetMissionResources
--]]

local edgeLength = 40
local padding = 60

function square:Init()
	-- Pick a random corner and direction
	if (math.random() > 0.5) then self.x = padding
	else self.x = getDisplayWidth()-padding end
	if (math.random() > 0.5) then self.y,self.yvel = -padding,1
	else self.y,self.yvel = getDisplayHeight()+padding,-1 end

	self.angle = 0
end

function square:setX(x)
	self.x = x + getDisplayWidth()/2 + (math.random() - 0.5) * 800
end

function square:Step()
	self.x = self.x + 1
	self.y = self.y+self.yvel
	self.angle = self.angle+self.yvel
	if (self.y < -padding or self.y > getDisplayHeight()+padding) then removeInst(self) end
end

local halfEdgeLength = edgeLength/2
function square:Render()
	local alpha = 0.5+0.3*math.sin(self.angle*.033)
	setColor(0,0,0,alpha)

	pushMatrix()
	translateMatrix(self.x,self.y,0)
	rotateMatrix(self.angle)
	drawRectangle(-halfEdgeLength,-halfEdgeLength,halfEdgeLength,halfEdgeLength,true)
	popMatrix()

	setColor(1,1,1,1)
end

function square:ShutDown()
end
