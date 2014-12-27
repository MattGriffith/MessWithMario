--[[
@NetMissionResources
--]]

function MyObject:Init()
	self.moveByX = -1;
end
function MyObject:Step()
	self.moveByX = self.moveByX-1
end

function MyObject:Render()
	pushMatrix()
	translateMatrix(self.moveByX,0,0)
end
function MyObject:ShutDown()
end
