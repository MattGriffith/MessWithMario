--[[
@NetMissionResources
--]]



function MyObject:Init()
	self.x = 0;
	self.y = 0;
	self.size = 12;
	self.anim = 1;
	self.alpha = 1;
	self.R, self.G, self.B = math.random(), math.random(), math.random()
end
function MyObject:Step()
end
function MyObject:Render()
	pushMatrix()
	setColor(self.R,self.G,self.B,self.alpha)
	translateMatrix(self.x,self.y,0)
	drawRectangle(0,0,self.size,self.size,true)
	setColor(1,1,1,1)
	popMatrix()
end
function MyObject:ShutDown()

end
