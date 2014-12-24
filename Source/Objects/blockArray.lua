--[[
@NetMissionResources
--]]

local matrixHeight = 19 -- actually 20 since 0 counts...
local groundHeight = 2
local matrixWidth = 49 -- same here... actually 25
local column = matrixWidth + 1
local blockWidth = 16
local blockHeight = 16

function blockArrayObj:Init()

	self.matrix = {}
	for i=-1,matrixHeight+1 do
		self.matrix[i] = {}
	end
	for row = -1, matrixHeight+1 do
		for col = -1,column do
			if(row <= groundHeight) then
				self.matrix[row][col] = "block"
			else
				self.matrix[row][col] = ""
			end
		end
	end

end

local anim = 0

function blockArrayObj:getIndices(xC, yC)
	local colIndex = math.floor((xC+anim)/blockWidth)
	local rowIndex = math.floor(yC/blockHeight)
	return colIndex, rowIndex
end

function blockArrayObj:getMarioIndices(xC, yC)
	local colIndex = math.floor(xC/blockWidth)
	local rowIndex = math.floor(yC/blockHeight)
	return colIndex, rowIndex
end

-- returns Y Coord of bottom left corner of block
function blockArrayObj:getYFromRow(row)
	return (row * blockHeight)
end

function blockArrayObj:getMarioXFromCol(col)
	return (col * blockWidth)
end

-- this function returns the x coord of the MIDPOINT of the column
-- that is, the x coord from mario's reference frame
function blockArrayObj:getXFromCol(col)
	return (col* blockWidth) + blockWidth/2
end

-- returns X Coord of bottom left corner of block
-- this function needs to use anim instead of the column variable. but I don't think I need a function like this anyway so I've commented it out
-- function blockArrayObj:getXFromCol(col)
-- 	return ((matrixWidth - column + col) * blockWidth)
-- end

function blockArrayObj:getBlockWidth()
	return blockWidth
end

function blockArrayObj:getBlockHeight()
	return blockHeight
end

function blockArrayObj:Step()
	local framesForBlockToPass = blockWidth
	if (math.fmod(anim, framesForBlockToPass) == 0) then
		column = column + 1
		for row=-1,matrixHeight do
			if (row <= groundHeight) then
				self.matrix[row][column] = "block"
			else
				self.matrix[row][column] = ""
			end
		end
	end

-- for removing and adding blocks
	if(mousePressed(BUTTON_LEFT)) then
		local colIndex, rowIndex = self:getIndices(mouseX(), mouseY())
		if(self.matrix[rowIndex][colIndex] == "block") then
			self.matrix[rowIndex][colIndex] = ""
		elseif(self.matrix[rowIndex][colIndex] == "") then
			self.matrix[rowIndex][colIndex] = "block"
		end
	end

	anim = anim + 1
end

function blockArrayObj:Render()
	for col = column - matrixWidth -2, column do
		for row = 0, matrixHeight do
			if(self.matrix[row][col] == "block") then
				pushMatrix()
				setColor(0.5,0.5,0.5,1)
				translateMatrix((blockWidth)*(col),blockHeight*(row),0)
				drawRectangle(0,0,blockWidth,blockHeight,true)
				setColor(1,1,1,1)
				popMatrix()
			end
		end
	end
end
function blockObj:ShutDown()

end
