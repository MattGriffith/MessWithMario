--[[
@NetMissionResources
--]]

function startCamera:Init()
	self.moveByX = -1;
end
function startCamera:Step()
	self.moveByX = self.moveByX-1
end

function startCamera:Render()
	pushMatrix()
	translateMatrix(self.moveByX,0,0)
end
function startCamera:ShutDown()
end
